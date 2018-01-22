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

#import <BaiduBCEBasic/BCEClient.h>

@class BCETask;
@class VODClientConfiguration;

@class VODGenerateMediaIDRequest;
@class VODProcessMediaRequest;
@class VODFilterMediaByPageRequest;
@class VODFilterMediaByMarkerRequest;


/**
 *  @brief Provides the client for accessing the Baidu Cloud VOD Service.
 */
@interface VODClient : BCEClient

/**
 *  @brief Constructs a new client using the client configuration.
 *  @param configuration The client configuration.
 *  @return Client object.
 */
- (instancetype)initWithConfiguration:(VODClientConfiguration*)configuration;

/**
 *  @brief Apply a mediaId from server. 
           The response also carry BOS location where your media file should upload to.
 *  @param request The request.
 *  @return Task of the generate media id request.
 */
- (BCETask*)generateMediaID:(VODGenerateMediaIDRequest*)request;

/**
 *  @brief Notify server to process the uploaded media.
 *  @param request The request.
 *  @return Task of the process media request.
 */
- (BCETask*)processMedia:(VODProcessMediaRequest*)request;

/**
 *  @brief Gets the properties of specific media resource managed by VOD service.
 *  @param mediaId The media id.
 *  @return Task of the get media request.
 */
- (BCETask*)getMedia:(NSString*)mediaId;

/**
 *  @brief Gets the filtered media by page.
 *  @param request The request.
 *  @return Task of the get filtered media request.
 */
- (BCETask*)getFilteredMediaByPage:(VODFilterMediaByPageRequest *)request;

/**
 *  @brief Gets the filtered media by marker.
 *  @param request The request.
 *  @return Task of the get filtered media request.
 */
- (BCETask*)getFilteredMediaByMarker:(VODFilterMediaByMarkerRequest *)request;

@end
