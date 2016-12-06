//
//  ReceiptViewController.h
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblReceipt;
@property (strong, nonatomic) IBOutlet UITableView *tblPaid;
@property (strong, nonatomic) IBOutlet UIButton *btnPaid;
@property (strong, nonatomic) IBOutlet UIButton *btnReceipt;
@property (strong, nonatomic) IBOutlet UIView *viewDarkBack;
@property (strong, nonatomic) IBOutlet UIView *viewDetailShadow;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;
@property (strong, nonatomic) IBOutlet UIView *viewDetailColorbar;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailContent;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailToUser;
@property (strong, nonatomic) IBOutlet UIButton *btnPayNow;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgDetailPaidFlag;
@property (strong, nonatomic) IBOutlet UIImageView *imgDetailAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailShortName;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;
@property (strong, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (strong, nonatomic) IBOutlet UIImageView *imgSearch;


- (IBAction)OnViewPaid:(id)sender;
- (IBAction)OnViewReceipt:(id)sender;
- (IBAction)OnSearch:(id)sender;
- (IBAction)OnPaynow:(id)sender;
- (IBAction)OnFilter:(id)sender;
- (IBAction)OnClear:(id)sender;

@end
