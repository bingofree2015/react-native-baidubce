//
//  PlayerControlDelegate.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/23.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlayerControlDelegate <NSObject>

- (BOOL)hasPrevious;
- (BOOL)hasNext;
- (void)play;
- (void)playPrevious;
- (void)playNext;
- (void)download:(void(^)(BOOL cancel))cancelBlock;
- (void)seek:(NSTimeInterval)position;
- (void)realtimeVariable:(NSTimeInterval*)playableDuration position:(NSTimeInterval*)position speed:(double*)speed;
- (void)scale:(NSInteger)mode;
- (void)changeBitrate:(NSInteger)index;
- (UIImage*)snapshot;
- (void)controlStop;

@end

@protocol PlayerActions <NSObject>

- (void)updateTitle:(NSString*)title;
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
- (void)updateDownoadable:(BOOL)state;
- (void)updatePreviousState:(BOOL)state;
- (void)updateNextState:(BOOL)state;
- (void)popPlayer;
- (void)updatePlayerState:(NSInteger)state;
- (void)updateDuration:(NSTimeInterval)duration;
- (void)updateResolution:(CGSize)size;
- (void)updateBitrateList:(NSArray*)bitrates index:(NSInteger)currentIndex;
- (void)updatePosition:(NSTimeInterval)position;

@end
