//
//  AddcontactViewController.m
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "AddcontactViewController.h"
#import "ContactTableViewCell.h"

@interface AddcontactViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrContacts;
    NSMutableArray *arrColors;
    NSMutableArray *arrSelected;
}
@end
@implementation AddcontactViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    arrContacts = [appController.arrContacts mutableCopy];
    arrColors = [commonUtils getColorArray];
    
    arrSelected = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *user in arrContacts) {
        [arrSelected addObject:@"0"];
    }
    
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
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblUsername.text = strUserName;
    cell.lblShortname.text = shortName;
    
    if ([[dicContact objectForKey:@"user_image"] isEqualToString:@""]) {
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
        cell.lblShortname.hidden = NO;
    }
    else {

        [commonUtils setImageViewAFNetworking:cell.imgAvatar withImageUrl:[dicContact objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];
        cell.lblShortname.hidden = YES;
        cell.imgAvatar.backgroundColor = [UIColor clearColor];
    }
    
    if ([[arrSelected objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        cell.imgChecked.hidden = NO;
    }
    else {
        cell.imgChecked.hidden = YES;
    }
    
//    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.width / 2;
//    //    cell.viewReceipt.layer.masksToBounds = true;
//    
//    cell.imgAvatar.layer.borderColor = [UIColor clearColor].CGColor;
//    cell.imgAvatar.layer.borderWidth = 0.5;
//    cell.imgAvatar.clipsToBounds = YES;
    
    cell.imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imgAvatar.layer.shadowOffset = CGSizeZero;
    cell.imgAvatar.layer.shadowRadius = 1.0;
    cell.imgAvatar.layer.shadowOpacity = 0.2;
    cell.imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:cell.imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[arrSelected objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        [arrSelected replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else {
        [arrSelected replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [_tblContacts reloadData];
}

- (IBAction)OnBack:(id)sender {
        
    int nIndex = 0;
    for (NSMutableDictionary *user in arrContacts) {
        if ([[arrSelected objectAtIndex:nIndex] isEqualToString:@"1"]) {
            [appController.selected_users addObject:user];
        }
        nIndex++;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
