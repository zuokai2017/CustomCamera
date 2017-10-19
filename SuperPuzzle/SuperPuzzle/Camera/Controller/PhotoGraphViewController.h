//
//  PhotoGraphViewController.h
//  美萌相机
//
//  Created by zuokai on 2017/4/3.
//  Copyright © 2017年 zsx. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "BottomView.h"
#import <AVFoundation/AVFoundation.h>
#import "TitleView.h"

@interface PhotoGraphViewController : UIViewController
// 下边的视图
@property (nonatomic,strong)BottomView *bottomView;
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
// 相机各种参数设置
@property(nonatomic)AVCaptureDeviceFormat *activeFormat;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic)UIView *previewView;
// 对焦  
@property (nonatomic)UIView *focusView;

@property (nonatomic,strong)TitleView *titlesView;
@property (nonatomic,assign)NSInteger screenBtnTag;
// 接收截取的图片
@property (nonatomic)UIImage *image;


//打开相机
- (void)openCamera;
// 设置导航条
- (void)setupNavBar;
// 设置子视图
- (void)settingOtherSubViews;
// 设置默认导航栏
- (void)settingTitleViewWithBtnTag:(NSInteger)btnTag;
// 屏幕宽比
- (void)switchScreenWithThan:(NSInteger)Tag;
// 第一次打开相机时获取的照片
- (void)getLatestPhotoBottomView:(BottomView*)bottomView;
- (void)startSession;


@end
