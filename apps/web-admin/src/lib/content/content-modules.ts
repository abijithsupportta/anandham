export const CONTENT_MODULES = {
  krithis: "guru_krithis",
  keerthanams: "guru_keerthanams",
  dharmas: "guru_dharmas",
  photos: "guru_photos",
  stories: "guru_stories",
} as const;

export type ContentModuleKey = keyof typeof CONTENT_MODULES;

export function isContentModuleKey(value: string): value is ContentModuleKey {
  return value in CONTENT_MODULES;
}

export function getModuleCollection(moduleKey: ContentModuleKey) {
  return CONTENT_MODULES[moduleKey];
}
