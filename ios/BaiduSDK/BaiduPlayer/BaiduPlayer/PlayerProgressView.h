//
//  PlayerProgressView.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerProgressView : UIView

@property(nonatomic, assign) float maximumValue;
@property(nonatomic, assign) float minimumValue;
@property(nonatomic, assign) float value;
@property(nonatomic, assign) float cacheValue;

@property(nonatomic, copy) void (^downBlock)();
@property(nonatomic, copy) void (^seekBlock)(float value);

- (void)updatePlayableUI;

@end
