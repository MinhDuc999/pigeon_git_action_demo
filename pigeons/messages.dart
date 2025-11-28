import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeon_generated.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/example/pigeon_git_action_demo/Pigeon.kt',
    swiftOut: 'ios/Runner/Pigeon.swift',
  ),
)

class DeviceInfo {
  DeviceInfo({required this.model, required this.osVersion, required this.platform});
  String model;
  String osVersion;
  String platform;
}

class BatteryInfo {
  BatteryInfo({required this.level, required this.isCharging});
  int level;
  bool isCharging;
}

@HostApi()
abstract class DeviceApi {
  DeviceInfo getDeviceInfo();
  BatteryInfo getBatteryInfo();
}