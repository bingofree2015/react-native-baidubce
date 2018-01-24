//
//  PlayerLabelView.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerLabelView : UIView

- (void)updateDuration:(NSTimeInterval)duration;
- (void)updatePositon:(NSTimeInterval)position;
- (void)updateResolution:(CGSize)size;
- (void)updateSpeed:(double)speed;

@end
