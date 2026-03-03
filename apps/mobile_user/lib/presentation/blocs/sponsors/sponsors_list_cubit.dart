import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sponsors_list_state.dart';

class SponsorsListCubit extends Cubit<SponsorsListState> {
  SponsorsListCubit() : super(const SponsorsListState.initial());

  Future<void> loadSponsors() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final rows = await SupabaseConfig.client
          .from('sponsors')
          .select(
            'id, sponsor_name, house_name, photo_url, donated_amount, '
            'amount_visible, created_at',
          )
          .eq('status', 'published')
          .eq('is_deleted', false)
          .order('donated_amount', ascending: false)
          .order('created_at', ascending: true);

      emit(
        state.copyWith(
          isLoading: false,
          items: (rows as List<dynamic>).cast<Map<String, dynamic>>(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load sponsors',
        ),
      );
    }
  }

  void updateQuery(String query) {
    if (query == state.query) {
      return;
    }
    emit(state.copyWith(query: query, errorMessage: null));
  }
}
