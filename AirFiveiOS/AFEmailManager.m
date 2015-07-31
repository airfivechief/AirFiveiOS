//
//  AFEmailManager.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFEmailManager.h"

@interface AFEmailManager()

@property (strong, nonatomic) NSArray *requiredFields;

@end

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
        [self loadRequiredFields];
    }
    return self;
}

- (void)loadRequiredFields
{
    self.requiredFields = @[@"fullName",@"phone"];
}

- (void)sendEmail
{
    if(![self emailAddressIsValid:self.emailAddress]){ //Failure - Invalid Email Address
        
    }
    else if(![self hasRequiredFields]){ //Failure - Does not have all required fields
        
    }
    else{
        [self formHTMLEmail];
    }
}

- (bool)emailAddressIsValid: (NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (bool)hasRequiredFields
{
    for(NSString *field in self.requiredFields){
        if(![self valueForKey:field]||[[[self valueForKey:field] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

- (void)formHTMLEmail
{
    
}

@end
