import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Generic database operations backed by Supabase PostgREST.
///
/// Provides type-safe CRUD helpers so you don't scatter raw
/// Supabase queries throughout the app.
class SupabaseDbService {
  SupabaseDbService._();

  static SupabaseClient get _client => SupabaseConfig.client;

  // ── READ ───────────────────────────────────────────────────────────────

  /// Fetch all rows from [table], optionally with ordering/pagination.
  ///
  /// ```dart
  /// final rows = await SupabaseDbService.getAll('krithis',
  ///   columns: 'id, title, category_id',
  ///   orderBy: 'order_index',
  /// );
  /// ```
  static Future<List<Map<String, dynamic>>> getAll(
    String table, {
    String columns = '*',
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      final filter = _client.from(table).select(columns);
      PostgrestTransformBuilder<PostgrestList> builder = filter;

      if (orderBy != null) {
        builder = filter.order(orderBy, ascending: ascending);
      }
      if (limit != null) {
        builder = builder.limit(limit);
      }
      if (offset != null) {
        builder = builder.range(offset, offset + (limit ?? 20) - 1);
      }

      final response = await builder;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseDbService] getAll($table) error: $e');
      rethrow;
    }
  }

  /// Fetch a single row by its [id].
  static Future<Map<String, dynamic>?> getById(
    String table,
    String id, {
    String columns = '*',
    String idColumn = 'id',
  }) async {
    try {
      final response = await _client
          .from(table)
          .select(columns)
          .eq(idColumn, id)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('[SupabaseDbService] getById($table, $id) error: $e');
      rethrow;
    }
  }

  /// Fetch rows matching a single equality filter.
  static Future<List<Map<String, dynamic>>> getWhere(
    String table, {
    required String column,
    required dynamic value,
    String columns = '*',
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      final filter = _client.from(table).select(columns).eq(column, value);
      PostgrestTransformBuilder<PostgrestList> builder = filter;

      if (orderBy != null) {
        builder = filter.order(orderBy, ascending: ascending);
      }
      if (limit != null) {
        builder = builder.limit(limit);
      }

      final response = await builder;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseDbService] getWhere($table) error: $e');
      rethrow;
    }
  }

  /// Fetch all rows updated after [since] — used for incremental sync.
  static Future<List<Map<String, dynamic>>> getUpdatedSince(
    String table, {
    required DateTime since,
    String columns = '*',
    String timestampColumn = 'updated_at',
    String? orderBy,
  }) async {
    try {
      final filter = _client
          .from(table)
          .select(columns)
          .gt(timestampColumn, since.toIso8601String());
      PostgrestTransformBuilder<PostgrestList> builder = filter;

      if (orderBy != null) {
        builder = filter.order(orderBy);
      }

      final response = await builder;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseDbService] getUpdatedSince($table) error: $e');
      rethrow;
    }
  }

  /// Full-text search across a column using Supabase `textSearch`.
  static Future<List<Map<String, dynamic>>> search(
    String table, {
    required String column,
    required String query,
    String columns = '*',
    int? limit,
  }) async {
    try {
      final filter = _client
          .from(table)
          .select(columns)
          .textSearch(column, query);
      PostgrestTransformBuilder<PostgrestList> builder = filter;

      if (limit != null) {
        builder = filter.limit(limit);
      }

      final response = await builder;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseDbService] search($table) error: $e');
      rethrow;
    }
  }

  // ── CREATE ─────────────────────────────────────────────────────────────

  /// Insert a single row and return the inserted data.
  static Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.from(table).insert(data).select().single();
      return response;
    } catch (e) {
      debugPrint('[SupabaseDbService] insert($table) error: $e');
      rethrow;
    }
  }

  /// Insert multiple rows at once.
  static Future<List<Map<String, dynamic>>> insertMany(
    String table,
    List<Map<String, dynamic>> data,
  ) async {
    try {
      final response = await _client.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseDbService] insertMany($table) error: $e');
      rethrow;
    }
  }

  /// Upsert (insert or update on conflict).
  static Future<Map<String, dynamic>> upsert(
    String table,
    Map<String, dynamic> data, {
    String? onConflict,
  }) async {
    try {
      final response = await _client
          .from(table)
          .upsert(data, onConflict: onConflict)
          .select()
          .single();
      return response;
    } catch (e) {
      debugPrint('[SupabaseDbService] upsert($table) error: $e');
      rethrow;
    }
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────

  /// Update a single row by its [id].
  static Future<Map<String, dynamic>> update(
    String table,
    String id,
    Map<String, dynamic> data, {
    String idColumn = 'id',
  }) async {
    try {
      final response = await _client
          .from(table)
          .update(data)
          .eq(idColumn, id)
          .select()
          .single();
      return response;
    } catch (e) {
      debugPrint('[SupabaseDbService] update($table, $id) error: $e');
      rethrow;
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────

  /// Delete a single row by its [id].
  static Future<void> delete(
    String table,
    String id, {
    String idColumn = 'id',
  }) async {
    try {
      await _client.from(table).delete().eq(idColumn, id);
    } catch (e) {
      debugPrint('[SupabaseDbService] delete($table, $id) error: $e');
      rethrow;
    }
  }

  /// Delete rows matching a filter.
  static Future<void> deleteWhere(
    String table, {
    required String column,
    required dynamic value,
  }) async {
    try {
      await _client.from(table).delete().eq(column, value);
    } catch (e) {
      debugPrint('[SupabaseDbService] deleteWhere($table) error: $e');
      rethrow;
    }
  }

  // ── COUNT ──────────────────────────────────────────────────────────────

  /// Get the row count for a table (with optional filter).
  static Future<int> count(
    String table, {
    String? filterColumn,
    dynamic filterValue,
  }) async {
    try {
      if (filterColumn != null && filterValue != null) {
        final response = await _client
            .from(table)
            .select()
            .eq(filterColumn, filterValue)
            .count(CountOption.exact);
        return response.count;
      } else {
        final response = await _client
            .from(table)
            .select()
            .count(CountOption.exact);
        return response.count;
      }
    } catch (e) {
      debugPrint('[SupabaseDbService] count($table) error: $e');
      rethrow;
    }
  }

  // ── RPC (Database Functions) ───────────────────────────────────────────

  /// Call a Postgres function via RPC.
  static Future<dynamic> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _client.rpc(functionName, params: params);
    } catch (e) {
      debugPrint('[SupabaseDbService] rpc($functionName) error: $e');
      rethrow;
    }
  }
}
