import 'package:equatable/equatable.dart';

class KeerthanamSavedState extends Equatable {
  final bool isLoading;
  final Set<String> savedIds;
  final String? errorMessage;

  const KeerthanamSavedState({
    required this.isLoading,
    required this.savedIds,
    required this.errorMessage,
  });

  const KeerthanamSavedState.initial()
    : isLoading = false,
      savedIds = const {},
      errorMessage = null;

  KeerthanamSavedState copyWith({
    bool? isLoading,
    Set<String>? savedIds,
    String? errorMessage,
  }) {
    return KeerthanamSavedState(
      isLoading: isLoading ?? this.isLoading,
      savedIds: savedIds ?? this.savedIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, savedIds, errorMessage];
}
