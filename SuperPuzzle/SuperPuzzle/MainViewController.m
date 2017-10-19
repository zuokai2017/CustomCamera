//
//  ViewController.m
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/7.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import "MainViewController.h"
#import "MexjAlertViewController.h"
#import "TakingPicturesViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import "DrawMainViewController.h"
#import "AppDelegate.h"
#import "MeituEditStyleViewController.h"
#import "UIColor+Help.h"

@interface MainViewController()<MexjAlertViewControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *drawVIew;

@property (weak, nonatomic) IBOutlet UIView *CameraView;
@property (weak, nonatomic) IBOutlet UIView *PuzzleView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 相机
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    [self.CameraView addGestureRecognizer:cameraTap];
    
    // 画板
    UITapGestureRecognizer *drawTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawClicked:)];
    [self.drawVIew addGestureRecognizer:drawTap];
    
    // 拼图
    UITapGestureRecognizer *puzzleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(puzzleClicked:)];
    [self.PuzzleView addGestureRecognizer:puzzleTap];
    
}

// 拼图
- (void)puzzleClicked:(UITapGestureRecognizer*)sender {
    
    
    [self startPicker];
    
}


//照相
- (void)takePhoto:(UITapGestureRecognizer*)sender {
    if ( [self isCanUserCamear] && [self isCanUsePhotos]){
        TakingPicturesViewController *TPicVC = [[ TakingPicturesViewController alloc]init];
        UINavigationController *TPNav = [[UINavigationController alloc]initWithRootViewController:TPicVC];
        [self presentViewController:TPNav animated:YES completion:nil];
    }else {
        MexjAlertViewController *alertView = STORYBOARDVC(@"TakingPicturesViewController",@"MexjAlertViewController");
        alertView.alertOneText = @"Please open camera/photos permissions";
        alertView.alertTwoText = @"Settings - Privacy - Camera/Photos";
        alertView.delegate = self;
        // 显示一个模态窗口，大小和位置是自定义的，遮罩在原来的页面上
        alertView.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:alertView animated:NO completion:nil];
    }
}
// 画板
- (void)drawClicked:(UITapGestureRecognizer*)sender {
    DrawMainViewController *DrawVc = STORYBOARDVC(@"DrawingMain",@"DrawMainViewController");
    UINavigationController *drawVc = [[UINavigationController alloc] initWithRootViewController:DrawVc];
    [self presentViewController:drawVc animated:YES completion:nil];
}

#pragma mark - 检查相机权限
- (BOOL)isCanUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
- (BOOL)isCanUsePhotos {
    
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
     if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    return YES;
}
-(void)alertViewController:(UIViewController *)alertVC Btn:(UIButton *)btn alertText:(NSString *)alertOneText{
    if (btn.tag == 10) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"Failed to obtain camera permissions!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}


- (void)startPicker
{
    if (_picker == nil) {
        _picker = [[ZYQAssetPickerController alloc] init];
        _picker.maximumNumberOfSelection = 5;
        _picker.assetsFilter = [ALAssetsFilter allPhotos];
        _picker.showEmptyGroups=NO;
        _picker.delegate = self;
    }
    _picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    if (IOS7) {
        _picker.navigationBar.barTintColor = [UIColor colorWithHexString:@"#1fbba6"];
    }else{
        _picker.navigationBar.tintColor = [UIColor colorWithHexString:@"#1fbba6"];
    }
    [D_Main_Appdelegate showPreView];
    _picker.vc =self;
    [self presentViewController:_picker animated:YES completion:NULL];
    [D_Main_Appdelegate preview].delegateSelectImage = self;
    [[D_Main_Appdelegate preview] reMoveAllResource];

}


#pragma mark
#pragma mark ImageAddPreViewDelegate
- (void)startPintuAction:(ImageAddPreView *)sender
{
    if ([sender.imageassets count] >= 2) {
        MeituEditStyleViewController *meituEditVC = [[MeituEditStyleViewController alloc] init];
        meituEditVC.assets = sender.imageassets;
        [_picker pushViewController:meituEditVC animated:YES];
    }else if([sender.imageassets count] == 1){
    }else{
        UIAlertView *imageCountWarningalert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:D_LocalizedCardString(@"card_meitu_max_image_count_less_than_two")
                                                                        delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:D_LocalizedCardString(@"card_meitu_max_image_promptDetermine"), nil];
        [imageCountWarningalert show];
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
