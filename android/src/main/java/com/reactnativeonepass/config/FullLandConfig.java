package com.reactnativeonepass.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;

import com.facebook.react.bridge.ReadableMap;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

public class FullLandConfig extends BaseUIConfig {

    private int mOldScreenOrientation;

    public FullLandConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
        super(activity, authHelper);
    }

    @Override
    public void configAuthPage(ReadableMap layout) {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
        AuthUIConfig.Builder builder = new AuthUIConfig.Builder();

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
        if (Build.VERSION.SDK_INT == 26) {
            mOldScreenOrientation = mActivity.getRequestedOrientation();
            mActivity.setRequestedOrientation(authPageOrientation);
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        //sdk默认控件的区域是marginTop50dp
        int designHeight = mScreenHeightDp - 50;
        int unit = designHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        builder.setSloganHidden(true)
                .setNavHidden(false)
                .setStatusBarHidden(true)
                .setLogoOffsetY(unit)
                .setLogoWidth(50)
                .setLogoHeight(50)
                .setNumFieldOffsetY(unit * 3)
                .setLogBtnOffsetY(unit * 5)
                .setLogBtnHeight(logBtnHeight)
                .setSwitchOffsetY(unit * 7)
                .setPrivacyMargin(115)
                .setLogBtnWidth(339)
                .setScreenOrientation(authPageOrientation);
        setUILayout(layout, builder);
        mAuthHelper.setAuthUIConfig(builder.create());
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mOldScreenOrientation != mActivity.getRequestedOrientation()) {
            mActivity.setRequestedOrientation(mOldScreenOrientation);
        }
    }
}
