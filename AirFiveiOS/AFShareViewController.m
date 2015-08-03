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
#import "iCarousel.h"

@interface AFShareViewController() <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) AFCardViewController *cardViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoVerticalConstraint;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UITextField *recipientEmailTextField;
@property (strong, nonatomic) NSString *recipientEmailAddress;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation AFShareViewController

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.cards = [NSMutableArray array];
    for (int i = 0; i < 1000; i++)
    {
        [self.cards addObject:@(i)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBackground];
    [self setUpShareView];
    [self setUpTextFontsAndColors];
    [self configureCarousel];
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

#pragma mark - iCarousel

- (void)configureCarousel
{
    //configure carousel
    self.carousel.type = iCarouselTypeCoverFlow2;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.cards count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [self.cards[index] stringValue];
    
    return view;
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
