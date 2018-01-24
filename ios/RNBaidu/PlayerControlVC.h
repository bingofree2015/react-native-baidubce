//
//  PlayerControlVC.h
//  VideoPlayer
//
//  Created by 白璐 on 16/9/20.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerControlDelegate.h"

@interface PlayerControlVC : UIViewController <PlayerActions>

@property(nonatomic, weak) id<PlayerControlDelegate> delegate;

@end
