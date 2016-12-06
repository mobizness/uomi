//
//  RegisterViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "RegisterViewController.h"
#import "PdsViewController.h"
#import "WPAttributedStyleAction.h"
#import "NSString+WPAttributedMarkup.h"


@interface RegisterViewController ()<UITextFieldDelegate>
{

}
@end
@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _textfieldEmail.delegate = self;
    _textfieldFullname.delegate = self;
    _textfieldPhone.delegate = self;
    _textfieldPassword.delegate = self;

    
    _textfieldEmail.text = @"johnsmith@gmail.com";
    _textfieldFullname.text = @"John Smith";
    _textfieldPhone.text = @"123456789";
    _textfieldPassword.text = @"qwerty";
    
}


#pragma mark - IBAction
- (IBAction)OnSignup:(id)sender {
    if ([_textfieldFullname.text isEqualToString:@"Full Name"] ||
        [_textfieldEmail.text isEqualToString:@"Email Address"] ||
        [_textfieldPhone.text isEqualToString:@"Phone Number"] ||
        [_textfieldFullname.text isEqualToString:@""] ||
        [_textfieldEmail.text isEqualToString:@""] ||
        [_textfieldPassword.text isEqualToString:@""] ||
        [_textfieldPhone.text isEqualToString:@""]) {
        
        [commonUtils showAlert:@"Registration" withMessage:@"Please fill information" view:self];
        return;
    }
    if (![commonUtils validateEmail:_textfieldEmail.text]) {
        [commonUtils showAlert:@"Registration" withMessage:@"Please input valid Email Address" view:self];
        return;
    }
    if ([_textfieldPassword.text length] < 6) {
        [commonUtils showAlert:@"Registration" withMessage:@"Password must be at least 6 characters" view:self];
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"2" forKey:@"signup_mode"];
    [userInfo setObject:_textfieldEmail.text forKey:@"user_email"];
    [userInfo setObject:_textfieldPassword.text forKey:@"password"];
    [userInfo setObject:_textfieldFullname.text forKey:@"user_name"];
    [userInfo setObject:_textfieldPhone.text forKey:@"phone"];
    
    if (appController.deviceToken == nil) {
        appController.deviceToken = @"";
    }
    
    [userInfo setObject:appController.deviceToken forKey:@"device_token"];
    [userInfo setObject:@"ios" forKey:@"device"];
//    [userInfo setObject:[commonUtils encodeToBase64String:_profile_imageVIew.image byCompressionRatio:0.3] forKey:@"user_photo_data"];
    
    if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
        [userInfo setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
    } else {
        [commonUtils setUserDefault:@"user_apns_id" withFormat:@"1"];
        [userInfo setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
    }
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSingup:userInfo];
    });
    
}

- (IBAction)OnTermsConditions:(id)sender {
    [commonUtils showAlert:@"Terms & Conditions" withMessage:@"Coming Soon!" view:self];
}

- (IBAction)OnPrivacyPolicy:(id)sender {
    [commonUtils showAlert:@"Privacy Policy" withMessage:@"Coming Soon!" view:self];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            if ([textField.text isEqualToString:@"Full Name"]) {
                textField.text = @"";
            }
            break;
        case 2:
            if ([textField.text isEqualToString:@"Email Address"]) {
                textField.text = @"";
            }
            break;
        case 3:
            if ([textField.text isEqualToString:@"Phone Number"]) {
                textField.text = @"";
            }
            break;
        case 4:
            if ([textField.text isEqualToString:@"Password"]) {
                textField.text = @"";
            }
            break;
    
        default:
            break;
    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            if ([textField.text isEqualToString:@""]) {
                textField.text = @"Full Name";
            }
            break;
        case 2:
            if ([textField.text isEqualToString:@""]) {
                textField.text = @"Email Address";
            }
            break;
        case 3:
            if ([textField.text isEqualToString:@""]) {
                textField.text = @"Phone Number";
            }
            break;
        case 4:
            if ([textField.text isEqualToString:@""]) {
                textField.text = @"Password";
            }
            break;
            
        default:
            break;
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            [_textfieldEmail becomeFirstResponder];
            break;
        case 2:
            [_textfieldPhone becomeFirstResponder];
            break;
        case 3:
            [_textfieldPassword becomeFirstResponder];
            break;
        case 4:
            return [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    return true;
}

#pragma mark - Request API
- (void) requestSingup:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.strUserId = [result objectForKey:@"user_id"];
            appController.dicUserInfo = [result objectForKey:@"user_info"];

            [commonUtils setUserDefault:@"user_id" withFormat:appController.strUserId];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            
            PdsViewController* addMembersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PdsViewController"];
            [self.navigationController pushViewController:addMembersViewController animated:YES];

            
        } else if([status intValue] == 2) {
            [commonUtils showAlert: @"User already registered." withMessage:@"Please log in." view:self];
        } else if([status intValue] == 3) {
            [commonUtils showAlert: @"User already registered." withMessage:@"Please log in." view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
