import 'package:equatable/equatable.dart';

class KeerthanamSavedState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> items;
  final Set<String> savedIds;
  final String? errorMessage;

  const KeerthanamSavedState({
    required this.isLoading,
    required this.items,
    required this.savedIds,
    required this.errorMessage,
  });

  const KeerthanamSavedState.initial()
    : isLoading = false,
      items = const [],
      savedIds = const {},
      errorMessage = null;

  KeerthanamSavedState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? items,
    Set<String>? savedIds,
    String? errorMessage,
  }) {
    return KeerthanamSavedState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      savedIds: savedIds ?? this.savedIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, savedIds, errorMessage];
}
