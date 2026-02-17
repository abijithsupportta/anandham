import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Monitors network connectivity and exposes current status.
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  /// Emits `true` when connected, `false` when offline.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool _isConnected = true;

  /// Last known connectivity state.
  bool get isConnected => _isConnected;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Call once at app start to begin listening to connectivity changes.
  Future<void> init() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = _parseResults(results);

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final connected = _parseResults(results);
      if (connected != _isConnected) {
        _isConnected = connected;
        _controller.add(_isConnected);
      }
    });
  }

  /// Manually check the current connectivity.
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isConnected = _parseResults(results);
    return _isConnected;
  }

  bool _parseResults(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Releases resources.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
