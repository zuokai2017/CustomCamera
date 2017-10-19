//
//  PhotoGraphViewController.m
//  美萌相机
//
//  Created by zuokai on 2017/4/3.
//  Copyright © 2017年 zsx. All rights reserved.
//
#import "PhotoGraphViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Photos/Photos.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "SaveAndCancelView.h"
#import "ImgDetailViewController.h"
#define  BottomHeight  123

static SystemSoundID shake_sound_male_id = 0;

@interface PhotoGraphViewController ()<AVCaptureMetadataOutputObjectsDelegate,BottomViewDelegate,TitleViewDelegate,SaveAndCancelViewDelegate>
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//
//@property (nonatomic,strong)AVCaptureMovieFileOutput *outPut;
// 点击照相按钮捕获输出
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
// 截取的照片显示的视图
@property (nonatomic)UIImageView *imageView;
// 接收截取的二进制图片
@property (nonatomic)NSData *imageData;
// 队列
@property (nonatomic,strong,readwrite) dispatch_queue_t captureQueue;

/*自定义导航栏*/
@property (nonatomic,strong)TitleView *flashView;
@property (nonatomic,strong)TitleView *timeView;
// 延迟时间
@property (nonatomic,assign)NSInteger delaySec;
@property (nonatomic,strong)SaveAndCancelView *saveAndCancelVi;

@end

@implementation PhotoGraphViewController
//
- (SaveAndCancelView*)saveAndCancelVi {
    if (_saveAndCancelVi == nil) {
        _saveAndCancelVi = [[SaveAndCancelView alloc]init];
        _saveAndCancelVi.delegate = self;
    }
    return _saveAndCancelVi;
}
#pragma mark - 串行队列+同步任务
-(dispatch_queue_t)captureQueue {
    if (_captureQueue==nil) {
        _captureQueue = dispatch_queue_create("com.camera.CaptureDispatchQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _captureQueue;
}
- (UIView*)focusView {
    if (_focusView == nil ) {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.hidden = YES;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
    }
    return _focusView;
}
-(UIView*)previewView {
    if (_previewView == nil) {
        _previewView = [[UIView alloc]init];
        _previewView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_previewView atIndex:0];
    }
    return _previewView;
}

// 上面导航栏视图
-(TitleView*)titlesView {
    if (_titlesView == nil) {
        CGFloat rectNavH = self.navigationController.navigationBar.frame.size.height;
        _titlesView = [TitleView TitleView];
        _titlesView.frame = CGRectMake(0, 0, kScreenWidth, rectNavH);
    }
    return _titlesView;
}
-(TitleView*)flashView {
    if (_flashView == nil) {
        CGFloat rectNavH = self.navigationController.navigationBar.frame.size.height;
        _flashView = [TitleView FlashView];
        _flashView.frame = CGRectMake(0, 0, kScreenWidth, rectNavH);
    }
    return _flashView;
}
- (TitleView*)timeView {
    if (_timeView == nil) {
        CGFloat rectNavH = self.navigationController.navigationBar.frame.size.height;
        _timeView = [TitleView TimeView];
        _timeView.frame = CGRectMake(0, 0, kScreenWidth, rectNavH);
    }
    return _timeView;
}
// 下面的按钮
-(BottomView*)bottomView {
    if (_bottomView == nil) {
        _bottomView = [BottomView BottomView];
        [self.view addSubview:_bottomView];
        _bottomView.delegate = self;
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidLayoutSubviews {
    self.bottomView.frame = CGRectMake(0, kScreenHeight - BottomHeight , kScreenWidth, BottomHeight);
    _saveAndCancelVi.frame = WINDOW.bounds;
}
//打开相机
- (void)openCamera {
    
    [self customCamera];
}
// 设置导航条
- (void)setupNavBar {
 self.navigationController.navigationBar.backgroundColor =  [UIColor whiteColor];
//  self.navigationItem.titleView = self.titlesView;
    [self switchTitleView:self.titlesView];
}

- (void)settingOtherSubViews {
    
    self.titlesView.delegate = self;
    
}
// bottomView的代理方法一
-(void)BottomView:(UIView *)view btn:(UIButton *)btn
{
    switch (btn.tag) {
            
        case 1:{ // 构图
            
        }
            break;
        case 2:{
            // 拍照功能
            [self showDelayView:self.delaySec];
        }
            break;
        case 3:
        {
           // 进入照片详情
            if (self.bottomView.image) {
                ImgDetailViewController *imgVc = [[ImgDetailViewController alloc] init];
                UINavigationController *detailVc = [[UINavigationController alloc]initWithRootViewController:imgVc];
                imgVc.currentImage = self.bottomView.image;
                [self.navigationController presentViewController:detailVc animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 实现titleView的代理方法
-(void)TitleView:(UIView *)view btn:(UIButton *)btn {
    
    if (btn.tag/10 == 1) {
        
        [self swithBtnDefualtWith:btn.tag];
        
    } else if(btn.tag/10 == 2) {
        // 闪光灯
        [self switchFlashTypeWith:btn.tag];
        
    } else if (btn.tag/10 == 3) {
        // 定时器
       [self switchTimerTypeWith:btn.tag];
    }    
}

- (void)switchTitleView:(UIView*)titleView {
    [self.navigationController.navigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.navigationController.navigationBar addSubview:titleView];
}
// 默认状态点击按钮
- (void)swithBtnDefualtWith:(NSInteger)BtnTag{
    switch (BtnTag) {
        case 10:{
            // 返回按钮
            [self stopSession];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 11:{
            // 闪光灯
           self.flashView.delegate = self;
           [self switchTitleView:self.flashView];
           [self addAnimation];
        }
            break;
        case 12:
            // 定时器
            self.timeView.delegate = self;
            [self switchTitleView:self.timeView];
            [self addAnimation];
            break;
        case 13:
            // 摄像头切换
            [self changeCamera];
            break;
        default:
            break;
    }
}
//  定时器拍照
-(BOOL) showDelayView: (NSInteger) delay{
    if (delay < 1) {
        // 直接拍照
        [self shutterCamera];
        return YES;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tickSound" ofType:@"wav"];
        NSLog(@"-播放路劲--%@----",path);
        if (path) {
            //注册声音到系统
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        }
    });
    AudioServicesPlaySystemSound(shake_sound_male_id);
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.square = YES;
    hud.minSize = CGSizeMake(100, 100);
    //hud.color = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:0.8];
    hud.color = [UIColor clearColor];
    hud.labelColor = [UIColor redColor];
    hud.labelText = [NSString stringWithFormat:@"%ld", (long)delay];
    hud.labelFont = [UIFont boldSystemFontOfSize:36];

    delay -=1;

    __weak __typeof(self) weakSelf = self;
    hud.completionBlock = ^{
        [weakSelf showDelayView:delay];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });;
    return NO;
}
// BottomView 代理方法三 --- > 屏幕宽比
- (void)BottomView:(UIView *)view screenBtn:(UIButton*)btn{
    [self switchScreenWithThan:btn.tag];
}
// 屏幕宽比
- (void)switchScreenWithThan:(NSInteger)Tag {
    self.screenBtnTag = Tag;
    switch (Tag) {
        case 4:
        {
            CGRect BigFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*16/9);
            self.previewView.frame = BigFrame;
            self.previewLayer.frame = CGRectMake(0, 0, self.previewView.AJZJ_width, self.previewView.AJZJ_height);
            self.bottomView.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.backgroundColor =  [UIColor clearColor];
            [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 0;
        }
            break;
        case 5:
        {
            self.previewView.frame = CGRectMake(0, 44, kScreenWidth, kScreenWidth * 4/3);
            self.previewLayer.frame = CGRectMake(0, 0, self.previewView.AJZJ_width, self.previewView.AJZJ_height);
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.bottomView.backgroundColor = [UIColor whiteColor];
            self.navigationController.navigationBar.backgroundColor =  [UIColor whiteColor];
            [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
        }
            break;
        case 6:
        {
            self.previewView.frame = CGRectMake(0, 44 + (kScreenHeight - self.bottomView.AJZJ_height - 44 - kScreenWidth)/2.0, kScreenWidth, kScreenWidth);
            self.previewLayer.frame = CGRectMake(0, 0, self.previewView.AJZJ_width, self.previewView.AJZJ_height);
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.bottomView.backgroundColor = [UIColor whiteColor];
            self.navigationController.navigationBar.backgroundColor =  [UIColor whiteColor];
            [[self.navigationController.navigationBar subviews] objectAtIndex:0].alpha = 1;
        }
        default:
            break;
    }
}

// 闪光灯模式
- (void)switchFlashTypeWith:(NSInteger)BtnTag {
    
    NSInteger index = BtnTag % 20;
    [self FlashOnBtnIndenx:index];
    [self settingTitleViewWithBtnTag:BtnTag];
}
// 定时器
- (void)switchTimerTypeWith:(NSInteger)BtnTag {
     self.delaySec = 3 * ( BtnTag % 30 );
     [self settingTitleViewWithBtnTag:BtnTag];
     NSLog(@"====延长时间:%ld======",self.delaySec);
}
// 设置默认导航栏
- (void)settingTitleViewWithBtnTag:(NSInteger)btnTag {
    
    [self.titlesView settingBtnWithImgBtnTag:btnTag imgCallBack:^(id obj) {
        NSLog(@"=======%@======",obj);
    }];
    self.titlesView.delegate = self;
    [self switchTitleView:self.titlesView];
    CATransition *animation = [CATransition new];
    animation.duration = 0.5;
    animation.type = @"moveIn";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.subtype = kCATransitionFromLeft;
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];
}
// 切换其他导航栏时的动画
- (void)addAnimation  {
    CATransition *animation = [CATransition new];
    animation.duration = 0.5;
    animation.type = @"push";
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.subtype = kCATransitionFromRight;
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];
}
// 自定义相机
- (void)customCamera{
    
    self.view.backgroundColor = [UIColor clearColor];
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 设置参数
    self.activeFormat = self.device.activeFormat;
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    //生成会话，用来结合输入输出
        self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    // 图片输出
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
        
        
    }

    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewView.frame = CGRectMake(0, 44, kScreenWidth, kScreenWidth * 4/3);
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    // 默认是
    self.previewLayer.frame = CGRectMake(0, 0, self.previewView.AJZJ_width, self.previewView.AJZJ_height);;
    // NSLog(@"=====宽高比：===%f========",kScreenWidth/(kScreenHeight - BottomHeight - 44));
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.previewLayer];
    //开始启动
    [self startSession];
    // 访问设备的硬件性能。
    if ([_device lockForConfiguration:nil]) {
        // 设置闪光灯模式
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
         //关闭访问设备的硬件性能
        [_device unlockForConfiguration];
    }
}

// 设置闪光灯
- (void)FlashOnBtnIndenx:(NSInteger)BtnIndex{
    
    if ([_device lockForConfiguration:nil]) {
        if (BtnIndex == 2) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
            }
        }else if (BtnIndex == 1){
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
            }
        }else if (BtnIndex == 0){
            
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
        }
        
        [_device unlockForConfiguration];
    }
}
// 前后置摄像头的切换
- (void)changeCamera{
    
    // 获取摄像头的个数
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        //给摄像头的切换添加翻转动画
        CATransition *animation = [CATransition animation];
        
        //定义个转场动画
        animation.duration = .5f;
        //计时函数，从头到尾的流畅度
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //转场动画类型
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //拿到另外一个摄像头位置
        AVCaptureDevicePosition position = [[_input device] position];
        
        if (position == AVCaptureDevicePositionFront){
            //  转换后置摄像头
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            //转场动画将去的方向
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            //  转换前置摄像头
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        // 设置新的输入
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        // 替换原来的输入设备
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
             [SVProgressHUD showErrorWithStatus:ERROR(error).domain];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            NSLog(@"toggle carema failed, error = %@",ERROR(error));
        }
    }
}

// 获取当前想要的硬件设备：如摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
#pragma mark - 截取照片
- (void) shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        // 拍照失败
        [SVProgressHUD showErrorWithStatus:@"Photo failure!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        // 把二进制图片装换成 image格式
        self.image = [UIImage imageWithData:imageData];
        NSLog(@"===截取的图片===%f=%f====",self.image.size.width,self.image.size.height);
        self.imageData = imageData;
        // 拍照停止运行
        [self stopSession];
        self.imageView = [[UIImageView alloc]initWithFrame:self.previewView.frame];
        self.imageView.image = self.image;
        // 把截取的图片插入拍照按钮的下方
        [self.view insertSubview:self.imageView atIndex:2];
        self.imageView.layer.masksToBounds = YES;
        [WINDOW addSubview:self.saveAndCancelVi];
       // [MMXJSINGLE alertView:@"是否保存图片到相册?" andMesgeTwo:@"" parentVC:self delegate:self];
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
    }];
}
- (void)SaveAndCancelView:(SaveAndCancelView *)view btn:(UIButton *)sender {
    [self.saveAndCancelVi removeFromSuperview];
    if (sender.tag == 10) {
     // 取消
     [self cancle];
    }else {
     // 保存
        CGSize size = CGSizeMake(self.imageView.AJZJ_width * [UIScreen mainScreen].scale * 2, self.imageView.AJZJ_height * [UIScreen mainScreen].scale * 2);
        NSLog(@"===截取的真实宽高===                                   %f=%f====",size.width,size.height);
        [self saveImageToPhotoAlbum:[UIImage imageCompressForSize:self.image targetSize:size]];
        self.bottomView.image = [UIImage imageCompressForSize:self.image targetSize:size];
        [self.imageView removeFromSuperview];
   }
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    [SVProgressHUD showWithStatus:@""];
    dispatch_async(self.captureQueue, ^{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        [SVProgressHUD dismiss];
   });
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [SVProgressHUD showErrorWithStatus:@"Failed to save picture!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [self cancle];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"Save picture successfully!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        [self cancle];
    }
}
- (void)startSession
{
    dispatch_async(self.captureQueue, ^{
        if (![self.session isRunning]) {
            [self.session startRunning];
        }
    });
}


- (void)stopSession
{
    dispatch_async(self.captureQueue, ^{
        if ([self.session isRunning]) {
            [self.session stopRunning];
        }

    });
}

// 取消保存图片
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self startSession];
}
// 获取最新的一张图片
- (void)getLatestPhotoBottomView:(BottomView*)bottomView {
    dispatch_queue_t  myQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myQueue1, ^{
    // 获取相机相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    if (collections.count < 1) {
        return ;
    }
    PHFetchResult *assets= [PHAsset fetchAssetsInAssetCollection:collections.firstObject options:[[PHFetchOptions alloc]init]];
    //对上述result对象根据下标取的PHAsset对象,取出PHAsset中的image对象
    //All Photos
    // 选择图片时的配置项
    if (assets.count < 1) {
        return;
        
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //NSLog(@"==PHFetchResult=====%ld========",assets.count);
    PHAsset *asset = assets.lastObject;
    //pixelWidth 像素宽度 = [UIScreen mainScreen].scale * 点
    CGSize size = CGSizeMake(asset.pixelWidth / [UIScreen mainScreen].scale, asset.pixelHeight / [UIScreen mainScreen].scale);
     dispatch_async(dispatch_get_main_queue(), ^{
    // 请求图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        bottomView.image = result;
        return ;
    }];
    });
    });
}
//- (void)dealloc
//{
//    dispatch_async(self.captureQueue, ^{
//        if ([self.session isRunning]) {
//            [self.session stopRunning];
//            NSLog(@"相机销毁");
//        }
//    });
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
