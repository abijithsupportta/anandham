import 'package:equatable/equatable.dart';

class SponsorsListState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> items;
  final String query;
  final String? errorMessage;

  const SponsorsListState({
    required this.isLoading,
    required this.items,
    required this.query,
    required this.errorMessage,
  });

  const SponsorsListState.initial()
    : isLoading = false,
      items = const [],
      query = '',
      errorMessage = null;

  SponsorsListState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? items,
    String? query,
    String? errorMessage,
  }) {
    return SponsorsListState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, query, errorMessage];
}
