import 'package:fast_clipboard/model/transfer_status.dart';
import 'package:flutter/foundation.dart';

class TransferProvider with ChangeNotifier {
  final TransferStatus status = TransferStatus.send;
}
