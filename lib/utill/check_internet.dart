import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart' as rx;

typedef RecieveStateCallback = Function(List<ConnectivityResult>);

mixin CheckInternet {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  rx.Rx<List<ConnectivityResult>> state = rx.Rx([]);

  checkNow(RecieveStateCallback recieveStateCallback) async {
    var connectivity = Connectivity();
    //recieveStateCallback(await connectivity.checkConnectivity());

    _subscription = connectivity.onConnectivityChanged.listen((event) {
      recieveStateCallback.call(event);
      state.value = event;
    });
  }

  Future<List<ConnectivityResult>> isConnected() async {
    var result = await Connectivity().checkConnectivity();
    return result;
  }

  disposeInternetSubscription() {
    if (_subscription == null) return;
    _subscription?.cancel();
  }
}
