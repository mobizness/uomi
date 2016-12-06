//
//  SettingsViewController.h
//  uomi
//
//  Created by scs on 11/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
- (IBAction)OnUpdateProfile:(id)sender;
- (IBAction)OnBack:(id)sender;
@end
