//
//  FeedTableViewCell.h
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgEventType;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@end
