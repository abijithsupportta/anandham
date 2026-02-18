import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keerthanam_saved_state.dart';

class KeerthanamSavedCubit extends Cubit<KeerthanamSavedState> {
  static const String _contentType = 'keerthanam';

  KeerthanamSavedCubit() : super(const KeerthanamSavedState.initial());

  Future<void> loadSaved() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: {}));
        return;
      }

      final savedRows = await SupabaseConfig.client
          .from('saved_items')
          .select('content_id')
          .eq('user_id', user.id)
          .eq('content_type', _contentType)
          .order('created_at', ascending: false);

      final savedIds = (savedRows as List<dynamic>)
          .map((row) => (row as Map<String, dynamic>)['content_id'] as String?)
          .whereType<String>()
          .toList();

      final savedSet = savedIds.toSet();

      if (savedIds.isEmpty) {
        emit(state.copyWith(isLoading: false, items: [], savedIds: savedSet));
        return;
      }

      final rows = await SupabaseConfig.client
          .from('guru_keerthanams')
          .select('id, title, description, author_name, youtube_url')
          .inFilter('id', savedIds)
          .eq('status', 'published')
          .eq('is_deleted', false)
          .order('display_order', ascending: true, nullsFirst: false)
          .order('created_at', ascending: false);

      final items = (rows as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();

      emit(state.copyWith(isLoading: false, items: items, savedIds: savedSet));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load saved keerthanams',
        ),
      );
    }
  }

  Future<void> removeSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    await SupabaseConfig.client
        .from('saved_items')
        .delete()
        .eq('user_id', user.id)
        .eq('content_type', _contentType)
        .eq('content_id', keerthanamId);

    await loadSaved();
  }

  Future<void> toggleSaved(String keerthanamId) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    if (state.savedIds.contains(keerthanamId)) {
      await SupabaseConfig.client
          .from('saved_items')
          .delete()
          .eq('user_id', user.id)
          .eq('content_type', _contentType)
          .eq('content_id', keerthanamId);
    } else {
      await SupabaseConfig.client.from('saved_items').insert({
        'user_id': user.id,
        'content_type': _contentType,
        'content_id': keerthanamId,
      });
    }

    await loadSaved();
  }
}
