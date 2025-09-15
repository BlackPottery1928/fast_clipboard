import 'package:fast_clipboard/model/connect_status.dart';
import 'package:flutter/foundation.dart';

class ConnectStatusProvider extends ChangeNotifier {
  final ConnectStatus status = ConnectStatus.connecting;
}
