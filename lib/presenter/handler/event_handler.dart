import 'package:fast_clipboard/presenter/event/event_bus.dart';

class EventHandler {
  EventHandler._();

  static final EventHandler _instance = EventHandler._();

  EventBus get eventBus => _eventBus;

  static EventHandler get instance => _instance;

  final EventBus _eventBus = EventBus();

  void publish(Object event) {
    _eventBus.fire(event);
  }
}

final EventHandler eventHandler = EventHandler.instance;
