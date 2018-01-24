//
//  TouchOptimizationView.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/28.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerProgressView.h"

@interface TouchOptimizationView : UIView

@property(nonatomic, strong) PlayerProgressView* progressView;
@property(nonatomic, assign) BOOL optimizationFlag;

@end
