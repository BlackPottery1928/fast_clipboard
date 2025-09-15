import 'package:intl/intl.dart';

class Time {
  static String display(Duration duration) {
    return DateFormat(
      'mm:ss',
    ).format(DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds));
  }
}
