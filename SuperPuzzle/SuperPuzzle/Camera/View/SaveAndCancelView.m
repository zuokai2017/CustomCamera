//
//  SaveAndCancelView.m
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/8.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import "SaveAndCancelView.h"

@interface SaveAndCancelView()

@end
@implementation SaveAndCancelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return self;
}
- (IBAction)btnClicke:(id)sender {
    if ([self.delegate respondsToSelector:@selector(SaveAndCancelView:btn:)]) {
        [self.delegate SaveAndCancelView:self btn:sender];
    }
}


@end
