//
//  FirstpaymentViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "FirstpaymentViewController.h"
#import "ContactScan.h"

@interface FirstpaymentViewController (){
    
}
@end
@implementation FirstpaymentViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestContacts:userInfo];
    });
    

}

- (void)filterContacts {
    for (int i = 0; i < appController.arrAllUsers.count; i++) {
        NSMutableDictionary *dicContact = [appController.arrAllUsers objectAtIndex:i];
        NSString *phone = [dicContact objectForKey:@"phone"];
        BOOL flag = false;
        for (int j = 0; i < appController.arrAllUsers.count; i++) {
            NSMutableDictionary *dicUser = [appController.arrAllUsers objectAtIndex:j];
            if ([[dicContact objectForKey:@"phone"] isEqualToString:phone]) {
                flag = true;
                break;
            }
        }
        if (flag) {
            
        }
    }
}

- (void)getContacts {
    [appController.arrContacts removeAllObjects];
    for (int i = 0; i < appController.arrAllUsers.count; i++) {
        NSMutableDictionary *dicUser = [appController.arrAllUsers objectAtIndex:i];
        for (int j = 0; j < appController.arrPhoneContacts.count; j++) {
            NSMutableDictionary *dicPhoneContact = [appController.arrPhoneContacts objectAtIndex:j];
            NSArray *arrphone = [dicPhoneContact objectForKey:@"phone"];
            BOOL flag = false;
            for (int k = 0; k < arrphone.count; k++) {
                NSString *strphone = [arrphone objectAtIndex:k];
                if ([[dicUser objectForKey:@"phone"] isEqualToString:strphone] || [[NSString stringWithFormat:@"+%@", [dicUser objectForKey:@"phone"]] isEqualToString:strphone] || [[dicUser objectForKey:@"phone"] isEqualToString:[NSString stringWithFormat:@"+%@", strphone]]) {
                    [appController.arrContacts addObject:dicUser];
                    flag = true;
                    break;
                }
            }
            if (flag) break;
        }
    }
}


#pragma mark - Request API
- (void) requestContacts:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_CONTACTS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            [appController.arrAllUsers removeAllObjects];
            appController.arrAllUsers = [result objectForKey:@"user_info"];
            [self getContacts];
            
        } else {
            [commonUtils showAlert: @"Login" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
