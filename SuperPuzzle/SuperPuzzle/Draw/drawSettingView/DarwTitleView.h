//
//  DarwTitleView.h
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/10.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DarwTitleView;

@protocol DarwTitleViewDelegate <NSObject>
- (void)darwTitleView:(DarwTitleView*)view btn:(UIButton*)btn;
@end
@interface DarwTitleView : UIView

@property (nonatomic,assign)id<DarwTitleViewDelegate> delegate;

@end
