import 'package:equatable/equatable.dart';

class DharmaSloka extends Equatable {
  final int itemNumber;
  final String text;
  final String explanation;

  const DharmaSloka({
    required this.itemNumber,
    required this.text,
    required this.explanation,
  });

  @override
  List<Object?> get props => [itemNumber, text, explanation];
}

class DharmaWord extends Equatable {
  final String word;
  final String meaning;

  const DharmaWord({required this.word, required this.meaning});

  @override
  List<Object?> get props => [word, meaning];
}

class DharmaItemView extends Equatable {
  final String id;
  final String title;
  final String description;
  final String translation;
  final List<DharmaSloka> slokas;
  final List<DharmaWord> words;

  const DharmaItemView({
    required this.id,
    required this.title,
    required this.description,
    required this.translation,
    required this.slokas,
    required this.words,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    translation,
    slokas,
    words,
  ];
}

class DharmasState extends Equatable {
  final bool isLoading;
  final List<DharmaItemView> items;
  final Map<String, String> categoryById;
  final String? errorMessage;

  const DharmasState({
    required this.isLoading,
    required this.items,
    required this.categoryById,
    required this.errorMessage,
  });

  const DharmasState.initial()
    : isLoading = false,
      items = const [],
      categoryById = const {},
      errorMessage = null;

  DharmasState copyWith({
    bool? isLoading,
    List<DharmaItemView>? items,
    Map<String, String>? categoryById,
    String? errorMessage,
  }) {
    return DharmasState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      categoryById: categoryById ?? this.categoryById,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, categoryById, errorMessage];
}
