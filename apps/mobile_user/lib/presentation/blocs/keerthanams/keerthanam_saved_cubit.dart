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
        emit(state.copyWith(isLoading: false, savedIds: {}));
        return;
      }

      final savedRows = await SupabaseConfig.client
          .from('saved_items')
          .select('content_id')
          .eq('user_id', user.id)
          .eq('content_type', _contentType);

      final savedIds = (savedRows as List<dynamic>)
          .map((row) => (row as Map<String, dynamic>)['content_id'] as String?)
          .whereType<String>()
          .toList();

      emit(state.copyWith(isLoading: false, savedIds: savedIds.toSet()));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load saved keerthanams',
        ),
      );
    }
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
