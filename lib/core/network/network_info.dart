import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for network connectivity checks
abstract class NetworkInfo {
  /// Check if device is currently connected to internet
  Future<bool> get isConnected;

  /// Stream that emits connectivity status changes
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result.first);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return _isConnected(results.first);
    });
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
