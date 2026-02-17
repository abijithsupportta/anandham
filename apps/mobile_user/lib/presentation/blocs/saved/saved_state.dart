import 'package:equatable/equatable.dart';

class SavedState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> items;
  final Set<String> savedIds;
  final String? errorMessage;

  const SavedState({
    required this.isLoading,
    required this.items,
    required this.savedIds,
    required this.errorMessage,
  });

  const SavedState.initial()
    : isLoading = false,
      items = const [],
      savedIds = const {},
      errorMessage = null;

  SavedState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? items,
    Set<String>? savedIds,
    String? errorMessage,
  }) {
    return SavedState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      savedIds: savedIds ?? this.savedIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, savedIds, errorMessage];
}
