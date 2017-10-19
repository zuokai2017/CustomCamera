//
//  AJZJAlertViewController.h
//  美萌相机
//
//  Created by zuokai on 2017/4/4.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MexjAlertViewControllerDelegate <NSObject>
@optional

- (void)alertViewController:(UIViewController *)alertVC Btn:(UIButton*)btn alertText:(NSString*)alertOneText;
@end

@interface MexjAlertViewController : UIViewController;
///文案
@property(copy, nonatomic) NSString *alertOneText;
@property(copy, nonatomic) NSString *alertTwoText;
//代理属性：
@property(assign, nonatomic) id<MexjAlertViewControllerDelegate>delegate;
@end
