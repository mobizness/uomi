//
//  ManualInputViewController.h
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualInputViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblShortname;
@property (strong, nonatomic) IBOutlet UITableView *tblInput;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UIView *viewConfirm;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet NSMutableDictionary *dicSelectedUser;

- (IBAction)OnAdd:(id)sender;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnConfirm:(id)sender;
@end
