import 'dart:async';

import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';

enum SavedContentKind { krithi, keerthanam }

class SavedItemsSnapshot {
  final List<Map<String, dynamic>> items;
  final Set<String> savedIds;

  const SavedItemsSnapshot({required this.items, required this.savedIds});
}

class SavedItemsOrchestrationService {
  final LocalContentRepository _localRepository;
  final ContentSyncService _syncService;

  SavedItemsOrchestrationService(this._localRepository, this._syncService);

  Future<SavedItemsSnapshot> loadSaved({
    required String userId,
    required SavedContentKind kind,
    bool forceSync = false,
  }) async {
    final contentType = _toContentType(kind);

    final localIds = await _localRepository.getSavedContentIds(
      userId: userId,
      contentType: contentType,
    );
    final localItems = await _getItemsByKind(kind, localIds);

    if (forceSync || localIds.isEmpty) {
      await _syncService.syncSavedItemsForUser(
        userId: userId,
        contentType: contentType,
        force: true,
      );
      final refreshedIds = await _localRepository.getSavedContentIds(
        userId: userId,
        contentType: contentType,
      );

      var refreshedItems = await _getItemsByKind(kind, refreshedIds);
      if (refreshedItems.isEmpty && refreshedIds.isNotEmpty) {
        await _syncContentByKind(kind);
        refreshedItems = await _getItemsByKind(kind, refreshedIds);
      }

      return SavedItemsSnapshot(
        items: refreshedItems,
        savedIds: refreshedIds.toSet(),
      );
    }

    unawaited(_syncInBackground(userId: userId, kind: kind));

    return SavedItemsSnapshot(items: localItems, savedIds: localIds.toSet());
  }

  Future<SavedItemsSnapshot> removeSaved({
    required String userId,
    required SavedContentKind kind,
    required String contentId,
  }) async {
    final contentType = _toContentType(kind);
    await _localRepository.removeSavedItem(
      userId: userId,
      contentType: contentType,
      contentId: contentId,
    );
    await _syncService.enqueuePendingOp(
      tableRef: 'saved_items',
      opType: 'delete',
      payload: {
        'user_id': userId,
        'content_type': contentType,
        'content_id': contentId,
      },
    );

    return _buildSnapshot(userId: userId, kind: kind);
  }

  Future<SavedItemsSnapshot> toggleSaved({
    required String userId,
    required SavedContentKind kind,
    required String contentId,
    required Set<String> currentlySavedIds,
  }) async {
    if (currentlySavedIds.contains(contentId)) {
      return removeSaved(userId: userId, kind: kind, contentId: contentId);
    }

    final contentType = _toContentType(kind);
    final nextPosition =
        (await _localRepository.getMaxSavedPosition(
          userId: userId,
          contentType: contentType,
        )) ??
        0;

    await _localRepository.upsertSavedItem(
      userId: userId,
      contentType: contentType,
      contentId: contentId,
      position: nextPosition + 1,
    );
    await _syncService.enqueuePendingOp(
      tableRef: 'saved_items',
      opType: 'upsert',
      payload: {
        'user_id': userId,
        'content_type': contentType,
        'content_id': contentId,
        'position': nextPosition + 1,
      },
    );

    return _buildSnapshot(userId: userId, kind: kind);
  }

  Future<SavedItemsSnapshot> reorderSaved({
    required String userId,
    required SavedContentKind kind,
    required List<Map<String, dynamic>> currentItems,
    required int oldIndex,
    required int newIndex,
  }) async {
    final contentType = _toContentType(kind);
    final reordered = List<Map<String, dynamic>>.from(currentItems);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    final previousPositions = <String, int>{};
    for (var i = 0; i < currentItems.length; i++) {
      final id = currentItems[i]['id'] as String?;
      if (id != null) {
        previousPositions[id] = i + 1;
      }
    }

    for (var i = 0; i < reordered.length; i++) {
      final id = reordered[i]['id'] as String?;
      if (id == null) {
        continue;
      }
      final newPosition = i + 1;
      if (previousPositions[id] == newPosition) {
        continue;
      }

      await _localRepository.updateSavedPosition(
        userId: userId,
        contentType: contentType,
        contentId: id,
        position: newPosition,
      );
      await _syncService.enqueuePendingOp(
        tableRef: 'saved_items',
        opType: 'upsert',
        payload: {
          'user_id': userId,
          'content_type': contentType,
          'content_id': id,
          'position': newPosition,
        },
      );
    }

    return SavedItemsSnapshot(
      items: reordered,
      savedIds: reordered
          .map((item) => item['id'] as String?)
          .whereType<String>()
          .toSet(),
    );
  }

  Future<void> _syncInBackground({
    required String userId,
    required SavedContentKind kind,
  }) async {
    try {
      final contentType = _toContentType(kind);
      await _syncService.syncSavedItemsForUser(
        userId: userId,
        contentType: contentType,
      );
      final refreshedIds = await _localRepository.getSavedContentIds(
        userId: userId,
        contentType: contentType,
      );
      var refreshedItems = await _getItemsByKind(kind, refreshedIds);
      if (refreshedItems.isEmpty && refreshedIds.isNotEmpty) {
        await _syncContentByKind(kind);
        refreshedItems = await _getItemsByKind(kind, refreshedIds);
      }
    } catch (_) {}
  }

  Future<SavedItemsSnapshot> _buildSnapshot({
    required String userId,
    required SavedContentKind kind,
  }) async {
    final contentType = _toContentType(kind);
    final ids = await _localRepository.getSavedContentIds(
      userId: userId,
      contentType: contentType,
    );
    final items = await _getItemsByKind(kind, ids);
    return SavedItemsSnapshot(items: items, savedIds: ids.toSet());
  }

  String _toContentType(SavedContentKind kind) {
    switch (kind) {
      case SavedContentKind.krithi:
        return 'krithi';
      case SavedContentKind.keerthanam:
        return 'keerthanam';
    }
  }

  Future<List<Map<String, dynamic>>> _getItemsByKind(
    SavedContentKind kind,
    List<String> ids,
  ) {
    switch (kind) {
      case SavedContentKind.krithi:
        return _localRepository.getKrithisByIds(ids);
      case SavedContentKind.keerthanam:
        return _localRepository.getKeerthanamsByIds(ids);
    }
  }

  Future<void> _syncContentByKind(SavedContentKind kind) {
    switch (kind) {
      case SavedContentKind.krithi:
        return _syncService.syncKrithis(force: true);
      case SavedContentKind.keerthanam:
        return _syncService.syncKeerthanams(force: true);
    }
  }
}
