import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  final _controller = StreamController<String>.broadcast();
  ConnectivityResult? _lastConnectivity;
  bool? _lastInternetStatus;

  NetworkService() {
    _checkInitialConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      await _emitConnectionStatus(result, initial: false);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    bool isOnline = await InternetConnectionChecker().hasConnection;

    _lastConnectivity = result;
    _lastInternetStatus = isOnline;

    if (!isOnline || result == ConnectivityResult.none) {
      _controller.sink.add("No Internet Connection ❌");
    }
  }

  Future<void> _emitConnectionStatus(ConnectivityResult result, {bool initial = false}) async {
    bool isOnline = await InternetConnectionChecker().hasConnection;

    // 🔹 Avoid duplicate messages (no change)
    if (!initial &&
        result == _lastConnectivity &&
        isOnline == _lastInternetStatus) return;

    _lastConnectivity = result;
    _lastInternetStatus = isOnline;

    if (!isOnline) {
      _controller.sink.add("Internet Disconnected ❌");
      return;
    }

    switch (result) {
      case ConnectivityResult.mobile:
        _controller.sink.add("Connected to Mobile Data !");
        break;
      case ConnectivityResult.wifi:
        _controller.sink.add("Connected to WiFi !");
        break;
      case ConnectivityResult.ethernet:
        _controller.sink.add("Connected to Ethernet !");
        break;
      case ConnectivityResult.vpn:
        _controller.sink.add("Connected via VPN !");
        break;
      case ConnectivityResult.none:
        _controller.sink.add("No Connection !");
        break;
      default:
        _controller.sink.add("Unknown Network !");
        break;
    }
  }

  Stream<String> get connectionStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
