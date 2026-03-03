import 'package:equatable/equatable.dart';

class GuruStoryDetailState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? story;
  final String? errorMessage;

  const GuruStoryDetailState({
    required this.isLoading,
    required this.story,
    required this.errorMessage,
  });

  const GuruStoryDetailState.initial()
    : isLoading = false,
      story = null,
      errorMessage = null;

  GuruStoryDetailState copyWith({
    bool? isLoading,
    Map<String, dynamic>? story,
    String? errorMessage,
  }) {
    return GuruStoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      story: story ?? this.story,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, story, errorMessage];
}
