//
//  ReceiptViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ReceiptViewController.h"
#import "PaymentTableViewCell.h"
#import "SplitTableViewCell.h"
#import "ReceiptDetailViewController.h"
#import "FilterViewController.h"

@interface ReceiptViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSMutableArray *arrPaid;
    NSMutableArray *arrUnpaid;
    NSMutableArray *arrReceipts;
    
    NSMutableArray *arrPaid_Filtered;
    NSMutableArray *arrUnpaid_Filtered;
    NSMutableArray *arrReceipt_Filtered;
    
    
    NSMutableArray *arrColors;
    NSMutableArray *arrPaidIcon;
    NSMutableArray *arrUnpaidIcon;
    
    CGSize orignal;
    BOOL isSearch;
    NSString *nSelectedSplitId;
    float maxPrice;
    int maxPeople;
}
@end
@implementation ReceiptViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    arrColors = [commonUtils getColorArray];
    arrPaidIcon = [commonUtils getPaidIconArray];
    arrUnpaidIcon = [commonUtils getUnpaidIconArray];
    
    arrPaid_Filtered = [[NSMutableArray alloc] init];
    arrUnpaid_Filtered = [[NSMutableArray alloc] init];
    arrReceipt_Filtered = [[NSMutableArray alloc] init];
    
    arrReceipts = [AppData sharedData].arrReceipts;
    arrUnpaid = [AppData sharedData].arrUnpaid;
    arrPaid = [AppData sharedData].arrPaid;
    
    maxPrice = 0;
    maxPeople = 0;
    [self getMaxPrice];
    [self getMaxPeople];
    
    [self initizeScreen];
    isSearch = NO;
    
    [self filterResult];
    
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestReceipts:userInfo];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [self filterResult];
}

- (void)initizeScreen {
    
    _tblReceipt.delegate = self;
    _tblReceipt.dataSource = self;
    
    _tblPaid.delegate = self;
    _tblPaid.dataSource = self;
    
    _textFieldSearch.delegate = self;
    
    _viewDetailShadow.layer.cornerRadius = 5;
    _viewDetailShadow.layer.masksToBounds = YES;
    
    _viewDetailShadow.layer.borderColor = [UIColor clearColor].CGColor;
    _viewDetailShadow.layer.borderWidth = 0.5;
    
    _viewDetailShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewDetailShadow.layer.shadowOffset = CGSizeZero;
    _viewDetailShadow.layer.shadowRadius = 3.0;
    _viewDetailShadow.layer.shadowOpacity = 0.2;
    
    _viewDetail.layer.cornerRadius = 5.5;
    _viewDetail.clipsToBounds = YES;
    _viewDetailShadow.layer.masksToBounds = NO;
    
    orignal = _viewDetailShadow.frame.size;
    
//    _imgDetailAvatar.layer.cornerRadius = _imgDetailAvatar.frame.size.width/2;
//    _imgDetailAvatar.layer.borderColor = [UIColor clearColor].CGColor;
//    _imgDetailAvatar.layer.borderWidth = 0.5;
//    _imgDetailAvatar.clipsToBounds = YES;
    
    _imgDetailAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgDetailAvatar.layer.shadowOffset = CGSizeZero;
    _imgDetailAvatar.layer.shadowRadius = 1.0;
    _imgDetailAvatar.layer.shadowOpacity = 0.2;
    _imgDetailAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:_imgDetailAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    
    _textFieldSearch.delegate = self;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissDetail:)];
    [self.viewDarkBack addGestureRecognizer:singleFingerTap];
    

}

- (void)dismissDetail:(UITapGestureRecognizer *)recognizer {
    _viewDetailShadow.hidden = YES;
    _viewDarkBack.hidden = YES;
    
    CGRect rect = _viewDetailShadow.frame;
    rect.size = orignal;
    _viewDetailShadow.frame = rect;
    
    rect = _viewDetail.frame;
    rect.size = orignal;
    _viewDetail.frame = rect;
    
}

- (void)searchReceived {
    if (!isSearch || [_textFieldSearch.text isEqualToString:@""]) {
        [_tblReceipt reloadData];
        return;
    }
    NSMutableArray *arrSearch = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicEvent in arrPaid_Filtered) {
        NSString *title = [[dicEvent objectForKey:@"receipt_title"] lowercaseString];
        
        if ([title rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearch addObject:dicEvent];
            continue;
        }
        if ([title rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearch addObject:dicEvent];
            continue;
        }
        
        NSMutableArray *arrSplit = [dicEvent objectForKey:@"split_info"];
        for (NSMutableDictionary *dicSplit in arrSplit) {
            NSString *user_name = [[dicSplit objectForKey:@"user_name"] lowercaseString];
            
            if ([user_name rangeOfString:_textFieldSearch.text].location != NSNotFound) {
                [arrSearch addObject:dicEvent];
                break;
            }
        }
        
    }
    
    [arrReceipt_Filtered removeAllObjects];
    arrReceipt_Filtered = [arrSearch mutableCopy];
    
    [_tblReceipt reloadData];
}


- (void)searchPaid {
    if (!isSearch || [_textFieldSearch.text isEqualToString:@""]) {
        [_tblPaid reloadData];
        return;
    }
    NSMutableArray *arrSearchPaid = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicEvent in arrPaid_Filtered) {
        NSString *title = [dicEvent objectForKey:@"receipt_title"];
        NSString *user_name = [dicEvent objectForKey:@"user_name"];
        
        if ([title rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearchPaid addObject:dicEvent];
            continue;
        }
        if ([user_name rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearchPaid addObject:dicEvent];
            continue;
        }
    }
    
    [arrPaid_Filtered removeAllObjects];
    arrPaid_Filtered = [arrSearchPaid mutableCopy];
    
    NSMutableArray *arrSearchUnpaid = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicEvent in arrUnpaid_Filtered) {
        NSString *title = [[dicEvent objectForKey:@"receipt_title"] lowercaseString];
        NSString *user_name = [[dicEvent objectForKey:@"user_name"] lowercaseString];
        
        if ([title rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearchUnpaid addObject:dicEvent];
            continue;
        }
        if ([user_name rangeOfString:_textFieldSearch.text].location != NSNotFound) {
            [arrSearchUnpaid addObject:dicEvent];
            continue;
        }
    }
    
    [arrUnpaid_Filtered removeAllObjects];
    arrUnpaid_Filtered = [arrSearchUnpaid mutableCopy];
    [_tblPaid reloadData];
}

- (void)getMaxPrice {
    for (NSMutableDictionary *dicPaid in arrPaid) {
        float price = [[dicPaid objectForKey:@"price"] floatValue];
        if (price > maxPrice) {
            maxPrice = price;
        }
    }
    
    for (NSMutableDictionary *dicPaid in arrUnpaid) {
        float price = [[dicPaid objectForKey:@"price"] floatValue];
        if (price > maxPrice) {
            maxPrice = price;
        }
    }
}

- (void)getMaxPeople {
    for (NSMutableDictionary *dicReceipt in arrReceipts) {
        int nSplit = (int)[[dicReceipt objectForKey:@"split_info"] count];
        if (nSplit > maxPeople) {
            maxPeople = nSplit;
        }
    }
}


- (void)filterResult {
    
    if (_tblPaid.hidden) {
        [self filterReceived];
    }
    else {
        [self filterPaid];
    }
}

- (void)filterReceived {
    NSMutableDictionary *dicFilter = [commonUtils getUserDefaultDicByKey:@"filter_received"];
    
    int upperPeople = [[dicFilter objectForKey:@"people_upper"] intValue];
    int lowerPeople = [[dicFilter objectForKey:@"people_lower"] intValue];
    
    int days = [commonUtils filterDays: [dicFilter objectForKey:@"date"]];
    int isPaid = [[dicFilter objectForKey:@"status"] intValue];
    
    [arrReceipt_Filtered removeAllObjects];

    for (NSMutableDictionary *dicReceipt in arrReceipts) {
        if (isPaid != -1 && [[dicReceipt objectForKey:@"is_paid"] intValue] == isPaid) {
            continue;
        }
        if ([[dicReceipt objectForKey:@"split_info"] count] > upperPeople || [[dicReceipt objectForKey:@"split_info"] count] < lowerPeople) {
            continue;
        }
        NSDate *date = [commonUtils changeTimezone:[commonUtils stringToDate: [dicReceipt objectForKey:@"create_at"] dateFormat:@"yyyy-MM-dd HH:mm:ss"] dateFormat:@"yyyy-MM-dd"];
        
        if (days == 0) {
            
        }
        else if (days == 1) {
            if (![commonUtils checkToday:date]) {
                continue;
            }
        }
        else {
            NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
            if (diff > 3600 * 24 * days) {
                continue;
            }
        }
        [arrReceipt_Filtered addObject:dicReceipt];
    }
    
    [self searchReceived];
}

- (void)filterPaid {
    NSMutableDictionary *dicFilter = [commonUtils getUserDefaultDicByKey:@"filter_paid"];
    int upperMoney = [[dicFilter objectForKey:@"money_upper"] intValue];
    int lowerMoney = [[dicFilter objectForKey:@"money_lower"] intValue];
    
    int days = [commonUtils filterDays: [dicFilter objectForKey:@"date"]];
    int isPaid = [[dicFilter objectForKey:@"status"] intValue];
    
    [arrPaid_Filtered removeAllObjects];
    [arrUnpaid_Filtered removeAllObjects];

    if (isPaid != 0) {
        for (NSMutableDictionary *dicReceipt in arrUnpaid) {
            if ([[dicReceipt objectForKey:@"price"] floatValue] > upperMoney || [[dicReceipt objectForKey:@"price"] floatValue] < lowerMoney) {
                continue;
            }
            NSDate *date = [commonUtils changeTimezone:[commonUtils stringToDate: [dicReceipt objectForKey:@"create_at"] dateFormat:@"yyyy-MM-dd HH:mm:ss"] dateFormat:@"yyyy-MM-dd"];
            
            if (days == 0) {
                
            }
            else if (days == 1) {
                if (![commonUtils checkToday:date]) {
                    continue;
                }
            }
            else {
                NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
                if (diff > 3600 * 24 * days) {
                    continue;
                }
            }
            [arrUnpaid_Filtered addObject:dicReceipt];
        }
        
    }
    if (isPaid != 1) {
        for (NSMutableDictionary *dicReceipt in arrPaid) {
            if ([[dicReceipt objectForKey:@"price"] floatValue] > upperMoney || [[dicReceipt objectForKey:@"price"] floatValue] < lowerMoney) {
                continue;
            }
            NSDate *date = [commonUtils changeTimezone:[commonUtils stringToDate: [dicReceipt objectForKey:@"create_at"] dateFormat:@"yyyy-MM-dd HH:mm:ss"] dateFormat:@"yyyy-MM-dd"];
            
            if (days == 0) {
                
            }
            else if (days == 1) {
                if (![commonUtils checkToday:date]) {
                    continue;
                }
            }
            else {
                NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:date];
                if (diff > 3600 * 24 * days) {
                    continue;
                }
            }
            [arrPaid_Filtered addObject:dicReceipt];
        }
        
    }
    
    [self searchPaid];
}


#pragma mark - UITableViewDelegate-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return 2;
    }
    else if (tableView.tag == 2) {
        return 1;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        if (section == 0) {
            return arrUnpaid_Filtered.count;
        }
        return arrPaid_Filtered.count == 0 ? 0 : arrPaid_Filtered.count + 1;
    }
    else if (tableView.tag == 2) {
        return arrReceipt_Filtered.count;
    }
    else {
        return [[[arrReceipt_Filtered objectAtIndex:tableView.tag - 10] objectForKey:@"split_info"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        static NSString *strTableIdentifier = @"PaymentTableViewCell";
        PaymentTableViewCell* cell = (PaymentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
        
        if (cell == nil) {
            cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
        }
        
        NSMutableDictionary *dicReceipt;
        if (indexPath.section == 0) {
            dicReceipt = [arrUnpaid_Filtered objectAtIndex:indexPath.row];
            cell.imgPaidFlag.image = [UIImage imageNamed:[arrUnpaidIcon objectAtIndex:indexPath.row % arrColors.count]];
            cell.imgPaidFlag.hidden = NO;
            cell.viewShadow.hidden = NO;
        }
        else {
            cell.imgPaidFlag.hidden = YES;
            if (indexPath.row == 0) {
                cell.viewShadow.hidden = YES;
                return cell;
            }
            else {
                cell.viewShadow.hidden = NO;
            }
            
            dicReceipt = [arrPaid_Filtered objectAtIndex:indexPath.row - 1];
        }
        
        
        cell.lblContent.text = [dicReceipt objectForKey:@"receipt_title"];
        cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dicReceipt objectForKey:@"price"] floatValue]];
        cell.lblToUser.text = [NSString stringWithFormat:@"to %@", [commonUtils getFirstName:[dicReceipt objectForKey:@"user_name"]]];
        
        
        cell.viewShadow.layer.cornerRadius = 5;
        //    cell.viewReceipt.layer.masksToBounds = true;
        
        cell.viewShadow.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.viewShadow.layer.borderWidth = 0.5;
        cell.viewShadow.clipsToBounds = YES;
        
        cell.viewShadow.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.viewShadow.layer.shadowOffset = CGSizeZero;
        cell.viewShadow.layer.shadowRadius = 2.0;
        cell.viewShadow.layer.shadowOpacity = 0.2;
        cell.viewShadow.layer.masksToBounds = NO;
        
        cell.viewReceipt.layer.cornerRadius = 5.5;
        cell.viewReceipt.clipsToBounds = YES;
        
        if (indexPath.section == 0) {
            cell.viewColorBar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
            cell.lblPrice.textColor = COLOR_GRAY2;
        }
        else {
            cell.viewColorBar.backgroundColor = [[arrColors objectAtIndex:(indexPath.row - 1) % arrColors.count] colorWithAlphaComponent:0.5];
            cell.lblPrice.textColor = [COLOR_GRAY2 colorWithAlphaComponent:0.5];
        }
        
        return cell;
    }
    else if (tableView.tag == 2) {
        static NSString *strTableIdentifier = @"PaymentTableViewCell";
        PaymentTableViewCell* cell = (PaymentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
        
        if (cell == nil) {
            cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
        }
        
        
        NSMutableDictionary *dicReceipt = [arrReceipt_Filtered objectAtIndex:indexPath.row];
        
        int nSplit = (int)[[dicReceipt objectForKey:@"split_info"] count];
        CGRect rect = cell.tblSplit.frame;
        rect.size.height = cell.tblSplit.rowHeight * nSplit;
        cell.tblSplit.frame = rect;
        rect = cell.viewShadow.frame;
        rect.size.height = 72 + cell.tblSplit.rowHeight * nSplit + 10;
        cell.viewShadow.frame = rect;
        
        
        
        cell.lblContent.text = [dicReceipt objectForKey:@"receipt_title"];
        cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dicReceipt objectForKey:@"receipt_price"] floatValue]];
        NSDate *date = [commonUtils stringToDate:[dicReceipt objectForKey:@"receipt_date"] dateFormat:@"yyyy-MM-dd"];
        cell.lblToUser.text = [commonUtils dateToString:date dateFormat:@"MMM dd"];
        
        if ([[dicReceipt objectForKey:@"is_paid"] isEqualToString:@"0"]) {
            cell.imgPaidFlag.image = [UIImage imageNamed:@"icon_unpaid.png"];
            cell.viewColorBar.backgroundColor = COLOR_DARK_BROWN;
            cell.viewShadow.layer.zPosition = 2;
            cell.imgPaidFlag.layer.zPosition = 1;
        }
        else {
            cell.imgPaidFlag.image = [UIImage imageNamed:@"icon_checked_green.png"];
            cell.viewColorBar.backgroundColor = COLOR_LIGHT_GREEN;
            cell.viewShadow.layer.zPosition = 1;
            cell.imgPaidFlag.layer.zPosition = 2;
        }
        
        
        cell.viewShadow.layer.cornerRadius = 5;
        //    cell.viewReceipt.layer.masksToBounds = true;
        
        cell.viewShadow.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.viewShadow.layer.borderWidth = 0.5;
        cell.viewShadow.clipsToBounds = YES;
        
        cell.viewShadow.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.viewShadow.layer.shadowOffset = CGSizeZero;
        cell.viewShadow.layer.shadowRadius = 2.0;
        cell.viewShadow.layer.shadowOpacity = 0.5;
        cell.viewShadow.layer.masksToBounds = NO;
        
        cell.viewReceipt.layer.cornerRadius = 5;
        cell.viewReceipt.clipsToBounds = YES;
        
        cell.tblSplit.tag = 10 + indexPath.row;
        
        cell.tblSplit.delegate = self;
        cell.tblSplit.dataSource = self;
        [cell.tblSplit reloadData];
        return cell;
    }
    
    static NSString *strTableIdentifier = @"SplitTableViewCell";
    SplitTableViewCell* cell = (SplitTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[SplitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    
    NSMutableDictionary *dicPaid = [arrReceipts objectAtIndex:tableView.tag - 10];
    NSMutableDictionary *dicSplit = [[dicPaid objectForKey:@"split_info"] objectAtIndex:indexPath.row];
    
    if ([[dicSplit objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
        cell.lblUsername.text = @"You";
    }
    else {
        cell.lblUsername.text = [dicSplit objectForKey:@"user_name"];
    }
    
    cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dicSplit objectForKey:@"price"] floatValue]];
    
    NSMutableDictionary *dicReceipt = [arrReceipts objectAtIndex:tableView.tag - 10];
    if ([[dicReceipt objectForKey:@"is_paid"] intValue] == 1) {
        cell.lblPrice.textColor = [COLOR_GRAY2 colorWithAlphaComponent:0.7];
    }
    else {
        if ([[dicSplit objectForKey:@"is_paid"] isEqualToString:@"1"]) {
            cell.lblPrice.textColor =  [COLOR_GRAY2 colorWithAlphaComponent:0.2];
        }
        else {
            cell.lblPrice.textColor = COLOR_BROWN;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView.tag == 1) {
        if (indexPath.section == 0) {
            return tableView.rowHeight;
        }
        
        if (indexPath.row == 0) {
            return 40;
        }
        else {
            return tableView.rowHeight;
        }

    }
    else if (tableView.tag == 2) {
        static NSString *strTableIdentifier = @"PaymentTableViewCell";
        PaymentTableViewCell* cell = (PaymentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
        
        if (cell == nil) {
            cell = [[PaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
        }
        
        NSMutableDictionary *dicReceipt = [arrReceipts objectAtIndex:indexPath.row];
        
        int nSplit = (int)[[dicReceipt objectForKey:@"split_info"] count];
        CGRect rect = cell.tblSplit.frame;
        rect.size.height = cell.tblSplit.rowHeight * nSplit;
        cell.tblSplit.frame = rect;
        rect = cell.viewShadow.frame;
        rect.size.height = 72 + cell.tblSplit.rowHeight * nSplit + 10;
        cell.viewShadow.frame = rect;
        
        return rect.size.height + 20;
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        
        NSMutableDictionary *dicReceipt;
        if (indexPath.section == 0) {
            dicReceipt = [arrUnpaid objectAtIndex:indexPath.row];
        }
        else {
            if (indexPath.row > 0) {
                dicReceipt = [arrPaid objectAtIndex:indexPath.row - 1];
                _viewDetailColorbar.backgroundColor = [arrColors objectAtIndex:(indexPath.row - 1) % arrColors.count];
                _btnPayNow.backgroundColor = [arrColors objectAtIndex:(indexPath.row - 1) % arrColors.count];
            }
            else {
                return;
            }
        }

        _viewDarkBack.hidden = NO;
        _viewDetailShadow.hidden = NO;

        nSelectedSplitId = [dicReceipt objectForKey:@"split_id"];
        _lblDetailContent.text = [dicReceipt objectForKey:@"receipt_title"];
        _lblDetailPrice.text = [NSString stringWithFormat:@"$%@", [dicReceipt objectForKey:@"price"]];
        _lblDetailToUser.text = [NSString stringWithFormat:@"to %@", [dicReceipt objectForKey:@"user_name"]];
        
        if ([[dicReceipt objectForKey:@"is_paid"] isEqualToString:@"0"]) {
            _imgDetailPaidFlag.image = [UIImage imageNamed:@"icon_unpaid.png"];
            _btnPayNow.hidden = NO;
            _lblDetailDescription.text = @"Unpaid";
        }
        else {
            _imgDetailPaidFlag.image = [UIImage imageNamed:@"icon_checked_green.png"];
            CGRect rect = _viewDetail.frame;
            CGRect rectShadow = _viewDetailShadow.frame;
            rect.size.height -= _btnPayNow.frame.size.height;
            rectShadow.size.height -= _btnPayNow.frame.size.height;
            _viewDetailShadow.frame = rectShadow;
            _viewDetail.frame = rect;
            
            _btnPayNow.hidden = YES;
            
            NSDate *date = [commonUtils stringToDate:[dicReceipt objectForKey:@"paid_at"] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            date = [commonUtils changeTimezone:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [commonUtils dateToString:date dateFormat:@"EEEE dd MMMM yyyy hh:mm a"];
            
            _lblDetailDescription.text = [NSString stringWithFormat: @"Paid %@", strDate];
        }
        
        if ([[dicReceipt objectForKey:@"user_image"] isEqualToString:@""]) {
            _imgDetailAvatar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
            _lblDetailShortName.hidden = NO;
        }
        else {
            
            [commonUtils setImageViewAFNetworking:_imgDetailAvatar withImageUrl:[dicReceipt objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];
            
            _lblDetailShortName.hidden = YES;
            _imgDetailAvatar.backgroundColor = [UIColor clearColor];
        }
    }
    else if (tableView.tag == 2){
        NSMutableDictionary *dicReceipt = [arrReceipt_Filtered objectAtIndex:indexPath.row];

        ReceiptDetailViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptDetailViewController"];
        VC.dicReceiptDetail = dicReceipt;
        VC.isPaid = 0;
        
        if ([[dicReceipt objectForKey:@"is_paid"] isEqualToString:@"0"]) {
            VC.isFullPaid = false;
        }
        else {
            VC.isFullPaid = true;
        }
        

        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self filterResult];
    return [textField resignFirstResponder];
}

#pragma mark - IBAction-

- (IBAction)OnViewPaid:(id)sender {
    _tblReceipt.hidden = YES;
    _tblPaid.hidden = NO;
    [_btnPaid setBackgroundImage:[UIImage imageNamed:@"icon_arrowup_profile.png"] forState:UIControlStateNormal];
    [_btnReceipt setBackgroundImage:[UIImage imageNamed:@"icon_down_un.png"] forState:UIControlStateNormal];
    [self filterPaid];
}

- (IBAction)OnViewReceipt:(id)sender {
    _tblReceipt.hidden = NO;
    _tblPaid.hidden = YES;
    [_btnPaid setBackgroundImage:[UIImage imageNamed:@"icon_up_un.png"] forState:UIControlStateNormal];
    [_btnReceipt setBackgroundImage:[UIImage imageNamed:@"icon_arrowdown_profile.png"] forState:UIControlStateNormal];
    [self filterReceived];
    
}

- (IBAction)OnSearch:(id)sender {
    if (isSearch) {
        isSearch = NO;
        _imgSearch.image = [UIImage imageNamed:@"icon_search.png"];
        _viewSearch.hidden = YES;
        [self.view endEditing:YES];
        _btnPaid.hidden = NO;
        _btnReceipt.hidden = NO;
        _textFieldSearch.text = @"";
        [self filterResult];
    }
    else {
        _imgSearch.image = [UIImage imageNamed:@"icon_close.png"];
        isSearch = YES;
        _viewSearch.hidden = NO;
        _btnPaid.hidden = YES;
        _btnReceipt.hidden = YES;
    }
}

- (IBAction)OnPaynow:(id)sender {
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    [userInfo setObject:nSelectedSplitId forKey:@"split_id"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestPayNow:userInfo];
    });
}

- (IBAction)OnFilter:(id)sender {
    FilterViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    if (_tblPaid.hidden) {
        VC.filterType = @"filter_received";
        VC.maxPeople = maxPeople;
        VC.maxPrice = maxPrice;
    }
    else {
        VC.filterType = @"filter_paid";
        VC.maxPeople = maxPeople;
        VC.maxPrice = maxPrice;
    }
    
    [self.navigationController presentViewController:VC animated:YES completion:nil];
}

- (IBAction)OnClear:(id)sender {
    _textFieldSearch.text = @"";
}

#pragma mark - Request API
- (void) requestReceipts:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_RECEIPTS withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            arrReceipts = [result objectForKey:@"receipt_info"];
            arrPaid = [result objectForKey:@"paid"];
            arrUnpaid = [result objectForKey:@"unpaid"];
            [AppData sharedData].arrReceipts = arrReceipts;
            [AppData sharedData].arrPaid = arrPaid;
            [AppData sharedData].arrUnpaid = arrUnpaid;
            
            [self getMaxPrice];
            [self getMaxPeople];
            [self filterResult];
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestPayNow:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SET_PAID withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            [self dismissDetail:nil];
            arrReceipts = [result objectForKey:@"receipt_info"];
            arrPaid = [result objectForKey:@"paid"];
            arrUnpaid = [result objectForKey:@"unpaid"];
            [AppData sharedData].arrReceipts = arrReceipts;
            [AppData sharedData].arrPaid = arrPaid;
            [AppData sharedData].arrUnpaid = arrUnpaid;
            [self getMaxPrice];
            [self getMaxPeople];
            [self filterResult];
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
