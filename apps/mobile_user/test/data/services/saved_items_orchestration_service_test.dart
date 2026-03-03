import 'package:anandham_user/data/local/db/app_database.dart';
import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:anandham_user/data/services/saved_items_orchestration_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SavedItemsOrchestrationService.reorderSaved', () {
    late AppDatabase database;
    late LocalContentRepository localRepository;
    late ContentSyncService syncService;
    late SavedItemsOrchestrationService orchestrationService;

    const userId = 'u1';
    const contentType = 'krithi';

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      localRepository = LocalContentRepository(database);
      syncService = ContentSyncService(database);
      orchestrationService = SavedItemsOrchestrationService(
        localRepository,
        syncService,
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('updates local ordering and enqueues pending upserts', () async {
      await localRepository.upsertSavedItem(
        userId: userId,
        contentType: contentType,
        contentId: 'a',
        position: 1,
      );
      await localRepository.upsertSavedItem(
        userId: userId,
        contentType: contentType,
        contentId: 'b',
        position: 2,
      );
      await localRepository.upsertSavedItem(
        userId: userId,
        contentType: contentType,
        contentId: 'c',
        position: 3,
      );

      final snapshot = await orchestrationService.reorderSaved(
        userId: userId,
        kind: SavedContentKind.krithi,
        currentItems: const [
          {'id': 'a'},
          {'id': 'b'},
          {'id': 'c'},
        ],
        oldIndex: 0,
        newIndex: 3,
      );

      final orderedIds = await localRepository.getSavedContentIds(
        userId: userId,
        contentType: contentType,
      );
      final pendingOps = await database.select(database.pendingOps).get();

      expect(snapshot.items.map((item) => item['id']), ['b', 'c', 'a']);
      expect(orderedIds, ['b', 'c', 'a']);
      expect(pendingOps.length, greaterThanOrEqualTo(2));
    });
  });
}
