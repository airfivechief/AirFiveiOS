//
//  UIFont+AirFive.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/1/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "UIFont+AirFive.h"

@implementation UIFont (AirFive)

+ (UIFont *)airFiveFontSlabRegularWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"RobotoSlab-Regular" size:size];
}

+ (UIFont *)airFiveFontMediumWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Roboto-Medium" size:size];
}

+ (UIFont *)airFiveFontItalicWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Roboto-Italic" size:size];
}

@end
