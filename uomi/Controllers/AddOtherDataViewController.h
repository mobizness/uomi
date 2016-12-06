//
//  AddOtherDataViewController.h
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOtherDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblUsers;
@property (strong, nonatomic) IBOutlet UIScrollView *viewScroll;
@property (strong, nonatomic) IBOutlet UITextField *textfieldTitle;
@property (strong, nonatomic) IBOutlet UITextField *textfieldDate;
@property (strong, nonatomic) IBOutlet UILabel *lblContacts;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
;
@property (strong, nonatomic) IBOutlet UIButton *btnCategory;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIImageView *imgCategory;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UIView *viewSend;

@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)OnCategory:(id)sender;
- (IBAction)OnSend:(id)sender;
- (IBAction)OnBack:(id)sender;
- (IBAction)OnShowPicker:(id)sender;
- (IBAction)OnHidePicker:(id)sender;
@end
