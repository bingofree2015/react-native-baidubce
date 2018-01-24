//
//  PlayerProgressView.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerProgressView.h"

@interface PlayerProgressView ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@end

@implementation PlayerProgressView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self.sliderView setMinimumTrackImage:[UIImage imageNamed:@"slider_track"] forState:UIControlStateNormal];
        [self.sliderView setMaximumTrackImage:[UIImage imageNamed:@"slider_background"] forState:UIControlStateNormal];
        [self.sliderView setThumbImage:[UIImage imageNamed:@"slider_point"] forState:UIControlStateNormal];
    }
    
    return self;
}

- (float)maximumValue {
    return self.sliderView.maximumValue;
}

- (void)setMaximumValue:(float)maximumValue {
    self.sliderView.maximumValue = maximumValue;
    NSLog(@"set maximumValue value %.2f", maximumValue);
}

- (float)minimumValue {
    return self.sliderView.minimumValue;
}

- (void)setMinimumValue:(float)minimumValue {
    self.sliderView.minimumValue = minimumValue;
}

- (float)value {
    return self.sliderView.value;
}

- (void)setValue:(float)value {
    self.sliderView.value = value;
}

- (void)setCacheValue:(float)cacheValue {
    _cacheValue = cacheValue;
}

- (void)updatePlayableUI {
    if (fabs(self.sliderView.maximumValue) > 10e-6) {
        float progress = self.cacheValue / self.sliderView.maximumValue;
        self.progressView.progress = progress;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = self.bounds;
    frame = CGRectInset(frame, 0, -20);
    frame = CGRectOffset(frame, 0, -10);
    if (CGRectContainsPoint(frame, point)) {
        return self.sliderView;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
