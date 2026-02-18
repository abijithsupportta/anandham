import 'dart:convert';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/data/local/db/app_database.dart';
import 'package:drift/drift.dart';

class ContentSyncService {
  final AppDatabase _db;

  ContentSyncService(this._db);

  Future<void> syncKrithis({bool force = false}) async {
    if (!await _shouldSync(
      'last_sync_krithis',
      const Duration(minutes: 3),
      force: force,
    )) {
      return;
    }

    final rows = await SupabaseConfig.client
        .from('krithis')
        .select(
          'id, title, description, youtube_url, display_order, status, is_deleted, created_at',
        )
        .eq('status', 'published')
        .order('display_order', ascending: true, nullsFirst: false)
        .order('created_at', ascending: false);

    final krithis = (rows as List<dynamic>).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      for (final row in krithis) {
        await _db
            .into(_db.krithisLocal)
            .insertOnConflictUpdate(
              KrithisLocalCompanion(
                id: Value((row['id'] as String?) ?? ''),
                title: Value((row['title'] as String?) ?? ''),
                description: Value(row['description'] as String?),
                youtubeUrl: Value(row['youtube_url'] as String?),
                displayOrder: Value(row['display_order'] as int?),
                status: Value((row['status'] as String?) ?? 'published'),
                isDeleted: Value((row['is_deleted'] as bool?) ?? false),
                createdAt: Value(_toDateTime(row['created_at'])),
                updatedAt: Value(
                  _toDateTime(row['created_at']) ?? DateTime.now(),
                ),
              ),
            );
      }

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('last_sync_krithis'),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> syncKeerthanams({bool force = false}) async {
    if (!await _shouldSync(
      'last_sync_keerthanams',
      const Duration(minutes: 3),
      force: force,
    )) {
      return;
    }

    final rows = await SupabaseConfig.client
        .from('guru_keerthanams')
        .select(
          'id, title, author_name, description, youtube_url, display_order, status, is_deleted, created_at',
        )
        .eq('status', 'published')
        .order('display_order', ascending: true, nullsFirst: false)
        .order('created_at', ascending: false);

    final keerthanams = (rows as List<dynamic>).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      for (final row in keerthanams) {
        await _db
            .into(_db.keerthanamsLocal)
            .insertOnConflictUpdate(
              KeerthanamsLocalCompanion(
                id: Value((row['id'] as String?) ?? ''),
                title: Value((row['title'] as String?) ?? ''),
                authorName: Value(row['author_name'] as String?),
                description: Value(row['description'] as String?),
                youtubeUrl: Value(row['youtube_url'] as String?),
                displayOrder: Value(row['display_order'] as int?),
                status: Value((row['status'] as String?) ?? 'published'),
                isDeleted: Value((row['is_deleted'] as bool?) ?? false),
                createdAt: Value(_toDateTime(row['created_at'])),
                updatedAt: Value(
                  _toDateTime(row['created_at']) ?? DateTime.now(),
                ),
              ),
            );
      }

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('last_sync_keerthanams'),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> syncHomeContentTypes({bool force = false}) async {
    if (!await _shouldSync(
      'last_sync_content_types',
      const Duration(minutes: 5),
      force: force,
    )) {
      return;
    }

    final rows = await SupabaseConfig.client
        .from('content_types')
        .select(
          'name, display_name, description, icon, color, table_name, display_order, is_active',
        )
        .eq('is_active', true)
        .order('display_order', ascending: true);

    final types = (rows as List<dynamic>).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      for (final row in types) {
        final name = row['name'] as String?;
        if (name == null || name.isEmpty) {
          continue;
        }

        await _db
            .into(_db.contentTypesLocal)
            .insertOnConflictUpdate(
              ContentTypesLocalCompanion(
                name: Value(name),
                displayName: Value((row['display_name'] as String?) ?? ''),
                description: Value(row['description'] as String?),
                icon: Value(row['icon'] as String?),
                color: Value(row['color'] as String?),
                tableRef: Value(row['table_name'] as String?),
                displayOrder: Value(row['display_order'] as int?),
                isActive: Value((row['is_active'] as bool?) ?? true),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('last_sync_content_types'),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> syncDharmas({bool force = false}) async {
    if (!await _shouldSync(
      'last_sync_dharmas',
      const Duration(minutes: 3),
      force: force,
    )) {
      return;
    }

    final dharmaRows = await SupabaseConfig.client
        .from('dharmas')
        .select(
          'id, title, description, translation, display_order, status, is_deleted, created_at',
        )
        .eq('status', 'published')
        .order('display_order', ascending: true, nullsFirst: false)
        .order('created_at', ascending: false);

    final dharmas = (dharmaRows as List<dynamic>).cast<Map<String, dynamic>>();
    final dharmaIds = dharmas
        .map((row) => row['id'] as String?)
        .whereType<String>()
        .toList();

    final slokaRows = dharmaIds.isEmpty
        ? <dynamic>[]
        : await SupabaseConfig.client
              .from('dharma_items')
              .select('dharma_id, item_number, text, explanation, is_deleted')
              .inFilter('dharma_id', dharmaIds)
              .order('item_number', ascending: true);

    final wordRows = dharmaIds.isEmpty
        ? <dynamic>[]
        : await SupabaseConfig.client
              .from('dharma_words')
              .select('dharma_id, word, meaning, display_order')
              .inFilter('dharma_id', dharmaIds)
              .order('display_order', ascending: true);

    await _db.transaction(() async {
      for (final row in dharmas) {
        await _db
            .into(_db.dharmasLocal)
            .insertOnConflictUpdate(
              DharmasLocalCompanion(
                id: Value((row['id'] as String?) ?? ''),
                title: Value((row['title'] as String?) ?? ''),
                description: Value(row['description'] as String?),
                translation: Value(row['translation'] as String?),
                displayOrder: Value(row['display_order'] as int?),
                status: Value((row['status'] as String?) ?? 'published'),
                isDeleted: Value((row['is_deleted'] as bool?) ?? false),
                createdAt: Value(_toDateTime(row['created_at'])),
                updatedAt: Value(
                  _toDateTime(row['created_at']) ?? DateTime.now(),
                ),
              ),
            );
      }

      if (dharmaIds.isNotEmpty) {
        await (_db.delete(
          _db.dharmaItemsLocal,
        )..where((table) => table.dharmaId.isIn(dharmaIds))).go();
        await (_db.delete(
          _db.dharmaWordsLocal,
        )..where((table) => table.dharmaId.isIn(dharmaIds))).go();
      }

      await _db.batch((batch) {
        for (final dynamic row in slokaRows) {
          final data = row as Map<String, dynamic>;
          final dharmaId = data['dharma_id'] as String?;
          if (dharmaId == null || dharmaId.isEmpty) {
            continue;
          }

          batch.insert(
            _db.dharmaItemsLocal,
            DharmaItemsLocalCompanion.insert(
              dharmaId: dharmaId,
              itemNumber: (data['item_number'] as int?) ?? 0,
              textValue: (data['text'] as String?) ?? '',
              explanation: Value(data['explanation'] as String?),
              isDeleted: Value((data['is_deleted'] as bool?) ?? false),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        for (final dynamic row in wordRows) {
          final data = row as Map<String, dynamic>;
          final dharmaId = data['dharma_id'] as String?;
          if (dharmaId == null || dharmaId.isEmpty) {
            continue;
          }

          batch.insert(
            _db.dharmaWordsLocal,
            DharmaWordsLocalCompanion.insert(
              dharmaId: dharmaId,
              displayOrder: (data['display_order'] as int?) ?? 0,
              word: (data['word'] as String?) ?? '',
              meaning: (data['meaning'] as String?) ?? '',
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('last_sync_dharmas'),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> syncGuruPhotos({bool force = false}) async {
    if (!await _shouldSync(
      'last_sync_guru_photos',
      const Duration(minutes: 3),
      force: force,
    )) {
      return;
    }

    final rows = await SupabaseConfig.client
        .from('guru_photos')
        .select(
          'id, title, description, image_url, status, is_deleted, display_order, created_at',
        )
        .eq('status', 'published')
        .order('display_order', ascending: true, nullsFirst: false)
        .order('created_at', ascending: false);

    final photos = (rows as List<dynamic>).cast<Map<String, dynamic>>();

    final imageRows = await SupabaseConfig.client
        .from('guru_photo_images')
        .select('id, guru_photo_id, image_url, display_order, created_at')
        .order('display_order', ascending: true);
    final images = (imageRows as List<dynamic>).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      for (final row in photos) {
        final id = row['id'] as String?;
        if (id == null || id.isEmpty) {
          continue;
        }

        await _db
            .into(_db.guruPhotosLocal)
            .insertOnConflictUpdate(
              GuruPhotosLocalCompanion(
                id: Value(id),
                title: Value((row['title'] as String?) ?? ''),
                description: Value(row['description'] as String?),
                imageUrl: Value(row['image_url'] as String?),
                status: Value((row['status'] as String?) ?? 'published'),
                isDeleted: Value((row['is_deleted'] as bool?) ?? false),
                displayOrder: Value(row['display_order'] as int?),
                createdAt: Value(_toDateTime(row['created_at'])),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }

      for (final image in images) {
        final imageId = image['id'] as String?;
        final guruPhotoId = image['guru_photo_id'] as String?;
        if (imageId == null ||
            imageId.isEmpty ||
            guruPhotoId == null ||
            guruPhotoId.isEmpty) {
          continue;
        }

        await _db
            .into(_db.guruPhotoImagesLocal)
            .insertOnConflictUpdate(
              GuruPhotoImagesLocalCompanion(
                id: Value(imageId),
                guruPhotoId: Value(guruPhotoId),
                imageUrl: Value((image['image_url'] as String?) ?? ''),
                displayOrder: Value((image['display_order'] as int?) ?? 0),
                createdAt: Value(_toDateTime(image['created_at'])),
                updatedAt: Value(DateTime.now()),
              ),
            );
      }

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: const Value('last_sync_guru_photos'),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> syncSavedItemsForUser({
    required String userId,
    required String contentType,
    bool force = false,
  }) async {
    final syncKey = 'last_sync_saved_${contentType}_$userId';
    if (!await _shouldSync(
      syncKey,
      const Duration(seconds: 20),
      force: force,
    )) {
      return;
    }

    final didFlushPendingOps = await flushPendingOps();
    if (!didFlushPendingOps) {
      return;
    }

    final rows = await SupabaseConfig.client
        .from('saved_items')
        .select('content_id, position, created_at')
        .eq('user_id', userId)
        .eq('content_type', contentType)
        .order('position', ascending: true, nullsFirst: false)
        .order('created_at', ascending: true);

    final items = (rows as List<dynamic>).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      await (_db.delete(_db.savedItemsLocal)
            ..where((table) => table.userId.equals(userId))
            ..where((table) => table.contentType.equals(contentType)))
          .go();

      await _db.batch((batch) {
        for (final row in items) {
          final contentId = row['content_id'] as String?;
          if (contentId == null || contentId.isEmpty) {
            continue;
          }

          batch.insert(
            _db.savedItemsLocal,
            SavedItemsLocalCompanion.insert(
              userId: userId,
              contentType: contentType,
              contentId: contentId,
              position: Value(row['position'] as int?),
              createdAt: _toDateTime(row['created_at']) ?? DateTime.now(),
              updatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      await _db
          .into(_db.syncMeta)
          .insertOnConflictUpdate(
            SyncMetaCompanion(
              key: Value(syncKey),
              value: Value(DateTime.now().toIso8601String()),
            ),
          );
    });
  }

  Future<void> upsertSavedItemCloud({
    required String userId,
    required String contentType,
    required String contentId,
    int? position,
  }) async {
    await SupabaseConfig.client.from('saved_items').upsert({
      'user_id': userId,
      'content_type': contentType,
      'content_id': contentId,
      'position': position,
    }, onConflict: 'user_id,content_type,content_id');
  }

  Future<void> removeSavedItemCloud({
    required String userId,
    required String contentType,
    required String contentId,
  }) async {
    await SupabaseConfig.client
        .from('saved_items')
        .delete()
        .eq('user_id', userId)
        .eq('content_type', contentType)
        .eq('content_id', contentId);
  }

  Future<void> enqueuePendingOp({
    required String tableRef,
    required String opType,
    required Map<String, dynamic> payload,
  }) async {
    final opId = '${DateTime.now().microsecondsSinceEpoch}_${tableRef}_$opType';
    await _db
        .into(_db.pendingOps)
        .insertOnConflictUpdate(
          PendingOpsCompanion(
            opId: Value(opId),
            tableRef: Value(tableRef),
            opType: Value(opType),
            payloadJson: Value(jsonEncode(payload)),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  Future<bool> flushPendingOps() async {
    final query = _db.select(_db.pendingOps)
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]);

    final ops = await query.get();
    var allSynced = true;
    for (final op in ops) {
      try {
        final payload = jsonDecode(op.payloadJson) as Map<String, dynamic>;
        if (op.tableRef == 'saved_items') {
          if (op.opType == 'upsert') {
            await upsertSavedItemCloud(
              userId: payload['user_id'] as String,
              contentType: payload['content_type'] as String,
              contentId: payload['content_id'] as String,
              position: payload['position'] as int?,
            );
          } else if (op.opType == 'delete') {
            await removeSavedItemCloud(
              userId: payload['user_id'] as String,
              contentType: payload['content_type'] as String,
              contentId: payload['content_id'] as String,
            );
          }
        }

        await (_db.delete(
          _db.pendingOps,
        )..where((table) => table.opId.equals(op.opId))).go();
      } catch (_) {
        allSynced = false;
        break;
      }
    }

    return allSynced;
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  Future<bool> _shouldSync(
    String key,
    Duration minInterval, {
    bool force = false,
  }) async {
    if (force) {
      return true;
    }

    final row =
        await (_db.select(_db.syncMeta)
              ..where((table) => table.key.equals(key))
              ..limit(1))
            .getSingleOrNull();

    final last = row == null ? null : DateTime.tryParse(row.value);
    if (last == null) {
      return true;
    }

    return DateTime.now().difference(last) >= minInterval;
  }
}
