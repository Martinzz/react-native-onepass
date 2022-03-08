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
import com.reactnativeonepass.R;

public class DialogBottomConfig extends BaseUIConfig {

    public DialogBottomConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
        super(activity, authHelper);
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
        int dialogHeight = (int) (mScreenHeightDp * 0.5f);
        //sdk默认控件的区域是marginTop50dp
        int designHeight = dialogHeight - 50;
        int unit = designHeight / 10;
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
                .setLogoOffsetY(0)
                .setLogoWidth(60)
                .setLogoHeight(60)
                .setNumFieldOffsetY(unit + 30)
                .setNumberSizeDp(20)
                .setSloganOffsetY(unit * 3)
                .setSloganTextSizeDp(12)
                .setLogBtnOffsetY(unit * 4)
                .setSwitchOffsetY(unit * 4 + logBtnHeight + 10)
                .setLogBtnHeight(logBtnHeight)
                .setLogBtnTextSizeDp(20)
                .setDialogHeight(dialogHeight)
                .setDialogBottom(true)
                .setScreenOrientation(authPageOrientation);
        setUILayout(layout, builder);
        mAuthHelper.setAuthUIConfig(builder.create());
    }
}
