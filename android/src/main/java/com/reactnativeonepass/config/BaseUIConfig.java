package com.reactnativeonepass.config;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.Surface;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.reactnativeonepass.AppUtils;
import com.reactnativeonepass.Constant;
import com.reactnativeonepass.R;

import java.sql.Array;

public abstract class BaseUIConfig {
    public Activity mActivity;
    public Context mContext;
    public PhoneNumberAuthHelper mAuthHelper;
    public int mScreenWidthDp;
    public int mScreenHeightDp;

    public static BaseUIConfig init(int type, Activity activity, PhoneNumberAuthHelper authHelper) {
        switch (type) {
            case Constant.FULL_PORT:
                return new FullPortConfig(activity, authHelper);
            case Constant.FULL_LAND:
                return new FullLandConfig(activity, authHelper);
            case Constant.DIALOG_PORT:
                return new DialogPortConfig(activity, authHelper);
            case Constant.DIALOG_LAND:
                return new DialogLandConfig(activity, authHelper);
            case Constant.DIALOG_BOTTOM:
                return new DialogBottomConfig(activity, authHelper);
            default:
                return null;
        }
    }

    public BaseUIConfig(Activity activity, PhoneNumberAuthHelper authHelper) {
        mActivity = activity;
        mContext = activity.getApplicationContext();
        mAuthHelper = authHelper;
    }

    protected AuthUIConfig.Builder setUILayout(ReadableMap layout, AuthUIConfig.Builder builder){
        if(layout.hasKey("logBtnToastHidden")){
            builder.setLogBtnToastHidden(layout.getBoolean("logBtnToastHidden"));
        }
        if(layout.hasKey("navIsHidden")){
            builder.setNavHidden(layout.getBoolean("navIsHidden"));
        }
        if(layout.hasKey("navColor")){
            builder.setNavColor(Color.parseColor(layout.getString("navColor")));
            builder.setStatusBarColor(Color.parseColor(layout.getString("navColor")));
        }
        if(layout.hasKey("navTitle")){
            ReadableMap navTitle = layout.getMap("navTitle");
            if(navTitle.hasKey("text"))builder.setNavText(navTitle.getString("text"));
            if(navTitle.hasKey("color"))builder.setNavTextColor(Color.parseColor(navTitle.getString("color")));
            if(navTitle.hasKey("size"))builder.setNavTextSizeDp(navTitle.getInt("size"));
        }
        if(layout.hasKey("navBackImage")){
            builder.setNavReturnImgPath(layout.getString("navBackImage"));
        }
        if(layout.hasKey("hideNavBackItem")){
            builder.setNavReturnHidden(layout.getBoolean("hideNavBackItem"));
        }
        if(layout.hasKey("privacyNavColor")){
            builder.setWebNavColor(Color.parseColor(layout.getString("privacyNavColor")));
            builder.setWebViewStatusBarColor(Color.parseColor(layout.getString("privacyNavColor")));
        }
        if(layout.hasKey("privacyNavTitleColor")){
            builder.setWebNavTextColor(Color.parseColor(layout.getString("privacyNavTitleColor")));
        }
        if(layout.hasKey("privacyNavTitleSize")){
            builder.setWebNavTextSizeDp(layout.getInt("privacyNavTitleSize"));
        }
        if(layout.hasKey("privacyNavBackImage")){
            builder.setWebNavReturnImgPath(layout.getString("privacyNavBackImage"));
        }
        if(layout.hasKey("sloganText")){
            ReadableMap sloganText = layout.getMap("sloganText");
            if(sloganText.hasKey("text"))builder.setSloganText(sloganText.getString("text"));
            if(sloganText.hasKey("color"))builder.setSloganTextColor(Color.parseColor(sloganText.getString("color")));
            if(sloganText.hasKey("size"))builder.setSloganTextSizeDp(sloganText.getInt("size"));
        }
        if(layout.hasKey("loginBtnText")){
            ReadableMap loginBtnText = layout.getMap("loginBtnText");
            if(loginBtnText.hasKey("text"))builder.setLogBtnText(loginBtnText.getString("text"));
            if(loginBtnText.hasKey("color"))builder.setLogBtnTextColor(Color.parseColor(loginBtnText.getString("color")));
            if(loginBtnText.hasKey("size"))builder.setLogBtnTextSizeDp(loginBtnText.getInt("size"));
        }
        if(layout.hasKey("loginBtnBgImgs")){
            ReadableArray btns = layout.getArray("loginBtnBgImgs");
            if(btns != null && btns.size() > 0){
                builder.setLogBtnBackgroundPath(btns.getString(0));
            }
        }
        if(layout.hasKey("changeBtnTitle")){
            ReadableMap changeBtnTitle = layout.getMap("changeBtnTitle");
            if(changeBtnTitle.hasKey("text"))builder.setSwitchAccText(changeBtnTitle.getString("text"));
            if(changeBtnTitle.hasKey("color"))builder.setSwitchAccTextColor(Color.parseColor(changeBtnTitle.getString("color")));
            if(changeBtnTitle.hasKey("size"))builder.setSwitchAccTextSizeDp(changeBtnTitle.getInt("size"));
        }
        if(layout.hasKey("changeBtnIsHidden")){
            builder.setSwitchAccHidden(layout.getBoolean("changeBtnIsHidden"));
        }
        if(layout.hasKey("prefersStatusBarHidden")){
            builder.setStatusBarHidden(layout.getBoolean("prefersStatusBarHidden"));
        }
        if(layout.hasKey("preferredStatusBarStyle")){
            builder.setLightColor(layout.getInt("preferredStatusBarStyle") == 0);
        }
        if(layout.hasKey("logoImage")){
            builder.setLogoImgPath(layout.getString("logoImage"));
        }
        if(layout.hasKey("logoIsHidden")){
            builder.setLogoHidden(layout.getBoolean("logoIsHidden"));
        }
        if(layout.hasKey("numberColor")){
            builder.setNumberColor(Color.parseColor(layout.getString("numberColor")));
        }
        if(layout.hasKey("numberFontSize")){
            builder.setNumberSizeDp(Color.parseColor(layout.getString("numberFontSize")));
        }

        if(layout.hasKey("checkBoxImages")){
            ReadableArray checkBoxImages = layout.getArray("checkBoxImages");
            if(checkBoxImages != null && checkBoxImages.size() == 2){
                builder.setUncheckedImgPath(checkBoxImages.getString(0));
                builder.setCheckedImgPath(checkBoxImages.getString(1));
            }
        }
        if(layout.hasKey("checkBoxIsHidden")){
            builder.setCheckboxHidden(layout.getBoolean("checkBoxIsHidden"));
        }
        if(layout.hasKey("checkBoxWH")){
            builder.setCheckBoxWidth(layout.getInt("checkBoxWH"));
            builder.setCheckBoxHeight(layout.getInt("checkBoxWH"));
        }
        if(layout.hasKey("privacyOne")){
            ReadableArray privacyOne = layout.getArray("privacyOne");
            if(privacyOne != null && privacyOne.size() == 2){
                builder.setAppPrivacyOne(privacyOne.getString(0), privacyOne.getString(1));
            }
        }
        if(layout.hasKey("privacyTwo")){
            ReadableArray privacyTwo = layout.getArray("privacyTwo");
            if(privacyTwo != null && privacyTwo.size() == 2){
                builder.setAppPrivacyTwo(privacyTwo.getString(0), privacyTwo.getString(1));
            }
        }
        if(layout.hasKey("privacyColors")){
            ReadableArray privacyColors = layout.getArray("privacyColors");
            if(privacyColors != null && privacyColors.size() == 2){
                builder.setAppPrivacyColor(Color.parseColor(privacyColors.getString(0)),
                        Color.parseColor(privacyColors.getString(1)));
            }
        }
        if(layout.hasKey("checkBoxIsChecked")){
            builder.setPrivacyState(layout.getBoolean("checkBoxIsChecked"));
        }
        if(layout.hasKey("privacyAlignment")){
            int privacyAlignment = layout.getInt("privacyAlignment");
            switch (privacyAlignment){
                case 1:
                    builder.setProtocolLayoutGravity(Gravity.CENTER);
                    break;
                case 2:
                    builder.setProtocolLayoutGravity(Gravity.RIGHT);
                    break;
                default:
                    builder.setProtocolLayoutGravity(Gravity.LEFT);
                    break;
            }
        }

        if(layout.hasKey("privacyPreText")){
            builder.setPrivacyBefore(layout.getString("privacyPreText"));
        }
        if(layout.hasKey("privacySufText")){
            builder.setPrivacyEnd(layout.getString("privacySufText"));
        }
        if(layout.hasKey("privacyOperatorPreText")){
            builder.setVendorPrivacyPrefix(layout.getString("privacyOperatorPreText"));
        }
        if(layout.hasKey("privacyOperatorSufText")){
            builder.setVendorPrivacySuffix(layout.getString("privacyOperatorSufText"));
        }
        if(layout.hasKey("privacyFontSize")){
            builder.setPrivacyTextSizeDp(layout.getInt("privacyFontSize"));
        }
        builder.setAuthPageActIn("in_activity", "out_activity")
                .setAuthPageActOut("in_activity", "out_activity");

        if(layout.hasKey("logoFrameBlock")){
            ReadableMap logoFrameBlock = layout.getMap("logoFrameBlock");
            if(logoFrameBlock.hasKey("width")){
                builder.setLogoWidth(logoFrameBlock.getInt("width"));
            }
            if(logoFrameBlock.hasKey("height")){
                builder.setLogoHeight(logoFrameBlock.getInt("height"));
            }
            if(logoFrameBlock.hasKey("y")){
                builder.setLogoOffsetY(logoFrameBlock.getInt("y"));
            }
        }
        if(layout.hasKey("numberFrameBlock")){
            ReadableMap numberFrameBlock = layout.getMap("numberFrameBlock");
            if(numberFrameBlock.hasKey("x")){
                builder.setNumberFieldOffsetX(numberFrameBlock.getInt("x"));
            }
            if(numberFrameBlock.hasKey("y")){
                builder.setNumFieldOffsetY(numberFrameBlock.getInt("y"));
            }
        }
        if(layout.hasKey("loginBtnFrameBlock")){
            ReadableMap loginBtnFrameBlock = layout.getMap("loginBtnFrameBlock");
            if(loginBtnFrameBlock.hasKey("width")){
                builder.setLogBtnWidth(loginBtnFrameBlock.getInt("width"));
            }
            if(loginBtnFrameBlock.hasKey("height")){
                builder.setLogBtnHeight(loginBtnFrameBlock.getInt("height"));
            }
            if(loginBtnFrameBlock.hasKey("x")){
                builder.setLogBtnOffsetX(loginBtnFrameBlock.getInt("x"));
            }
            if(loginBtnFrameBlock.hasKey("y")){
                builder.setLogBtnOffsetY(loginBtnFrameBlock.getInt("y"));
            }
        }
        if(layout.hasKey("changeBtnFrameBlock")){
            ReadableMap changeBtnFrameBlock = layout.getMap("changeBtnFrameBlock");
            if(changeBtnFrameBlock.hasKey("y")){
                builder.setSwitchOffsetY(changeBtnFrameBlock.getInt("y"));
            }
        }
        if(layout.hasKey("sloganFrameBlock")){
            ReadableMap sloganFrameBlock = layout.getMap("sloganFrameBlock");
            if(sloganFrameBlock.hasKey("y")){
                builder.setSloganOffsetY(sloganFrameBlock.getInt("y"));
            }
        }
        if(layout.hasKey("contentViewFrameBlock")){
            ReadableMap contentViewFrameBlock = layout.getMap("contentViewFrameBlock");
            if(contentViewFrameBlock.hasKey("width")){
                builder.setDialogWidth(contentViewFrameBlock.getInt("width"));
            }
            if(contentViewFrameBlock.hasKey("height")){
                builder.setDialogHeight(contentViewFrameBlock.getInt("height"));
            }
            if(contentViewFrameBlock.hasKey("x")){
                builder.setDialogOffsetX(contentViewFrameBlock.getInt("x"));
            }
            if(contentViewFrameBlock.hasKey("y")){
                builder.setDialogOffsetY(contentViewFrameBlock.getInt("y"));
            }
        }
        return builder;
    }

    protected void updateScreenSize(int authPageScreenOrientation) {
        int screenHeightDp = AppUtils.px2dp(mContext, AppUtils.getPhoneHeightPixels(mContext));
        int screenWidthDp = AppUtils.px2dp(mContext, AppUtils.getPhoneWidthPixels(mContext));
        int rotation = mActivity.getWindowManager().getDefaultDisplay().getRotation();
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_BEHIND) {
            authPageScreenOrientation = mActivity.getRequestedOrientation();
        }
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_LANDSCAPE) {
            rotation = Surface.ROTATION_90;
        } else if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_PORTRAIT) {
            rotation = Surface.ROTATION_180;
        }
        switch (rotation) {
            case Surface.ROTATION_0:
            case Surface.ROTATION_180:
                mScreenWidthDp = screenWidthDp;
                mScreenHeightDp = screenHeightDp;
                break;
            case Surface.ROTATION_90:
            case Surface.ROTATION_270:
                mScreenWidthDp = screenHeightDp;
                mScreenHeightDp = screenWidthDp;
                break;
            default:
                break;
        }
    }

    public abstract void configAuthPage(ReadableMap layout);

    /**
     *  在横屏APP弹竖屏一键登录页面或者竖屏APP弹横屏授权页时处理特殊逻辑
     *  Android8.0只能启动SCREEN_ORIENTATION_BEHIND模式的Activity
     */
    public void onResume() {

    }
}
