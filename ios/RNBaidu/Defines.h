//
//  Defines.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/18.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kDefaultVideoFilename;
extern NSString* const kDefaultUser;
extern NSString* const kDefaultUserFilename;

@interface VideoItem : NSObject
@property(nonatomic, copy) NSString* img;
@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* detail;
@property(nonatomic, copy) NSString* url;
@end

typedef NS_ENUM(NSUInteger, NetworkType) {
    NetworkTypeNone,
    NetworkTypeWIFI,
    NetworkTypeWWAN
};

typedef NS_ENUM(NSUInteger, DownloadState) {
    DownloadStateNone,
    DownloadStateRunning,
    DownloadStateSuspend,
    DownloadStateCompleted
};

@protocol VideoSource <NSObject>

- (void)downloadVideo:(NSString*)url cancelBlock:(void(^)(BOOL cancel))block;
- (VideoItem*)previousVideo:(NSString*)url;
- (VideoItem*)nextVideo:(NSString*)url;
- (BOOL)downloadable:(NSString*)url;

@end
