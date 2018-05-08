package com.reactnative.baibubce;

import android.content.Context;
import android.os.Build;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.xiaomi.mipush.sdk.MiPushClient;

/**
 * Created by sky on 2018/2/4.
 */

public class Utils {
    private static ReactContext reactContext;
    private static long lastSendTime = 0;

    public static void setReactContext(ReactContext reactContext){
        Utils.reactContext = reactContext;
    }

    public static ReactContext getReactContext() {
        return reactContext;
    }

    public static void emit(String eventName, Object data){
        try{
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendUploadProgress(String strpercent)
    {
        long curTime = System.currentTimeMillis();
        if((curTime - lastSendTime) > 500) {
            lastSendTime = curTime;
            Utils.emit("videoUploadStatus", strpercent);
        }else if(strpercent.equals("100.0")){
            lastSendTime = curTime + 1000000;
            Utils.emit("videoUploadStatus", strpercent);
        }
    }

    public static void registerMiPush(Context context, String appId, String appKey){
        MiPushClient.registerPush(context, "2882303761517765408", "5661776524408");
    }

    public static String getMiPushRegid(Context context){
        return MiPushClient.getRegId(context);
    }
}
