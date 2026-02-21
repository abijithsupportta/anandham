import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? profileName;
  final List<Map<String, dynamic>> contentTypes;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    required this.profileName,
    required this.contentTypes,
    required this.errorMessage,
  });

  const HomeState.initial()
    : isLoading = false,
      profileName = null,
      contentTypes = const [],
      errorMessage = null;

  HomeState copyWith({
    bool? isLoading,
    String? profileName,
    List<Map<String, dynamic>>? contentTypes,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      profileName: profileName ?? this.profileName,
      contentTypes: contentTypes ?? this.contentTypes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    profileName,
    contentTypes,
    errorMessage,
  ];
}
