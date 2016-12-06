//
//  ReceiptDetailViewController.h
//  uomi
//
//  Created by scs on 10/23/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tblSplit;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionUsers;
@property (strong, nonatomic) IBOutlet UIView *viewDarkBack;
@property (strong, nonatomic) IBOutlet UIView *viewDetailShadow;
@property (strong, nonatomic) IBOutlet UIView *viewDetailColorbar;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblSplitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailToUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDetailDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgNewMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblMessages;
@property (strong, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptDate;
@property (strong, nonatomic) IBOutlet UIButton *btnPayNow;
@property (strong, nonatomic) IBOutlet UIView *viewBelow;
@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblDetails;

@property (nonatomic, strong) NSMutableDictionary *dicReceiptDetail;
@property (nonatomic, assign) int isPaid;
@property (nonatomic, assign) BOOL isFullPaid;

- (IBAction)OnBack:(id)sender;
- (IBAction)OnMessage:(id)sender;
- (IBAction)OnPaynow:(id)sender;
@end
