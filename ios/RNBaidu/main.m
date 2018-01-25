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
#import "UIView+Toast.h"
#import "BaiduPlayer/BaiduPlayer.h"

NSInteger const LRDRCTSimpleToastBottomOffset = 40;
double const LRDRCTSimpleToastShortDuration = 3.0;
double const LRDRCTSimpleToastLongDuration = 5.0;
NSInteger const LRDRCTSimpleToastGravityBottom = 1;
NSInteger const LRDRCTSimpleToastGravityCenter = 2;
NSInteger const LRDRCTSimpleToastGravityTop = 3;

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
- (NSDictionary *)constantsToExport {
    return @{
             @"SHORT": [NSNumber numberWithDouble:LRDRCTSimpleToastShortDuration],
             @"LONG": [NSNumber numberWithDouble:LRDRCTSimpleToastLongDuration],
             @"BOTTOM": [NSNumber numberWithInteger:LRDRCTSimpleToastGravityBottom],
             @"CENTER": [NSNumber numberWithInteger:LRDRCTSimpleToastGravityCenter],
             @"TOP": [NSNumber numberWithInteger:LRDRCTSimpleToastGravityTop]
             };
}

RCT_EXPORT_METHOD(show:(NSString *)msg {
    [self _show:msg duration:2.0 gravity:LRDRCTSimpleToastGravityBottom];
});

RCT_EXPORT_METHOD(showWithGravity:(NSString *)msg duration:(double)duration gravity:(nonnull NSNumber *)gravity{
    [self _show:msg duration:duration gravity:gravity.intValue];
});

- (void)_show:(NSString *)msg duration:(NSTimeInterval)duration gravity:(NSInteger)gravity {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *root = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
        CGRect bound = root.bounds;
        bound.size.height -= _keyOffset;
        if (bound.size.height > LRDRCTSimpleToastBottomOffset*2) {
            bound.origin.y += LRDRCTSimpleToastBottomOffset;
            bound.size.height -= LRDRCTSimpleToastBottomOffset*2;
        }
        UIView *view = [[UIView alloc] initWithFrame:bound];
        view.userInteractionEnabled = NO;
        [root addSubview:view];
        UIView __weak *blockView = view;
        id position;
        if (gravity == LRDRCTSimpleToastGravityTop) {
            position = CSToastPositionTop;
        } else if (gravity == LRDRCTSimpleToastGravityCenter) {
            position = CSToastPositionCenter;
        } else {
            position = CSToastPositionBottom;
        }
        [view makeToast:msg
               duration:duration
               position:position
                  title:nil
                  image:nil
                  style:nil
             completion:^(BOOL didTap) {
                 [blockView removeFromSuperview];
             }];
    });
}

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

RCT_EXPORT_METHOD(playVideo:(NSString *)mediaId resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    NSMutableDictionary *data = [vodObj queryMediaInfo:mediaId];
    if(data.count){
        NSString *status  = [data objectForKey:@"Status"];
        if( [status isEqualToString:@"RUNNING"] == YES){
            reject(@"-1", @"转码中", nil);
        }else if( [status isEqualToString:@"PUBLISHED"] == YES){
            NSString *title = [data objectForKey:@"Title"];
            NSMutableArray *urlArray = [data objectForKey:@"UrlList"];
            NSString *url = [[urlArray objectAtIndex:0] objectForKey:@"Url"];
            dispatch_async(dispatch_get_main_queue(), ^{
                BaiduPlayerController *player = [[BaiduPlayerController alloc] init];
                [player play:url title:title];
            });
        }else if( [status isEqualToString:@"FAILED"] == YES){
            reject(@"-1", @"转码失败", nil);
        }else if( [status isEqualToString:@"PROCESSING"] == YES){
            reject(@"-1", @"内部处理中", nil);
        }else if( [status isEqualToString:@"DISABLED"] == YES){
            reject(@"-1", @"已停用", nil);
        }else if( [status isEqualToString:@"BANNED"] == YES){
            reject(@"-1", @"已屏蔽", nil);
        }else{
            reject(@"-1", @"未知错误", nil);
        }
    }else{
        reject(@"-1", @"error", nil);
    }
}
@end
