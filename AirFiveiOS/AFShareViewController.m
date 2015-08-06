//
//  AFShareViewController.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/3/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFShareViewController.h"
#import "AFEmailManager.h"
#import "UIColor+AirFive.h"
#import "UIFont+AirFive.h"
#import "iCarousel.h"
#import "AFCardView.h"
#import "AFCard.h"

@interface AFShareViewController() <iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;
@property (strong, nonatomic) NSString *recipientEmailAddress;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) NSArray *cards;

@property (nonatomic, strong) AFCardView *selectedCardView;
@property (weak, nonatomic) UITextField *selectedTextField;

@end

@implementation AFShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpShareView];
    [self setUpTextFontsAndColors];
    [self configureCarousel];
    [self.carousel scrollToItemAtIndex:0 animated:NO];
}

- (void)dealloc
{
    self.carousel.dataSource = nil;
    self.carousel.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    [self loadCards];
}

- (void)loadCards
{
    self.cards = @[[[AFCard alloc] init],[[AFCard alloc] init], [[AFCard alloc] init]];
}

- (void)setCards:(NSArray *)cards
{
    _cards = cards;
    [self.carousel reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    [self deregisterFromKeyboardNotifications];
}

#pragma mark - iCarousel

- (void)configureCarousel
{
    //configure carousel
    self.carousel.type = iCarouselTypeCoverFlow;
    self.carousel.centerItemWhenSelected = YES;
    self.carousel.stopAtItemBoundary = YES;
    self.carousel.bounces = NO;
    self.carousel.pagingEnabled = YES;
    self.carousel.scrollSpeed = 0.01;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.cards count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    AFCardView *cardView = (AFCardView *)view;
    if (cardView == nil){
        cardView = [[[NSBundle mainBundle] loadNibNamed:@"AFCardView" owner:self options:nil] lastObject];
        cardView.cardViewWidthConstraint.constant = carousel.bounds.size.width;
        cardView.cardViewHeightConstraint.constant = carousel.bounds.size.height;
    }

    cardView.card = [self.cards objectAtIndex:index];
    
    NSLog(@"%@", NSStringFromCGRect(carousel.bounds));
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    return cardView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.selectedCardView = (AFCardView *)[carousel itemViewAtIndex:carousel.currentItemIndex];
    [self setCardViewDelegates];
}

#pragma mark - Background View

- (void)setUpBackground
{
    self.view.backgroundColor = [UIColor airFiveBlue];
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
    [AFEmailManager sharedInstance].firstName = self.selectedCardView.card.firstName;
    [AFEmailManager sharedInstance].lastName = self.selectedCardView.card.lastName;
    [AFEmailManager sharedInstance].position = self.selectedCardView.card.position;
    [AFEmailManager sharedInstance].organization = self.selectedCardView.card.organization;
    [AFEmailManager sharedInstance].industry = self.selectedCardView.card.industry;
    [AFEmailManager sharedInstance].emailAddress = self.selectedCardView.card.emailAddress;
    [AFEmailManager sharedInstance].phone = self.selectedCardView.card.phone;
    [AFEmailManager sharedInstance].website = self.selectedCardView.card.website;
    [AFEmailManager sharedInstance].recipientEmailAddress = self.recipientEmailAddress;;
    [[AFEmailManager sharedInstance] sendEmail];
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

#pragma mark - UITextField Delegate

- (void)setCardViewDelegates
{
    self.selectedCardView.fullNameTextField.delegate = self;
    self.selectedCardView.firstNameTextField.delegate = self;
    self.selectedCardView.lastNameTextField.delegate = self;
    self.selectedCardView.positionAndOrgTextField.delegate = self;
    self.selectedCardView.positionTextField.delegate = self;
    self.selectedCardView.organizationTextField.delegate = self;
    self.selectedCardView.industryTextField.delegate = self;
    self.selectedCardView.emailTextField.delegate = self;
    self.selectedCardView.phoneTextField.delegate = self;
    self.selectedCardView.websiteTextField.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.selectedCardView.positionTextField || textField == self.selectedCardView.organizationTextField){
        self.selectedCardView.positionTextField.textColor = self.selectedCardView.positionAndOrgTextField.textColor;
        self.selectedCardView.positionTextField.font = self.selectedCardView.positionAndOrgTextField.font;
        self.selectedCardView.positionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.positionTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
        
        self.selectedCardView.organizationTextField.textColor = self.selectedCardView.positionAndOrgTextField.textColor;
        self.selectedCardView.organizationTextField.font = self.selectedCardView.positionAndOrgTextField.font;
        self.selectedCardView.organizationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.organizationTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
        
        self.selectedCardView.positionAndOrgTextField.textColor = [UIColor clearColor];
        self.selectedCardView.positionAndOrgTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.positionAndOrgTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
    }
    else if(textField == self.selectedCardView.firstNameTextField || textField == self.selectedCardView.lastNameTextField){
        self.selectedCardView.firstNameTextField.textColor = self.selectedCardView.fullNameTextField.textColor;
        self.selectedCardView.firstNameTextField.font = self.selectedCardView.fullNameTextField.font;
        self.selectedCardView.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
        
        self.selectedCardView.lastNameTextField.textColor = self.selectedCardView.fullNameTextField.textColor;
        self.selectedCardView.lastNameTextField.font = self.selectedCardView.fullNameTextField.font;
        self.selectedCardView.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFiveLightGray], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
        
        self.selectedCardView.fullNameTextField.textColor = [UIColor clearColor];
        self.selectedCardView.fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.fullNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
    }
    else{
        [self setUpTextFontsAndColors];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setUpTextFontsAndColors];
    [self.selectedCardView updateFullNameTextField];
    [self.selectedCardView updatePositionAndOrgTextField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.selectedTextField = textField;
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField == self.selectedCardView.fullNameTextField){
        //Do nothing
    }
    else if(textField == self.selectedCardView.firstNameTextField){
        self.selectedCardView.card.firstName = text;
    }
    else if(textField == self.selectedCardView.lastNameTextField){
        self.selectedCardView.card.lastName = text;
    }
    else if(textField == self.selectedCardView.positionAndOrgTextField){
        // Do nothing
    }
    else if(textField == self.selectedCardView.positionTextField){
        self.selectedCardView.card.position = text;
    }
    else if(textField == self.selectedCardView.organizationTextField){
        self.selectedCardView.card.organization = text;
    }
    else if(textField == self.selectedCardView.industryTextField){
        self.selectedCardView.card.industry = text;
    }
    else if(textField == self.selectedCardView.emailTextField){
        self.selectedCardView.card.emailAddress = text;
    }
    else if(textField == self.selectedCardView.phoneTextField){
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:text deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:text deleteLastChar:NO ];
        }
        self.selectedCardView.card.phone = textField.text;
        return NO;
    }
    else if(textField == self.selectedCardView.websiteTextField){
        self.selectedCardView.card.website = text;
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


@end
