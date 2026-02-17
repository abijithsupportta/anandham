import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

/// Handles file uploads/downloads via Supabase Storage.
///
/// Each bucket should have its own RLS policies configured
/// in the Supabase dashboard.
class SupabaseStorageService {
  SupabaseStorageService._();

  static SupabaseStorageClient get _storage => SupabaseConfig.storage;

  // ── Bucket constants ───────────────────────────────────────────────────

  /// Standard bucket names used across the platform.
  static const String avatarsBucket = 'avatars';
  static const String contentBucket = 'content';
  static const String documentsBucket = 'documents';

  // ── Upload ─────────────────────────────────────────────────────────────

  /// Upload a file from bytes and return its public URL.
  ///
  /// ```dart
  /// final url = await SupabaseStorageService.uploadFile(
  ///   bucket: 'avatars',
  ///   path: 'user_123/avatar.jpg',
  ///   bytes: imageBytes,
  ///   contentType: 'image/jpeg',
  /// );
  /// ```
  static Future<String> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
    bool upsert = true,
  }) async {
    try {
      await _storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType, upsert: upsert),
          );

      return getPublicUrl(bucket: bucket, path: path);
    } catch (e) {
      debugPrint('[SupabaseStorageService] uploadFile error: $e');
      rethrow;
    }
  }

  // ── Download ───────────────────────────────────────────────────────────

  /// Download a file as bytes.
  static Future<Uint8List> downloadFile({
    required String bucket,
    required String path,
  }) async {
    try {
      return await _storage.from(bucket).download(path);
    } catch (e) {
      debugPrint('[SupabaseStorageService] downloadFile error: $e');
      rethrow;
    }
  }

  // ── URL ────────────────────────────────────────────────────────────────

  /// Get the public URL for a file.
  static String getPublicUrl({required String bucket, required String path}) {
    return _storage.from(bucket).getPublicUrl(path);
  }

  /// Create a signed URL that expires after [expiresIn] seconds.
  static Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresIn = 3600,
  }) async {
    try {
      return await _storage.from(bucket).createSignedUrl(path, expiresIn);
    } catch (e) {
      debugPrint('[SupabaseStorageService] getSignedUrl error: $e');
      rethrow;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────

  /// Delete one or more files from a bucket.
  static Future<void> deleteFiles({
    required String bucket,
    required List<String> paths,
  }) async {
    try {
      await _storage.from(bucket).remove(paths);
    } catch (e) {
      debugPrint('[SupabaseStorageService] deleteFiles error: $e');
      rethrow;
    }
  }

  // ── List ───────────────────────────────────────────────────────────────

  /// List all files in a bucket/folder.
  static Future<List<FileObject>> listFiles({
    required String bucket,
    String path = '',
  }) async {
    try {
      return await _storage.from(bucket).list(path: path);
    } catch (e) {
      debugPrint('[SupabaseStorageService] listFiles error: $e');
      rethrow;
    }
  }
}
