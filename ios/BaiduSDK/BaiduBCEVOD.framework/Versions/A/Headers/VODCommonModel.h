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

#import <Foundation/Foundation.h>

@class BCEError;

/**
 Media Attributes Object.
 */
@interface VODMediaAttributes : NSObject

/**
 Media title.
 */
@property(nonatomic, copy) NSString* mediaTitle;

/**
 Media description.
 */
@property(nonatomic, copy) NSString* mediaDescription;
@end

/**
 Media metadata. Include original size, total size and duration.
 */
@interface VODMediaMetadata : NSObject

/**
 Media original size in bytes.
 */
@property(nonatomic, assign) uint64_t sourceSizeInBytes;

/**
 Media total size on BOS, include original file, files after transcoding, thumbnails.
 */
@property(nonatomic, assign) uint64_t sizeInBytes;

/**
 Media duration in seconds.
 */
@property(nonatomic, assign) uint64_t durationInSeconds;
@end

@interface VODPlayableURLMeta : NSObject


/**
 transcoded video space
 */
@property(nonatomic, assign) NSInteger sizeInBytes;

/**
 transcoded video duration, in seconds
 */
@property(nonatomic, assign) double durationInSeconds;

/**
 transcoded video bit rate
 */
@property(nonatomic, assign) NSInteger bitRateInBps;

/**
 transcoded video frame rate
 */
@property(nonatomic, assign) double frameRate;

/**
 transcoded video width in pixel
 */
@property(nonatomic, assign) NSInteger widthInPixel;

/**
 transcoded video height in pixel
 */
@property(nonatomic, assign) NSInteger heightInPixel;

@end

/**
 Media playable url.
 */
@interface VODPlayableURL : NSObject

/**
 The transcoding preset name of the media file which the url point to.
 */
@property(nonatomic, copy) NSString* transcodingPresetName;

/**
 The media file's url.
 */
@property(nonatomic, copy) NSString* url;

/**
 The meta data of playable url
 */
@property(nonatomic, strong) VODPlayableURLMeta *meta;
@end

/**
 The business error when process media.
 */
@interface VODGetMediaError : NSObject

/**
 Error code.
 */
@property(nonatomic, copy) NSString* code;

/**
 Error message.
 */
@property(nonatomic, copy) NSString* message;
@end


@interface VODMedia : NSObject

/**
 The media ID.
 */
@property(nonatomic, copy) NSString* mediaId;

/**
 The status of the media.
 */
@property(nonatomic, copy) NSString* status;

/**
 The attributes of the media.
 */
@property(nonatomic, strong) VODMediaAttributes* attributes;

/**
 The metadata of the media.
 */
@property(nonatomic, strong) VODMediaMetadata* mediaMetadata;

/**
 The business error of the media. Not nil when status is equal to kVODMediaStatusFailed.
 */
@property(nonatomic, strong) VODGetMediaError* error;

/**
 The publish time of the media.
 */
@property(nonatomic, copy) NSString* publishTime;

/**
 The create time of the media.
 */
@property(nonatomic, copy) NSString* createTime;

/**
 The transcoding preset group applied to the media.
 */
@property(nonatomic, copy) NSString* transcodingPresetGroupName;

/**
 The playable urls.
 */
@property(nonatomic, strong) NSArray<VODPlayableURL*>* playableUrlList;

/**
 The thumbnail list.
 */
@property(nonatomic, strong) NSArray<NSString*>* thumbnailList;


/**
 parse Json to VODMedia object

 @param json response json
 @param error the error
 @return parse state
 */
- (BOOL)parseJson:(id)json error:(BCEError **)error;
@end

/**
 The media status means internal processing. It's an intermediate state.
 */
extern NSString* const kVODMediaStatusProcessing;

/**
 The media status means process is running.
 */
extern NSString* const kVODMediaStatusRunning;

/**
 The media status means process failed.
 */
extern NSString* const kVODMediaStatusFailed;

/**
 The media status means the media has been published.
 */
extern NSString* const kVODMediaStatusPublished;

/**
 The media status means the media is disabled.
 */
extern NSString* const kVODMediaStatusDisabled;

/**
 The media status means the media is banned.
 */
extern NSString* const kVODMediaStatusBanned;
