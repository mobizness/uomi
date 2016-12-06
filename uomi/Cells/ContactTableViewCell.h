//
//  ContactTableViewCell.h
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblShortname;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UIImageView *imgChecked;
@property (strong, nonatomic) IBOutlet UILabel *lblBar;
@property (strong, nonatomic) IBOutlet UIButton *btnInvite;
@end
