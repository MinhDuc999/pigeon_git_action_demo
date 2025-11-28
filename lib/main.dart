import 'package:flutter/material.dart';
import 'pigeon_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DeviceApi _api = DeviceApi();
  DeviceInfo? _deviceInfo;
  BatteryInfo? _batteryInfo;

  Future<void> _getDeviceInfo() async {
    final info = await _api.getDeviceInfo();
    setState(() => _deviceInfo = info);
  }

  Future<void> _getBatteryInfo() async {
    final info = await _api.getBatteryInfo();
    setState(() => _batteryInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pigeon Demo'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _getDeviceInfo,
              child: const Text('Get Device Info'),
            ),
            if (_deviceInfo != null) ...[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Model: ${_deviceInfo!.model}'),
                      Text('OS: ${_deviceInfo!.osVersion}'),
                      Text('Platform: ${_deviceInfo!.platform}'),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getBatteryInfo,
              child: const Text('Get Battery Info'),
            ),
            if (_batteryInfo != null) ...[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level: ${_batteryInfo!.level}%'),
                      Text('Charging: ${_batteryInfo!.isCharging ? "Yes" : "No"}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}