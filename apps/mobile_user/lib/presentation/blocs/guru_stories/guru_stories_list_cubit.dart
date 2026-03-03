import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guru_stories_list_state.dart';

class GuruStoriesListCubit extends Cubit<GuruStoriesListState> {
  GuruStoriesListCubit() : super(const GuruStoriesListState.initial());

  Future<void> loadStories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final rows = await SupabaseConfig.client
          .from('guru_stories')
          .select(
            'id, title, body, author_name, reference_book, '
            'published_at, created_at',
          )
          .eq('status', 'published')
          .eq('is_deleted', false)
          .order('published_at', ascending: false, nullsFirst: false)
          .order('created_at', ascending: false);

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
          errorMessage: 'Failed to load guru stories',
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
