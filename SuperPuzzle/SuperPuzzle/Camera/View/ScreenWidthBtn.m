//
//  ScreenWidthBtn.m
//  美萌相机
//
//  Created by zuokai on 2017/4/9.
//  Copyright © 2017年 cn.steven. All rights reserved.
//

#import "ScreenWidthBtn.h"
#import "UIColor+HexOne.h"
@interface ScreenWidthBtn()

@end

@implementation ScreenWidthBtn

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"#448FEE"]  forState:UIControlStateSelected];
    if (self.tag == 5) {
        self.selected = YES;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{ // 只要重写了这个方法，按钮就无法进入highlighted状态
    
}



@end
