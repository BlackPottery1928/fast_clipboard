import 'dart:isolate';
import 'dart:ui';

class HttpServerIsolateParams {
  final String address;
  final int port;
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;

  HttpServerIsolateParams(
    this.address,
    this.port,
    this.sendPort,
    this.rootIsolateToken,
  );
}
