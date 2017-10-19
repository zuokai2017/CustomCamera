//
//  AJZJAlertViewController.m
//  美萌相机
//
//  Created by zuokai on 2017/4/4.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import "MexjAlertViewController.h"

@interface MexjAlertViewController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *textOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *TextTwoLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@end

@implementation MexjAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5];
    self.textOneLabel.text = self.alertOneText;
    self.TextTwoLabel.text = self.alertTwoText;
}
-(void)viewDidLayoutSubviews {
    
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 10.0 / 2;
    self.yesBtn.layer.masksToBounds = YES;
    self.yesBtn.layer.cornerRadius = 5.0 / 2;
    self.noBtn.layer.masksToBounds = YES;
    self.noBtn.layer.cornerRadius = 5.0 / 2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - 点击按钮执行相应的代理方法

- (IBAction)btnClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewController:Btn:alertText:)]) {
    [self.delegate alertViewController:self Btn:sender alertText:self.alertOneText];
    }
}



@end
