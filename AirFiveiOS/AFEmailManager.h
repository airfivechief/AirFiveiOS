//
//  AFEmailManager.h
//  AirFiveiOS
//
//  Created by Joshua Gafni on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFEmailManager : NSObject

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *position;
@property (copy, nonatomic) NSString *organization;
@property (copy, nonatomic) NSString *industry;
@property (copy, nonatomic) NSString *emailAddress;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *website;
@property (copy, nonatomic) NSString *recipientEmailAddress;

+ (instancetype)sharedInstance;

- (bool)hasRequiredFields;
- (void)sendEmail; //Later, add completion block with success and failure

@end
