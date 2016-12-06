//
//  AddNewViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "AddNewViewController.h"

@interface AddNewViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
}
@end
@implementation AddNewViewController
- (void)viewDidLoad {
    self.hidesBottomBarWhenPushed = NO;
}
- (IBAction)OnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OnScan:(id)sender {
    @try {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.videoMaximumDuration = 15;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    @catch (NSException *exception) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Message"
                                     message:@"Can't Access Camera"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
