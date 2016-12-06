//
//  RegisterViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "LoginViewController.h"
#import "TabbarController.h"
#import "Onboarding3ViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    
}
@end
@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _textfieldPassword.delegate = self;
    _textfieldPhone.delegate = self;
    
    _textfieldPhone.text = @"79084793642";
    _textfieldPassword.text = @"qwert";
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            if ([textField.text isEqualToString:@"Phone Number"]) {
                textField.text = @"";
            }
            break;
        case 2:
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
                textField.text = @"Phone Number";
            }
            break;
        case 2:
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
            return [_textfieldPhone becomeFirstResponder];
        case 2:
            return [_textfieldPassword becomeFirstResponder];
        default:
            break;
    }
    return true;
}

#pragma mark - IBAction

- (IBAction)OnLogin:(id)sender {
    if ([_textfieldPhone.text isEqualToString:@"Phone Number"] ||
        [_textfieldPassword.text isEqualToString:@""] ||
        [_textfieldPhone.text isEqualToString:@""]) {
        
        [commonUtils showAlert:@"" withMessage:@"Please fill information" view:self];
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:_textfieldPassword.text forKey:@"password"];
    [userInfo setObject:_textfieldPhone.text forKey:@"phone"];
    
    if (appController.deviceToken == nil) {
        appController.deviceToken = @"";
    }
    
    [userInfo setObject:appController.deviceToken forKey:@"device_token"];
    [userInfo setObject:@"ios" forKey:@"device"];
    
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
        
        [self requestLogin:userInfo];
    });
    

}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestLogin:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_USER_LOGIN withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.strUserId = [result objectForKey:@"user_id"];
            appController.dicUserInfo = [result objectForKey:@"user_info"];
            
            [commonUtils setUserDefault:@"user_id" withFormat:appController.strUserId];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            
            if ([[appController.dicUserInfo objectForKey:@"status"] intValue] == 0) {
                Onboarding3ViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding3ViewController"];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
            else {
                [commonUtils setUserDefault:@"is_logined" withFormat:@"1"];
                
                TabbarController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            
        } else {
            [commonUtils showAlert: @"Login" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
