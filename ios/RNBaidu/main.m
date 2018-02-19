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
    #import <React/RCTEventEmitter.h>
#else
    #import <RCTLog.h>
    #import <RCTBridgeModule.h>
    #import <RCTEventEmitter.h>
#endif
#import "RNBaiduVod.h"

@interface BaiduBce : RCTEventEmitter <RCTBridgeModule>
@end

@implementation BaiduBce{
    CGFloat _keyOffset;
    RNBaiduVod *vodObj;
}
- (instancetype)init
{
    if ((self = [super init])) {
        _keyOffset = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHiden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        vodObj = [[RNBaiduVod alloc] init];
    }
    return self;
}
- (void)keyboardWasShown:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    int height = MIN(keyboardSize.height,keyboardSize.width);
    int width = MAX(keyboardSize.height,keyboardSize.width);
    
    _keyOffset = height;
}

- (void)keyboardWillHiden:(NSNotification *)notification {
    _keyOffset = 0;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"videoUploadStatus"]; //return @[@"videoUploadStatus", @"asdfasdf"];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(applyUploadAndProcess:(NSString *)filePath title:(NSString *)title description:(NSString *)description
                  resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject ){
    NSString *mediaId = [vodObj uploadVideo:filePath title:title description:description eventDispatcher:self];
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
@end
