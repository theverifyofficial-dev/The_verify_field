import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  final _controller = StreamController<String>.broadcast();

  NetworkService() {
    // Check initial status
    _checkInitialConnection();

    // Listen for network changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      await _emitConnectionStatus(result);
    });
  }

  /// Initial check
  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    await _emitConnectionStatus(result);
  }

  /// Emit message based on connection + actual internet availability
  Future<void> _emitConnectionStatus(ConnectivityResult result) async {
    bool isOnline = await InternetConnectionChecker().hasConnection;

    if (!isOnline) {
      _controller.sink.add("Internet Off ❌");
      return;
    }

    // 🔹 Always emit on every change (so WiFi ↔ Mobile shows too)
    switch (result) {
      case ConnectivityResult.mobile:
        _controller.sink.add("Switched to Mobile Data 📱✅");
        break;
      case ConnectivityResult.wifi:
        _controller.sink.add("Switched to WiFi 📶✅");
        break;
      case ConnectivityResult.ethernet:
        _controller.sink.add("Switched to Ethernet 🔌✅");
        break;
      case ConnectivityResult.bluetooth:
        _controller.sink.add("Switched to Bluetooth Tethering 🔵✅");
        break;
      case ConnectivityResult.vpn:
        _controller.sink.add("Using VPN 🛡️✅");
        break;
      case ConnectivityResult.none:
        _controller.sink.add("No Connection 🚫");
        break;
      default:
        _controller.sink.add("Unknown Connection ❓");
        break;
    }
  }

  Stream<String> get connectionStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
