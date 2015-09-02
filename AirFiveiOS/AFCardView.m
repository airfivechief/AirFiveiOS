//
//  AFCardView.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/4/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//
//  Social Media Icons from https://dribbble.com/shots/1209419-20-Social-Media-Icons-Freebie

#import "AFCardView.h"
#import "UIColor+AirFive.h"
#import "UIFont+AirFive.h"
#import "AFCard.h"

#define LINKED_IN_URL @"https://www.linkedin.com/in/"

typedef NS_ENUM(NSInteger, AFAlertViewType){
    kAlertViewTypeLinkedIn = 0,
    kAlertViewTypeInstagram,
    kAlertViewTypeFacebook,
    kAlertViewTypeTwitter
};

@interface AFCardView() <UIAlertViewDelegate>

@end

@implementation AFCardView

#pragma mark - Card View

- (void)setIsEditModeOn:(bool)isEditModeOn
{
    if(_isEditModeOn != isEditModeOn){
        _isEditModeOn = isEditModeOn;
        [self setUpTextFontsAndColors];
        [self setUpCardImageView];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isEditModeOn = YES;
}

- (void)setCard:(AFCard *)card
{
    _card = card;
    [self loadCard];
    [self setUpCardView];
}

- (void)loadCard
{
    self.firstNameTextField.text = self.card.firstName;
    self.lastNameTextField.text = self.card.lastName;
    [self updateFullNameTextField];
    self.positionTextField.text = self.card.position;
    self.organizationTextField.text = self.card.organization;
    [self updatePositionAndOrgTextField];
    self.industryTextField.text = self.card.industry;
    self.emailTextField.text = self.card.emailAddress;
    self.phoneTextField.text = self.card.phone;
    self.websiteTextField.text = self.card.website;
}

- (void)setUpCardView
{
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cardView.layer.shadowOpacity = 0.20;
    self.cardView.layer.shadowRadius = 3.0;
    self.cardView.layer.masksToBounds = NO;
    self.isEditModeOn = NO;
}

- (void)setUpCardImageView
{
    if(self.isEditModeOn){
        self.cardImageButton.userInteractionEnabled = YES;
    }
    else{
        self.cardImageButton.userInteractionEnabled = NO;
    }
    self.cardImageButton.layer.cornerRadius = self.cardImageButton.frame.size.width/2.0;
    self.cardImageButton.backgroundColor = [UIColor airFiveLightGray];
    [self.cardImageButton.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.cardImageButton.layer setBorderWidth: 5.0];
}

- (void)setUpInfoView;
{
    [self setUpDividers];
    [self setUpTextFieldIcons];
    self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self updateSocialMediaButtons];
    if(self.isEditModeOn){
        self.industryLabel.hidden = NO;
        self.industryTextField.hidden = NO;
        self.dividerViewTop.hidden = NO;
        self.contactInfoLabel.hidden = NO;
        self.emailTextField.hidden = NO;
        self.phoneTextField.hidden = NO;
        self.dividerViewBottom.hidden = NO;
        self.websiteTextField.hidden = NO;
        self.editButton.selected = YES;
        self.bigEditButtonContainerView.hidden = YES;
        if(self.emailTextField.text && ![[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [self.emailTextField.leftView setTintColor:[UIColor airFiveGray]];
        }
        if(self.phoneTextField.text && ![[self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [self.phoneTextField.leftView setTintColor:[UIColor airFiveGray]];
        }
        if(self.websiteTextField.text && ![[self.websiteTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [self.websiteTextField.leftView setTintColor:[UIColor airFiveGray]];
        }
    }
    else{
        self.editButton.selected = NO;
        if(!self.industryTextField.text || [[self.industryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            self.industryTextField.hidden = YES;
            self.industryLabel.hidden = YES;
            self.dividerViewTop.hidden = YES;
        }
        if(!self.emailTextField.text || [[self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            self.emailTextField.hidden = YES;
        }
        if(!self.phoneTextField.text || [[self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            self.phoneTextField.hidden = YES;
        }
        if(!self.websiteTextField.text || [[self.websiteTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            self.websiteTextField.hidden = YES;
        }
        if(self.emailTextField.hidden && self.phoneTextField.hidden && self.websiteTextField.hidden){
            self.contactInfoLabel.hidden = YES;
            self.dividerViewBottom.hidden = YES;
        }
        if(self.industryLabel.hidden && self.contactInfoLabel.hidden){
            self.bigEditButtonContainerView.hidden = NO;
        }
    }
}

- (void)setUpTextFieldIcons
{
    //Email
    UIImageView *emailTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emailIcon"]];
    [self setUpLeftViewOfTextField:self.emailTextField withLeftView:emailTextFieldLeftView];
    
    //Phone
    UIImageView *phoneTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneIcon"]];
    [self setUpLeftViewOfTextField:self.phoneTextField withLeftView:phoneTextFieldLeftView];
    
    //Website
    UIImageView *websiteTextFieldLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"websiteIcon"]];
    [self setUpLeftViewOfTextField:self.websiteTextField withLeftView:websiteTextFieldLeftView];
}

- (void)setUpLeftViewOfTextField:(UITextField *)textField withLeftView:(UIImageView *)leftView
{
    leftView.backgroundColor = [UIColor clearColor];
    leftView.image = [leftView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [leftView setTintColor:[UIColor lightGrayColor]];
    leftView.frame = CGRectMake(0.0, 0.0, leftView.image.size.width+10.0, leftView.image.size.height);
    leftView.contentMode = UIViewContentModeLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
}

- (void)setUpDividers
{
    self.dividerViewTop.backgroundColor = [UIColor airFiveLightGray];
    self.dividerViewBottom.backgroundColor = [UIColor airFiveLightGray];
}

- (void)setUpTextFontsAndColors
{
    UIColor *mainInfoPlaceHolderColor = self.isEditModeOn ? [UIColor whiteColor] : [UIColor clearColor];
    
    self.fullNameTextField.font = [UIFont airFiveFontMediumWithSize:21.0];
    self.fullNameTextField.textColor = [UIColor whiteColor];
    self.fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.fullNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : mainInfoPlaceHolderColor, NSFontAttributeName : self.fullNameTextField.font}];
    
    self.firstNameTextField.textColor = [UIColor clearColor];
    self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.fullNameTextField.font}];
    
    self.lastNameTextField.textColor = [UIColor clearColor];
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.fullNameTextField.font}];
    
    self.positionAndOrgTextField.textColor = [UIColor whiteColor];
    self.positionAndOrgTextField.font = [UIFont airFiveFontMediumWithSize:16.0];
    self.positionAndOrgTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionAndOrgTextField.placeholder attributes:@{NSForegroundColorAttributeName : mainInfoPlaceHolderColor, NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    self.positionTextField.textColor = [UIColor clearColor];
    self.positionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.positionTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    self.organizationTextField.textColor = [UIColor clearColor];
    self.organizationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.organizationTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.positionAndOrgTextField.font}];
    
    UIColor *infoPlaceHolderColor = self.isEditModeOn ? [UIColor airFiveLightGray] : [UIColor clearColor];
    
    self.industryTextField.textColor = [UIColor airFiveBlue];
    self.industryTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.industryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.industryTextField.placeholder attributes:@{NSForegroundColorAttributeName : infoPlaceHolderColor, NSFontAttributeName : self.industryTextField.font}];
    
    self.emailTextField.textColor = [UIColor airFiveBlue];
    self.emailTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailTextField.placeholder attributes:@{NSForegroundColorAttributeName : infoPlaceHolderColor, NSFontAttributeName : self.emailTextField.font}];
    
    self.phoneTextField.textColor = [UIColor airFiveBlue];
    self.phoneTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.phoneTextField.placeholder attributes:@{NSForegroundColorAttributeName : infoPlaceHolderColor, NSFontAttributeName : self.phoneTextField.font}];
    
    self.websiteTextField.textColor = [UIColor airFiveBlue];
    self.websiteTextField.font = [UIFont airFiveFontSlabRegularWithSize:16.0];
    self.websiteTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.websiteTextField.placeholder attributes:@{NSForegroundColorAttributeName : infoPlaceHolderColor, NSFontAttributeName : self.websiteTextField.font}];
    
    NSAttributedString *bigEditButtonTitle = [[NSAttributedString alloc] initWithString:@"Tap to Edit" attributes:@{NSForegroundColorAttributeName : [UIColor airFiveBlue], NSFontAttributeName :self.bigEditButton.titleLabel.font}];
    [self.bigEditButton setAttributedTitle:bigEditButtonTitle forState:UIControlStateNormal];
    
    self.firstNameTextField.userInteractionEnabled = self.isEditModeOn;
    self.lastNameTextField.userInteractionEnabled = self.isEditModeOn;
    self.positionTextField.userInteractionEnabled = self.isEditModeOn;
    self.organizationTextField.userInteractionEnabled = self.isEditModeOn;
    self.industryTextField.userInteractionEnabled = self.isEditModeOn;
    self.emailTextField.userInteractionEnabled = self.isEditModeOn;
    self.phoneTextField.userInteractionEnabled = self.isEditModeOn;
    self.websiteTextField.userInteractionEnabled = self.isEditModeOn;
    
    [self setUpInfoView];
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

#pragma mark - Social Media Buttons

- (void)updateSocialMediaButtons
{
    [self updateLinkedInButton];
    [self updateInstagramButton];
    [self updateFacebookButton];
    [self updateTwitterButton];
}

- (void)updateLinkedInButton
{
    if([self.card.linkedInEnabled boolValue] && (self.card.linkedInURLString && ![[self.card.linkedInURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])){
        self.linkedInButton.selected = YES;
    }
    else{
        self.linkedInButton.selected = NO;
    }
}

- (void)updateInstagramButton
{
    if([self.card.instagramEnabled boolValue] && (self.card.instagramUserNameString && ![[self.card.instagramUserNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])){
        self.instagramButton.selected = YES;
    }
    else{
        self.instagramButton.selected = NO;
    }
}

- (void)updateFacebookButton
{
    if([self.card.facebookEnabled boolValue] && (self.card.facebookUserNameString && ![[self.card.facebookUserNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])){
        self.facebookButton.selected = YES;
    }
    else{
        self.facebookButton.selected = NO;
    }
}

- (void)updateTwitterButton
{
    if([self.card.twitterEnabled boolValue] && (self.card.twitterUserNameString && ![[self.card.twitterUserNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])){
        self.twitterButton.selected = YES;
    }
    else{
        self.twitterButton.selected = NO;
    }
}

- (IBAction)linkedInButtonTouched:(UIButton *)sender
{
    if(self.isEditModeOn){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Linkedin" message:[NSString stringWithFormat:@"%@...\nenter username", LINKED_IN_URL] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alertView.tag = kAlertViewTypeLinkedIn;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = [self.card.linkedInURLString stringByReplacingOccurrencesOfString:LINKED_IN_URL withString:@""];
        [alertView show];
    }
    else{
        if(![self.card.linkedInEnabled boolValue]){ //Enabled
            if(self.card.linkedInURLString && ![self.card.linkedInURLString isEqualToString:@""]){ //Has info on file
                self.card.linkedInEnabled = @(![self.card.linkedInEnabled boolValue]);
                [self updateLinkedInButton];
            }
            else{ //Does not have info on file
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LinkedIn Not on File" message:[NSString stringWithFormat:@"Tap the edit button and then tap the LinkedIn button again to add your info."] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{ //Disabled
            self.card.linkedInEnabled = @(![self.card.linkedInEnabled boolValue]);
            [self updateLinkedInButton];
        }
    }
}

- (IBAction)instagramButtonTouched:(UIButton *)sender
{
    if(self.isEditModeOn){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Instagram" message:[NSString stringWithFormat:@"Enter username"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alertView.tag = kAlertViewTypeInstagram;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = self.card.instagramUserNameString;
        [alertView show];
    }
    else{
        if(![self.card.instagramEnabled boolValue]){ //Enabled
            if(self.card.instagramUserNameString && ![self.card.instagramUserNameString isEqualToString:@""]){ //Has info on file
                self.card.instagramEnabled = @(![self.card.instagramEnabled boolValue]);
                [self updateInstagramButton];
            }
            else{ //Does not have info on file
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Instagram Not on File" message:[NSString stringWithFormat:@"Tap the edit button and then tap the Instagram button again to add your info."] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{ //Disabled
            self.card.instagramEnabled = @(![self.card.instagramEnabled boolValue]);
            [self updateInstagramButton];
        }
    }
}

- (IBAction)facebookButtonTouched:(UIButton *)sender
{
    if(self.isEditModeOn){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"facebook" message:[NSString stringWithFormat:@"Enter username"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alertView.tag = kAlertViewTypeFacebook;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = self.card.facebookUserNameString;
        [alertView show];
    }
    else{
        if(![self.card.facebookEnabled boolValue]){ //Enabled
            if(self.card.facebookUserNameString && ![self.card.facebookUserNameString isEqualToString:@""]){ //Has info on file
                self.card.facebookEnabled = @(![self.card.facebookEnabled boolValue]);
                [self updateFacebookButton];
            }
            else{ //Does not have info on file
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"facebook Not on File" message:[NSString stringWithFormat:@"Tap the edit button and then tap the facebook button again to add your info."] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{ //Disabled
            self.card.facebookEnabled = @(![self.card.facebookEnabled boolValue]);
            [self updateFacebookButton];
        }
    }
}

- (IBAction)twitterButtonTouched:(UIButton *)sender
{
    if(self.isEditModeOn){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"twitter" message:[NSString stringWithFormat:@"Enter username"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        alertView.tag = kAlertViewTypeTwitter;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = self.card.twitterUserNameString;
        [alertView show];
    }
    else{
        if(![self.card.twitterEnabled boolValue]){ //Enabled
            if(self.card.twitterUserNameString && ![self.card.twitterUserNameString isEqualToString:@""]){ //Has info on file
                self.card.twitterEnabled = @(![self.card.twitterEnabled boolValue]);
                [self updateTwitterButton];
            }
            else{ //Does not have info on file
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Not on File" message:[NSString stringWithFormat:@"Tap the edit button and then tap the Twitter button again to add your info."] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else{ //Disabled
            self.card.twitterEnabled = @(![self.card.twitterEnabled boolValue]);
            [self updateTwitterButton];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: break; //Cancel
        case 1: //Okay
        {
            UITextField *usernameTextField = [alertView textFieldAtIndex:0];
            if(usernameTextField.text && ![[usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
                switch (alertView.tag) {
                    case kAlertViewTypeLinkedIn:
                    {
                        self.card.linkedInURLString = [NSString stringWithFormat:@"%@%@",LINKED_IN_URL,[usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                        self.card.linkedInEnabled = @(YES);
                        [self updateLinkedInButton];
                        break;
                    }
                    case kAlertViewTypeInstagram:
                    {
                        self.card.instagramUserNameString = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        self.card.instagramEnabled = @(YES);
                        [self updateInstagramButton];
                        break;
                    }
                    case kAlertViewTypeFacebook:
                    {
                        self.card.facebookEnabled = @(YES);
                        self.card.facebookUserNameString = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        [self updateFacebookButton];
                        break;
                    }
                    case kAlertViewTypeTwitter:
                    {
                        self.card.twitterUserNameString = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        self.card.twitterEnabled = @(YES);
                        [self updateTwitterButton];
                        break;
                    }
                    default: break;
                }
            }
            break;
        }
        default: break;
    }
}



@end
