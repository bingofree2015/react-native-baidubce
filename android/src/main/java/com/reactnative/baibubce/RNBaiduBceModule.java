package com.reactnative.baidubce;

import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.Toast;

import com.baidubce.BceClientConfiguration;
import com.baidubce.auth.DefaultBceCredentials;
import com.baidubce.services.bos.BosClient;
import com.baidubce.services.bos.BosClientConfiguration;
import com.baidubce.services.bos.model.BosObjectSummary;
import com.baidubce.services.bos.model.ListObjectsResponse;
import com.baidubce.services.vod.VodClient;
import com.baidubce.services.vod.model.GenerateMediaIdResponse;
import com.baidubce.services.vod.model.GetMediaResourceResponse;
import com.baidubce.services.vod.model.PlayableUrl;
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
import com.reactnative.baiducloud.videoplayer.AdvancedPlayActivity;
import com.reactnative.baiducloud.videoplayer.SimplePlayActivity;
import com.reactnative.baiducloud.videoplayer.info.VideoInfo;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
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
        initVodAndBosClient();
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
        if(!message.isEmpty()){
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
    public void applyUploadAndProcess(final String uriPath, final String title, final String description, final Promise promise) {
        new Thread() {
            @Override
            public void run() {
                try {
                    Log.v("SelfMsg", "start file upload");
                    Log.v("SelfMsg", uriPath);
                    //"开始上传VOD"
                    long startTimestamp = System.currentTimeMillis();
                    String filePath = getPath(getReactApplicationContext(), Uri.parse(uriPath));
                    File file = new File(filePath);
                    //File file = new File(new URI(filePath));
                    if (!file.exists()) {
                        throw new FileNotFoundException("The media file " + file.getAbsolutePath() + " doesn't exist!");
                    }

                    Log.v("SelfMsg", uriPath);
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
                    Log.v("SelfMsg", bosKey);
                    Log.v("SelfMsg", mediaId);
                    Log.v("SelfMsg", bucket);

                    String transcodingPresetGroupName = "vod.inbuilt.adaptive.hls"; // 模板名必须为VOD后台的模板组名称
                    // transcodingPresetGroupName 传入null，表示默认模板组; 上传不转码时需要指定相应的模板组名字
                    // upload: upload the file using multipart
                    FileUploadSession session = new FileUploadSession(bosClient);
                    if (session.upload(file, bucket, bosKey)) {
                        Log.v("SelfMsg", "File Upload Success");
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
                        Log.v("SelfMsg", "success");
                        promise.resolve(mediaId);
                    } else {
                        //"上传文件失败"
                        Log.v("SelfMsg", "failed");
                        promise.reject("400", "上传文件失败");
                    }

                } catch (Throwable e) {
                    e.printStackTrace();
                    // Exception means status failed
                    //"上传失败，错误信息：" + e.getMessage()
                    promise.reject("401", "上传文件失败");
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

    @ReactMethod
    public void queryMediaInfo(final String mediaId, final Promise promise) {
        try {
            GetMediaResourceResponse response = vodClient.getMediaResource(uploadedMediaId);
            WritableMap map = Arguments.createMap();
            map.putString("CreateTime", response.getCreateTime());
            map.putString("PublishTime", response.getPublishTime());
            map.putString("Source", response.getSource());
            map.putString("Status", response.getStatus());
            map.putString("Title", response.getAttributes().getTitle());
            map.putString("Description", response.getAttributes().getDescription());
            map.putString("Size", response.getMeta().getSizeInBytes().toString());
            map.putString("Length", response.getMeta().getDurationInSeconds().toString());
            WritableArray urlArray = Arguments.createArray();
            List<PlayableUrl> playableUrlList = response.getPlayableUrlList();
            for(PlayableUrl object : playableUrlList){
                WritableMap playableMap = Arguments.createMap();
                playableMap.putString("Url", object.getUrl());
                playableMap.putString("PresetGroupName", object.getTranscodingPresetName());
                urlArray.pushMap(playableMap);
            }
            map.putArray("UrlList", urlArray);

            WritableArray thumbArray = Arguments.createArray();
            List<String> thumbList = response.getThumbnailList();
            for(String thumb : thumbList) {
                thumbArray.pushString(thumb);
            }
            map.putArray("ThumbnailList", thumbArray);
            map.putString("ResponseString", response.toString());
            promise.resolve(map);
        }catch (Exception e) {
            e.printStackTrace();
            promise.reject("400","error");
        }
    }
    @ReactMethod
    public void playVideo(final String mediaId, final Promise promise){
        GetMediaResourceResponse response = vodClient.getMediaResource(uploadedMediaId);
        String title = response.getAttributes().getTitle();
        String url = response.getPlayableUrlList().get(0).getUrl();
        String status = response.getStatus();
        if(status.equals("RUNNING")){
            promise.reject("400", "转码中");
        }else if(status.equals("PUBLISHED")){
            promise.resolve("已发布");
            VideoInfo info = new VideoInfo(title, url);
            Intent intent = null;
            // SimplePlayActivity简易播放窗口，便于快速了解播放流程
            intent = new Intent(getReactApplicationContext(), SimplePlayActivity.class);
            // AdvancedPlayActivity高级播放窗口，内含丰富的播放控制逻辑
            //intent = new Intent(getReactApplicationContext(), AdvancedPlayActivity.class);
            intent.putExtra("videoInfo", info);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            getReactApplicationContext().startActivity(intent);
        }else if(status.equals("FAILED")){
            promise.reject("400", "转码失败");
        }else if(status.equals("PROCESSING")){
            promise.reject("400", "内部处理中");
        }else if(status.equals("DISABLED")){
            promise.reject("400", "已停用");
        }else if(status.equals("BANNED")){
            promise.reject("400", "已屏蔽");
        }else{
            promise.reject("400", "未知错误");
        }
    }
    /**
     * Get a file path from a Uri. This will get the the path for Storage Access
     * Framework Documents, as well as the _data field for the MediaStore and
     * other file-based ContentProviders.
     *
     * @param context The context.
     * @param uri The Uri to query.
     * @author paulburke
     */
    public static String getPath(final Context context, final Uri uri) {

        final boolean isKitKat = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }

                // TODO handle non-primary volumes
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[] {
                        split[1]
                };

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }

    /**
     * Get the value of the data column for this Uri. This is useful for
     * MediaStore Uris, and other file-based ContentProviders.
     *
     * @param context The context.
     * @param uri The Uri to query.
     * @param selection (Optional) Filter used in the query.
     * @param selectionArgs (Optional) Selection arguments used in the query.
     * @return The value of the _data column, which is typically a file path.
     */
    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }


    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }
}