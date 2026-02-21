import 'dart:async';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/data/services/saved_items_orchestration_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keerthanam_saved_state.dart';

class KeerthanamSavedCubit extends Cubit<KeerthanamSavedState> {
  final SavedItemsOrchestrationService _savedService;

  KeerthanamSavedCubit({SavedItemsOrchestrationService? savedService})
    : _savedService = savedService ?? sl<SavedItemsOrchestrationService>(),
      super(const KeerthanamSavedState.initial());

  Future<void> loadSaved({bool forceSync = false}) async {
    emit(state.copyWith(isLoading: state.items.isEmpty, errorMessage: null));

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }

      final snapshot = await _savedService.loadSaved(
        userId: user.id,
        kind: SavedContentKind.keerthanam,
        forceSync: forceSync,
      );

      emit(
        state.copyWith(
          isLoading: false,
          items: snapshot.items,
          savedIds: snapshot.savedIds,
          errorMessage: null,
        ),
      );
    } catch (_) {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }
      final snapshot = await _savedService.loadSaved(
        userId: user.id,
        kind: SavedContentKind.keerthanam,
      );
      emit(
        state.copyWith(
          isLoading: false,
          items: snapshot.items,
          savedIds: snapshot.savedIds,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> removeSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    final snapshot = await _savedService.removeSaved(
      userId: user.id,
      kind: SavedContentKind.keerthanam,
      contentId: keerthanamId,
    );
    emit(
      state.copyWith(
        items: snapshot.items,
        savedIds: snapshot.savedIds,
        errorMessage: null,
      ),
    );
  }

  Future<void> toggleSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    if (state.savedIds.contains(keerthanamId)) {
      await removeSaved(keerthanamId);
      return;
    }

    final snapshot = await _savedService.toggleSaved(
      userId: user.id,
      kind: SavedContentKind.keerthanam,
      contentId: keerthanamId,
      currentlySavedIds: state.savedIds,
    );
    emit(
      state.copyWith(
        items: snapshot.items,
        savedIds: snapshot.savedIds,
        errorMessage: null,
      ),
    );
  }

  Future<void> reorderSaved(int oldIndex, int newIndex) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    final snapshot = await _savedService.reorderSaved(
      userId: user.id,
      kind: SavedContentKind.keerthanam,
      currentItems: state.items,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );

    emit(state.copyWith(items: snapshot.items, savedIds: snapshot.savedIds));
  }

  void clearError() {
    emit(
      state.copyWith(
        isLoading: state.isLoading,
        items: state.items,
        savedIds: state.savedIds,
        errorMessage: null,
      ),
    );
  }
}
