import 'package:flutter_bloc/flutter_bloc.dart';

import 'krithi_detail_state.dart';

class KrithiDetailCubit extends Cubit<KrithiDetailState> {
  static const double minFontSize = 16.0;
  static const double maxFontSize = 26.0;

  KrithiDetailCubit() : super(const KrithiDetailState.initial());

  void initVideo(String url) {
    final id = _extractYoutubeId(url);
    emit(state.copyWith(videoId: id.isEmpty ? null : id));
  }

  void increaseFontSize() {
    final next = (state.fontSize + 1).clamp(minFontSize, maxFontSize);
    emit(state.copyWith(fontSize: next));
  }

  void decreaseFontSize() {
    final next = (state.fontSize - 1).clamp(minFontSize, maxFontSize);
    emit(state.copyWith(fontSize: next));
  }

  String _extractYoutubeId(String url) {
    try {
      if (url.contains('youtube.com/embed/')) {
        return url.split('embed/')[1].split('?')[0];
      } else if (url.contains('youtube.com/watch?v=')) {
        return url.split('v=')[1].split('&')[0];
      } else if (url.contains('youtu.be/')) {
        return url.split('youtu.be/')[1].split('?')[0];
      }
    } catch (_) {
      return '';
    }
    return '';
  }
}
