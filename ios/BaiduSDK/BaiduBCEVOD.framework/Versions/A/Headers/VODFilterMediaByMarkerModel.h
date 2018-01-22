//
//  VODFilterMediaByMarkerModel.h
//  bce
//
//  Created by He,Rui on 2017/7/13.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <BaiduBCEVOD/VODFilterMediaModel.h>

@interface VODFilterMediaByMarkerRequest : VODFilterMediaRequest

/**
 the marker of the start query position in this request
 */
@property(nonatomic, copy) NSString *marker;

/**
 the maximum number of the result;
 valid value:[1,1000];
 default value : 1000;
 */
@property(nonatomic, assign) NSInteger maxSize;

@end

@interface VODFilterMediaByMarkerResponse : VODFilterMediaResponse

/**
 returen YES indicated that there is data remain;
 return NO indicated that there is no more data;
 */
@property(nonatomic, assign) BOOL isTruncated;

/**
 Gets the marker value to be passed on the next page;
 valid only if isTruncated is true;
 */
@property(nonatomic, copy) NSString *nextMarker;

/**
 The marker of this request, marking the starting position of the query
 */
@property(nonatomic, copy) NSString *marker;

@end
