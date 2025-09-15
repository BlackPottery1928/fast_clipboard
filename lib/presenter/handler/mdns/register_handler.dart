import 'package:fast_clipboard/common/device.dart';
import 'package:fast_clipboard/model/local_device.dart';

class RegisterHandler {
  RegisterHandler._();

  static final RegisterHandler _instance = RegisterHandler._();

  static RegisterHandler get instance => _instance;

  Future<LocalDevice> getLocalDevice() async {
    Map<String, String> deviceInfo = await Device.getDeviceInfo();

    LocalDevice device = LocalDevice(
      'FastSendApp',
      uniqueId: deviceInfo['uniqueId'] ?? '',
      deviceName: deviceInfo['deviceName'] ?? '',
      deviceType: Device.getDeviceTypeName(),
    );

    return device;
  }
}
