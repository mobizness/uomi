//
//  ManualInputTableViewCell.h
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualInputTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblItemNumber;
@property (strong, nonatomic) IBOutlet UITextField *textFieldItemName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPrice;
@end
