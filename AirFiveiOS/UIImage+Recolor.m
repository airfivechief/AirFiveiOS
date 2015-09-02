//
//  UIImage+Recolor.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 9/2/15.
//  Copyright © 2015 AirFive. All rights reserved.
//

#import "UIImage+Recolor.h"

@implementation UIImage (Recolor)

- (UIImage *)recoloredWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, self.size.width, self.size.height));
    
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return coloredImg;
}

@end
