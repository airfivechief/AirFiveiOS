//
//  AFCardView.h
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/4/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFCard;

@interface AFCardView : UIView

@property (strong, nonatomic) AFCard *card;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIButton *cardImageButton;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionAndOrgTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *organizationTextField;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UITextField *industryTextField;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) NSString *linkedInURLString;
@property (weak, nonatomic) IBOutlet UIView *dividerViewTop;
@property (weak, nonatomic) IBOutlet UIView *dividerViewBottom;
@property (weak, nonatomic) IBOutlet UIView *bigEditButtonContainerView;
@property (weak, nonatomic) IBOutlet UIButton *bigEditButton;



- (void)updatePositionAndOrgTextField;
- (void)updateFullNameTextField;
- (void)setUpTextFontsAndColorsWithEditMode:(bool)editMode;
- (void)setUpCardImageViewWithEditMode:(bool)editMode;

@end
