import 'package:anandham_user/data/local/db/app_database.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestContentSyncService extends ContentSyncService {
  final bool failUpsert;
  final List<Map<String, dynamic>> upserts = [];
  final List<Map<String, dynamic>> deletes = [];

  _TestContentSyncService(super.db, {this.failUpsert = false});

  @override
  Future<void> upsertSavedItemCloud({
    required String userId,
    required String contentType,
    required String contentId,
    int? position,
  }) async {
    if (failUpsert) {
      throw Exception('Simulated sync failure');
    }
    upserts.add({
      'user_id': userId,
      'content_type': contentType,
      'content_id': contentId,
      'position': position,
    });
  }

  @override
  Future<void> removeSavedItemCloud({
    required String userId,
    required String contentType,
    required String contentId,
  }) async {
    deletes.add({
      'user_id': userId,
      'content_type': contentType,
      'content_id': contentId,
    });
  }
}

void main() {
  group('ContentSyncService.flushPendingOps', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('replays queued operations and clears queue on success', () async {
      final service = _TestContentSyncService(database);

      await service.enqueuePendingOp(
        tableRef: 'saved_items',
        opType: 'upsert',
        payload: {
          'user_id': 'u1',
          'content_type': 'krithi',
          'content_id': 'k1',
          'position': 1,
        },
      );
      await service.enqueuePendingOp(
        tableRef: 'saved_items',
        opType: 'delete',
        payload: {
          'user_id': 'u1',
          'content_type': 'krithi',
          'content_id': 'k2',
        },
      );

      final result = await service.flushPendingOps();

      final remaining = await database.select(database.pendingOps).get();
      expect(result, isTrue);
      expect(service.upserts.length, 1);
      expect(service.deletes.length, 1);
      expect(remaining, isEmpty);
    });

    test('returns false and keeps queue when replay fails', () async {
      final service = _TestContentSyncService(database, failUpsert: true);

      await service.enqueuePendingOp(
        tableRef: 'saved_items',
        opType: 'upsert',
        payload: {
          'user_id': 'u1',
          'content_type': 'krithi',
          'content_id': 'k1',
          'position': 1,
        },
      );

      final result = await service.flushPendingOps();

      final remaining = await database.select(database.pendingOps).get();
      expect(result, isFalse);
      expect(remaining.length, 1);
    });
  });
}
