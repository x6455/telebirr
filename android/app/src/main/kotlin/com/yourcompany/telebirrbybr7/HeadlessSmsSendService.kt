package com.yourcompany.telebirrbybr7

import android.service.quicksettings.TileService

/**
 * This service is required for your app to be eligible as the default SMS app.
 * Without this, Android will NOT allow your app to become the default SMS app.
 * 
 * This service handles the "quick reply" feature from notifications.
 * Even if you don't use quick reply, this class MUST exist.
 */
class HeadlessSmsSendService : TileService() {
    // This class can remain empty.
    // Its existence alone satisfies Android's requirement for default SMS apps.
}