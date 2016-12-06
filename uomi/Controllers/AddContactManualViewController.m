//
//  AddContactManualViewController.m
//  uomi
//
//  Created by scs on 10/29/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "AddContactManualViewController.h"
#import "ContactTableViewCell.h"
#import "ManualInputViewController.h"

@interface AddContactManualViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrContacts;
    NSMutableArray *arrColors;
}
@end

@implementation AddContactManualViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    arrColors = [commonUtils getColorArray];
    arrContacts = [appController.arrContacts mutableCopy];
    
    _tblContacts.delegate = self;
    _tblContacts.dataSource = self;
    [_tblContacts reloadData];
    
}

#pragma mark-UITableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strTableIdentifier = @"ContactTableViewCell";
    ContactTableViewCell* cell = (ContactTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    NSMutableDictionary *dicContact = [arrContacts objectAtIndex:indexPath.row];
    NSString *strUserName = [dicContact objectForKey:@"user_name"];
    int nUserId = [[dicContact objectForKey:@"user_id"] intValue];
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblUsername.text = strUserName;
    cell.lblShortname.text = shortName;
    
    if ([[dicContact objectForKey:@"user_image"] isEqualToString:@""]) {
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:nUserId % arrColors.count];
        cell.lblShortname.hidden = NO;
    }
    else {
        cell.imgAvatar.image = [UIImage imageNamed: [dicContact objectForKey:@"user_image"]];
        cell.lblShortname.hidden = YES;
        cell.imgAvatar.backgroundColor = [UIColor clearColor];
    }
    
    cell.imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imgAvatar.layer.shadowOffset = CGSizeZero;
    cell.imgAvatar.layer.shadowRadius = 1.0;
    cell.imgAvatar.layer.shadowOpacity = 0.2;
    cell.imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:cell.imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ManualInputViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ManualInputViewController"];
    VC.dicSelectedUser = [arrContacts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
