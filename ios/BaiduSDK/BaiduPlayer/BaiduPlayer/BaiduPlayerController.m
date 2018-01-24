//
//  BaiduPlayerController.m
//  BaiduPlayer
//
//  Created by Mac on 1/24/18.
//  Copyright © 2018 RNBaidu. All rights reserved.
//

#import "BaiduPlayerController.h"
#import "PlayerVC.h"
#import "PlayerModel.h"
#import "PlayerControlVC.h"
#import "PlayerViewModel.h"
#import <BDCloudMediaPlayer/BDCloudMediaPlayer.h>

@interface BaiduPlayerController()

@end

@implementation BaiduPlayerController
- (instancetype)init
{
    if ((self = [super init])) {
        [[BDCloudMediaPlayerAuth sharedInstance] setAccessKey:@"724c9abc6cd9403daece9d4d17c3e31b"];
    }
    return self;
}

- (void)play:(NSString *)url title:(NSString *)title {
    PlayerViewModel* viewModel = [[PlayerViewModel alloc] initWithURL:url title:title downloadable:false];
    viewModel.videoSource = nil;
    
    NSBundle *bundle1 = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle1 pathForResource:@"Player" ofType:@"bundle"];
    if (bundlePath) {
        bundle1 = [NSBundle bundleWithPath:bundlePath];
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Player" bundle:bundle1];
    PlayerVC *vc = (PlayerVC*)[sb instantiateViewControllerWithIdentifier:@"PlayerVC"];
    vc.viewModel = viewModel;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //UIView *root = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootViewController presentViewController:vc animated:NO completion:nil];
    });
}
@end
