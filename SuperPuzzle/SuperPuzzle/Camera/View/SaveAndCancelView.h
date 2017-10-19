//
//  SaveAndCancelView.h
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/8.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SaveAndCancelView;

@protocol SaveAndCancelViewDelegate <NSObject>
- (void)SaveAndCancelView:(SaveAndCancelView*)view btn:(UIButton*)sender;
@end


@interface SaveAndCancelView : UIView

/* 代理 */
@property (nonatomic,assign) id<SaveAndCancelViewDelegate>delegate;

@end
