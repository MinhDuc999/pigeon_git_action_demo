import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pigeon_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  static const MethodChannel extraChannel = MethodChannel('com.example/extra');

  DeviceInfo? _deviceInfo;
  BatteryInfo? _batteryInfo;
  int? _freeMem;
  int? _totalMem;
  String? _deviceTime;
  Map? _storage;

  Future<void> _getDeviceInfo() async {
    final info = await _api.getDeviceInfo();
    setState(() => _deviceInfo = info);
  }

  Future<void> _getBatteryInfo() async {
    final info = await _api.getBatteryInfo();
    setState(() => _batteryInfo = info);
  }

  Future<void> _getMemoryInfo() async {
    final freeMem = await extraChannel.invokeMethod<int>('getFreeMemory');
    final totalMem = await extraChannel.invokeMethod<int>('getTotalMemory');
    final deviceTime = await extraChannel.invokeMethod<String>('getDeviceTime');
    final storage = await extraChannel.invokeMethod<Map>('getStorageInfo');
    setState(() {
      _freeMem = freeMem;
      _totalMem = totalMem;
      _deviceTime = deviceTime;
      _storage = storage;
    });
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
              const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getMemoryInfo,
              child: const Text('Get Extra Device Info'),
            ),
            if (_freeMem != null && _totalMem != null && _deviceTime != null && _storage != null) ...[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Free Memory: $_freeMem MB'),
                      Text('Total Memory: $_totalMem MB'),
                      Text('Device Time: $_deviceTime'),
                      Text('Storage: ${_storage!['free']} MB free / ${_storage!['total']} MB total'),
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