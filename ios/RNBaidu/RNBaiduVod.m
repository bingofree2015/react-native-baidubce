//
//  RNBaidu.m
//  RNBaidu
//
//  Created by Mac on 1/22/18.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import "RNBaiduVod.h"
#import <BaiduBCEBasic/BaiduBCEBasic.h>
#import <BaiduBCEBOS/BaiduBCEBOS.h>
#import <BaiduBCEVOD/BaiduBCEVOD.h>

@implementation RNBaiduVod {
}
- (instancetype)init
{
    if ((self = [super init])) {
        [self initBaiduBce];
    }
    return self;
}
- (void)initBaiduBce {
    //STS方式获得鉴权credentials对象，推荐采用
    //BCESTSCredentials* credentials = [BCESTSCredentials new];
    //credentials.accessKey = @"<your ak>";
    //credentials.secretKey = @"<your sk>";
    //credentials.sessionToken = @"<your session token>";
    
    //或者AKSK方式鉴权credentials对象，两种方式任选其一即可
    BCECredentials* credentials = [BCECredentials new];
    credentials.accessKey = @"1ddd1007c19b4a0581e25523be1c567a";
    credentials.secretKey = @"44298a5fca9b4876a08d6534beffcd28";
    
    
    //初始化鉴权后的BOSClient对象
    BOSClientConfiguration* bosConfig = [BOSClientConfiguration new];
    bosConfig.credentials = credentials;
    bosClient = [[BOSClient alloc] initWithConfiguration:bosConfig];
    
    //初始化鉴权后的VODClient对象
    VODClientConfiguration* vodConfig = [VODClientConfiguration new];
    vodConfig.credentials = credentials;
    vodClient = [[VODClient alloc] initWithConfiguration:vodConfig];
}
- (NSString *) uploadVideo:(NSString *)filepath {
    VODGenerateMediaIDRequest* request = [[VODGenerateMediaIDRequest alloc] init];
    //request.mode = @"<mode>";
    __block VODGenerateMediaIDResponse* mediaIdResponse = nil;
    
    BCETask *task = [vodClient generateMediaID:request];//此处的vodClient指向之前的步骤中已经鉴权并初始化的VodClient对象
    task.then(^(BCEOutput* output) {
        if (output.response) {
            //任务执行成功，通过返回的response获取mediaId等相关字段
            mediaIdResponse = (VODGenerateMediaIDResponse*)output.response;
            //执行任务成功相关逻辑代码
        }
        if (output.error) {
            //执行任务失败相关逻辑代码
        }
    });
    [task waitUtilFinished];
    
    //上传媒体资源
    if (!mediaIdResponse) {
        return NULL;
    }
    NSString *uploadFile = [[NSBundle mainBundle] pathForResource:filepath ofType:nil];
    
    BOSObjectContent* content = [[BOSObjectContent alloc] init];
    //content.objectData.file = uploadFile;
    content.objectData.file = filepath;
    
    BOSPutObjectRequest* putRequest = [[BOSPutObjectRequest alloc] init];
    putRequest.bucket = mediaIdResponse.sourceBucket;
    putRequest.key = mediaIdResponse.sourceKey;
    putRequest.objectContent = content;
    
    int nTaskResult = 0;
    task = [bosClient putObject:putRequest];//此处的bosClient指向之前的步骤中已经鉴权并初始化的VodClient对象
    task.then(^(BCEOutput* output) {
        if (output.progress) {//上传中
            //处理相关逻辑
            //可以通过 output.progress.floatValue 获取当前上传进度
            nTaskResult = 0;
        }
        
        if (output.response) {//上传成功
            //处理相关逻辑
            nTaskResult = 1;
        }
        
        if (output.error) {//上传错误
            //处理相关逻辑
            nTaskResult = -1;
        }
    });
    [task waitUtilFinished];
    if(nUploadResult != 1){
        return NULL;
    }
    //处理媒体资源
    VODProcessMediaRequest* submitRequest = [VODProcessMediaRequest new];
    submitRequest.mediaId = mediaIdResponse.mediaID;
    submitRequest.attributes.mediaTitle = @"Title";
    submitRequest.attributes.mediaDescription = @"Upload Video from iOS";
    submitRequest.sourceExtension = @"MOV";
    submitRequest.transcodingPresetGroupName = @"vod.inbuilt.adaptive.hls";
    
    task = [vodClient processMedia:submitRequest];
    task.then(^(BCEOutput* output) {
        if (output.response) {//处理媒资请求成功
            //处理相关业务逻辑
            nTaskResult = 1;
        }
        if (output.error) {//处理媒资请求错误
            //处理相关业务逻辑
            nTaskResult = -1;
        }
    });
    [task waitUtilFinished];
    if(nTaskResult != 1){
        return NULL;
    }
    mediaId = mediaIdResponse.mediaID;
}

- (void) queryMediaInfo:(NSString *)mediaId{
    __block VODGetMediaResponse* response = nil;
    BCETask *task = [vodClient getMedia:mediaId];
    task.then(^(BCEOutput* output) {
        
        if (output.response) {//处理媒资请求成功
            //通过返回的response获取mediaId等相关字段
            response = (VODGetMediaResponse*)output.response;
            
            NSString *title = response.media.attributes.mediaTitle;
            NSString *description = response.media.attributes.mediaDescription;
            NSString *url = response.media.playableUrlList[0].url;
            int n = 10;
            //处理相关业务逻辑
        }
        
        if (output.error) {//处理媒资请求错误
            //处理相关业务逻辑
            
        }
    });
    [task waitUtilFinished];
}
@end
