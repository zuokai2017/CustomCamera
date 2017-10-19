//
//  UIBarButtonItem+Item.m
//  爱建证券
//
//  Created by zuokai on 2016/11/15.
//  Copyright © 2016年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
// 快速创建UIBarButtonItem

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

// item返回按钮

+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

// 选中状态下的按钮

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

// 设置item的显示文字

+ (UIBarButtonItem *)setImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

@end
