//
//  Vod.m
//  RNBaidu
//
//  Created by Mac on 1/22/18.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<React/RCTConvert.h>)
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>
#else
#import <RCTLog.h>
#import <RCTBridgeModule.h>
#endif

#import "RNBaiduVod.h"

@interface BaiduBce : NSObject <RCTBridgeModule>
@end

@implementation BaiduBce{
    RNBaiduVod *vodObj;
}
- (instancetype)init
{
    if ((self = [super init])) {
        vodObj = [[RNBaiduVod alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE()
RCT_EXPORT_METHOD(show:(NSString *)message resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    
}

RCT_EXPORT_METHOD(applyUploadAndProcess:(NSString *)filePath title:(NSString *)title description:(NSString *)description
                  resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject ){
    NSString *mediaId = [vodObj uploadVideo:filePath];
    if(mediaId != nil){
        resolve(mediaId);
    }else{
        reject(@"-1", @"上传文件失败", nil);
    }
}

RCT_EXPORT_METHOD(queryMediaInfo:(NSString *)mediaId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    NSMutableDictionary *data = [vodObj queryMediaInfo:mediaId];
    if(data.count){
        resolve(data);
    }else{
        reject(@"-1", @"error", nil);
    }
    
}

RCT_EXPORT_METHOD(playVideo:(NSString *)mediaId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    
}
@end
