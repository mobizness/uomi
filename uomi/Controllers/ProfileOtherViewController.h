//
//  ProfileOtherViewController.h
//  uomi
//
//  Created by scs on 10/24/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileOtherViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblShortName;
@property (strong, nonatomic) IBOutlet UILabel *lblPaid;
@property (strong, nonatomic) IBOutlet UILabel *lblReceived;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (nonatomic, strong) NSMutableDictionary *dicUserInfo;

- (IBAction)OnBack:(id)sender;
- (IBAction)OnSend:(id)sender;
- (IBAction)OnRequest:(id)sender;
- (IBAction)OnSearch:(id)sender;
@end
