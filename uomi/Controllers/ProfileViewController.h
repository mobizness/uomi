//
//  ProfileViewController.h
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewNotification;
@property (strong, nonatomic) IBOutlet UIView *viewLogout;
@property (strong, nonatomic) IBOutlet UILabel *lblPaid;
@property (strong, nonatomic) IBOutlet UILabel *lblReceived;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblShortName;
@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;

- (IBAction)OnSettings:(id)sender;
- (IBAction)OnEditImage:(id)sender;
- (IBAction)OnLogout:(id)sender;

@end
