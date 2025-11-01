import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onStatusChange;
}

class ConnectivityNetworkInfo implements NetworkInfo {
  ConnectivityNetworkInfo({required Connectivity connectivity})
      : _connectivity = connectivity,
        _statusController = StreamController<bool>.broadcast();

  final Connectivity _connectivity;
  final StreamController<bool> _statusController;
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onStatusChange {
    _subscription ??= _connectivity.onConnectivityChanged.listen((status) {
      final isOnline = status != ConnectivityResult.none;
      _statusController.add(isOnline);
    });
    return _statusController.stream.distinct();
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
