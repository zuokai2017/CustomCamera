//
//  DarwTitleView.m
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/10.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import "DarwTitleView.h"

@implementation DarwTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return self;
}
- (IBAction)sender:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(darwTitleView:btn:)]) {
        [self.delegate darwTitleView:self btn:sender];
    }
    
}


@end
