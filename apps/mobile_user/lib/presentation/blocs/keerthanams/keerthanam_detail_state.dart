import 'package:equatable/equatable.dart';

class KeerthanamDetailState extends Equatable {
  final double fontSize;
  final String? videoId;

  const KeerthanamDetailState({required this.fontSize, required this.videoId});

  const KeerthanamDetailState.initial() : fontSize = 18.0, videoId = null;

  KeerthanamDetailState copyWith({double? fontSize, String? videoId}) {
    return KeerthanamDetailState(
      fontSize: fontSize ?? this.fontSize,
      videoId: videoId ?? this.videoId,
    );
  }

  @override
  List<Object?> get props => [fontSize, videoId];
}
