//
//  UIView+AJZJFrame.h
//  爱建证券
//
//  Created by zuokai on 2016/11/24.
//  Copyright © 2016年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AJZJFrame)
@property CGFloat AJZJ_width;
@property CGFloat AJZJ_height;
@property CGFloat AJZJ_x;
@property CGFloat AJZJ_y;
@property CGFloat AJZJ_centerX;
@property CGFloat AJZJ_centerY;
+ (instancetype)AJZJ_viewFromXib;
@end
