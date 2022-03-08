package com.reactnativeonepass.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.facebook.react.bridge.ReadableMap;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.nirvana.tools.core.AppUtils;
import com.reactnativeonepass.R;

public class DialogPortConfig extends BaseUIConfig {
    /**
     * 应用包名
     */
    private String mPackageName;

    public DialogPortConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
        super(activity, authHelper);
        mPackageName = AppUtils.getPackageName(activity);
    }

    @Override
    public void configAuthPage(ReadableMap layout) {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
        AuthUIConfig.Builder builder = new AuthUIConfig.Builder();
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        int dialogWidth = (int) (mScreenWidthDp * 0.8f);
        int dialogHeight = (int) (mScreenHeightDp * 0.65f) - 50;
        int unit = dialogHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
                .setLayout(R.layout.custom_port_dialog_action_bar, new AbstractPnsViewDelegate() {
                    @Override
                    public void onViewCreated(View view) {
                        if(layout.hasKey("alertTitle")){
                            TextView textView = (TextView)findViewById(R.id.tv_title);
                            ReadableMap alertTitle = layout.getMap("alertTitle");
                            if(alertTitle.hasKey("text"))textView.setText(alertTitle.getString("text"));
                            if(alertTitle.hasKey("size"))textView.setTextSize(alertTitle.getInt("size"));
                        }
                        findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                mAuthHelper.quitLoginPage();
                            }
                        });
                    }
                })
                .build());
        builder.setNavHidden(true)
                .setDialogBottom(false)
                .setSwitchOffsetY(unit * 5 + 20)
                .setLogoOffsetY(0)
                .setLogoWidth(42)
                .setLogoHeight(42)
                .setNumFieldOffsetY(unit + 10)
                .setLogBtnWidth(dialogWidth - 30)
                .setLogBtnHeight(logBtnHeight)
                .setSloganTextSizeDp(12)
                .setLogBtnOffsetY(unit * 4)
                .setSloganOffsetY(unit * 3)
                .setDialogWidth(dialogWidth)
                .setDialogHeight(dialogHeight)
                .setScreenOrientation(authPageOrientation);
        setUILayout(layout, builder);
        mAuthHelper.setAuthUIConfig(builder.create());
    }
}
