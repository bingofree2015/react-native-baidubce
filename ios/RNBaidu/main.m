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
#import "UIView+Toast.h"

NSInteger const LRDRCTSimpleToastBottomOffset = 40;
double const LRDRCTSimpleToastShortDuration = 3.0;
double const LRDRCTSimpleToastLongDuration = 5.0;
NSInteger const LRDRCTSimpleToastGravityBottom = 1;
NSInteger const LRDRCTSimpleToastGravityCenter = 2;
NSInteger const LRDRCTSimpleToastGravityTop = 3;

@interface BaiduBce : NSObject <RCTBridgeModule>
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
