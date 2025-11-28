package com.example.pigeon_git_action_demo

import DeviceApi
import DeviceInfo
import BatteryInfo
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        DeviceApi.setUp(flutterEngine.dartExecutor.binaryMessenger, DeviceApiImpl(this))
    }

    inner class DeviceApiImpl(private val context: Context) : DeviceApi {
        override fun getDeviceInfo(): DeviceInfo {
            return DeviceInfo(
                    model = Build.MODEL,
                    osVersion = Build.VERSION.RELEASE,
                    platform = "Android ${Build.VERSION.SDK_INT}"
            )
        }

        override fun getBatteryInfo(): BatteryInfo {
            val batteryStatus = context.registerReceiver(
                    null,
                    IntentFilter(Intent.ACTION_BATTERY_CHANGED)
            )

            val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            val batteryPct = if (level >= 0 && scale > 0) {
                (level * 100 / scale.toFloat()).toInt()
            } else {
                0
            }

            val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                    status == BatteryManager.BATTERY_STATUS_FULL

            return BatteryInfo(
                    level = batteryPct.toLong(),
                    isCharging = isCharging
            )
        }
    }
}