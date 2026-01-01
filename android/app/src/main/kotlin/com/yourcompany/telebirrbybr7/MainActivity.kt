package com.yourcompany.telebirrbybr7

import android.Manifest
import android.content.pm.PackageManager
import android.content.Intent
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val PERMISSION_REQUEST_CODE = 100
    private val DEFAULT_SMS_CHANNEL = "default_sms"
    private val SMS_SEND_CHANNEL = "sms_sender"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestSmsPermissions()
    }

    private fun requestSmsPermissions() {
        val permissions = arrayOf(
            Manifest.permission.SEND_SMS,
            Manifest.permission.READ_SMS,
            Manifest.permission.RECEIVE_SMS
        )

        val missingPermissions = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (missingPermissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                missingPermissions.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        // Optionally handle granted/denied permissions here
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel for requesting default SMS role
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEFAULT_SMS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "requestDefaultSms") {
                    val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
                    intent.putExtra(
                        Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
                        packageName
                    )
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.notImplemented()
                }
            }

        // MethodChannel for sending SMS natively
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_SEND_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "sendSms") {
                    val phone = call.argument<String>("phone") ?: ""
                    val message = call.argument<String>("message") ?: ""
                    try {
                        val smsManager = SmsManager.getDefault()
                        smsManager.sendTextMessage(phone, null, message, null, null)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SMS_ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}