//
//  Onboarding3ViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "Onboarding3ViewController.h"
#import "TutorialViewController.h"

@interface Onboarding3ViewController ()<UITextFieldDelegate>
{
    BOOL isSendPhoneNumber;
}
@end
@implementation Onboarding3ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *dicUserInfo = appController.dicUserInfo;
    NSString *strPhone = [dicUserInfo objectForKey:@"phone"];
    _textFieldNumber.text = strPhone;
    isSendPhoneNumber = false;
    _textFieldNumber.delegate = self;
    [_textFieldNumber becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"####  ###  ###"]) {
        textField.text = @"";
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!isSendPhoneNumber) {
        NSMutableDictionary *dicUserInfo = appController.dicUserInfo;
        NSString *strUserid = [dicUserInfo objectForKey:@"user_id"];

        NSMutableDictionary *verifyInfo = [[NSMutableDictionary alloc] init];
        [verifyInfo setObject:strUserid forKey:@"user_id"];
        [verifyInfo setObject:_textFieldNumber.text forKey:@"phone"];
        
        
        [commonUtils showActivityIndicator:self.view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestSendPhonenumber:verifyInfo];
        });
    }
    else {
        NSMutableDictionary *dicUserInfo = appController.dicUserInfo;
        NSString *strUserid = [dicUserInfo objectForKey:@"user_id"];

        NSMutableDictionary *verifyInfo = [[NSMutableDictionary alloc] init];
        [verifyInfo setObject:strUserid forKey:@"user_id"];
        [verifyInfo setObject:_textFieldNumber.text forKey:@"verify_code"];
        
        [commonUtils showActivityIndicator:self.view];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestVerify:verifyInfo];
        });
    }
    return [textField resignFirstResponder];
}

#pragma mark - Request API
- (void) requestSendPhonenumber:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SEND_PHONENUMBER withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            isSendPhoneNumber = true;
            _textFieldNumber.text = @"";
            [commonUtils showAlert:@"Verify" withMessage:@"Sent verification code via SMS." view:self];
            [_textFieldNumber becomeFirstResponder];
            
        } else if([status intValue] == 2) {
            [commonUtils showAlert: @"Register" withMessage:[result objectForKey:@"message"] view:self];
        } else if([status intValue] == 3) {
            [commonUtils showAlert: @"Register" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestVerify:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SEND_VERIFYCODE withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.dicUserInfo = [result objectForKey:@"user_info"];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            [commonUtils setUserDefault:@"is_logined" withFormat:@"1"];
            
            TutorialViewController* addMembersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
            [self.navigationController pushViewController:addMembersViewController animated:YES];
            
            
        } else {
            [commonUtils showAlert: @"Verify" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
