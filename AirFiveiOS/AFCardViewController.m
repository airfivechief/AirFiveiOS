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
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;

@property (strong, nonatomic) NSString *recipientEmailAddress;
@property (weak, nonatomic) UITextField *selectedTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;

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
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [self deregisterFromKeyboardNotifications];
}

- (void)loadCard
{
    self.fullNameTextField.text = self.fullName;
    self.positionAndOrgTextField.text = [NSString stringWithFormat:@"%@, %@", self.position, self.organization];
    self.industryTextField.text = self.industry;
    self.emailTextField.text = self.emailAddress;
    self.phoneTextField.text = self.phone;
    self.websiteTextField.text = self.website;
    
}

- (IBAction)shareButtonTouched:(UIButton *)sender
{
    [AFEmailManager sharedInstance].firstName = self.fullName;
    [AFEmailManager sharedInstance].lastName = self.fullName;
    [AFEmailManager sharedInstance].position = self.position;
    [AFEmailManager sharedInstance].organization = self.organization;
    [AFEmailManager sharedInstance].industry = self.industry;
    [AFEmailManager sharedInstance].emailAddress = self.emailAddress;
    [AFEmailManager sharedInstance].phone = self.phone;
    [AFEmailManager sharedInstance].website = self.website;
    [AFEmailManager sharedInstance].recipientEmailAddress = self.recipientEmailAddress;;
    [[AFEmailManager sharedInstance] sendEmail];
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.selectedTextField = textField;
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.fullNameTextField){
        self.fullName = text;
    }
    else if(textField == self.positionAndOrgTextField){
        self.position = text; //Will need to get self.organization property eventually
    }
    else if(textField == self.industryTextField){
        self.industry = text;
    }
    else if(textField == self.emailTextField){
        self.emailAddress = text;
    }
    else if(textField == self.phoneTextField){
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:text deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:text deleteLastChar:NO ];
        }
        self.phone = textField.text;
        return NO;
    }
    else if(textField == self.websiteTextField){
        self.website = text;
    }
    else if(textField == self.recipientEmailTextField){
        self.recipientEmailAddress = text;
    }
    return YES;
}

//http://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
-(NSString*) formatPhoneNumber:(NSString*) simpleNumber deleteLastChar:(BOOL)deleteLastChar {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //int keyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
    //self.logoVerticalConstraint.constant = 40 - keyboardHeight;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    //self.logoVerticalConstraint.constant = 40;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
@end
