//
//  ContactsViewController.h
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblContact;
@property (strong, nonatomic) IBOutlet UIView *viewInvite;

- (IBAction)OnInvite:(id)sender;
- (IBAction)OnAddPerson:(id)sender;
@end
