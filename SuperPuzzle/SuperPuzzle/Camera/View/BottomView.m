//
//  BottomView.m
//  美萌相机
//
//  Created by zuokai on 2017/4/3.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import "BottomView.h"
#import "ScreenWidthBtn.h"
@interface BottomView()

@property (strong, nonatomic) IBOutletCollection(ScreenWidthBtn) NSArray *SceenWidthBtns;
@end

@implementation BottomView

-(void)setImage:(UIImage *)image {
    _image = image;
    CGSize size = CGSizeMake(self.photoAlbumBtn.AJZJ_width * [UIScreen mainScreen].scale * 2, self.photoAlbumBtn.AJZJ_height * [UIScreen mainScreen].scale * 2);
    [self.photoAlbumBtn setImage:[UIImage imageCompressForSize:self.image targetSize:size] forState:UIControlStateNormal];
}


+ (instancetype)BottomView
{
  return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)bottomBtn:(id)sender {
    // 代理方法二
    [self.delegate BottomView:self btn:sender];
}

// 屏幕宽比
- (IBAction)screenBtnCliked:(id)sender {
    UIButton *button = sender;
    for (UIButton *btn in self.SceenWidthBtns) {
        if (btn.tag == button.tag) {
            btn.selected = YES;
        }else {
            btn.selected = NO;
        }
    }
    // 代理方法三
    [self.delegate BottomView:self screenBtn:sender];
}


@end
