//
//  FirstViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "FirstViewController.h"
#import "TabbarController.h"
#import "Onboarding3ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface FirstViewController () {
    
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([commonUtils isLogined]) {
        appController.strUserId = [commonUtils getUserDefault:@"user_id"];
        appController.dicUserInfo = [commonUtils getUserDefaultDicByKey:@"user_info"];
        TabbarController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
    }
    
}

#pragma mark-loginWithFacebook
- (void)fetchUserInfo {

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name,  first_name, last_name, picture.type(large), email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"facebook fetched info : %@", result);
             
             NSDictionary *temp = (NSDictionary *)result;
             NSMutableDictionary *userTemp = [[NSMutableDictionary alloc] initWithDictionary:temp];
             NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
             [userInfo setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
             [userInfo setObject:@"1" forKey:@"signup_mode"];
             [userInfo setObject:[temp objectForKey:@"name"] forKey:@"user_name"];
             
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
             [self requestLoginFB:userInfo];
         }
     }];
    
}

- (void) requestLoginFB:(id) params {
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
            
            [commonUtils setUserDefault:@"is_logined" withFormat:@"1"];
            
            if ([[appController.dicUserInfo objectForKey:@"status"] intValue] == 0) {
                Onboarding3ViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding3ViewController"];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
            else {
                [commonUtils setUserDefault:@"is_logined" withFormat:@"1"];
                
                TabbarController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
                [self.navigationController pushViewController:VC animated:YES];
            }
            
            
        } else if([status intValue] == 2) {
            
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status" view:self];
    }
}

- (IBAction)OnFBLogin:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_birthday", @"user_photos"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in with token : @%@", result.token);
            if ([result.grantedPermissions containsObject:@"email"]) {
                NSLog(@"result is:%@",result);
                [self fetchUserInfo];
            }
        }
    }];
    
}



@end
