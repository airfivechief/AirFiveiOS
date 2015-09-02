//
//  AFCard.h
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/3/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFCard : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *linkedInURLString;
@property (strong, nonatomic) NSString *instagramUserNameString;
@property (strong, nonatomic) NSString *facebookUserNameString;
@property (strong, nonatomic) NSString *twitterUserNameString;

@property (strong, nonatomic) NSNumber *linkedInEnabled; //bool value
@property (strong, nonatomic) NSNumber *instagramEnabled; //bool value
@property (strong, nonatomic) NSNumber *facebookEnabled; //bool value
@property (strong, nonatomic) NSNumber *twitterEnabled; //bool value

@end
