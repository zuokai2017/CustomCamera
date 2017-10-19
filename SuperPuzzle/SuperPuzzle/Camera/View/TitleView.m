//
//  TitleView.m
//  美萌相机
//
//  Created by zuokai on 2017/4/1.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import "TitleView.h"

@interface TitleView ()
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *timerBtn;
// 闪光灯
@property (nonatomic, assign)NSInteger flashIndex;
@property (nonatomic,strong)NSArray *flashImgsArr;

// 定时器
@property (nonatomic, assign)NSInteger timeIndex;
@property (nonatomic,strong)NSArray *timeImgsArr;

@end
@implementation TitleView

- (void) settingBtnWithImgBtnTag:(NSInteger)btnTag imgCallBack:(imgNameCallBack)callback{
    NSLog(@"====btnTag==%ld=======",(long)btnTag);
    if (btnTag/10  == 2) {
        self.flashIndex = btnTag % 20;
    } else if(btnTag/10 == 3) {
        self.timeIndex = btnTag % 30;
    }
    [self layoutSubviews];
}
- (void)awakeFromNib {
    
  [super awakeFromNib];
  self.flashImgsArr = @[@"闪光灯",@"闪光灯_打开",@"闪光灯_关闭"];
  self.timeImgsArr = @[@"定时",@"定时_3秒",@"定时_6秒",@"定时_9秒"];
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    [self.flashBtn setImage:[UIImage imageNamed:self.flashImgsArr[self.flashIndex]] forState:UIControlStateNormal];
    [self.timerBtn setImage:[UIImage imageNamed:self.timeImgsArr[self.timeIndex]] forState:UIControlStateNormal];
}
+ (instancetype)TitleView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+ (instancetype)FlashView {
   return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] [1];
}
+ (instancetype)TimeView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] [2];
}
- (IBAction)BtnClicked:(id)sender {
    
    [self.delegate TitleView:self btn:sender];
}



@end
