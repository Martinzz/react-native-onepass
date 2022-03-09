package com.reactnativeonepass

import android.util.Log
import com.facebook.react.bridge.*
import com.mobile.auth.gatewayauth.model.TokenRet
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.mobile.auth.gatewayauth.*
import com.reactnativeonepass.config.BaseUIConfig
import com.facebook.react.bridge.ReactMethod




class OnepassModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    private val TAG = "OnepassModule"
    private var mPhoneNumberAuthHelper: PhoneNumberAuthHelper? = null
    private var mUIConfig: BaseUIConfig? = null
    private val prefetchNumberTimeout = 3000
    private val tokenNumberTimeout = 3000
    override fun getName(): String {
        return "Onepass"
    }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    fun multiply(a: Int, b: Int, promise: Promise) {
    
      promise.resolve(a * b)
    
    }

    @ReactMethod
    fun addListener(eventName: String) {
        // Set up any upstream listeners or background tasks as necessary
    }

    @ReactMethod
    fun removeListeners(count: Int?) {
        // Remove upstream listeners, stop unnecessary background tasks
    }

    /**
     * 初始化号码认证，并检测环境是否可用
     */
    @ReactMethod
    fun setAuthSDKInfo(secretInfo: String, promise: Promise) {
        mPhoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(reactApplicationContext.applicationContext, null)
        mPhoneNumberAuthHelper!!.getReporter().setLoggerEnable(true)
        mPhoneNumberAuthHelper!!.setAuthSDKInfo(secretInfo)
        promise.resolve(null)
    }

    @ReactMethod
    fun checkAndPrepareEnv(promise: Promise) {
        var mTokenResultListener = object : TokenResultListener {
            override fun onTokenSuccess(s: String) {
                try {
                    val pTokenRet = TokenRet.fromJson(s)
                    if (ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS == pTokenRet.code) {
                        accelerateLoginPage(prefetchNumberTimeout)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                returnMap(s, promise)
            }
            override fun onTokenFailed(s: String) {
                returnMap(s, promise)
            }
        }
        mPhoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(reactApplicationContext.applicationContext, mTokenResultListener)
        mPhoneNumberAuthHelper!!.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN)
    }

    fun returnMap(s: String, promise: Promise){
        try {
            val pTokenRet = TokenRet.fromJson(s)
            val writableMap = Arguments.createMap()
            writableMap.putString("code", pTokenRet.code)
            writableMap.putString("msg", pTokenRet.msg)
            promise.resolve(writableMap)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * 在不是一进app就需要登录的场景 建议调用此接口 加速拉起一键登录页面
     * 等到用户点击登录的时候 授权页可以秒拉
     * 预取号的成功与否不影响一键登录功能，所以不需要等待预取号的返回。
     */
    fun accelerateLoginPage(timeout: Int) {
        if(mPhoneNumberAuthHelper == null)return
        mPhoneNumberAuthHelper!!.accelerateLoginPage(timeout, object : PreLoginResultListener {
            override fun onTokenSuccess(s: String) {
                Log.e(TAG, "预取号成功: $s")
            }

            override fun onTokenFailed(s: String, s1: String) {
                Log.e(TAG, "预取号失败：, $s1")
            }
        })
    }

    /**
     * 配置UI
     */
    @ReactMethod
    fun buildWithStyleGetToken(style: Int, layout: ReadableMap, promise: Promise) {
        if(mPhoneNumberAuthHelper == null)return
        mUIConfig = BaseUIConfig.init(style, reactApplicationContext.currentActivity, mPhoneNumberAuthHelper)
        mUIConfig!!.configAuthPage(layout)
        getLoginToken(promise)
    }

    private fun emit(methodName: String, data: WritableMap) {
        reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                .emit(methodName, data)
    }

    fun getLoginToken(promise: Promise) {
        if(mPhoneNumberAuthHelper == null)return
        mPhoneNumberAuthHelper!!.setUIClickListener(AuthUIControlClickListener { code, context, jsonString ->
            val writableMap = Arguments.createMap()
            writableMap.putString("code", code)
            writableMap.putString("jsonString", jsonString)
            emit("onAuthUIControlClick", writableMap)
        })

        var mTokenResultListener = object : TokenResultListener {
            override fun onTokenSuccess(s: String) {
                var tokenRet: TokenRet? = null
                try {
                    tokenRet = TokenRet.fromJson(s)
                    if (ResultCode.CODE_SUCCESS == tokenRet.code) {
                        Log.i(TAG, "获取token成功：$s")
//                        token = tokenRet.token
                        mPhoneNumberAuthHelper!!.setAuthListener(null)
                        returnMap(s, promise)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            override fun onTokenFailed(s: String) {
                returnMap(s, promise)
                //如果环境检查失败 使用其他登录方式
                mPhoneNumberAuthHelper!!.quitLoginPage()
                mPhoneNumberAuthHelper!!.setAuthListener(null)
            }
        }
        mPhoneNumberAuthHelper!!.setAuthListener(mTokenResultListener)
        mPhoneNumberAuthHelper!!.getLoginToken(reactApplicationContext.currentActivity, tokenNumberTimeout)
    }

}
