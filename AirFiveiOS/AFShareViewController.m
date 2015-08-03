//
//  AFShareViewController.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/3/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFShareViewController.h"
#import "AFCardViewController.h"
#import "AFEmailManager.h"
#import "UIColor+AirFive.h"
#import "UIFont+AirFive.h"

@interface AFShareViewController()

@property (strong, nonatomic) AFCardViewController *cardViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;
@property (strong, nonatomic) NSString *recipientEmailAddress;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation AFShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpShareView];
    [self setUpTextFontsAndColors];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [self deregisterFromKeyboardNotifications];
}

#pragma mark - Background View

- (void)setUpBackground
{
    self.view.backgroundColor = [UIColor airFiveBlue];
}

#pragma mark - Card View Controller

- (void)setCardViewController:(AFCardViewController *)cardViewController
{
    _cardViewController = cardViewController;
    [_cardViewController loadCard];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Embed Card View"]){
        if([segue.destinationViewController isKindOfClass:[AFCardViewController class]]){
            self.cardViewController = segue.destinationViewController;
        }
    }
}

#pragma mark - Share View

- (void)setUpShareView
{
    self.shareView.layer.cornerRadius = 7.0;
    self.shareView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shareView.layer.shadowOffset = CGSizeMake(0, 0);
    self.shareView.layer.shadowOpacity = 0.20;
    self.shareView.layer.shadowRadius = 3.0;
    [self setUpShareButton];
}

- (void)setUpTextFontsAndColors
{
    self.recipientEmailTextField.textColor = [UIColor blackColor];
    self.recipientEmailTextField.font = [UIFont airFiveFontMediumWithSize:16.0];
    self.recipientEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.recipientEmailTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.recipientEmailTextField.font}];
    
    [self.shareButton.titleLabel setFont:[UIFont airFiveFontMediumWithSize:16.0]];
    
}

- (void)setUpShareButton
{
    self.shareButton.layer.cornerRadius = 0.0;
    self.shareButton.backgroundColor = [UIColor airFiveRed];
}

- (IBAction)shareButtonTouched:(UIButton *)sender
{
    [AFEmailManager sharedInstance].firstName = self.cardViewController.firstName;
    [AFEmailManager sharedInstance].lastName = self.cardViewController.lastName;
    [AFEmailManager sharedInstance].position = self.cardViewController.position;
    [AFEmailManager sharedInstance].organization = self.cardViewController.organization;
    [AFEmailManager sharedInstance].industry = self.cardViewController.industry;
    [AFEmailManager sharedInstance].emailAddress = self.cardViewController.emailAddress;
    [AFEmailManager sharedInstance].phone = self.cardViewController.phone;
    [AFEmailManager sharedInstance].website = self.cardViewController.website;
    [AFEmailManager sharedInstance].recipientEmailAddress = self.recipientEmailAddress;;
    [[AFEmailManager sharedInstance] sendEmail];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self setUpTextFontsAndColors];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.recipientEmailTextField){
        self.recipientEmailAddress = text;
    }
    return YES;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
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

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.logoVerticalConstraint.constant = 40;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
