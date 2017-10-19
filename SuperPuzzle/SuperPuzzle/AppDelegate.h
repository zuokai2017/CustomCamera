//
//  AppDelegate.h
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/10.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAddPreView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ImageAddPreView  *preview;

- (void)showPreView;
- (void)hiddenPreView;

@end

