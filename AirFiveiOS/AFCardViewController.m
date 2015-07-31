//
//  AFCardViewController.m
//  AirFiveiOS
//
//  Created by Jeremy Redman on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFCardViewController.h"
#import "AFEmailManager.h"

@interface AFCardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionAndOrgTextField;
@property (weak, nonatomic) IBOutlet UITextField *industryTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;

@end

@implementation AFCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fullName = @"Jeremy Redman";
    self.position = @"Founder & CEO";
    self.organization = @"AirFive";
    self.industry = @"Entrepreneur";
    self.emailAddress = @"Jeremy@airfive.com";
    self.website = @"airfive.com";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCard];
}

- (void)loadCard
{
    self.fullNameTextField.text = self.fullName;
    self.positionAndOrgTextField.text = [NSString stringWithFormat:@"%@, %@", self.position, self.organization];
    self.industryTextField.text = self.industry;
    self.emailTextField.text = self.emailAddress;
    self.websiteTextField.text = self.website;
}

- (IBAction)shareButtonTouched:(UIButton *)sender
{
    [AFEmailManager sharedInstance].fullName = self.fullName;
    [AFEmailManager sharedInstance].position = self.position;
    [AFEmailManager sharedInstance].organization = self.organization;
    [AFEmailManager sharedInstance].industry = self.industry;
    [AFEmailManager sharedInstance].emailAddress = self.emailAddress;
    [AFEmailManager sharedInstance].website = self.website;
    [[AFEmailManager sharedInstance] sendEmail];
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.fullNameTextField){
        self.fullName = self.fullNameTextField.text;
    }
    else if(textField == self.positionAndOrgTextField){
        self.position = self.positionAndOrgTextField.text; //Will need to get self.organization property eventually
    }
    else if(textField == self.industryTextField){
        self.industry = self.industryTextField.text;
    }
    else if(textField == self.emailTextField){
        self.emailAddress = self.emailTextField.text;
    }
    else if(textField == self.websiteTextField){
        self.website = self.websiteTextField.text;
    }
    return YES;
}

@end
