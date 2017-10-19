//
//  ImgDetailViewController.m
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/9.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import "ImgDetailViewController.h"
#import "UIColor+HexOne.h"

@interface ImgDetailViewController ()
/**图片 */
@property (nonatomic,strong)UIImageView *currentImageVi;
@end

@implementation ImgDetailViewController

- (UIImageView*)currentImageVi {
    if (_currentImageVi == nil) {
        _currentImageVi = [[UIImageView alloc]init];
        [self.view addSubview:_currentImageVi];
    }
    return _currentImageVi;
}
- (void)setCurrentImage:(UIImage *)currentImage {
    _currentImage = currentImage;
    CGSize size = [UIImage imageCompressForWidth:currentImage orangeSize:currentImage.size andScleSize:CGSizeMake(kScreenWidth, kScreenHeight - 64)];
    CGFloat imVIW = size.width;
    CGFloat imVIH = size.height;
    self.currentImageVi.frame = CGRectMake((kScreenWidth - imVIW)/2, 64 + (self.view.AJZJ_height - 64 - imVIH - 1)/2,imVIW,imVIH);
    self.currentImageVi.image = currentImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e5e1e1"];
    [self setNav];
}
// 设置导航栏
- (void)setNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_btn_black"] highImage:[UIImage imageNamed:@"nav_btn_black"] target:self action:@selector(back)];
    self.title = @"pohto";
}
// 返回
- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
