//
//  TakingPicturesViewController.m
//  美萌相机
//
//  Created by zuokai on 2017/4/1.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import "TakingPicturesViewController.h"

@interface TakingPicturesViewController ()<TitleViewDelegate,BottomViewDelegate>

// 触及手势
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;

@end

@implementation TakingPicturesViewController
- (UITapGestureRecognizer*)tapGesture {
    
    if (_tapGesture == nil) {
       _tapGesture = [[UITapGestureRecognizer alloc]init];
    }
    return _tapGesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //打开相机
    [self openCamera];
    [self settingOtherSubViews];
    if (self.image !=nil) {
        self.bottomView.image = self.image;
    }else {
        [self getLatestPhotoBottomView:self.bottomView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foregroundNotification) name:@"foregroundNotification" object:nil];
    //设置导航栏
    [self setupNavBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
//    if (self.image !=nil) {
//        self.bottomView.image = self.image;
//    }else {
//        [self getLatestPhotoBottomView:self.bottomView];
//    }
}
- (void)foregroundNotification {
    [self startSession];
}

// 对焦
- (void)settingFocusValue:(float)value {
    // value ==> 0.0 到 1.0
    // 锁定配置
    NSError *error;
    [self.device unlockForConfiguration];
    if ([self.device lockForConfiguration:&error]) {
         [self.device setFocusModeLockedWithLensPosition:value completionHandler:^(CMTime syncTime) {
        }];
        // 解锁UIco
        [self.device unlockForConfiguration];
    }
}


// 自定义相机聚焦视图
- (void)addfocusView{
    
    [self.previewView addSubview:self.focusView];
   
    [self.previewView addGestureRecognizer:self.tapGesture];
    [self.tapGesture addTarget:self action:@selector(focusGesture:)];
}
// 点击聚焦手势
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
   CGPoint point = [gesture locationInView:gesture.view];
}
// 设置聚焦效果
- (void)focusAtPoint:(CGPoint)point model:(NSInteger)model{
    CGSize size = self.previewView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
            
            if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [self.device setFocusPointOfInterest:focusPoint];
                [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            
            if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                [self.device setExposurePointOfInterest:focusPoint];
                [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            
            [self.device unlockForConfiguration];
            self.focusView.center = point;
            self.focusView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.focusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    self.focusView.hidden = YES;
                }];
            }];
        }
}

- (void)dealloc {
   // 移除通知
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
