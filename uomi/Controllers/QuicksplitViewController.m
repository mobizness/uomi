//
//  QuicksplitViewController.m
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "QuicksplitViewController.h"
#import "SplitUserCollectionViewCell.h"
#import "AddcontactViewController.h"
#import "ReceiptDetailViewController.h"

@interface QuicksplitViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *arrUsers;
    NSMutableArray *arrColors;
    CGSize orignal;
    NSString *date;
}
@end
@implementation QuicksplitViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrColors =[commonUtils getColorArray];
    _collectionUsers.delegate = self;
    _collectionUsers.dataSource = self;

    appController.selected_users = [[NSMutableArray alloc] init];
    appController.selectedCategory = [[NSMutableDictionary alloc] init];
    
    NSString *strDate = [commonUtils dateToString: [NSDate date] dateFormat: @"dd MMMM yyyy"];
    [_textfieldDate setText:strDate];
    
    date = [commonUtils dateToString:[NSDate date] dateFormat:@"yyyy-MM-dd"];
    
    
    [self.textfieldAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textfieldTitle addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated {
    float width = [[UIScreen mainScreen] bounds].size.width;
    arrUsers = [appController.selected_users mutableCopy];
    if (arrUsers.count > 0) {
        _imgNumber2.hidden = YES;
        _imgNumber3.hidden = NO;
        [_lblContacts setTextColor:COLOR_BROWN];
        _imgAvataricon.hidden = NO;
        _lblSplitPrice.hidden = NO;
        NSString *amount = _textfieldAmount.text;
        CGFloat split = 0;
        if (![amount isEqualToString:@""]) {
            split = [[amount substringFromIndex:1] floatValue] / arrUsers.count;
        }
        _lblSplitPrice.text = [NSString stringWithFormat:@"= $%.2f   each", split];

    }
    else {
        _imgAvataricon.hidden = YES;
        _lblSplitPrice.hidden = YES;
        
    }

    [_collectionUsers reloadData];
    
    
    _imgCategory.image = [UIImage imageNamed:[appController.selectedCategory objectForKey:@"cat_image"]];
    if (appController.selectedCategory == nil || appController.selectedCategory.count == 0 || [[appController.selectedCategory objectForKey:@"cat_image"] isEqualToString:@""]) {
        [_btnCategory setTitle:@"Category" forState:UIControlStateNormal];
    }
    else {
        [_btnCategory setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    [self checkEnableSend];
}


-(void) dueDateChanged:(UIDatePicker *)sender {
    [_textfieldDate setText:[commonUtils dateToString: [sender date] dateFormat: @"dd MMMM yyyy"]];
    date = [commonUtils dateToString:[sender date] dateFormat:@"yyyy-MM-dd"];
}

- (void) textFieldDidChange : (UITextField*)textField {
    if (textField.tag == 1) {
        NSString* amount = textField.text;
        if (amount.length > 1) {
            if ([[amount substringToIndex:1] isEqualToString:@"$"]) {
                return;
            }
            else {
                textField.text = [NSString stringWithFormat:@"$%@", amount];
            }
            
        }
        else if (amount.length == 1) {
            if ([amount isEqualToString:@"$"]) {
                textField.text = @"";
            }
            else {
                _imgNumber2.hidden = NO;
                _imgNumber1.hidden = YES;
                [_lblAmount setTextColor:COLOR_BROWN];
                [_lblContacts setTextColor:COLOR_BROWN];
                
                textField.text = [NSString stringWithFormat:@"$%@", amount];
            }
        }
        else {
            
        }
        
    }
    
    [self checkEnableSend];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        _imgNumber1.hidden = false;
        _imgNumber2.hidden = true;
        _imgNumber3.hidden = true;
        
    }
    else {
        _imgNumber1.hidden = true;
        _imgNumber2.hidden = false;
        _imgNumber3.hidden = false;
        
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return arrUsers.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SplitUserCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SplitUserCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == arrUsers.count) {
        cell.imgAvatar.image = [UIImage imageNamed:@"icon_add_person.png"];
        cell.imgAvatar.backgroundColor = [UIColor clearColor];
        cell.lblUsername.text = @"";
        cell.lblShortname.text = @"";
        return cell;
    }
    NSMutableDictionary *dicSplit = [arrUsers objectAtIndex:indexPath.row];
    NSString *firstName = [commonUtils getFirstName:[dicSplit objectForKey:@"user_name"]];
    cell.lblUsername.text = firstName;
    cell.imgAvatar.image = [UIImage imageNamed:[commonUtils getFirstName:[dicSplit objectForKey:@"user_image"]]];
    
    NSString *strUserName = [dicSplit objectForKey:@"user_name"];
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblShortname.text = shortName;
    
    if ([[dicSplit objectForKey:@"user_image"] isEqualToString:@""]) {
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == arrUsers.count) {
        AddcontactViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddcontactViewController"];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    int viewWidth = _collectionUsers.frame.size.width;
    int totalCellWidth = 77 * (arrUsers.count + 1);
    
    int leftInset = (viewWidth - totalCellWidth) / 2;
    if (leftInset < 0) {
        leftInset = 0;
    }
    
    return UIEdgeInsetsMake(0, leftInset, 0, leftInset);
}


#pragma mark - Functions & Events

- (void)checkEnableSend {
    BOOL flag = YES;

    if (appController.selectedCategory == nil || appController.selectedCategory.count == 0 || [_textfieldTitle.text isEqualToString:@""]) {
        _imgNumber1.hidden = YES;
        _imgNumber2.hidden = YES;
        _imgNumber3.hidden = NO;

        flag = NO;
    }
    else {
        _lblDetail.textColor = COLOR_BROWN;
    }

    
    if (arrUsers.count == 0) {
        _imgNumber1.hidden = YES;
        _imgNumber2.hidden = NO;
        _imgNumber3.hidden = YES;
        
        _imgAvataricon.hidden = YES;
        _lblSplitPrice.hidden = YES;
        flag = NO;
    }
    else {
        _lblContacts.textColor = COLOR_BROWN;
        
        _imgAvataricon.hidden = NO;
        _lblSplitPrice.hidden = NO;
        NSString *amount = _textfieldAmount.text;
        CGFloat split = 0;
        if (![amount isEqualToString:@""]) {
            split = [[amount substringFromIndex:1] floatValue] / arrUsers.count;
        }
        _lblSplitPrice.text = [NSString stringWithFormat:@"= $%.2f   each", split];
        
    }
    
    if ([_textfieldAmount.text isEqualToString:@""] || [_textfieldAmount.text isEqualToString:@"$0"]) {
        _imgNumber1.hidden = NO;
        _imgNumber2.hidden = YES;
        _imgNumber3.hidden = YES;
        flag = NO;
    }
    else {
        _lblAmount.textColor = COLOR_BROWN;
    }
    
    if (flag) {
        _btnSend.hidden = NO;
        _imgNumber1.hidden = YES;
        _imgNumber2.hidden = YES;
        _imgNumber3.hidden = YES;
    }
    
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSend:(id)sender {
    NSMutableArray *arrUserIds = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicUser in arrUsers) {
        [arrUserIds addObject:[dicUser objectForKey:@"user_id"]];
    }
    NSString *split_users = [arrUserIds componentsJoinedByString:@"|"];
    NSString *receipt_price = [_textfieldAmount.text substringFromIndex:1];
    NSString *receipt_title = _textfieldTitle.text;
    NSString *receipt_type = @"quick_split";
    NSString *receipt_date = date;
    NSString *catgory_id = [appController.selectedCategory objectForKey:@"cat_name"];
    NSString *sender_id = appController.strUserId;
    
    NSMutableDictionary *receiptInfo = [[NSMutableDictionary alloc] init];
    [receiptInfo setObject:receipt_price forKey:@"receipt_price"];
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

- (IBAction)OnShowPicker:(id)sender {
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
            VC.isPaid = 1;
            VC.isFullPaid = false;
            VC.dicReceiptDetail = [result objectForKey:@"receipts_info"];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [commonUtils showAlert: @"Login" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
