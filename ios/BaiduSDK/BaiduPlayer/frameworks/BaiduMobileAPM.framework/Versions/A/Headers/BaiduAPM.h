//
//  BaiduAPM.h
//  APM-Mobile-IOS
//
//  Created by Jer on 15/10/10.
//  Copyright © 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class BaiduAPM
 @abstract Top-level class for interfacing with BaiduAPM SDK
 */
@interface BaiduAPM : NSObject

/*!
 @abstract Initializes BaiduAPM SDK object using token
 @param token distributed By APM
 @return null
 */
+ (void)startWithApplicationToken:(NSString *)token;

/*!
 @abstract Get application token
 @return application token
 */
+ (NSString*)getApplicationToken;

/*!
 @abstract Retrieves the version string for the BaiduAPM iOS SDK
 @return version string for the BaiduAPM iOS SDK
 */
+ (NSString*)getSdkVersion;

/*!
 @abstract Set start time for custom operation
 @param name The name of the operation
 @param scope The scope of the operation
 @param id The uniq identification for a single operation
 @return null
 */
+ (void)customMetricStart:(NSString*)name  scope:(NSString*)key id:(NSString*)id;

/*!
 @abstract Set start time for custom operation
 @param id The uniq identification for a single operation
 @return null
 */
+ (void)customeMetricEnd:(NSString*)id;

/*!
 @Api for LSS to report media performance data
 @param json The media performance data like:
  {
    "baseInfo":{ url,env等信息 },
	"eventName":"firstBufferFull",
	"eventInfo":{ event相关信息 }
   }
 @return null
 */
+ (void)onLssEvent:(NSString*)json;

/*!
 @Api to report media performance data
 @param json The media performance data like:
 {
    "baseInfo":{ url,env等信息 },
	"eventName":"firstBufferFull",
	"eventInfo":{ event相关信息 }
 }
 @return null
 */
+ (void)onLiveEvent:(NSString*)json;
@end
