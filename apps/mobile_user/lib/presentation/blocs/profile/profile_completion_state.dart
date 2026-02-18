import 'package:equatable/equatable.dart';

class ProfileCompletionState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic> profileData;
  final double completionPercentage;
  final List<String> missingFields;
  final String? errorMessage;

  const ProfileCompletionState({
    required this.isLoading,
    required this.profileData,
    required this.completionPercentage,
    required this.missingFields,
    required this.errorMessage,
  });

  const ProfileCompletionState.initial()
    : isLoading = false,
      profileData = const {},
      completionPercentage = 0.0,
      missingFields = const [],
      errorMessage = null;

  ProfileCompletionState copyWith({
    bool? isLoading,
    Map<String, dynamic>? profileData,
    double? completionPercentage,
    List<String>? missingFields,
    String? errorMessage,
  }) {
    return ProfileCompletionState(
      isLoading: isLoading ?? this.isLoading,
      profileData: profileData ?? this.profileData,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      missingFields: missingFields ?? this.missingFields,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    profileData,
    completionPercentage,
    missingFields,
    errorMessage,
  ];
}
