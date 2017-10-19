//
//  UIImage+Image_MEXJ.m
//  美萌相机
//
//  Created by zuokai on 2017/4/9.
//  Copyright © 2017年 cn.steven. All rights reserved.
//

#import "UIImage+Image_MEXJ.h"

@implementation UIImage (Image_MEXJ)
// 照片等比例压缩
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
       // NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
+  (CGSize)imageCompressForWidth:(UIImage *)sourceImage orangeSize:(CGSize)size andScleSize:(CGSize)scleSize {
    CGFloat orgeW = size.width ;
    CGFloat orgeH = size.height;
    CGFloat scleW = scleSize.width;
    CGFloat scleH = scleSize.height;
    CGFloat scleWW = orgeW/ scleW;
    CGFloat scleHH = orgeH/ scleH;
    //NSLog(@"orgeW    %f,orgeH   %f",orgeW ,orgeH);
    //NSLog(@"scleWW    %f,scleHH   %f",scleWW ,scleHH);
    CGFloat cutRatioType = 1.0;
    if (scleWW <= 1 ) {
        if (scleHH < 1 ) {
            if (scleHH > scleWW) {
                cutRatioType = scleH / orgeH;
            } else {
                 cutRatioType = scleW / orgeW;
            }
        }else if (scleHH >= 1 ) {
            cutRatioType = scleH / orgeH;
        }
    }else if (scleWW > 1){
        if (scleHH <= 1 ) {
            cutRatioType = scleW/ orgeW;
         }else if (scleHH > 1 ) {
             if (scleHH < scleWW) {
                 cutRatioType = scleW/ orgeW;
             }else {
                cutRatioType = scleH/ orgeH;
             }
        }
    }
    CGSize newSize = CGSizeMake(cutRatioType * orgeW, cutRatioType * orgeH);
    return newSize;
}

//指定宽度按比例缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)captureImageFromViewLow:(UIView *)orgView Scale:(CGFloat)scale{
    
//  orgView.transform = CGAffineTransformScale(orgView.transform, 0.5, 0.5);
    //获取指定View的图片
    UIGraphicsBeginImageContextWithOptions(orgView.bounds.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // orgView drawLayer:<#(nonnull CALayer *)#> inContext:<#(nonnull CGContextRef)#>
    
    [orgView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIImage *resultImg = [UIImage imageCompressForSize:image targetSize:size];
    
    UIGraphicsEndImageContext();
    CGFloat ScrenScle =  [UIScreen mainScreen].scale;
    CGImageRef shotRef = image.CGImage;
    CGImageRef ResultRef = CGImageCreateWithImageInRect(shotRef, CGRectMake(0, 0, orgView.bounds.size.width * ScrenScle , orgView.bounds.size.height * ScrenScle ));
    //UIImage * Result = [UIImage imageWithCGImage:ResultRef];
    UIImage * Result = [UIImage imageWithCGImage:ResultRef scale:(2 / scale ) orientation:(UIImageOrientationUp)];
    CGImageRelease(ResultRef);
   
    return  Result;
    //return resultImg;
}
@end
