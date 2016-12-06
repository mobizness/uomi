//
//  SettingsViewController.m
//  uomi
//
//  Created by scs on 11/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITextFieldDelegate>
{
    
}
@end
@implementation SettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _textFieldEmail.delegate = self;
    _textFieldUsername.delegate = self;
    _textFieldPhone.delegate = self;
    _textFieldPassword.delegate = self;
    
    _textFieldEmail.text = [appController.dicUserInfo objectForKey:@"user_email"];
    _textFieldUsername.text = [appController.dicUserInfo objectForKey:@"user_name"];
    _textFieldPhone.text = [appController.dicUserInfo objectForKey:@"phone"];
    
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
            [_textFieldEmail becomeFirstResponder];
            break;
        case 2:
            [_textFieldPhone becomeFirstResponder];
            break;
//        case 3:
//            [_textFieldPassword becomeFirstResponder];
//            break;
        case 3:
            return [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    return true;
}

#pragma mark - IBAction
- (IBAction)OnUpdateProfile:(id)sender {
    if ([_textFieldUsername.text isEqualToString:@"Full Name"] ||
        [_textFieldEmail.text isEqualToString:@"Email Address"] ||
        [_textFieldPhone.text isEqualToString:@"Phone Number"] ||
        [_textFieldUsername.text isEqualToString:@""] ||
        [_textFieldEmail.text isEqualToString:@""] ||
        [_textFieldPhone.text isEqualToString:@""]) {
        
        [commonUtils showAlert:@"Registration" withMessage:@"Please fill information" view:self];
        return;
    }
    if (![commonUtils validateEmail:_textFieldEmail.text]) {
        [commonUtils showAlert:@"Registration" withMessage:@"Please input valid Email Address" view:self];
        return;
    }
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    NSString *string = appController.strUserId;
    NSMutableDictionary *dic = [appController.dicUserInfo objectForKey:@"user_name"];
    [userInfo setObject:appController.strUserId forKey:@"user_id"];
    [userInfo setObject:_textFieldEmail.text forKey:@"user_email"];
    [userInfo setObject:_textFieldPassword.text forKey:@"password"];
    [userInfo setObject:_textFieldUsername.text forKey:@"user_name"];
    [userInfo setObject:_textFieldPhone.text forKey:@"phone"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestUpdateProfile:userInfo];
    });
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request API
- (void) requestUpdateProfile:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_USER_UPDATE withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.strUserId = [result objectForKey:@"user_id"];
            appController.dicUserInfo = [result objectForKey:@"user_info"];
            
            [commonUtils setUserDefault:@"user_id" withFormat:appController.strUserId];
            [commonUtils setUserDefaultDic:@"user_info" withDic:appController.dicUserInfo];
            [commonUtils showAlert: @"" withMessage:@"Updated successfully." view:self];
            
        } else if([status intValue] == 2) {
            [commonUtils showAlert: @"" withMessage:[result objectForKey:@"message"] view:self];
        } else if([status intValue] == 3) {
            [commonUtils showAlert: @"" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
