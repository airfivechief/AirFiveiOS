//
//  AFEmailManager.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 7/31/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "AFEmailManager.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#define AIR_FIVE_EMAIL @"sharecard@airfive.com"
#define PASS_USER_ID @"Kensingto5"
#define A_CONTACT_FROM_AIRFIVE @"A contact from Airfive!";

@interface AFEmailManager() <SKPSMTPMessageDelegate>

@property (strong, nonatomic) NSArray *requiredFields;

@end

@implementation AFEmailManager

+ (instancetype)sharedInstance
{
    static AFEmailManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self loadRequiredFields];
    }
    return self;
}

- (void)loadRequiredFields
{
    self.requiredFields = @[@"firstName", @"lastName", @"emailAddress", @"recipientEmailAddress"];
}

- (void)sendEmail
{
    if(![self hasRequiredFields]){ //Failure - Does not have all required fields
        NSLog(@"Email does not have all required fields");
    }
    else if(![self emailAddressIsValid:self.emailAddress]){ //Failure - Invalid Contact Email Address
        NSLog(@"Your Email Address Is Invalid");
    }
    else if(![self emailAddressIsValid:self.recipientEmailAddress]){ //Failure - Invalid Recipient Email Address
        NSLog(@"Recipient Email Address Is Invalid");
    }
    else{
        [self formHTMLEmail];
    }
}

- (bool)emailAddressIsValid: (NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (bool)hasRequiredFields
{
    for(NSString *field in self.requiredFields){
        if(![self valueForKey:field]||[[[self valueForKey:field] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"EMAIL SENT");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"MESSAGE FAILED TO SEND");
    
}


- (void)formHTMLEmail
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Contactcard" ofType:@"html"];
    if(!path){
        return;
    }
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.fromEmail = AIR_FIVE_EMAIL; //Required
    emailMessage.toEmail = self.recipientEmailAddress;  //Required
    emailMessage.relayHost = @"smtp.gmail.com";
    emailMessage.requiresAuth = true;
    emailMessage.login = AIR_FIVE_EMAIL; //Required
    emailMessage.pass = PASS_USER_ID; //Required
    emailMessage.subject = A_CONTACT_FROM_AIRFIVE;
    emailMessage.wantsSecure = true;
    emailMessage.delegate = self;
    
    
    //merge HTML with the current contact
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##CID##" withString:[[[NSUUID alloc] init] UUIDString]];
    
    
    if(self.firstName){htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##fname##" withString:self.firstName];}
    if(self.lastName){ htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##lname##" withString:self.lastName];};
    if(self.position){ htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##title##" withString:self.position]; }
    if(self.industry){ htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##industry##" withString:self.industry];}
    
    if(self.emailAddress){htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##email##" withString:self.emailAddress];}
    if(self.phone){htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##phone##" withString:self.phone];}
    if(self.website){htmlString = [htmlString stringByReplacingOccurrencesOfString:@"##website##" withString:self.website];}
    
    NSDictionary *plainMessage = @{
                                   kSKPSMTPPartContentTypeKey:@"text/html",
                                   kSKPSMTPPartMessageKey:htmlString,
                                   kSKPSMTPPartContentTransferEncodingKey:@"8bit"
                                   };
    
    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"contactInfo" ofType:@"vcf"];
    NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
    
    if(!vcfData){
        return;
    }
    
    NSString *str = [NSString stringWithContentsOfFile:vcfPath encoding:NSUTF8StringEncoding error:nil];
    //merge VCF with current contact
    
    if(self.firstName){str = [str stringByReplacingOccurrencesOfString:@"##fname##" withString:self.firstName];}
    if(self.lastName){str = [str stringByReplacingOccurrencesOfString:@"##lname##" withString:self.lastName];}
    if(self.position){str = [str stringByReplacingOccurrencesOfString:@"##title##" withString:self.position];}
    if(self.emailAddress){str = [str stringByReplacingOccurrencesOfString:@"##email##" withString:self.emailAddress];}
    if(self.phone){str = [str stringByReplacingOccurrencesOfString:@"##phone##" withString:self.phone];}
    if(self.website){str = [str stringByReplacingOccurrencesOfString:@"##website##" withString:self.website];}
    
    NSDictionary *vcfPart = @{kSKPSMTPPartContentTypeKey:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"contactInfo.vcf\"",
                              kSKPSMTPPartContentDispositionKey:@"attachment;\r\n\tfilename=\"ContactInfo.vcf\"",
                              kSKPSMTPPartMessageKey: [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                              kSKPSMTPPartContentTransferEncodingKey:@"base64"
                              };
    
    emailMessage.parts = @[plainMessage, vcfPart];
    [emailMessage send];
}

@end
