//
//  UIImage+ImageColor.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/10.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "UIImage+ImageColor.h"

@implementation UIImage (ImageColor)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
