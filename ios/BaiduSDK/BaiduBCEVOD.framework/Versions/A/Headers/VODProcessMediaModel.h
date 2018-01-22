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
 The process media request.
 */
@interface VODProcessMediaRequest : VODMediaIDRelatedRequest

/**
 The attributes will attached to the media, include title and description.
 */
@property(nonatomic, copy) VODMediaAttributes* attributes;

/**
 The extension of the original media file.
 */
@property(nonatomic, copy) NSString* sourceExtension;

/**
 The transcoding preset group will applied to on the media.
 */
@property(nonatomic, copy) NSString* transcodingPresetGroupName;
@end

/**
 The process media response.
 */
@interface VODProcessMediaResponse : BCEResponse

/**
 The returned media ID.
 */
@property(nonatomic, copy) NSString* mediaId;
@end
