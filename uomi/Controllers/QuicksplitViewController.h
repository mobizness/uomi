//
//  QuicksplitViewController.h
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuicksplitViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textfieldAmount;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionUsers;
@property (strong, nonatomic) IBOutlet UITextField *textfieldTitle;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblContacts;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UIImageView *imgNumber1;
@property (strong, nonatomic) IBOutlet UIImageView *imgNumber2;
@property (strong, nonatomic) IBOutlet UIImageView *imgNumber3;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitPrice;
@property (strong, nonatomic) IBOutlet UIImageView *imgAvataricon;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategory;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;

- (IBAction)OnBack:(id)sender;
- (IBAction)OnSend:(id)sender;

- (IBAction)OnShowPicker:(id)sender;
- (IBAction)OnHidePicker:(id)sender;
@end
