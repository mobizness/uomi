//
//  ReceiptDetailViewController.m
//  uomi
//
//  Created by scs on 10/23/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ReceiptDetailViewController.h"
#import "SplitTableViewCell.h"
#import "SplitUserCollectionViewCell.h"
#import "MessageViewController.h"


@interface ReceiptDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *arrSplit;
    NSMutableArray *arrColors;
    CGSize orignal;
    
}
@end
@implementation ReceiptDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    arrSplit = [_dicReceiptDetail objectForKey:@"split_info"];
    arrColors =[commonUtils getColorArray];
    
    
    [self initializeScreen];
    [self showDetails];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissDetail:)];
    [self.viewDarkBack addGestureRecognizer:singleFingerTap];
    [self refreshScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (void)showDetails {
    NSMutableDictionary *dicMessageInfo = [_dicReceiptDetail objectForKey:@"message_info"];
    if (dicMessageInfo.count == 0) {
        _lblMessages.textColor = COLOR_GRAY;
        _lblLastMessage.text = @"";
    }
    else {
        if ([[dicMessageInfo objectForKey:@"is_read"] isEqualToString:@""]) {
            _imgNewMessage.hidden = NO;
            _lblMessages.textColor = COLOR_BROWN;
        }
        _lblLastMessage.text = [[_dicReceiptDetail objectForKey:@"message_info"] objectForKey:@"content"];
    }
    
    if (_isPaid == 0) {
        [_btnPayNow setTitle:@"Nudge" forState:UIControlStateNormal];
    }
    else {
        [_btnPayNow setTitle:@"Pay Now" forState:UIControlStateNormal];
    }
    
    _lblReceiptTitle.text = [_dicReceiptDetail objectForKey:@"receipt_title"];
    NSDate *date = [commonUtils stringToDate:[_dicReceiptDetail objectForKey:@"receipt_date"] dateFormat:@"yyyy-MM-dd"];
    _lblReceiptDate.text = [commonUtils dateToString:date dateFormat:@"dd MMM yyyy"].uppercaseString;
}

- (void)initializeScreen {
    _tblSplit.delegate = self;
    _tblSplit.dataSource = self;
    _collectionUsers.delegate = self;
    _collectionUsers.dataSource = self;
    
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
    
}

- (void)refreshScrollView {
    if (_isFullPaid || _isPaid == 0) {
        _btnPayNow.hidden = YES;
        CGRect rectLabel = _lblDetails.frame;
        rectLabel.origin.y = 73;
        _lblDetails.frame = rectLabel;
        
    }
    else {
        _btnPayNow.hidden = NO;
    }
    
    CGRect rectTbl = _tblSplit.frame;
    rectTbl.origin.y = _lblDetails.frame.origin.y + _lblDetails.frame.size.height;
    rectTbl.size.height = _tblSplit.rowHeight * arrSplit.count;
    _tblSplit.frame = rectTbl;
    CGRect rectBelow = _viewBelow.frame;
    rectBelow.size.height = rectTbl.size.height + rectTbl.origin.y + 100;
    _viewBelow.frame = rectBelow;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _viewBelow.frame.size.height + _viewBelow.frame.origin.y);

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

#pragma mark - UITableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       return arrSplit.count;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *strTableIdentifier = @"SplitTableViewCell";
    SplitTableViewCell* cell = (SplitTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[SplitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    NSMutableDictionary *dicSplit = [arrSplit objectAtIndex:indexPath.row];
    
    if ([[dicSplit objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
        cell.lblUsername.text = @"You";
    }
    else {
        cell.lblUsername.text = [dicSplit objectForKey:@"user_name"];
    }
    
    cell.lblPrice.text = [NSString stringWithFormat:@"$%@", [dicSplit objectForKey:@"price"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _viewDarkBack.hidden = NO;
    _viewDetailShadow.hidden = NO;
    NSMutableDictionary *dicSplit = [arrSplit objectAtIndex:indexPath.row];
        
    NSString *strUserName = [dicSplit objectForKey:@"user_name"];
        
    NSString *firstname = [commonUtils getFirstName:strUserName];
        
    _lblDetailToUser.text = firstname;
    _lblDetailPrice.text = [NSString stringWithFormat:@"$%@", [dicSplit objectForKey:@"price"]];
    _lblSplitPrice.text = [NSString stringWithFormat:@"$%@", [dicSplit objectForKey:@"price"]];
        
    _viewDetailColorbar.backgroundColor = [arrColors objectAtIndex:indexPath.row % arrColors.count];
        

}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return arrSplit.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SplitUserCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SplitUserCollectionViewCell" forIndexPath:indexPath];

    NSMutableDictionary *dicSplit = [arrSplit objectAtIndex:indexPath.row];
    NSString *firstName = [commonUtils getFirstName:[dicSplit objectForKey:@"user_name"]];
    
    if ([[dicSplit objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
        cell.lblUsername.text = @"You";
    }
    else {
        cell.lblUsername.text = firstName;
    }
    
    cell.imgAvatar.image = [UIImage imageNamed:[commonUtils getFirstName:[dicSplit objectForKey:@"user_image"]]];
    
    NSString *strUserName = [dicSplit objectForKey:@"user_name"];
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    cell.lblShortname.text = shortName;
    
    if ([[dicSplit objectForKey:@"user_image"] isEqualToString:@""]) {
        cell.imgAvatar.backgroundColor = [arrColors objectAtIndex:[[dicSplit objectForKey:@"user_id"] intValue] % arrColors.count];
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
//    
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
    _viewDarkBack.hidden = NO;
    _viewDetailShadow.hidden = NO;
    NSMutableDictionary *dicSplit = [arrSplit objectAtIndex:indexPath.row];
    
    NSString *strUserName = [dicSplit objectForKey:@"user_name"];
    
    NSString *firstname = [commonUtils getFirstName:strUserName];
    
    _lblDetailToUser.text = firstname;
    _lblDetailPrice.text = [NSString stringWithFormat:@"$%@", [dicSplit objectForKey:@"price"]];
    _lblSplitPrice.text = [NSString stringWithFormat:@"$%@", [dicSplit objectForKey:@"price"]];
    
    _viewDetailColorbar.backgroundColor = [arrColors objectAtIndex:[[dicSplit objectForKey:@"user_id"] intValue] % arrColors.count];
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    int viewWidth = _collectionUsers.frame.size.width;
    int totalCellWidth = 77 * arrSplit.count;
    int leftInset = (viewWidth - totalCellWidth) / 2;
    if (leftInset < 0) {
        leftInset = 0;
    }
    return UIEdgeInsetsMake(0, leftInset, 0, leftInset);
}

#pragma mark - UICollectionViewDataSource
- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnMessage:(id)sender {
    MessageViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    VC.arrUsers = [arrSplit mutableCopy];
    VC.receipt_id = [_dicReceiptDetail objectForKey:@"receipt_id"];
    VC.sender_info = [_dicReceiptDetail objectForKey:@"sender_info"];
    [self.navigationController pushViewController:VC animated:YES];

//    ChatViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
//    VC.arrUsers = arrSplit;
//    VC.receipt_id = [_dicReceiptDetail objectForKey:@"receipt_id"];
//    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)OnPaynow:(id)sender {
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSString *user_name = [appController.dicUserInfo objectForKey:@"user_name"];
    NSString *receipt_id = [_dicReceiptDetail objectForKey:@"receipt_id"];
    NSString *receipt_title = [_dicReceiptDetail objectForKey:@"receipt_title"];
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setObject:user_id forKey:@"user_id"];
    [info setObject:user_name forKey:@"user_name"];
    [info setObject:receipt_id forKey:@"receipt_id"];
    [info setObject:receipt_title forKey:@"receipt_title"];
    
    [commonUtils showActivityIndicator:self.view];
    
    if (_isPaid == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestNudge:info];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (appController.isLoading) return;
            appController.isLoading = YES;
            
            [self requestPayNow:info];
        });
    }
}

- (void) requestPayNow:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SET_ALL_PAID withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            _dicReceiptDetail = [result objectForKey:@"receipt_info"];
            _lblLastMessage.text = @"Paid";
            [self viewDetail];
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestNudge:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SET_NUDGE withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            _isFullPaid = true;
            [self refreshScrollView];
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
