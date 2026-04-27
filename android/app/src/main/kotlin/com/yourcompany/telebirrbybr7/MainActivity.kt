package com.yourcompany.telebirrbybr7

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsManager
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
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
        createNotificationChannel()
        registerSmsSentReceiver()
    }

    private fun requestSmsPermissions() {
        val permissions = arrayOf(
            Manifest.permission.SEND_SMS,
            Manifest.permission.READ_SMS,
            Manifest.permission.RECEIVE_SMS,
            Manifest.permission.FOREGROUND_SERVICE
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

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "sms_channel",
                "SMS Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Used for sending SMS confirmations"
            }
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun registerSmsSentReceiver() {
        val sentReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                when (resultCode) {
                    android.app.Activity.RESULT_OK -> {
                        // SMS sent successfully
                        android.util.Log.d("SmsSender", "SMS sent successfully")
                    }
                    SmsManager.RESULT_ERROR_GENERIC_FAILURE -> {
                        android.util.Log.e("SmsSender", "Generic failure")
                    }
                    SmsManager.RESULT_ERROR_NO_SERVICE -> {
                        android.util.Log.e("SmsSender", "No service")
                    }
                    SmsManager.RESULT_ERROR_NULL_PDU -> {
                        android.util.Log.e("SmsSender", "Null PDU")
                    }
                    SmsManager.RESULT_ERROR_RADIO_OFF -> {
                        android.util.Log.e("SmsSender", "Radio off")
                    }
                }
            }
        }
        registerReceiver(sentReceiver, IntentFilter("SMS_SENT"), RECEIVER_EXPORTED)
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
                when (call.method) {
                    "requestDefaultSms" -> {
                        val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
                        intent.putExtra(
                            Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
                            packageName
                        )
                        startActivity(intent)
                        result.success(true)
                    }
                    "isDefaultSms" -> {
                        val isDefault = Telephony.Sms.getDefaultSmsPackage(this) == packageName
                        result.success(isDefault)
                    }
                    else -> result.notImplemented()
                }
            }

        // MethodChannel for sending SMS (Android 12+ compatible)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_SEND_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "sendSms") {
                    val phone = call.argument<String>("phone") ?: ""
                    val message = call.argument<String>("message") ?: ""

                    try {
                        val smsManager = SmsManager.getDefault()
                        
                        // Check if message needs splitting
                        val parts = smsManager.divideMessage(message)
                        
                        val sentIntents = ArrayList<PendingIntent>()
                        val deliveryIntents = ArrayList<PendingIntent>()

                        for (i in parts.indices) {
                            val sentIntent = PendingIntent.getBroadcast(
                                this, i, Intent("SMS_SENT"), 
                                PendingIntent.FLAG_IMMUTABLE
                            )
                            val deliveryIntent = PendingIntent.getBroadcast(
                                this, i, Intent("SMS_DELIVERED"), 
                                PendingIntent.FLAG_IMMUTABLE
                            )
                            sentIntents.add(sentIntent)
                            deliveryIntents.add(deliveryIntent)
                        }

                        // Send the message
                        if (parts.size == 1) {
                            smsManager.sendTextMessage(
                                phone, null, message, 
                                sentIntents.firstOrNull(), 
                                deliveryIntents.firstOrNull()
                            )
                        } else {
                            smsManager.sendMultipartTextMessage(
                                phone, null, parts, sentIntents, deliveryIntents
                            )
                        }

                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SMS_ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Unregister to avoid leaks
        try {
            unregisterReceiver(object : BroadcastReceiver() {
                override fun onReceive(context: Context, intent: Intent) {}
            })
        } catch (e: Exception) {
            // Receiver not registered
        }
    }
}