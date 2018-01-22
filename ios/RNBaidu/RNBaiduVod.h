//
//  RNBaidu.h
//  RNBaidu
//
//  Created by Mac on 1/22/18.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNBaiduVod : NSObject
- (void)initBaiduBce;
- (NSString *) uploadVideo:(NSString *)filepath;
- (void) queryMediaInfo:(NSString *)mediaId;
@end
