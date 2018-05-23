//
//  RNBaidu.h
//  RNBaidu
//
//  Created by Mac on 1/22/18.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTConvert.h>)
    #import <React/RCTEventEmitter.h>
#else
    #import <RCTEventEmitter.h>
#endif

@interface RNBaiduVod : NSObject
- (void)initBaiduBce;
- (NSString *) uploadVideo:(NSString *)filepath title:(NSString *)title description:(NSString *)description eventDispatcher:(RCTEventEmitter *)eventDispatcher errorString:(NSString **)errorString;
- (NSMutableDictionary *) queryMediaInfo:(NSString *)mediaId;
@end
 
