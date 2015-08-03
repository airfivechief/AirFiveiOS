//
//  AFCardViewController.h
//  AirFiveiOS
//
//  Created by Jeremy Redman on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFCard;

@interface AFCardViewController : UIViewController

@property (strong, nonatomic) AFCard *card;

- (void)loadCard;

@end

