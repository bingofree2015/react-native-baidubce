//
//  PlayerVC.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/18.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerVC.h"
#import "PlayerViewModel.h"
#import "PlayerControlVC.h"

@interface PlayerVC ()
@property(nonatomic, strong) PlayerControlVC* controlVC;
@end

@implementation PlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    if ([childController isKindOfClass:[PlayerControlVC class]]) {
        self.controlVC = (PlayerControlVC*)childController;
        self.controlVC.delegate = self.viewModel;
        self.viewModel.actions = self.controlVC;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.viewModel layout:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.viewModel start];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
