//
//  AFEmailManager.h
//  AirFiveiOS
//
//  Created by Joshua Gafni on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFEmailManager : NSObject

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *website;

+ (instancetype)sharedInstance;

- (void)sendEmail; //Later, add completion block with success and failure

@end
