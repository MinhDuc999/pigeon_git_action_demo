package com.example.pigeon_git_action_demo

import DeviceApi
import DeviceInfo
import BatteryInfo
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        DeviceApi.setUp(flutterEngine.dartExecutor.binaryMessenger, DeviceApiImpl(this))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example/extra").setMethodCallHandler { call, result ->
            when(call.method) {
                "getFreeMemory" -> {
                    val runtime = Runtime.getRuntime()
                    result.success((runtime.freeMemory() / 1024 / 1024).toInt())
                }
                "getTotalMemory" -> {
                    val runtime = Runtime.getRuntime()
                    result.success((runtime.totalMemory() / 1024 / 1024).toInt())
                }
                "getDeviceTime" -> {
                    val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
                    result.success(sdf.format(Date()))
                }
                "getStorageInfo" -> {
                    val path = Environment.getDataDirectory()
                    val stat = StatFs(path.path)
                    val freeMB = (stat.availableBlocksLong * stat.blockSizeLong / 1024 / 1024).toInt()
                    val totalMB = (stat.blockCountLong * stat.blockSizeLong / 1024 / 1024).toInt()
                    result.success(mapOf("free" to freeMB, "total" to totalMB))
                }
                else -> result.notImplemented()
            }
        }

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
