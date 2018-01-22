/*
 * Copyright (c) 2016 Baidu.com, Inc. All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

#import <BaiduBCEVOD/VODMediaRelatedModel.h>

/**
 The get media request.
 */
@interface VODGetMediaRequest : VODMediaIDRelatedRequest
@end

/**
 The get media response.
 */
@interface VODGetMediaResponse : BCEResponse

@property(nonatomic, strong) VODMedia *media;

@end

/**
 The business error code means transcoding action failed.
 */
extern NSString* const kVODGetMediaCodeTranscodingFailed;

/**
 The business error code means thumbnail action failed.
 */
extern NSString* const kVODGetMediaCodeThumbnailFailed;

/**
 The business error code means media process timeout.
 */
extern NSString* const kVODGetMediaCodeMediaOvertime;
