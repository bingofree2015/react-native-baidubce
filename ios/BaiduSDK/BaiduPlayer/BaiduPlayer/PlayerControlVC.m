//
//  PlayerControlVC.m
//  VideoPlayer
//
//  Created by 白璐 on 16/9/20.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "PlayerControlVC.h"
#import <BDCloudMediaPlayer/BDCloudMediaPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

#import "BitrateMapItem.h"
#import "PlayerLabelView.h"
#import "PlayerProgressView.h"
#import "TouchOptimizationView.h"

#import <Photos/Photos.h>

@interface PlayerControlVC ()

// 需要隐藏和显示的UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *messageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet PlayerLabelView *videoInfoView;
@property (weak, nonatomic) IBOutlet PlayerProgressView *slider;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *scaleView;
@property (weak, nonatomic) IBOutlet UIView *resolutionView;

// 子UI
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIButton *snapshotButton;
@property (weak, nonatomic) IBOutlet UIButton *scaleButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *resolutionButton;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (weak, nonatomic) IBOutlet MPVolumeView *volumeView;

// 超清、高清、标清
@property (weak, nonatomic) IBOutlet UIButton *superButton;
@property (weak, nonatomic) IBOutlet UIButton *highButton;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;


@property (assign, nonatomic) BOOL blockPositionUpdate;

@property (strong, nonatomic) NSDate* startTime;
@property (strong, nonatomic) NSTimer* timer;

@property (assign, nonatomic) NSTimeInterval playableDuration;
@property (assign, nonatomic) NSTimeInterval currentPlaybackTime;
@property (assign, nonatomic) double speed;
@property (strong, nonatomic) NSArray<BitrateMapItem*>* sortedIndexList;
@property (nonatomic, strong) NSBundle *assetBundle;
@end

@implementation PlayerControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetBundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [self.assetBundle pathForResource:@"Player" ofType:@"bundle"];
    if (bundlePath) {
        self.assetBundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    self.volumeView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self optimizationView].progressView = self.slider;
}

- (TouchOptimizationView*)optimizationView {
    return (TouchOptimizationView*)self.view;
}

- (void)enableTouchOptimization:(BOOL)enable {
    [self optimizationView].optimizationFlag = enable;
}

- (void)dealloc {
}

- (void)startTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(onTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onTimer:(NSTimer*)timer {
    NSTimeInterval interval = fabs([self.startTime timeIntervalSinceNow]);
    if (interval > 3 && !self.topView.hidden) {
        [self autoHide];
    }
    
    [self.delegate realtimeVariable:&_playableDuration position:&_currentPlaybackTime speed:&_speed];
    self.slider.cacheValue = self.playableDuration;
    [self.videoInfoView updateSpeed:self.speed];
    [self updatePosition:self.currentPlaybackTime];
}

- (void)updateIdleTime {
    self.startTime = [NSDate date];
}

- (void)autoHide {
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.slider.hidden = YES;
    self.videoInfoView.hidden = YES;
    self.volumeView.hidden = YES;
    self.messageView.hidden = YES;
    self.scaleView.hidden = YES;
    self.resolutionView.hidden = YES;
    
    if (self.downloadButton.enabled) {
        self.downloadButton.hidden = !self.downloadButton.hidden;
    }
    
    self.snapshotButton.selected = NO;
    self.scaleButton.selected = NO;
    self.resolutionButton.selected = NO;
    self.volumeButton.selected = NO;
    [self enableTouchOptimization:YES];
}

#pragma mark - PlayerActions
- (void)updateTitle:(NSString*)title {
    self.titleView.text = title;
    self.startTime = [NSDate date];
}

- (void)startLoadingAnimation {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)stopLoadingAnimation {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
}

- (void)updateDownoadable:(BOOL)downloadable {
    self.downloadButton.enabled = downloadable;
    self.downloadButton.hidden = !downloadable;
}

- (void)popPlayer {
    [self.navigationController popViewControllerAnimated:YES];
    [self stopTimer];
}

- (void)updatePlayerState:(NSInteger)state {
    
    NSArray* buttons = @[
                         self.actionButton,
                         self.volumeButton,
                         self.scaleButton
                         ];
    
    for (UIButton* button in buttons) {
        button.enabled = NO;
    }
    self.slider.userInteractionEnabled = NO;
    
    switch (state) {
        case BDCloudMediaPlayerPlaybackStateStopped:
        case BDCloudMediaPlayerPlaybackStateInterrupted:
            self.actionButton.enabled = YES;
            [self.actionButton setImage:[UIImage imageNamed:@"button_play" inBundle:self.assetBundle compatibleWithTraitCollection:nil]
                               forState:UIControlStateNormal];
            
            break;
        case BDCloudMediaPlayerPlaybackStatePlaying:
            NSLog(@"state changed to BDCloudMediaPlayerPlaybackStatePlaying!!!!!!!!");
            [self.actionButton setImage:[UIImage imageNamed:@"button_pause" inBundle:self.assetBundle compatibleWithTraitCollection:nil]
                               forState:UIControlStateNormal];
            for (UIButton* button in buttons) {
                button.enabled = YES;
            }
            self.slider.userInteractionEnabled = YES;
            break;
        case BDCloudMediaPlayerPlaybackStatePaused:
            NSLog(@"state changed to BDCloudMediaPlayerPlaybackStatePaused!!!!!!!!");
            [self.actionButton setImage:[UIImage imageNamed:@"button_play" inBundle:self.assetBundle compatibleWithTraitCollection:nil]
                               forState:UIControlStateNormal];
            for (UIButton* button in buttons) {
                button.enabled = YES;
            }
            self.slider.userInteractionEnabled = YES;
            break;
            break;
        default: {
            break;
        }}
}

- (void)updateDuration:(NSTimeInterval)duration {
    self.slider.userInteractionEnabled = fabs(duration) > 10e-6;
    self.slider.maximumValue = duration;
    self.slider.minimumValue = 0;
    self.slider.value = 0;
    self.slider.cacheValue = 0;
    
    [self.videoInfoView updateDuration:duration];
    [self startTimer];
}

- (void)updateResolution:(CGSize)size {
    [self.videoInfoView updateResolution:size];
}

- (void)updateBitrateList:(NSArray*)bitrates index:(NSInteger)currentIndex {
    if (!bitrates || bitrates.count < 2) {
        self.resolutionButton.hidden = YES;
        return;
    }
    
    if (currentIndex == -1) {
        currentIndex = 0;
    }
    
    NSInteger index = 0;
    BitrateMapItem* currentItem = nil;
    
    NSMutableArray* items = [NSMutableArray array];
    for (BDCloudMediaPlayerBitrateItem* playerItem in bitrates) {
        BitrateMapItem* item = [[BitrateMapItem alloc] init];
        item.bitrate = playerItem.bitrate;
        item.index = index++;
        item.titleTag = NSNotFound;
        [items addObject:item];
        
        if (item.index == currentIndex) {
            currentItem = item;
        }
    }
    
    NSArray<BitrateMapItem*>* sortedItems = [items sortedArrayUsingSelector:@selector(compare:)];
    if (sortedItems.count > 3) {
        sortedItems = [sortedItems subarrayWithRange:NSMakeRange(0, 3)];
    }
    
    self.sortedIndexList = sortedItems;
    
    index = sortedItems.count - 1;
    NSInteger titleTag = 2;
    for (; index >= 0; --index, --titleTag) {
        BitrateMapItem* item = sortedItems[index];
        item.titleTag = titleTag;
    }
    
    NSString* title;
    if (currentItem && currentItem.titleTag != NSNotFound) {
        NSArray* titles = @[@"超清", @"高清", @"标清"];
        title = titles[currentItem.titleTag];
    } else {
        title = @"标清";
    }
    
    [self.resolutionButton setTitle:title forState:UIControlStateNormal];
    [self.resolutionButton setTitle:title forState:UIControlStateHighlighted];
    [self.resolutionButton setTitle:title forState:UIControlStateSelected];
    
    self.superButton.enabled = sortedItems.count >= 3;
    self.highButton.enabled = sortedItems.count >= 2;
    self.normalButton.enabled = sortedItems.count >= 1;
    
    if (self.superButton.enabled) {
        [self.superButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if (self.highButton.enabled) {
        [self.highButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if (self.normalButton.enabled) {
        [self.normalButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)updatePosition:(NSTimeInterval)position {
    if (self.blockPositionUpdate) {
        return;
    }
    
    self.slider.value = position;
    [self.slider updatePlayableUI];
    [self.videoInfoView updatePositon:position];
}

- (void)updatePreviousState:(BOOL)state {
    self.previousButton.enabled = state;
}

- (void)updateNextState:(BOOL)state {
    self.nextButton.enabled = state;
}

#pragma mark - ui actions

- (IBAction)onBack:(id)sender {
    [self stopTimer];
    [self.delegate controlStop];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onDownload:(id)sender {
    [self updateIdleTime];
    
    __weak typeof(self) wself = self;
    [self.delegate download:^(BOOL cancel) {
        if (cancel) {
            return;
        }
        
        CGRect frame = wself.downloadButton.frame;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect animiationFrame = CGRectMake(frame.origin.x, wself.view.frame.size.height,
                                                frame.size.width, frame.size.height);
            wself.downloadButton.frame = animiationFrame;
        } completion:^(BOOL finished) {
            wself.downloadButton.frame = frame;
            wself.downloadButton.hidden = YES;
            wself.downloadButton.enabled = NO;
        }];
    }];

}

- (IBAction)onSliderSeek:(id)sender {
    [self updateIdleTime];
    [self.delegate seek:self.slider.value];
}

- (IBAction)sliderDown:(id)sender {
    [self updateIdleTime];
    self.blockPositionUpdate = YES;
    self.tapGesture.enabled = NO;
    [self stopTimer];
}

- (IBAction)sliderUp:(id)sender {
    [self performSelector:@selector(enableUpdatePosition) withObject:nil afterDelay:2];
    self.tapGesture.enabled = YES;
    [self startTimer];
}

- (void)enableUpdatePosition {
    self.blockPositionUpdate = NO;
}

- (IBAction)onTapBlank:(id)sender {
    CGPoint point = [self.tapGesture locationInView:self.view];
    CGRect topFrame = self.topView.frame;
    CGRect bottomFrame = self.bottomView.frame;
    CGRect volumeSliderFrame = self.volumeView.frame;
    
    if (CGRectContainsPoint(topFrame, point) || CGRectContainsPoint(bottomFrame, point)) {
        [self updateIdleTime];
        return;
    }
    
    if (!self.volumeView.hidden && CGRectContainsPoint(volumeSliderFrame, point)) {
        [self updateIdleTime];
        return;
    }
    
    BOOL hidden = !self.topView.hidden;
    self.topView.hidden = hidden;
    self.bottomView.hidden = hidden;
    self.videoInfoView.hidden = hidden;
    self.slider.hidden = hidden;
    
    if (hidden) {
        self.volumeView.hidden = YES;
        self.messageView.hidden = YES;
        self.scaleView.hidden = YES;
        self.resolutionView.hidden = YES;
    } else {
        self.messageView.hidden = (self.messageView.text.length == 0);
        [self updateIdleTime];
    }
    
    if (self.downloadButton.enabled) {
        self.downloadButton.hidden = !self.downloadButton.hidden;
    }
    
    self.volumeButton.selected = NO;
    self.scaleButton.selected = NO;
    self.resolutionButton.selected = NO;
    
    [self enableTouchOptimization:YES];
}

- (IBAction)onSnapshot:(id)sender {
    [self updateIdleTime];
    
    UIImage* image = [self.delegate snapshot];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
    }];
}

- (IBAction)onScale:(id)sender {
    [self updateIdleTime];
    
    self.resolutionView.hidden = YES;
    self.volumeView.hidden = YES;
    self.scaleView.hidden = !self.scaleView.hidden;
    if (!self.scaleView.hidden) {
        CGRect origin = self.scaleView.frame;
        
        CGRect begin = origin;
        begin.size.height = 0;
        begin.origin.y = origin.origin.y + origin.size.height;
        
        self.scaleView.frame = begin;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.scaleView.frame = origin;
        }];
    }
    
    self.resolutionButton.selected = NO;
    self.volumeButton.selected = NO;
    self.scaleButton.selected = !self.scaleView.hidden;
    [self enableTouchOptimization:!self.scaleButton.selected];
}

- (IBAction)onPrevious:(id)sender {
    [self stopTimer];
    [self updateIdleTime];
    [self.delegate playPrevious];
}

- (IBAction)onAction:(id)sender {
    [self updateIdleTime];
    [self.delegate play];
}

- (IBAction)onNext:(id)sender {
    [self stopTimer];
    [self updateIdleTime];
    [self.delegate playNext];
}

- (IBAction)onResolution:(id)sender {
    [self updateIdleTime];
    
    self.scaleView.hidden = YES;
    self.volumeView.hidden = YES;
    self.resolutionView.hidden = !self.resolutionView.hidden;
    if (!self.resolutionView.hidden) {
        CGRect origin = self.resolutionView.frame;
        
        CGRect begin = origin;
        begin.size.height = 0;
        begin.origin.y = origin.origin.y + origin.size.height;
        
        self.resolutionView.frame = begin;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.resolutionView.frame = origin;
        }];
    }
    
    self.scaleButton.selected = NO;
    self.volumeButton.selected = NO;
    self.resolutionButton.selected = !self.resolutionView.hidden;
    [self enableTouchOptimization:!self.resolutionButton.selected];
}

- (IBAction)onVolume:(id)sender {
    [self updateIdleTime];
    
    self.scaleView.hidden = YES;
    self.resolutionView.hidden = YES;
    self.volumeView.hidden = !self.volumeView.hidden;
    if (!self.volumeView.hidden) {
        CGRect origin = self.volumeView.frame;
        
        CGRect begin = origin;
        begin.size.height = 0;
        begin.origin.y = origin.origin.y + origin.size.height;
        
        self.volumeView.frame = begin;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.volumeView.frame = origin;
        }];
    }
    
    self.scaleButton.selected = NO;
    self.resolutionButton.selected = NO;
    self.volumeButton.selected = !self.volumeView.hidden;
    [self enableTouchOptimization:!self.volumeButton.selected];
}

- (IBAction)onScaleChange:(id)sender {
    [self updateIdleTime];
    
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    [self.delegate scale:tag];
    
    self.scaleView.hidden = YES;
    self.scaleButton.selected = NO;
    
    NSString* title = (tag == 0 ? @"适应" : @"填充");
    [self.scaleButton setTitle:title forState:UIControlStateNormal];
    [self.scaleButton setTitle:title forState:UIControlStateHighlighted];
    [self.scaleButton setTitle:title forState:UIControlStateSelected];
}

- (IBAction)onResolutionChange:(id)sender {
    [self updateIdleTime];
    
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    
    NSInteger index = 0;
    if (tag < self.sortedIndexList.count) {
        BitrateMapItem* item = self.sortedIndexList[tag];
        index = item.index;
    }
    
    [self.delegate changeBitrate:index];
    
    self.resolutionView.hidden = YES;
    self.resolutionButton.selected = NO;
    
    NSArray* titles = @[@"超清", @"高清", @"标清"];
    NSString* title = titles[tag];
    
    [self.resolutionButton setTitle:title forState:UIControlStateNormal];
    [self.resolutionButton setTitle:title forState:UIControlStateHighlighted];
    [self.resolutionButton setTitle:title forState:UIControlStateSelected];
}



@end
