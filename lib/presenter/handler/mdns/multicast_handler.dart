import 'package:bonsoir/bonsoir.dart';
import 'package:fast_clipboard/presenter/event/discovery_service_event.dart';
import 'package:fast_clipboard/presenter/handler/event_handler.dart';
import 'package:fast_clipboard/presenter/handler/logger_handler.dart';

final String mDNSServerInstance = 'FastSendApp';
final String mDNSServerName = '_http._tcp';
final int mDNSServerPort = 5353;

class MulticastServerHandler {
  MulticastServerHandler._();

  static final MulticastServerHandler _instance = MulticastServerHandler._();

  static MulticastServerHandler get instance => _instance;

  Future<void> startup(Map<String, String> args) async {
    try {
      // 参数
      Map<String, String> attributes = {}
        ..addAll(args)
        ..addAll(BonsoirService.defaultAttributes);

      final BonsoirService bonsoirService = BonsoirService(
        name: mDNSServerInstance,
        type: mDNSServerName,
        port: mDNSServerPort,
        attributes: attributes,
      );

      BonsoirBroadcast broadcast = BonsoirBroadcast(service: bonsoirService);
      await broadcast.initialize();
      await broadcast.start();
    } on Exception catch (e) {
      LoggerHandler.instance.error('MDNS startup failed: ${e.toString()}');
    }
  }
}

class MulticastClientHandler {
  MulticastClientHandler._();

  static final MulticastClientHandler _instance = MulticastClientHandler._();

  static MulticastClientHandler get instance => _instance;

  Future<void> discover() async {
    LoggerHandler.instance.info('Discovering HTTP services...');

    final BonsoirDiscovery discovery = BonsoirDiscovery(type: mDNSServerName);
    await discovery.initialize();

    discovery.eventStream!.listen((event) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          EventHandler.instance.publish(
            DiscoveryServiceEvent(
              discoveryServiceId:
                  BonsoirDiscoveryServiceFoundEvent.discoveryServiceFound,
              data: event.service.toJson()['service.attributes'],
            ),
          );
          break;
        case BonsoirDiscoveryServiceResolvedEvent():
          EventHandler.instance.publish(
            DiscoveryServiceEvent(
              discoveryServiceId:
                  BonsoirDiscoveryServiceResolvedEvent.discoveryServiceResolved,
              data: event.service.toJson()['service.attributes'],
            ),
          );
          break;
        case BonsoirDiscoveryServiceUpdatedEvent():
          EventHandler.instance.publish(
            DiscoveryServiceEvent(
              discoveryServiceId:
                  BonsoirDiscoveryServiceUpdatedEvent.discoveryServiceUpdated,
              data: event.service.toJson()['service.attributes'],
            ),
          );
          break;
        case BonsoirDiscoveryServiceLostEvent():
          EventHandler.instance.publish(
            DiscoveryServiceEvent(
              discoveryServiceId:
                  BonsoirDiscoveryServiceLostEvent.discoveryServiceLost,
              data: event.service.toJson()['service.attributes'],
            ),
          );
          break;
        default:
          // print('Another event occurred : $event.');
          break;
      }
    });

    await discovery.start();
  }
}
