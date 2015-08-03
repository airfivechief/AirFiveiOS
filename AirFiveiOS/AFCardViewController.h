//
//  AFCardViewController.h
//  AirFiveiOS
//
//  Created by Jeremy Redman on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCardViewController : UIViewController

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *emailAddress;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *website;

- (void)loadCard;

@end

