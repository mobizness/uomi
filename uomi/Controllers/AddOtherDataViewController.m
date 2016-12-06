//
//  AddOtherDataViewController.m
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "AddOtherDataViewController.h"
#import "SplitUserCollectionViewCell.h"
#import "AddContactManualViewController.h"
#import "ContactTableViewCell.h"
#import "ReceiptDetailViewController.h"

@interface AddOtherDataViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *arrUsers;
    NSMutableArray *arrColors;
    CGSize orignal;
    NSString *date;
}
@end
@implementation AddOtherDataViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrColors =[commonUtils getColorArray];
    _tblUsers.delegate = self;
    _tblUsers.dataSource = self;
    
    appController.selected_users = [[NSMutableArray alloc] init];
    appController.selectedCategory = [[NSMutableDictionary alloc] init];
    
    [_datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSString *strDate = [commonUtils dateToString: [NSDate date] dateFormat: @"dd MMMM yyyy"];
    [_textfieldDate setText:strDate];
    
    date = [commonUtils dateToString:[NSDate date] dateFormat:@"yyyy-MM-dd"];
    
    [self.textfieldTitle addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textfieldDate addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewDidAppear:(BOOL)animated {
    arrUsers = [appController.selected_users mutableCopy];

    [self refreshSize];
    
    _imgCategory.image = [UIImage imageNamed:[appController.selectedCategory objectForKey:@"cat_image"]];
    if (appController.selectedCategory == nil || appController.selectedCategory.count == 0 || [[appController.selectedCategory objectForKey:@"cat_image"] isEqualToString:@""]) {
        [_btnCategory setTitle:@"Category" forState:UIControlStateNormal];
    }
    else {
        [_btnCategory setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    [self calculateTotalPrice];
    [self checkEnableSend];
}

- (void) calculateTotalPrice {
    Float32 totalPrice = 0;
    for (int i = 0; i < arrUsers.count; i++) {
        Float32 price = [[[[arrUsers objectAtIndex:i] objectForKey:@"total_price"] substringFromIndex:1] floatValue];
        totalPrice += price;
    }
    _lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
}

- (void) refreshSize {
    [_tblUsers reloadData];
    CGRect rectConfirm = _viewSend.frame;
    CGRect rectTable = _tblUsers.frame;
    rectTable.size.height = _tblUsers.rowHeight * (arrUsers.count + 1);
    rectConfirm.origin.y = _tblUsers.frame.origin.y + _tblUsers.rowHeight * (arrUsers.count + 1);
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    
    if (rectConfirm.origin.y + rectConfirm.size.height < height) {
        rectConfirm.origin.y = height - rectConfirm.size.height - 20;
        _tblUsers.frame = rectTable;
        _viewSend.frame = rectConfirm;
        
        return;
    }
    
    _tblUsers.frame = rectTable;
    _viewSend.frame = rectConfirm;
    
    _viewScroll.contentSize = CGSizeMake(_viewScroll.frame.size.width, rectTable.origin.y + rectTable.size.height + rectConfirm.size.height);
    
}

- (void) textFieldDidChange : (UITextField*)textField {   
    [self checkEnableSend];
}

#pragma mark - Functions & Events

- (void)checkEnableSend {
    if (appController.selectedCategory == nil || appController.selectedCategory.count == 0 || [_textfieldTitle.text isEqualToString:@""] || arrUsers.count == 0) {
        _btnSend.hidden = true;
        return;
    }
    _btnSend.hidden = false;
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    [_textfieldDate setText:[commonUtils dateToString: [sender date] dateFormat: @"dd MMMM yyyy"]];
    date = [commonUtils dateToString:[sender date] dateFormat:@"yyyy-MM-dd"];
}

#pragma mark-UITableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrUsers.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strTableIdentifier = @"ContactTableViewCell";
    ContactTableViewCell* cell = (ContactTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.imgAvatar.image = [UIImage imageNamed:@"icon_add_person.png"];
        cell.lblUsername.text = @"Add person";
        cell.lblShortname.hidden = YES;
        cell.lblValue.hidden = YES;
        cell.lblBar.hidden = YES;
        return cell;
    }
    NSMutableDictionary *dicSplit = [arrUsers objectAtIndex:indexPath.row - 1];
    NSString *firstName = [commonUtils getFirstName:[dicSplit objectForKey:@"user_name"]];
    int nUserId = [[dicSplit objectForKey:@"user_id"] intValue];
    
    cell.lblUsername.text = firstName;
    cell.imgAvatar.image = [UIImage imageNamed:[commonUtils getFirstName:[dicSplit objectForKey:@"user_image"]]];
    
    Float32 price = [[[[arrUsers objectAtIndex:indexPath.row - 1] objectForKey:@"total_price"] substringFromIndex:1] floatValue];
    
    cell.lblValue.text = [NSString stringWithFormat:@"$%.2f", price];
    
    NSString *strUserName = [dicSplit objectForKey:@"user_name"];
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblShortname.text = shortName;
    
    if ([[dicSplit objectForKey:@"user_image"] isEqualToString:@""]) {
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex: nUserId % arrColors.count];
        cell.lblShortname.hidden = NO;
    }
    else {
        [commonUtils setImageViewAFNetworking:cell.imgAvatar withImageUrl:[dicSplit objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];

        cell.lblShortname.hidden = YES;
        cell.imgAvatar.backgroundColor = [UIColor clearColor];
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
    
    if (indexPath.row == 0) {
        AddContactManualViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddContactManualViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (IBAction)OnCategory:(id)sender {
    
}

- (IBAction)OnSend:(id)sender {
    if ([_textfieldTitle.text isEqualToString:@""]) {
        [commonUtils showAlert:@"Please input Title." withMessage:@"" view:self];
        return;
    }
    if (arrUsers.count == 0) {
        [commonUtils showAlert:@"Please add your contacts." withMessage:@"" view:self];
        return;
    }
    if (appController.selectedCategory == nil || appController.selectedCategory.count == 0) {
        [commonUtils showAlert:@"Please select category." withMessage:@"" view:self];
        return;
    }
    
    NSMutableArray *arrUserIds = [[NSMutableArray alloc] init];
    NSMutableArray *arrPrices = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicUser in arrUsers) {
        [arrUserIds addObject:[dicUser objectForKey:@"user_id"]];
        
        [arrPrices addObject:[[dicUser objectForKey:@"total_price"] substringFromIndex:1]];
    }
    
    NSString *split_users = [arrUserIds componentsJoinedByString:@"|"];
    NSString *split_prices = [arrPrices componentsJoinedByString:@"|"];
    NSString *receipt_price = [_lblTotalPrice.text substringFromIndex:1];
    NSString *receipt_title = _textfieldTitle.text;
    NSString *receipt_type = @"manual";
    NSString *receipt_date = date;
    NSString *catgory_id = [appController.selectedCategory objectForKey:@"cat_name"];
    NSString *sender_id = appController.strUserId;
    
    NSMutableDictionary *receiptInfo = [[NSMutableDictionary alloc] init];
    [receiptInfo setObject:receipt_price forKey:@"receipt_price"];
    [receiptInfo setObject:split_prices forKey:@"split_prices"];
    [receiptInfo setObject:receipt_title forKey:@"receipt_title"];
    [receiptInfo setObject:receipt_type forKey:@"receipt_type"];
    [receiptInfo setObject:receipt_date forKey:@"receipt_date"];
    [receiptInfo setObject:catgory_id forKey:@"category_id"];
    [receiptInfo setObject:sender_id forKey:@"sender_id"];
    [receiptInfo setObject:split_users forKey:@"split_users"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSendSplit:receiptInfo];
    });

}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnShowPicker:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _viewPicker.transform = CGAffineTransformMakeTranslation(0, (-1) * _viewPicker.frame.size.height);
        [_viewPicker setHidden:NO];
    }];
}

- (IBAction)OnHidePicker:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _viewPicker.transform = CGAffineTransformMakeTranslation(0, 0);
        [_viewPicker setHidden:YES];
    }];
}

#pragma mark - Request API
- (void) requestSendSplit:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SEND_SPLIT withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            ReceiptDetailViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptDetailViewController"];
            VC.dicReceiptDetail = [result objectForKey:@"receipts_info"];
            VC.isFullPaid = false;
            VC.isPaid = 1;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [commonUtils showAlert: @"Login" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
