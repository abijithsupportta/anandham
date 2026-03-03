import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blogs_list_state.dart';

class BlogsListCubit extends Cubit<BlogsListState> {
  BlogsListCubit() : super(const BlogsListState.initial());

  static const int _pageSize = 10;
  static const Duration _networkTimeout = Duration(seconds: 15);

  Future<void> loadInitial() async {
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        page: 0,
        items: const [],
        errorMessage: null,
      ),
    );

    try {
      final items = await _fetchPage(0);
      emit(
        state.copyWith(
          isLoading: false,
          items: items,
          hasMore: items.length == _pageSize,
          page: 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Failed to load blogs'),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final items = await _fetchPage(state.page);
      emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...items],
          hasMore: items.length == _pageSize,
          page: state.page + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: 'Failed to load more blogs',
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

  Future<List<Map<String, dynamic>>> _fetchPage(int page) async {
    final from = page * _pageSize;
    final to = from + _pageSize - 1;

    final request = SupabaseConfig.client
        .from('blogs')
        .select(
          'id, title, excerpt, cover_images, youtube_url, '
          'published_at, created_at, '
          'category:blog_categories(id, name), author:authors(name)',
        )
        .eq('status', 'published')
        .eq('is_deleted', false);

    final rows = await request
        .order('published_at', ascending: false, nullsFirst: false)
        .order('created_at', ascending: false)
        .range(from, to)
        .timeout(_networkTimeout);
    return (rows as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
