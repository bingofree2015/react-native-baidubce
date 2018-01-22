//
//  VODFilterMediaModel.h
//  bce
//
//  Created by He,Rui on 2017/7/10.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <BaiduBCEVOD/VODMediaRelatedModel.h>

@interface VODFilterMediaRequest : VODMediaRelatedRequest

/**
 the status of media,used to filter media in a particular state
 */
@property(nonatomic, copy) NSString *status;

/**
 the upper limit of media creation time(createTime),
 used to filter the creation time is equal to or later than the media
 */
@property(nonatomic, copy)NSDate *begin;

/**
 media creation time (createTime) lower limit,
 used to filter the creation time is equal to or earlier than the end of the media
*/
@property(nonatomic, copy)NSDate *end;

/**
 media title prefix,
 used to filter the media whitch title begin with the [title] parameter
 */
@property(nonatomic, copy)NSString *title;

@end

@interface VODFilterMediaResponse : BCEResponse

/**
 an array of media
 */
@property(nonatomic, copy) NSArray<VODMedia *> *mediaList;

@end
