//
//  DrawMainViewController.m
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/9.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import "DrawMainViewController.h"
#import "UIView+WHB.h"
#import "HBDrawingBoard.h"
#import "MJExtension.h"
#import "DarwTitleView.h"

@interface DrawMainViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawingBoardDelegate,DarwTitleViewDelegate>
@property (nonatomic, strong) HBDrawingBoard *drawView;
@property (nonatomic, strong) DarwTitleView *darwTitleVi;
@end

@implementation DrawMainViewController

- (DarwTitleView*)darwTitleVi {
    if (!_darwTitleVi) {
        _darwTitleVi = [[DarwTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _darwTitleVi.delegate = self;
    }
    return _darwTitleVi;
}

- (void)darwTitleView:(DarwTitleView *)view btn:(UIButton *)btn {
    if (btn.tag == 22) {
        // 存储图片
        // self.drawView.isSave = YES;
        //初始化警告框
        if (self.drawView.paths.count < 1) {
            
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
        }
        UIAlertController*alert = [UIAlertController
                                   alertControllerWithTitle: @"Whether to save the pictures before you leave?"
                                   message: @"YES / NO ?"
                                   preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"YES"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            self.drawView.isSave = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"NO"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
       self.drawView.isSave = NO;
       [self dismissViewControllerAnimated:YES completion:nil];
       }]];
        //弹出提示框
        [self presentViewController:alert
                           animated:YES completion:nil];
    }else {
        
    self.drawView.shapType = btn.tag;
    [self.drawView showSettingBoard];
        
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNav];
    [self.view addSubview:self.drawView];
    
}

- (void)setNav {
    [self.navigationController.navigationBar addSubview:self.darwTitleVi];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self darwTitleView:nil btn:nil];
}

//- (IBAction)drawSetting:(id)sender {
//    
//    self.drawView.shapType = ((UIButton *)sender).tag;
//    
//    [self.drawView showSettingBoard];
//}

#pragma mark - <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 显示选择的图片
    self.drawView.backImage.image = info[UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
}

// 打开相机还是相册
#pragma mark - HBDrawingBoardDelegate
- (void)drawBoard:(HBDrawingBoard *)drawView action:(actionOpen)action{
    
    switch (action) {
            case actionOpenAlbum:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            
            break;
            case actionOpenCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
                
                pickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickVc.delegate = self;
                [self presentViewController:pickVc animated:YES completion:nil];
                
            }else{
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"warning" message:@"You don't have a camera" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)drawBoard:(HBDrawingBoard *)drawView drawingStatus:(HBDrawingStatus)drawingStatus model:(HBDrawModel *)model{
    
    NSLog(@"%@",model.keyValues);
}
- (HBDrawingBoard *)drawView
{
    if (!_drawView) {
        _drawView = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0,64, self.view.width, self.view.height - 64)];
        _drawView.delegate = self;
        
    }
    return _drawView;
}


@end
