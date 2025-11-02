import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datakap/core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onStatusChange => connectivity.onConnectivityChanged.map((status) => status != ConnectivityResult.none);
}
