//
//  UIColor+Hex.h
//  爱建证券
//
//  Created by zuokai on 2016/11/20.
//  Copyright © 2016年 zuokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexOne)
// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
