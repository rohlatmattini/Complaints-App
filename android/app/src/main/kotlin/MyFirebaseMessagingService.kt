package com.example.complaints

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.util.Log

class MyFirebaseMessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(message: RemoteMessage) {
        Log.d("FCM_TEST", "تم استقبال الإشعار ✅")
        Log.d("FCM_TEST", "العنوان: ${message.notification?.title}")
        Log.d("FCM_TEST", "المحتوى: ${message.notification?.body}")
    }
}
