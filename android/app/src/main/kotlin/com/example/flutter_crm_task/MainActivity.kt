package com.example.flutter_crm_task

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.security.ProviderInstaller
import com.google.android.gms.common.GooglePlayServicesNotAvailableException
import com.google.android.gms.common.GooglePlayServicesRepairableException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.flutter_crm_task/provider_installer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "installProvider") {
                try {
                    ProviderInstaller.installIfNeeded(this)
                    result.success(null)
                } catch (e: GooglePlayServicesRepairableException) {
                    result.error("PLAY_SERVICES_REPAIRABLE", "Google Play Services needs to be updated", null)
                } catch (e: GooglePlayServicesNotAvailableException) {
                    result.error("PLAY_SERVICES_NOT_AVAILABLE", "Google Play Services is not available", null)
                } catch (e: Exception) {
                    result.error("UNKNOWN_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
