import 'package:equatable/equatable.dart';

class BlogsListState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final List<Map<String, dynamic>> items;
  final String query;
  final String? errorMessage;

  const BlogsListState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.page,
    required this.items,
    required this.query,
    required this.errorMessage,
  });

  const BlogsListState.initial()
    : isLoading = false,
      isLoadingMore = false,
      hasMore = true,
      page = 0,
      items = const [],
      query = '',
      errorMessage = null;

  BlogsListState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    List<Map<String, dynamic>>? items,
    String? query,
    String? errorMessage,
  }) {
    return BlogsListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      items: items ?? this.items,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    hasMore,
    page,
    items,
    query,
    errorMessage,
  ];
}
