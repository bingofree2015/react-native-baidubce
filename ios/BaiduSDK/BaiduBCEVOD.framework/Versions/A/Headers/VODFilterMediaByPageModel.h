//
//  VODFilterMediaByPageModel.h
//  bce
//
//  Created by He,Rui on 2017/7/13.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <BaiduBCEVOD/VODFilterMediaModel.h>

@interface VODFilterMediaByPageRequest : VODFilterMediaRequest

/**
 the number of the page
 */
@property(nonatomic, assign) NSInteger pageNo;

/**
 the size of the page;
 valid value:[1,1000];
 */
@property(nonatomic, assign) NSInteger pageSize;

@end

@interface VODFilterMediaByPageResponse : VODFilterMediaResponse

/**
 current page number
 */
@property(nonatomic, assign) NSInteger pageNo;

/**
 current page size
 */
@property(nonatomic, assign) NSInteger pageSize;

/**
 the number of media being filtered out
 */
@property(nonatomic, assign) NSInteger totalCount;

@end

