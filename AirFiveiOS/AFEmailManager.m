//
//  AFEmailManager.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFEmailManager.h"

@implementation AFEmailManager

+ (instancetype)sharedInstance
{
    static AFEmailManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
