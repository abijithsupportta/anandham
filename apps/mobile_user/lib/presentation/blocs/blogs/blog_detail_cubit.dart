import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blog_detail_state.dart';

class BlogDetailCubit extends Cubit<BlogDetailState> {
  BlogDetailCubit() : super(const BlogDetailState.initial());

  Future<void> loadBlog(String blogId) async {
    if (blogId.trim().isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Invalid blog id'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final row = await SupabaseConfig.client
          .from('blogs')
          .select(
            'id, title, excerpt, body, cover_images, youtube_url, '
            'published_at, created_at, author:authors(name)',
          )
          .eq('id', blogId)
          .eq('status', 'published')
          .eq('is_deleted', false)
          .single();

      emit(state.copyWith(isLoading: false, blog: row));
    } catch (_) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Failed to load blog'),
      );
    }
  }
}
