//
//  TouchOptimizationView.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "TouchOptimizationView.h"

@implementation TouchOptimizationView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.optimizationFlag) {
        return [super hitTest:point withEvent:event];
    } else {
        CGRect frame = self.progressView.frame;
        frame = CGRectInset(frame, 0, -20);
        frame = CGRectOffset(frame, 0, -10);
        
        if (CGRectContainsPoint(frame, point)) {
            CGPoint aPoint = [self convertPoint:point toView:self.progressView];
            return [self.progressView hitTest:aPoint withEvent:event];
        } else {
            return [super hitTest:point withEvent:event];
        }
    }
}

@end
