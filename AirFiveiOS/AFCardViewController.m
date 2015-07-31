//
//  AFCardViewController.m
//  AirFiveiOS
//
//  Created by Jeremy Redman on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFCardViewController.h"

@interface AFCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionAndOrgTextField;

@end

@implementation AFCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fullName = @"Jeremy Redman";
    self.position = @"Founder & CEO";
    self.organization = @"AirFive";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fullNameTextField.text = self.fullName;
    self.positionAndOrgTextField.text = [NSString stringWithFormat:@"%@, %@", self.position, self.organization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

@end
