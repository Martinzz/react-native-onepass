package com.reactnativeonepass.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;

import com.facebook.react.bridge.ReadableMap;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

public class FullPortConfig extends BaseUIConfig {

    public FullPortConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
        super(activity, authHelper);
    }

    @Override
    public void configAuthPage(ReadableMap layout) {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        AuthUIConfig.Builder builder = new AuthUIConfig.Builder();
        setUILayout(layout, builder);
        mAuthHelper.setAuthUIConfig(builder.setScreenOrientation(authPageOrientation).create());
    }
}
