//
//  BitrateMapItem.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/29.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BitrateMapItem.h"

@implementation BitrateMapItem

// 降序排列
- (NSComparisonResult)compare:(BitrateMapItem*)otherItem {
    if (self.bitrate > otherItem.bitrate) {
        return NSOrderedAscending;
    } else if (self.bitrate < otherItem.bitrate) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"index %zd, bitrate:%zd, titleTag:%zd", self.index, self.bitrate, self.titleTag];
}

@end
