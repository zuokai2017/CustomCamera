//
//  BottomView.h
//  美萌相机
//
//  Created by zuokai on 2017/4/3.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScreenWidthBtn;
////声明一个Block类型的别名
//typedef void(^photoDataCallBack)(id obj);

@protocol BottomViewDelegate <NSObject>
@optional
// 其他模式下面View按钮点击事件
- (void)BottomView:(UIView *)view btn:(UIButton*)btn;
@optional
// 其他模式下点击屏幕宽比要执行的方法
- (void)BottomView:(UIView *)view screenBtn:(UIButton*)btn;

@end

@interface BottomView : UIView
@property(assign, nonatomic) id<BottomViewDelegate>delegate;
@property(nonatomic,strong)UIImage *image;
@property (weak, nonatomic) IBOutlet UIButton *comPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *photoAlbumBtn;
+ (instancetype)BottomView;

@end
