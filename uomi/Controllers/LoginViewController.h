//
//  LoginViewController.h
//  uomi
//
//  Created by scs on 10/22/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textfieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;

- (IBAction)OnLogin:(id)sender;
- (IBAction)OnBack:(id)sender;

@end
