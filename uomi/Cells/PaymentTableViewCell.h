//
//  PaymentTableViewCell.h
//  uomi
//
//  Created by scs on 10/22/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viewColorBar;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblToUser;
@property (strong, nonatomic) IBOutlet UIView *viewReceipt;
@property (strong, nonatomic) IBOutlet UIView *viewShadow;
@property (strong, nonatomic) IBOutlet UIImageView *imgPaidFlag;

@property (strong, nonatomic) IBOutlet UITableView *tblSplit;
@end
