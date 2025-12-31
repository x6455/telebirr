package com.yourcompany.telebirrbybr7;

import android.content.Intent;
import android.os.Build;
import android.provider.Telephony;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "sms_role";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(),
            CHANNEL
        ).setMethodCallHandler((call, result) -> {

            if (call.method.equals("isDefaultSmsApp")) {
                String pkg = Telephony.Sms.getDefaultSmsPackage(this);
                result.success(getPackageName().equals(pkg));
            }

            else if (call.method.equals("requestDefaultSmsApp")) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    Intent intent =
                        new Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT);
                    intent.putExtra(
                        Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
                        getPackageName()
                    );
                    startActivity(intent);
                    result.success(true);
                } else {
                    result.success(false);
                }
            }

            else {
                result.notImplemented();
            }
        });
    }
}
