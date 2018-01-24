//
//  PlayerVolumeView.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerVolumeView.h"

@implementation PlayerVolumeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.showsRouteButton = NO;
    }
    
    return self;
}

@end
