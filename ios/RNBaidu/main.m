//
//  Vod.m
//  RNBaidu
//
//  Created by Mac on 1/22/18.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTLog.h>
#import <React/RCTBridgeModule.h>
#import "RNBaiduVod.h"

@interface Baidu : NSObject <RCTBridgeModule>
    RNBaiduVod *vodObj = [[RNBaiduVod alloc] init];
@end

@implementation Baidu

RCT_EXPORT_MODULE()
RCT_EXPORT_METHOD(show:(NSString *)message resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    
}

RCT_EXPORT_METHOD(applyUploadAndProcess:(NSString *)filePath title:(NSString *)title description:(NSString *)description
                  resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject ){
    NSString *mediaId = [vodObj uploadVideo:filePath];
    if(mediaId != NULL){
        
    }else{
        
    }
}

RCT_EXPORT_METHOD(queryMediaInfo:(NSString *)mediaId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [vodObj queryMediaInfo:mediaId];
}

RCT_EXPORT_METHOD(playVideo:(NSString *)mediaId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    
}
@end
