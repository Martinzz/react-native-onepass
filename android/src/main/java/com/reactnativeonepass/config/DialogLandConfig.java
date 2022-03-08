package com.reactnativeonepass.config;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.react.bridge.ReadableMap;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.reactnativeonepass.AppUtils;
import com.reactnativeonepass.R;

public class DialogLandConfig extends BaseUIConfig{

    private int mOldScreenOrientation;


    public DialogLandConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
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
        final int dialogWidth = (int) (mScreenWidthDp * 0.63);
        final int dialogHeight = (int) (mScreenHeightDp * 0.75);

        //sdk默认控件的区域是marginTop50dp
        int designHeight = dialogHeight - 50;
        int unit = designHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        final int logBtnOffsetY = unit * 3;

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
                .setLogoHidden(true)
                .setSloganHidden(true)
                .setNumFieldOffsetY(0)
                .setPrivacyOffsetY_B(20)
                .setSwitchOffsetY(logBtnOffsetY + 60)
                .setLogBtnOffsetY(logBtnOffsetY)
                .setLogBtnWidth((int)(dialogWidth * 0.7))
                .setLogBtnHeight(50)
                .setDialogWidth(dialogWidth)
                .setDialogHeight(dialogHeight)
                .setDialogBottom(false)
                .setScreenOrientation(authPageOrientation);
        setUILayout(layout, builder);
        mAuthHelper.setAuthUIConfig(builder.create());
    }

//    private ImageView createLandDialogPhoneNumberIcon(int leftMargin) {
//        ImageView imageView = new ImageView(mContext);
//        int size = AppUtils.dp2px(mContext, 23);
//        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(size, size);
//        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
//        layoutParams.leftMargin = leftMargin;
//        imageView.setLayoutParams(layoutParams);
//        imageView.setBackgroundResource(R.drawable.phone);
//        imageView.setScaleType(ImageView.ScaleType.CENTER);
//        return imageView;
//    }

    private View createLandDialogCustomSwitchView() {
        View v = LayoutInflater.from(mContext).inflate(R.layout.custom_switch_other, new RelativeLayout(mContext), false);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
        v.setLayoutParams(layoutParams);
        return v;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mOldScreenOrientation != mActivity.getRequestedOrientation()) {
            mActivity.setRequestedOrientation(mOldScreenOrientation);
        }
    }

//    private ImageView initNumberView() {
//        ImageView pImageView = new ImageView(mContext);
//        pImageView.setImageResource(R.drawable.phone);
//        pImageView.setScaleType(ImageView.ScaleType.FIT_XY);
//        RelativeLayout.LayoutParams pParams = new RelativeLayout.LayoutParams(AppUtils.dp2px(mContext, 30), AppUtils.dp2px(mContext, 30));
//        pParams.setMargins(AppUtils.dp2px(mContext, 30), 0, 0, 0);
//        pImageView.setLayoutParams(pParams);
//        return pImageView;
//    }
}
