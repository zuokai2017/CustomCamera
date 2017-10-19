//
//  TitleView.h
//  美萌相机
//
//  Created by zuokai on 2017/4/1.
//  Copyright © 2017年 zsx. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明一个Block类型的别名
typedef void(^imgNameCallBack)(id obj);


@protocol TitleViewDelegate <NSObject>
@optional
- (void)TitleView:(UIView *)view btn:(UIButton*)btn;
@end
@interface TitleView : UIView

@property(assign, nonatomic) id<TitleViewDelegate>delegate;

// 默认标题
+ (instancetype)TitleView;
// 闪光灯
+ (instancetype)FlashView;
// 定时器
+ (instancetype)TimeView;

//声明block方法
- (void) settingBtnWithImgBtnTag:(NSInteger)btnTag imgCallBack:(imgNameCallBack)callback;

@end
