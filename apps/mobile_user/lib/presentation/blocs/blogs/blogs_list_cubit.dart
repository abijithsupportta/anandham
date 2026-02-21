import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/domain/usecases/get_blogs_page_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blogs_list_state.dart';

class BlogsListCubit extends Cubit<BlogsListState> {
  final GetBlogsPageUseCase _getBlogsPageUseCase;

  BlogsListCubit({GetBlogsPageUseCase? getBlogsPageUseCase})
    : _getBlogsPageUseCase = getBlogsPageUseCase ?? sl<GetBlogsPageUseCase>(),
      super(const BlogsListState.initial());

  static const int _pageSize = 10;

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
    return _getBlogsPageUseCase(from: from, to: to);
  }
}
