package com.yourcompany.telebirrbybr7

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Telephony
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        // This receiver is required to qualify as a default SMS app on Android 5.0+
        // On Android 12+, this is STRICTLY REQUIRED for default SMS status
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // For Android 4.4 and above, use Telephony class
            if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
                parseSmsMessage(intent, context)
            }
        } else {
            // Fallback for older Android versions
            if (intent.action == "android.provider.Telephony.SMS_RECEIVED") {
                parseSmsMessage(intent, context)
            }
        }
    }
    
    private fun parseSmsMessage(intent: Intent, context: Context) {
        try {
            // Get the SMS message from the intent
            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
            
            if (messages != null && messages.isNotEmpty()) {
                val firstMessage = messages[0]
                val messageBody = firstMessage.messageBody ?: ""
                val senderNumber = firstMessage.displayOriginatingAddress ?: ""
                
                Log.d("SmsReceiver", "SMS received from: $senderNumber")
                Log.d("SmsReceiver", "Message body: $messageBody")
                
                // Optional: Forward this to your Flutter app if needed
                // You can use a MethodChannel or EventChannel here
                // For now, just logging is enough
            }
        } catch (e: Exception) {
            Log.e("SmsReceiver", "Error parsing SMS: ${e.message}")
        }
    }
}