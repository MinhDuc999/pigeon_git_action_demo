import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let api = DeviceApiImpl()
        DeviceApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class DeviceApiImpl: DeviceApi {
    func getDeviceInfo() throws -> DeviceInfo {
        let device = UIDevice.current
        return DeviceInfo(
            model: device.model,
            osVersion: device.systemVersion,
            platform: "iOS \(device.systemVersion)"
        )
    }

    func getBatteryInfo() throws -> BatteryInfo {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        let state = UIDevice.current.batteryState

        let batteryLevel = level >= 0 ? Int64(level * 100) : 0
        let isCharging = state == .charging || state == .full

        return BatteryInfo(level: batteryLevel, isCharging: isCharging)
    }
}