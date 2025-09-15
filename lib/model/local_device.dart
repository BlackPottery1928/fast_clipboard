class LocalDevice {
  final String appName;
  final String uniqueId;
  final String deviceName;
  final String deviceType;
  final String addrIPv4;
  // final String addrIPv6;

  LocalDevice(
    this.appName, {
    required this.uniqueId,
    required this.deviceName,
    required this.deviceType,
    this.addrIPv4 = '',
    // this.addrIPv6 = '',
  });

  Map<String, String> toMap() {
    return {
      'appName': appName,
      'uniqueId': uniqueId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'addrIPv4': addrIPv4,
      // 'addrIPv6': addrIPv6,
    };
  }
}
