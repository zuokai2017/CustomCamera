//
//  UIImage+Image_MEXJ.h
//  美萌相机
//
//  Created by zuokai on 2017/4/9.
//  Copyright © 2017年 cn.steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image_MEXJ)
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

+  (CGSize)imageCompressForWidth:(UIImage *)sourceImage orangeSize:(CGSize)size andScleSize:(CGSize)scleSize;
+  (UIImage *)captureImageFromViewLow:(UIView *)orgView Scale:(CGFloat)scale;
@end
