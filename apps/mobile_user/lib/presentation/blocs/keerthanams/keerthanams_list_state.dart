import 'package:equatable/equatable.dart';

class KeerthanamsListState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> filteredItems;
  final String query;
  final String? errorMessage;

  const KeerthanamsListState({
    required this.isLoading,
    required this.items,
    required this.filteredItems,
    required this.query,
    required this.errorMessage,
  });

  const KeerthanamsListState.initial()
    : isLoading = false,
      items = const [],
      filteredItems = const [],
      query = '',
      errorMessage = null;

  KeerthanamsListState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? items,
    List<Map<String, dynamic>>? filteredItems,
    String? query,
    String? errorMessage,
  }) {
    return KeerthanamsListState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    items,
    filteredItems,
    query,
    errorMessage,
  ];
}
