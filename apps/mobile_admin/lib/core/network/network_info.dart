import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for checking network connectivity.
abstract class NetworkInfo {
  /// Returns true if the device has an active internet connection.
  Future<bool> get isConnected;

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using connectivity_plus package.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
