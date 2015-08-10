//
//  AFCardView.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/4/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFCardView.h"
#import "UIColor+AirFive.h"
#import "UIFont+AirFive.h"
#import "AFCard.h"

@implementation AFCardView

#pragma mark - Card View

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self setUpTextFontsAndColorsWithEditMode:YES];
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
    [self setUpCardImageView];
    [self setUpInfoView];
}

- (void)setUpCardImageView
{
    self.cardImageView.layer.cornerRadius = self.cardImageView.frame.size.width/2.0;
    self.cardImageView.backgroundColor = [UIColor airFiveLightGray];
    [self.cardImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.cardImageView.layer setBorderWidth: 5.0];
}

- (void)setUpInfoView
{
    [self setUpDividers];
}

- (void)setUpDividers
{
    for (UIView *divider in self.dividers){
        divider.backgroundColor = [UIColor airFiveLightGray];
    }
}

- (void)setUpTextFontsAndColorsWithEditMode:(bool)editMode
{
    UIColor *mainInfoPlaceHolderColor = editMode ? [UIColor whiteColor] : [UIColor clearColor];
    
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
    
    UIColor *infoPlaceHolderColor = editMode ? [UIColor airFiveLightGray] : [UIColor clearColor];
    
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


@end
