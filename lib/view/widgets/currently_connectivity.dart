import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_clipboard/common/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class CurrentlyConnectivity extends StatefulWidget {
  const CurrentlyConnectivity({super.key});

  @override
  State<CurrentlyConnectivity> createState() => _CurrentlyConnectivityState();
}

class _CurrentlyConnectivityState extends State<CurrentlyConnectivity> {
  late List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<bool>(
          future: SimpleConnectionChecker.isConnectedToInternet(),
          builder: (context, snapshot) {
            return IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {},
              iconSize: 16,
              icon: Icon(
                Device.getNetworkIcon(_connectionStatus),
                color: snapshot.hasData && snapshot.data!
                    ? Colors.green
                    : Colors.grey,
              ),
            );
          },
        ),
        Gap(6),
      ],
    );
  }
}
