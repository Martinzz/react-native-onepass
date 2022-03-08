package com.reactnativeonepass;

public class Constant {
    public static final String[] TYPES = {"全屏（竖屏）", "全屏（横屏）", "弹窗（竖屏）",
            "弹窗（横屏）", "底部弹窗"};
    /**
     * 全屏（竖屏）
     */
    public static final int FULL_PORT = 0;
    /**
     * 全屏（横屏）
     */
    public static final int FULL_LAND = 1;
    /**
     * 弹窗（竖屏）
     */
    public static final int DIALOG_PORT = 2;
    /**
     * "弹窗（横屏）
     */
    public static final int DIALOG_LAND = 3;
    /**
     * 底部弹窗
     */
    public static final int DIALOG_BOTTOM = 4;

    public static final String THEME_KEY = "theme";

    public static final String LOGIN_TYPE = "login_type";
    public static final int LOGIN = 1;
    public static final int LOGIN_DELAY = 2;
}
