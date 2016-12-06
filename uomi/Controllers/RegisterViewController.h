//
//  RegisterViewController.h
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textfieldFullname;
@property (strong, nonatomic) IBOutlet UITextField *textfieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textfieldPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblTerms;

- (IBAction)OnSignup:(id)sender;
- (IBAction)OnTermsConditions:(id)sender;
- (IBAction)OnPrivacyPolicy:(id)sender;
@end
