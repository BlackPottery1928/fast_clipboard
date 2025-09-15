import 'dart:io';

class NetworkHandler {
  NetworkHandler._();

  static final NetworkHandler _instance = NetworkHandler._();

  static NetworkHandler get instance => _instance;

  Future<List<InternetAddress>> getInternetAddress() async {
    List<InternetAddress> internetAddresses = [];

    for (final interface in await NetworkInterface.list()) {
      for (final InternetAddress addr in interface.addresses) {
        if (!addr.isLoopback) {
          internetAddresses.add(addr);
          break;
        }
      }
    }
    return internetAddresses;
  }

  Future<String> getIpAddress() async {
    List<InternetAddress> internetAddresses = await getInternetAddress();
    return internetAddresses.first.address;
  }
}
