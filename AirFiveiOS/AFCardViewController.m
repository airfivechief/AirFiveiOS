//
//  AFCardViewController.m
//  AirFiveiOS
//
//  Created by Jeremy Redman on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFCardViewController.h"
#import "AFEmailManager.h"
#import "UIColor+AirFive.h"
#import "UIFont+AirFive.h"

@interface AFCardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;
@property (weak, nonatomic) UITextField *selectedTextField;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionAndOrgTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *organizationTextField;
@property (weak, nonatomic) IBOutlet UITextField *industryTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;
@property (weak, nonatomic) IBOutlet UIView *dividerViewTop;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) NSString *recipientEmailAddress;


@end

@implementation AFCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpCardView];
    [self setUpShareView];
    [self setUpTextFontsAndColors];
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
    self.firstNameTextField.text = self.firstName;
    self.lastNameTextField.text = self.lastName;
    [self updateFullNameTextField];
    self.positionTextField.text = self.position;
    self.organizationTextField.text = self.organization;
    [self updatePositionAndOrgTextField];
    self.industryTextField.text = self.industry;
    self.emailTextField.text = self.emailAddress;
    self.phoneTextField.text = self.phone;
    self.websiteTextField.text = self.website;
}

- (IBAction)shareButtonTouched:(UIButton *)sender
{
    [AFEmailManager sharedInstance].firstName = self.firstName;
    [AFEmailManager sharedInstance].lastName = self.lastName;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.positionTextField || textField == self.organizationTextField){
        self.positionTextField.textColor = self.positionAndOrgTextField.textColor;
        self.positionTextField.font = self.positionAndOrgTextField.font;
        self.positionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.positionAndOrgTextField.font}];
        
        self.organizationTextField.textColor = self.positionAndOrgTextField.textColor;
        self.organizationTextField.font = self.positionAndOrgTextField.font;
        self.organizationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.organizationTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.positionAndOrgTextField.font}];
        
        self.positionAndOrgTextField.textColor = [UIColor clearColor];
        self.positionAndOrgTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionAndOrgTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.positionAndOrgTextField.font}];
    }
    else if(textField == self.firstNameTextField || textField == self.lastNameTextField){
        self.firstNameTextField.textColor = self.fullNameTextField.textColor;
        self.firstNameTextField.font = self.fullNameTextField.font;
        self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.fullNameTextField.font}];
        
        self.lastNameTextField.textColor = self.fullNameTextField.textColor;
        self.lastNameTextField.font = self.fullNameTextField.font;
        self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.fullNameTextField.font}];
        
        self.fullNameTextField.textColor = [UIColor clearColor];
        self.fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.fullNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.fullNameTextField.font}];
    }
    else{
        [self setUpTextFontsAndColors];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setUpTextFontsAndColors];
    [self updateFullNameTextField];
    [self updatePositionAndOrgTextField];
}

- (void)updatePositionAndOrgTextField
{
    NSMutableString *mutableText = [[NSMutableString alloc] init];
    if(self.positionTextField.text && [self.positionTextField.text length]){
        [mutableText appendString:self.positionTextField.text];
        if(self.organizationTextField.text && [self.organizationTextField.text length]){
            [mutableText appendString:@", "];
        }
    }
    if(self.organizationTextField.text && [self.organizationTextField.text length]){
        [mutableText appendString:self.organizationTextField.text];
    }
    self.positionAndOrgTextField.text = [mutableText copy];
}

- (void)updateFullNameTextField
{
    NSMutableString *mutableText = [[NSMutableString alloc] init];
    if(self.firstNameTextField.text && [self.firstNameTextField.text length]){
        [mutableText appendString:self.firstNameTextField.text];
        if(self.lastNameTextField.text && [self.lastNameTextField.text length]){
            [mutableText appendString:@" "];
        }
    }
    if(self.lastNameTextField.text && [self.lastNameTextField.text length]){
        [mutableText appendString:self.lastNameTextField.text];
    }
    self.fullNameTextField.text = [mutableText copy];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.selectedTextField = textField;
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.fullNameTextField){
        //Do nothing
    }
    else if(textField == self.firstNameTextField){
        self.firstName = text;
    }
    else if(textField == self.lastNameTextField){
        self.lastName = text;
    }
    else if(textField == self.positionAndOrgTextField){
       // Do nothing
    }
    else if(textField == self.positionTextField){
        self.position = text;
    }
    else if(textField == self.organizationTextField){
        self.organization = text;
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
    self.logoVerticalConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.logoVerticalConstraint.constant = 40;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

#pragma mark - Set Up View

- (void)setUpBackground
{
    self.view.backgroundColor = [UIColor airFiveBlue];
}

- (void)setUpCardView
{
    self.cardView.layer.cornerRadius = 7.0;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cardView.layer.shadowOpacity = 0.20;
    self.cardView.layer.shadowRadius = 3.0;
    [self setUpCardImageView];
    [self setUpInfoView];
}

- (void)setUpCardImageView
{
    self.cardImageView.layer.cornerRadius = self.cardImageView.frame.size.width/2.0;
    self.cardImageView.backgroundColor = [UIColor airFiveLightGray];
}

- (void)setUpInfoView
{
    self.infoView.layer.cornerRadius = 7.0;
    self.infoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.infoView.layer.shadowOffset = CGSizeMake(0, 0);
    self.infoView.layer.shadowOpacity = 0.20;
    self.infoView.layer.shadowRadius = 3.0;
    [self setUpDividers];
}

- (void)setUpShareView
{
    self.shareView.layer.cornerRadius = 7.0;
    self.shareView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shareView.layer.shadowOffset = CGSizeMake(0, 0);
    self.shareView.layer.shadowOpacity = 0.20;
    self.shareView.layer.shadowRadius = 3.0;
    [self setUpShareButton];
}

- (void)setUpShareButton
{
    self.shareButton.layer.cornerRadius = 0.0;
}

- (void)setUpDividers
{
    self.dividerViewTop.backgroundColor = [UIColor airFiveLightGray];
}

- (void)setUpTextFontsAndColors
{
    self.fullNameTextField.font = [UIFont airFiveFontMediumWithSize:25.0];
    self.fullNameTextField.textColor = [UIColor airFiveBlue];
    self.fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.fullNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.fullNameTextField.font}];
    
    self.firstNameTextField.textColor = [UIColor clearColor];
    self.firstNameTextField.attributedPlaceholder = self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.fullNameTextField.font}];
    
    self.lastNameTextField.textColor = [UIColor clearColor];
    self.lastNameTextField.attributedPlaceholder = self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.fullNameTextField.font}];
    
    self.positionAndOrgTextField.textColor = [UIColor airFiveGray];
    self.positionAndOrgTextField.font = [UIFont airFiveFontItalicWithSize:13.0];
    self.positionAndOrgTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionAndOrgTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    self.positionTextField.textColor = [UIColor clearColor];
    self.positionTextField.attributedPlaceholder = self.positionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    self.organizationTextField.textColor = [UIColor clearColor];
    self.organizationTextField.attributedPlaceholder = self.organizationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.organizationTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    self.industryTextField.textColor = [UIColor airFiveBlue];
    self.industryTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.industryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.industryTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.industryTextField.font}];
    
    self.emailTextField.textColor = [UIColor airFiveBlue];
    self.emailTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.emailTextField.font}];
    
    self.phoneTextField.textColor = [UIColor airFiveBlue];
    self.phoneTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.phoneTextField.font}];
    
    self.websiteTextField.textColor = [UIColor airFiveBlue];
    self.websiteTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.websiteTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.websiteTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.websiteTextField.font}];
    
    self.recipientEmailTextField.textColor = [UIColor blackColor];
    self.recipientEmailTextField.font = [UIFont airFiveFontMediumWithSize:16.0];
    self.recipientEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.recipientEmailTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.recipientEmailTextField.font}];
    
    [self.shareButton.titleLabel setFont:[UIFont airFiveFontMediumWithSize:16.0]];
}


@end
