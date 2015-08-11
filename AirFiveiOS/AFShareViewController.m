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
#import "UIUnderlinedButton.h"
#import "iCarousel.h"
#import "AFCardView.h"
#import "AFCard.h"

@interface AFShareViewController() <iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

//Navigation View
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *navigationButtons;

//Card View
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) AFCardView *selectedCardView;
@property (nonatomic, strong) NSArray *cards;
@property (assign, nonatomic) bool isEditModeOn;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

//Share View
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;
@property (strong, nonatomic) NSString *recipientEmailAddress;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

//Keyboard
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottomConstraint;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetCarousel];
}

- (void)resetCarousel
{
    self.isEditModeOn = NO;
    [self.carousel scrollToItemAtIndex:0 animated:NO];
    [self carouselCurrentItemIndexDidChange:self.carousel];
    [self setCardViewDelegates];
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

#pragma mark - Navigation View

- (IBAction)navigationButtonTouched:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.carousel scrollToItemAtIndex:sender.tag animated:YES];
}

- (void)updateNavigationViewUI
{
    NSInteger currentItemIndex = self.carousel.currentItemIndex;
    for(UIUnderlinedButton *button in self.navigationButtons){
        if(button.tag == currentItemIndex){
            button.selected = YES;
            button.underline = YES;
        }
        else{
            button.selected = NO;
            button.underline = NO;
        }
    }
}

#pragma mark - Edit Mode

- (IBAction)editButtonTouched:(UIButton *)sender
{
    self.isEditModeOn = !self.isEditModeOn;
}

- (void)setIsEditModeOn:(bool)isEditModeOn
{
    _isEditModeOn = isEditModeOn;
    if(_isEditModeOn){
        [self didEnterEditMode];
    }
    else{
        [self didEndEditMode];
    }
}

- (void)didEnterEditMode
{
    [self.selectedCardView setUpTextFontsAndColorsWithEditMode:YES];
    self.shareButton.enabled = NO;
}

- (void)didEndEditMode
{
    [self.selectedCardView setUpTextFontsAndColorsWithEditMode:NO];
    [self.view endEditing:YES];
    self.shareButton.enabled = YES;
}

#pragma mark - iCarousel

- (void)configureCarousel
{
    //configure carousel
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.centerItemWhenSelected = YES;
    self.carousel.stopAtItemBoundary = YES;
    self.carousel.bounces = NO;
    self.carousel.pagingEnabled = YES;
    self.carousel.scrollSpeed = 0.03;
    
    self.carousel.backgroundColor = [UIColor airFiveWhite];
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
        [cardView setFrame:self.carousel.bounds];
    }

    cardView.card = [self.cards objectAtIndex:index];
    return cardView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.selectedCardView = (AFCardView *)[carousel itemViewAtIndex:carousel.currentItemIndex];
    self.selectedCardView.card = [self.cards objectAtIndex:carousel.currentItemIndex];
    [self updateNavigationViewUI];
    [self setCardViewDelegates];
    [self updateEmailManager];
    self.isEditModeOn = ![[AFEmailManager sharedInstance] hasRequiredFields];
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //Linear
    //CGFloat spacing = 1.1f;
    //return CATransform3DTranslate(transform, offset * carousel.bounds.size.width * spacing, 0.0, 0.0);
    
    //Rotary
    CGFloat count = 3;
    CGFloat spacing = 1.1f;
    CGFloat arc = M_PI * 0.3; //Change to reduce increase angle of views coming in an out
    CGFloat radius = MAX(carousel.bounds.size.width * spacing / 2.0, carousel.bounds.size.width * spacing / 2.0 / tanf(arc/2.0/count));
    CGFloat angle = offset / count * arc;
    
    return CATransform3DTranslate(transform, radius * sin(angle), radius * cos(angle) - radius,1.0 );

}

#pragma mark - Background View

- (void)setUpBackground
{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Share View

- (void)setUpShareView
{
    self.shareView.backgroundColor = [UIColor airFiveWhite];
    [self setUpShareButton];
}

- (void)setUpTextFontsAndColors
{
    [self.selectedCardView setUpTextFontsAndColorsWithEditMode:self.isEditModeOn];
    self.recipientEmailTextField.textColor = [UIColor blackColor];
    self.recipientEmailTextField.font = [UIFont airFiveFontMediumWithSize:16.0];
    self.recipientEmailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.recipientEmailTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor airFivePink], NSFontAttributeName : self.recipientEmailTextField.font}];
    
    [self.shareButton.titleLabel setFont:[UIFont airFiveFontMediumWithSize:16.0]];
}

- (void)setUpShareButton
{
    self.shareButton.layer.cornerRadius = 3.0;
    self.shareButton.backgroundColor = [UIColor airFiveGreen];
}

- (IBAction)shareButtonTouched:(UIButton *)sender
{
    [[AFEmailManager sharedInstance] sendEmail];
}

- (void)updateEmailManager
{
    [AFEmailManager sharedInstance].firstName = self.selectedCardView.card.firstName;
    [AFEmailManager sharedInstance].lastName = self.selectedCardView.card.lastName;
    [AFEmailManager sharedInstance].position = self.selectedCardView.card.position;
    [AFEmailManager sharedInstance].organization = self.selectedCardView.card.organization;
    [AFEmailManager sharedInstance].industry = self.selectedCardView.card.industry;
    [AFEmailManager sharedInstance].emailAddress = self.selectedCardView.card.emailAddress;
    [AFEmailManager sharedInstance].phone = self.selectedCardView.card.phone;
    [AFEmailManager sharedInstance].website = self.selectedCardView.card.website;
    [AFEmailManager sharedInstance].recipientEmailAddress = self.recipientEmailAddress;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(self.selectedTextField == self.selectedCardView.emailTextField ||
       self.selectedTextField == self.selectedCardView.phoneTextField ||
       self.selectedTextField == self.selectedCardView.websiteTextField ||
       self.selectedTextField == self.recipientEmailTextField ){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        int keyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
        self.logoVerticalConstraint.constant = -keyboardHeight;
        self.shareViewBottomConstraint.constant = -keyboardHeight;
        [self.view layoutIfNeeded];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.logoVerticalConstraint.constant = 20;
    self.shareViewBottomConstraint.constant = 0;
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
    self.selectedTextField = textField;
    if(textField == self.selectedCardView.firstNameTextField || textField == self.selectedCardView.lastNameTextField){
        self.selectedCardView.firstNameTextField.textColor = self.selectedCardView.fullNameTextField.textColor;
        self.selectedCardView.firstNameTextField.font = self.selectedCardView.fullNameTextField.font;
        self.selectedCardView.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.firstNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
        
        self.selectedCardView.lastNameTextField.textColor = self.selectedCardView.fullNameTextField.textColor;
        self.selectedCardView.lastNameTextField.font = self.selectedCardView.fullNameTextField.font;
        self.selectedCardView.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.lastNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
        
        self.selectedCardView.fullNameTextField.textColor = [UIColor clearColor];
        self.selectedCardView.fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.fullNameTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.selectedCardView.fullNameTextField.font}];
    }
    else if(textField == self.selectedCardView.positionTextField || textField == self.selectedCardView.organizationTextField){
        self.selectedCardView.positionTextField.textColor = self.selectedCardView.positionAndOrgTextField.textColor;
        self.selectedCardView.positionTextField.font = self.selectedCardView.positionAndOrgTextField.font;
        self.selectedCardView.positionTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.positionTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
        
        self.selectedCardView.organizationTextField.textColor = self.selectedCardView.positionAndOrgTextField.textColor;
        self.selectedCardView.organizationTextField.font = self.selectedCardView.positionAndOrgTextField.font;
        self.selectedCardView.organizationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.organizationTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
        
        self.selectedCardView.positionAndOrgTextField.textColor = [UIColor clearColor];
        self.selectedCardView.positionAndOrgTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.selectedCardView.positionAndOrgTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : self.selectedCardView.positionAndOrgTextField.font}];
    }
    else{
        [self setUpTextFontsAndColors];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setUpTextFontsAndColors];
    //[self.selectedCardView setUpTextFontsAndColorsWithEditMode:NO];
    [self.selectedCardView updateFullNameTextField];
    [self.selectedCardView updatePositionAndOrgTextField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField != self.recipientEmailTextField && !self.isEditModeOn){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == self.selectedCardView.emailTextField || textField == self.selectedCardView.phoneTextField || textField == self.selectedCardView.websiteTextField){
        [textField.leftView setTintColor:[UIColor lightGrayColor]];
    }
    return YES;
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
        if(text && [text length]){
            [textField.leftView setTintColor:[UIColor airFiveGray]];
        }
        else{
            [textField.leftView setTintColor:[UIColor lightGrayColor]];
        }
    }
    else if(textField == self.selectedCardView.phoneTextField){
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:text deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:text deleteLastChar:NO ];
        }
        self.selectedCardView.card.phone = textField.text;
        if(text && [text length]){
            [textField.leftView setTintColor:[UIColor airFiveGray]];
        }
        else{
            [textField.leftView setTintColor:[UIColor lightGrayColor]];
        }
        return NO;
    }
    else if(textField == self.selectedCardView.websiteTextField){
        self.selectedCardView.card.website = text;
        if(text && [text length]){
            [textField.leftView setTintColor:[UIColor airFiveGray]];
        }
        else{
            [textField.leftView setTintColor:[UIColor lightGrayColor]];
        }
    }
    else if(textField == self.recipientEmailTextField){
        self.recipientEmailAddress = text;
    }
    [self updateEmailManager];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Card Image Button

- (IBAction)cardImageButtonTapped:(UIButton *)sender
{
    [self resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Edit Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex){
        case 0:
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                
            }];
            break;
        }
        case 1:
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                
            }];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (UIImagePickerController *) imagePickerController{
    if(!_imagePickerController){
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if([self.imagePickerController.view isDescendantOfView:self.navigationController.view]){
        [self.imagePickerController.view removeFromSuperview];
    }
    else if([self.imagePickerController.view isDescendantOfView:[[[UIApplication sharedApplication] delegate] window]]){
        [self.imagePickerController.view removeFromSuperview];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *buttonImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.selectedCardView.cardImageButton setBackgroundImage:buttonImage  forState:UIControlStateNormal];
        self.selectedCardView.cardImageButton.layer.masksToBounds = YES;
    }];
}


@end
