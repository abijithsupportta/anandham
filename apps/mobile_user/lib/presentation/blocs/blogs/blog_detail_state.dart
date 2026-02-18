import 'package:equatable/equatable.dart';

class BlogDetailState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? blog;
  final String? errorMessage;

  const BlogDetailState({
    required this.isLoading,
    required this.blog,
    required this.errorMessage,
  });

  const BlogDetailState.initial()
    : isLoading = false,
      blog = null,
      errorMessage = null;

  BlogDetailState copyWith({
    bool? isLoading,
    Map<String, dynamic>? blog,
    String? errorMessage,
  }) {
    return BlogDetailState(
      isLoading: isLoading ?? this.isLoading,
      blog: blog ?? this.blog,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, blog, errorMessage];
}
