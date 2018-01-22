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
 The generate media ID request.
 */
@interface VODGenerateMediaIDRequest : VODMediaRelatedRequest
/**
 Transcoding mode. Leave empty, means transcoding.
 For more mode, please visit https://cloud.baidu.com/doc/VOD/API.html#.E7.94.B3.E8.AF.B7.E5.AA.92.E8.B5.84.
 */
@property(nonatomic, copy) NSString* mode;

@end

/**
 The generate media ID response.
 */
@interface VODGenerateMediaIDResponse : BCEResponse

/**
 The media ID.
 */
@property(nonatomic, copy) NSString* mediaID;

/**
 The source bucket managed by BOS that media file should upload to.
 */
@property(nonatomic, copy) NSString* sourceBucket;

/**
 The source key in the source bucket.
 */
@property(nonatomic, copy) NSString* sourceKey;

/**
 The host of the BOS server.
 BOS client endpoint should be 'http[s]://<host>'.
 */
@property(nonatomic, copy) NSString* host;
@end
