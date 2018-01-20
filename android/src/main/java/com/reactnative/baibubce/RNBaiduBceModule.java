package com.reactnative.baidubce;

import android.widget.Toast;

import com.baidubce.BceClientConfiguration;
import com.baidubce.auth.DefaultBceCredentials;
import com.baidubce.services.bos.BosClient;
import com.baidubce.services.bos.BosClientConfiguration;
import com.baidubce.services.bos.model.BosObjectSummary;
import com.baidubce.services.bos.model.ListObjectsResponse;
import com.baidubce.services.vod.VodClient;
import com.baidubce.services.vod.model.GenerateMediaIdResponse;
import com.baidubce.services.vod.model.ProcessMediaRequest;
import com.baidubce.services.vod.model.ProcessMediaResponse;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.reactnative.baibubce.FileUploadSession;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Map;

public class RNBaiduBceModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String DURATION_SHORT_KEY = "SHORT";
    private static final String DURATION_LONG_KEY = "LONG";

    VodClient vodClient; // 用于apply，process媒资
    BosClient bosClient; // 用于文件上传
    String uploadedMediaId = "";

    public RNBaiduBceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "BaiduBce";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DURATION_SHORT_KEY, Toast.LENGTH_SHORT);
        constants.put(DURATION_LONG_KEY, Toast.LENGTH_LONG);
        return constants;
    }
    public void initVodAndBosClient() {
        // tempAk, tempSk, sessionToken are from your servers
        // BOS和VOD公用同一种认证
        String tempAk = "1ddd1007c19b4a0581e25523be1c567a";
        String tempSk = "44298a5fca9b4876a08d6534beffcd28";
        String sessionToken = "MjUzZjQzNTY4OTE0NDRkNjg3N2E4YzJhZTc4YmU5ZDh8AAAAADgBAADj2BkqcKFrD3kAsKRhxaQHRE+0QWor9sJPDHjU2mJH3ufdywB2og44oMOrRgBGVST28Trwy4jReBu7eHT1f12u6aso/vksTiXkQ/tZ/Z8/SULrt0H34ehGnK3R41woEKmaCTH2vEkSBxxJVDFmQeMopphpfof7xvnjuouWXQFn8/hY6P40lsAzjQtk2SGfBLhBugWIDuL7ZNeiaEhT7MOBtj/LyP39dp684YMYWBTBhooATQa+FTEvBYCAXFRKWhU=";
        //DefaultBceSessionCredentials stsCredentials = new DefaultBceSessionCredentials(tempAk, tempSk, sessionToken);

//        // 不推荐 DefaultBceCredentials. 因为ak,sk 泄漏后风险非常大。请使用上面的 DefaultBceSessionCredentials
        DefaultBceCredentials stsCredentials = new DefaultBceCredentials(tempAk, tempSk);

        BceClientConfiguration vodConfig = new BceClientConfiguration();
        vodConfig.withCredentials(stsCredentials);

        BosClientConfiguration bosConfig = new BosClientConfiguration();
        bosConfig.withCredentials(stsCredentials);

        vodClient = new VodClient(vodConfig);
        bosClient = new BosClient(bosConfig);
    }


    @ReactMethod
    public void show(String message, final Promise promise) {
        Toast.makeText(getReactApplicationContext(), message, Toast.LENGTH_SHORT).show();
        this.emit("observerShow", "call function success");
        if(message.isEmpty()){
            promise.resolve("success");
        }else{
            promise.reject("400", "empty string");
        }
    }

    public void emit(String eventName, Object data){
        try {
            this.reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, data);
        } catch (Exception e){
            e.printStackTrace();;
        }
    }

    @ReactMethod
    public void getVodList(final Promise promise) {
        initVodAndBosClient();
        WritableArray array = Arguments.createArray();
        GenerateMediaIdResponse generateMediaIdresponse = vodClient.applyMedia();
        String bucket = generateMediaIdresponse.getSourceBucket();
        ListObjectsResponse list = bosClient.listObjects(bucket);
        for(BosObjectSummary objectSummary : list.getContents()) {
            WritableMap map = Arguments.createMap();
            map.putString("mediaId", objectSummary.getKey());
            array.pushMap(map);
        }
        promise.resolve(array);
    }

    String transcodingPresetGroupName = "vod.inbuilt.adaptive.hls"; // 模板名必须为VOD后台的模板组名称
    // transcodingPresetGroupName 传入null，表示默认模板组; 上传不转码时需要指定相应的模板组名字
    public void applyUploadAndProcess(final String filePath, final String title, final String description) {
        new Thread() {
            @Override
            public void run() {
                try {
                    //"开始上传VOD"
                    long startTimestamp = System.currentTimeMillis();
                    File file = new File(filePath);
                    if (!file.exists()) {
                        throw new FileNotFoundException("The media file " + file.getAbsolutePath() + " doesn't exist!");
                    }
                    // try get file extension
                    String sourceExtension = null;
                    String filename = file.getName();
                    sourceExtension = getFileExtension(filename);
                    // apply: get a BOS bucket and extract mediaId from it
                    GenerateMediaIdResponse generateMediaIdresponse = vodClient.applyMedia();
//                    String mode = "no_transcoding";
//                    GenerateMediaIdResponse generateMediaIdresponse = vodClient.applyMediaForSpecificMode(mode);
                    String bosKey = generateMediaIdresponse.getSourceKey();
                    String mediaId = generateMediaIdresponse.getMediaId();
                    String bucket = generateMediaIdresponse.getSourceBucket();

                    // upload: upload the file using multipart
                    FileUploadSession session = new FileUploadSession(bosClient);
                    if (session.upload(file, bucket, bosKey)) {
                        ProcessMediaRequest request =
                                new ProcessMediaRequest()
                                        .withMediaId(mediaId)
                                        .withTitle(title)
                                        .withDescription(description)
                                        .withSourceExtension(sourceExtension)
                                        .withTranscodingPresetGroupName(transcodingPresetGroupName);
                        // process: let vod to process bos file
                        ProcessMediaResponse processResponse = vodClient.processMedia(request);
                        uploadedMediaId = processResponse.getMediaId();
                        long endTimestamp = System.currentTimeMillis();
                        //"上传完成，MediaId=" + uploadedMediaId + "; 耗时：" + (endTimestamp - startTimestamp) + "ms"
                    } else {
                        //"上传文件失败"
                    }

                } catch (Throwable e) {
                    e.printStackTrace();
                    // Exception means status failed
                    //"上传失败，错误信息：" + e.getMessage()
                }
            }
        }.start();
    }
    private String getFileExtension(String filename) {
        if (filename != null && filename.lastIndexOf(".") != -1) {
            String extension = filename.substring(filename.lastIndexOf(".") + 1);
            return extension;
        }
        return null;
    }
}