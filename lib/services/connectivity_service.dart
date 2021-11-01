import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:distributor/core/enums.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  // Public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    //Subscribe to the connectivity changed stream
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      connectionStatusController.add(_getStatusFromResult(connectivityResult));
    });
  }

  /// Convert from 3rd party enum
  _getStatusFromResult(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
        break;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
        break;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
        break;
      default:
        return ConnectivityStatus.Offline;
        break;
    }
  }
}