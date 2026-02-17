"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import type { ServiceResult } from "@/services/base";

// ── Generic data-fetching hook ─────────────────────────────

interface UseQueryResult<T> {
  data: T[];
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export function useQuery<T>(
  queryFn: () => Promise<ServiceResult<T[]>>,
  deps: unknown[] = []
): UseQueryResult<T> {
  const [data, setData] = useState<T[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const queryFnRef = useRef(queryFn);
  queryFnRef.current = queryFn;

  const refetch = useCallback(async () => {
    setLoading(true);
    setError(null);
    const result = await queryFnRef.current();
    if (result.error) {
      setError(result.error);
    } else {
      setData(result.data ?? []);
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    refetch();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);

  return { data, loading, error, refetch };
}

// ── Hook for mutations with toast feedback ─────────────────

interface UseMutationOptions {
  onSuccess?: () => void;
  successMessage?: string;
  errorMessage?: string;
}

interface UseMutationResult<TInput> {
  mutate: (input: TInput) => Promise<boolean>;
  loading: boolean;
}

export function useMutation<TInput>(
  mutationFn: (input: TInput) => Promise<ServiceResult<unknown>>,
  toast: (msg: string, type?: "success" | "error" | "info") => void,
  options: UseMutationOptions = {}
): UseMutationResult<TInput> {
  const [loading, setLoading] = useState(false);
  const mutationFnRef = useRef(mutationFn);
  mutationFnRef.current = mutationFn;
  const optionsRef = useRef(options);
  optionsRef.current = options;

  const mutate = useCallback(
    async (input: TInput): Promise<boolean> => {
      setLoading(true);
      const result = await mutationFnRef.current(input);
      setLoading(false);

      if (result.error) {
        toast(optionsRef.current.errorMessage ?? result.error, "error");
        return false;
      }

      if (optionsRef.current.successMessage) {
        toast(optionsRef.current.successMessage, "success");
      }
      optionsRef.current.onSuccess?.();
      return true;
    },
    [toast]
  );

  return { mutate, loading };
}
