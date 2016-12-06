//
//  ContactsViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactTableViewCell.h"
#import "ContactScan.h"
#import "ProfileOtherViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate> {
    NSMutableArray *arrContacts;
    NSMutableArray *arrColors;
    NSMutableArray *arrInvites;
    NSMutableDictionary *dicSelected;
}
@end
@implementation ContactsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;

    arrContacts = [appController.arrContacts mutableCopy];
    arrInvites = [[NSMutableArray alloc] init];
    arrColors = [commonUtils getColorArray];
    
    
    _viewInvite.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewInvite.layer.shadowOffset = CGSizeMake(0, -2);
    _viewInvite.layer.shadowRadius = 1.0;
    _viewInvite.layer.shadowOpacity = 0.2;
    _viewInvite.layer.masksToBounds = NO;

    _tblContact.delegate = self;
    _tblContact.dataSource = self;

    
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestContacts:userInfo];
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)getContacts {
    [appController.arrContacts removeAllObjects];
    for (int i = 0; i < appController.arrAllUsers.count; i++) {
        NSMutableDictionary *dicUser = [appController.arrAllUsers objectAtIndex:i];
        for (int j = 0; j < appController.arrPhoneContacts.count; j++) {
            NSMutableDictionary *dicPhoneContact = [appController.arrPhoneContacts objectAtIndex:j];
            NSArray *arrphone = [dicPhoneContact objectForKey:@"phone"];
            BOOL flag = false;
            for (int k = 0; k < arrphone.count; k++) {
                NSString *strphone = [arrphone objectAtIndex:k];
                if ([[dicUser objectForKey:@"phone"] isEqualToString:strphone] || [[NSString stringWithFormat:@"+%@", [dicUser objectForKey:@"phone"]] isEqualToString:strphone] || [[dicUser objectForKey:@"phone"] isEqualToString:[NSString stringWithFormat:@"+%@", strphone]]) {
                    [appController.arrContacts addObject:dicUser];
                    flag = true;
                    break;
                }
            }
            if (flag) {
                [arrInvites addObject:dicPhoneContact];
                break;
            }
        }
    }
}


- (void)showSMS: (int)index {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
//    [commonUtils showSmallIndicator:self.view];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    messageController.recipients = [[arrInvites objectAtIndex:index] objectForKey:@"phone"];
    messageController.body = @"Join uomi to pay me back or get paid, in only minutes! bit.ly/uomiapp";

    [self presentViewController:messageController animated:YES completion:nil];
}


#pragma mark-UITableViewDelegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return arrContacts.count + 1;
    }
    else {
        return arrInvites.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strTableIdentifier = @"ContactTableViewCell";
    ContactTableViewCell* cell = (ContactTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    if (indexPath.section == 0 && indexPath.row == arrContacts.count) {
        cell.lblShortname.hidden = true;
        cell.lblUsername.hidden = true;
        cell.lblPhone.hidden = true;
        cell.lblBar.hidden = true;
        cell.lblValue.hidden = true;
        cell.btnInvite.hidden = true;
        cell.imgChecked.hidden = true;
        cell.imgAvatar.hidden = true;
        return cell;
    }
    else {
        cell.lblShortname.hidden = false;
        cell.lblUsername.hidden = false;
        cell.lblPhone.hidden = false;
        cell.lblBar.hidden = false;
        cell.lblValue.hidden = false;
        cell.btnInvite.hidden = false;
        cell.imgChecked.hidden = false;
        cell.imgAvatar.hidden = false;
    }
    
    NSMutableDictionary *dicContact = [arrContacts objectAtIndex:indexPath.row];
    if (indexPath.section == 1) {
        dicContact = [arrInvites objectAtIndex:indexPath.row];
    }
    NSString *strUserName = [dicContact objectForKey:@"user_name"];

    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblUsername.text = strUserName;
    cell.lblShortname.text = shortName;
    if (indexPath.section == 0) {
        cell.lblPhone.text = [dicContact objectForKey:@"phone"];
    }
    else {
        cell.lblPhone.text = [[dicContact objectForKey:@"phone"] objectAtIndex:0];
    }
    
    Float32 price = [[dicContact objectForKey:@"received"] floatValue] - [[dicContact objectForKey:@"paid"] floatValue];
    
    
    
    if (indexPath.section == 0) {
        if (price >= 0) {
            cell.lblValue.textColor = RGBA(40, 148, 64, 1);
            cell.lblValue.text = [NSString stringWithFormat:@"+%.2f", price];
        }
        else {
            cell.lblValue.textColor = RGBA(191, 50, 50, 1);
            cell.lblValue.text = [NSString stringWithFormat:@"%.2f", price];
        }
        
        if ([[dicContact objectForKey:@"user_image"] isEqualToString:@""]) {
            cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
            cell.lblShortname.hidden = NO;
        }
        else {
            [commonUtils setImageViewAFNetworking:cell.imgAvatar withImageUrl:[dicContact objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];
            cell.lblShortname.hidden = YES;
            cell.imgAvatar.backgroundColor = [UIColor clearColor];
        }
        cell.btnInvite.hidden = true;
    }
    else {
        cell.btnInvite.hidden = false;
        cell.btnInvite.tag = indexPath.row;
        cell.imgAvatar.image = nil;
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
        cell.lblShortname.hidden = NO;
    }
    [cell.btnInvite addTarget:self action:@selector (invite:)forControlEvents:UIControlEventTouchUpInside];
    
//    cell.imgAvatar.layer.cornerRadius = cell.imgAvatar.frame.size.width / 2;
    //    cell.viewReceipt.layer.masksToBounds = true;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == arrContacts.count) {
        return 30;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dicUser = [arrContacts objectAtIndex:indexPath.row];
    
    ProfileOtherViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileOtherViewController"];
    VC.dicUserInfo = dicUser;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)invite:(UIButton*)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showSMS: sender.tag];
    });
    
}

#pragma mark - IBAction

- (IBAction)OnInvite:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self showSMS:];
    });
    
}

- (IBAction)OnAddPerson:(id)sender {
    
}



#pragma mark - Request API
- (void) requestContacts:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_CONTACTS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            [appController.arrAllUsers removeAllObjects];
            appController.arrAllUsers = [result objectForKey:@"user_info"];
            [self getContacts];
            [_tblContact reloadData];
        } else {
            [commonUtils showAlert: @"Contacts" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
