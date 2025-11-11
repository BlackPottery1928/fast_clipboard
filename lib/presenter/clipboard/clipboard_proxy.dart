import 'package:super_clipboard/super_clipboard.dart';

class ClipboardProxy {
  final clipboard = SystemClipboard.instance;

  Future<String> getClipboardText() async {
    if (clipboard == null) {
      return "";
    }

    final ClipboardReader? reader = await clipboard?.read();
    reader?.canProvide(Formats.plainText);

    return '';
  }
}
