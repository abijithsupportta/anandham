import 'package:equatable/equatable.dart';

class KrithiDetailState extends Equatable {
  final double fontSize;
  final String? videoId;

  const KrithiDetailState({required this.fontSize, required this.videoId});

  const KrithiDetailState.initial() : fontSize = 18.0, videoId = null;

  KrithiDetailState copyWith({double? fontSize, String? videoId}) {
    return KrithiDetailState(
      fontSize: fontSize ?? this.fontSize,
      videoId: videoId ?? this.videoId,
    );
  }

  @override
  List<Object?> get props => [fontSize, videoId];
}
