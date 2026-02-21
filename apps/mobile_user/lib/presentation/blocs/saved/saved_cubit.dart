import 'dart:async';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/data/services/saved_items_orchestration_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  final SavedItemsOrchestrationService _savedService;

  SavedCubit({SavedItemsOrchestrationService? savedService})
    : _savedService = savedService ?? sl<SavedItemsOrchestrationService>(),
      super(const SavedState.initial());

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
        kind: SavedContentKind.krithi,
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
    } catch (e) {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }
      final snapshot = await _savedService.loadSaved(
        userId: user.id,
        kind: SavedContentKind.krithi,
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

  Future<void> removeSaved(String krithiId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    final snapshot = await _savedService.removeSaved(
      userId: user.id,
      kind: SavedContentKind.krithi,
      contentId: krithiId,
    );
    emit(
      state.copyWith(
        items: snapshot.items,
        savedIds: snapshot.savedIds,
        errorMessage: null,
      ),
    );
  }

  Future<void> toggleSaved(String krithiId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    if (state.savedIds.contains(krithiId)) {
      await removeSaved(krithiId);
      return;
    }

    final snapshot = await _savedService.toggleSaved(
      userId: user.id,
      kind: SavedContentKind.krithi,
      contentId: krithiId,
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
      kind: SavedContentKind.krithi,
      currentItems: state.items,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );

    emit(state.copyWith(items: snapshot.items, savedIds: snapshot.savedIds));
  }
}
