//
//  UIView+AJZJFrame.m
//  爱建证券
//
//  Created by zuokai on 2016/11/24.
//  Copyright © 2016年 zuokai. All rights reserved.
//

#import "UIView+AJZJFrame.h"

@implementation UIView (AJZJFrame)
+ (instancetype)AJZJ_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setAJZJ_height:(CGFloat)AJZJ_height
{
    CGRect rect = self.frame;
    rect.size.height = AJZJ_height;
    self.frame = rect;
}

- (CGFloat)AJZJ_height
{
    return self.frame.size.height;
}

- (CGFloat)AJZJ_width
{
    return self.frame.size.width;
}
- (void)setAJZJ_width:(CGFloat)AJZJ_width
{
    CGRect rect = self.frame;
    rect.size.width = AJZJ_width;
    self.frame = rect;
}

- (CGFloat)AJZJ_x
{
    return self.frame.origin.x;
    
}

- (void)setAJZJ_x:(CGFloat)AJZJ_x
{
    CGRect rect = self.frame;
    rect.origin.x = AJZJ_x;
    self.frame = rect;
}

- (void)setAJZJ_y:(CGFloat)AJZJ_y
{
    CGRect rect = self.frame;
    rect.origin.y = AJZJ_y;
    self.frame = rect;
}

- (CGFloat)AJZJ_y
{
    
    return self.frame.origin.y;
}

- (void)setAJZJ_centerX:(CGFloat)AJZJ_centerX
{
    CGPoint center = self.center;
    center.x = AJZJ_centerX;
    self.center = center;
}

- (CGFloat)AJZJ_centerX
{
    return self.center.x;
}

- (void)setAJZJ_centerY:(CGFloat)AJZJ_centerY
{
    CGPoint center = self.center;
    center.y = AJZJ_centerY;
    self.center = center;
}

- (CGFloat)AJZJ_centerY
{
    return self.center.y;
}

@end
