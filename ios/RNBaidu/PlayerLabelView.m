//
//  PlayerLabelView.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerLabelView.h"

@interface PlayerLabelView ()
@property (weak, nonatomic) IBOutlet UILabel *currentPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation PlayerLabelView
- (void)updateDuration:(NSTimeInterval)duration {
    self.currentPositionLabel.text = [self formatTimeInterval:0];
    self.durationLabel.text = [self formatTimeInterval:duration];
}

- (void)updatePositon:(NSTimeInterval)position {
    self.currentPositionLabel.text = [self formatTimeInterval:position];
}

- (void)updateResolution:(CGSize)size {
    if (size.width < 0 && size.height < 0) {
        size.width = 0;
        size.height = 0;
    }
    
    self.resolutionLabel.text = [NSString stringWithFormat:@"%.0fX%.0f", size.width, size.height];
}

- (void)updateSpeed:(double)speed {
    self.speedLabel.text = [NSString stringWithFormat:@"%.0fKbps", speed / 1024];
}

- (NSString*)formatTimeInterval:(NSTimeInterval)interval {
    NSUInteger totalMinutes = (NSUInteger)interval / 60;
    NSUInteger leftSeconds = (NSUInteger)interval % 60;
    
    NSUInteger totalHours = totalMinutes / 60;
    NSUInteger leftMinutes = totalMinutes % 60;
    
    NSMutableString* string = [NSMutableString string];
    if (totalHours != 0) {
        [string appendFormat:@"%lu:", (unsigned long)totalHours];
    }
    
    if (totalMinutes != 0) {
        [string appendFormat:@"%02lu:", (unsigned long)leftMinutes];
    } else {
        [string appendString:@"00:"];
    }
    
    [string appendFormat:@"%02lu", (unsigned long)leftSeconds];
    
    return string;
}

@end
