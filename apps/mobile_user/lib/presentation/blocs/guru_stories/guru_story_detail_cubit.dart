import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guru_story_detail_state.dart';

class GuruStoryDetailCubit extends Cubit<GuruStoryDetailState> {
  GuruStoryDetailCubit() : super(const GuruStoryDetailState.initial());

  Future<void> loadStory(String storyId) async {
    if (storyId.trim().isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Invalid story id'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final row = await SupabaseConfig.client
          .from('guru_stories')
          .select(
            'id, title, body, author_name, reference_book, '
            'published_at, created_at',
          )
          .eq('id', storyId)
          .eq('status', 'published')
          .eq('is_deleted', false)
          .single();

      emit(state.copyWith(isLoading: false, story: row));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load guru story',
        ),
      );
    }
  }
}
