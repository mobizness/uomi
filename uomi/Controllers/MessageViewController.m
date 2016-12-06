//
//  MessageViewController.m
//  uomi
//
//  Created by scs on 10/25/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "MessageViewController.h"
#import "SplitUserCollectionViewCell.h"
#import "MessageTableViewCell.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface MessageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate> {
    NSMutableArray *arrMessage;
    NSMutableArray *arrColors;
    CGSize orignal;
    CGFloat heightKeyboard;
    UIRefreshControl *refreshControl;
    
    BOOL isFinished;
    BOOL isFirstLoading;
    NSString *firstMessageId;
    NSString *lastMessageId;
    
    IBOutlet UIBubbleTableView *bubbleTable;
    NSMutableArray *bubbleData;
}
@end
@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    arrColors =[commonUtils getColorArray];
    
    isFinished = false;
    isFirstLoading = true;
    firstMessageId = @"-1";
    lastMessageId = @"-1";
    
    for (NSMutableDictionary *dicSplit in _arrUsers) {
        if ([[dicSplit objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
            [_arrUsers removeObject:dicSplit];
        }
    }
    [_arrUsers addObject:_sender_info];
    
    _collectionUsers.delegate = self;
    _collectionUsers.dataSource = self;
    _textfieldMessage.delegate = self;
    
    bubbleData = [[NSMutableArray alloc] init];
    arrMessage = [[NSMutableArray alloc] init];

    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 120;
    bubbleTable.showAvatars = NO;
    
    orignal = bubbleTable.frame.size;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [bubbleTable addSubview:refreshControl];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessage) name:@"new_message" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissKeyboard:)];
    [bubbleTable addGestureRecognizer:singleFingerTap];
    
    [self getOldMessages];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    heightKeyboard = (-1) * MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2 animations:^{
        _viewInput.transform = CGAffineTransformMakeTranslation(0, 0);
        
        _viewInput.transform = CGAffineTransformMakeTranslation(0, heightKeyboard);
        CGRect rectTable = bubbleTable.frame;
        rectTable.size.height = orignal.height + heightKeyboard;
        bubbleTable.frame = rectTable;
        CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
        [bubbleTable setContentOffset:bottomOffset animated:NO];

    }];
    
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    heightKeyboard = (-1) * MIN(keyboardSize.height,keyboardSize.width);
    
    [UIView animateWithDuration:0.2 animations:^{
        _viewInput.transform = CGAffineTransformMakeTranslation(0, 0);
        
        CGRect rectTable = bubbleTable.frame;
        rectTable.size.height = orignal.height;
        bubbleTable.frame = rectTable;
    }];
    
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    
}

- (void) getOldMessages {
    NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
    [messageInfo setObject:_receipt_id forKey:@"receipt_id"];
    [messageInfo setObject:appController.strUserId forKey:@"sender_id"];
    [messageInfo setObject:firstMessageId forKey:@"firstMessageId"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetMessages:messageInfo];
    });
}

- (void) getUnreadMessages {
    NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
    [messageInfo setObject:_receipt_id forKey:@"receipt_id"];
    [messageInfo setObject:appController.strUserId forKey:@"sender_id"];
    [messageInfo setObject:lastMessageId forKey:@"lastMessageId"];
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetUnreadMessages:messageInfo];
    });
}

- (void)receiveNewMessage {
    [self getUnreadMessages];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}


#pragma mark - TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        return false;
    }
    
    NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
    [messageInfo setObject:_textfieldMessage.text forKey:@"content"];
    [messageInfo setObject:_receipt_id forKey:@"receipt_id"];
    [messageInfo setObject:appController.strUserId forKey:@"sender_id"];
    [messageInfo setObject:lastMessageId forKey:@"lastMessageId"];
    _textfieldMessage.text = @"";
    
    [commonUtils showActivityIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSendMessage:messageInfo];
    });
    
    
//    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
//    
//    NSBubbleData *sayBubble = [NSBubbleData dataWithText:_textfieldMessage.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
//    [bubbleData addObject:sayBubble];
//    [bubbleTable reloadData];    
    [_textfieldMessage resignFirstResponder];
    return true;
}

- (void) handleRefresh: (id)sender {
    [self getOldMessages];
}

- (void)scrollViewDidScroll:(UITableView *)tableView {

    CGPoint offset = tableView.contentOffset;
    float y = offset.y;
    
    if (isFinished) {
        return;
    }
    
    float reload_distance = 10;
    if(y < reload_distance) {
        if (isFinished) {
            return;
        }
        
        
    }
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _arrUsers.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SplitUserCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SplitUserCollectionViewCell" forIndexPath:indexPath];
    
    NSMutableDictionary *dicSplit = [_arrUsers objectAtIndex:indexPath.row];
    
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
//    cell.imgAvatar.layer.borderColor = (__bridge CGColorRef _Nullable)([arrColors objectAtIndex:indexPath.row % arrColors.count]);
//    cell.imgAvatar.layer.borderWidth = 0.5;
//    cell.imgAvatar.clipsToBounds = YES;
    
    cell.imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imgAvatar.layer.shadowOffset = CGSizeZero;
    cell.imgAvatar.layer.shadowRadius = 1.0;
    cell.imgAvatar.layer.shadowOpacity = 0.2;

    UIColor *color = [arrColors objectAtIndex:[[dicSplit objectForKey:@"user_id"] intValue] % arrColors.count];
    cell.imgAvatar.layer.borderColor = color.CGColor;
    cell.imgAvatar.layer.borderWidth = 2;
    cell.imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:cell.imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)cv
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dicSplit = [_arrUsers objectAtIndex:indexPath.row];

    if ([[dicSplit objectForKey:@"user_id"] isEqualToString:appController.strUserId]) {
        return CGSizeZero;
    }
    return [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    int viewWidth = _collectionUsers.frame.size.width;
    int totalCellWidth = 77 * _arrUsers.count;
    int leftInset = (viewWidth - totalCellWidth) / 2;
    if (leftInset < 0) {
        leftInset = 0;
    }
    
    return UIEdgeInsetsMake(0, leftInset, 0, leftInset);
}

#pragma mark - Events

- (IBAction)OnCamera:(id)sender {
    [_textfieldMessage resignFirstResponder];
    
    UIAlertController *optionMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self openCameraAction];
    }];
    
    UIAlertAction* gallertAction = [UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self openGalleryAction];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
    
    
    [optionMenu addAction:cameraAction];
    [optionMenu addAction:gallertAction];
    [optionMenu addAction:cancelAction];
    
    
    [self presentViewController:optionMenu animated:YES completion:nil];
}

- (IBAction)Onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSend:(id)sender {
    if ([_textfieldMessage.text isEqualToString:@""]) {
        return;
    }
    [self.view endEditing:YES];
    
    NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
    [messageInfo setObject:_textfieldMessage.text forKey:@"content"];
    [messageInfo setObject:_receipt_id forKey:@"receipt_id"];
    [messageInfo setObject:appController.strUserId forKey:@"sender_id"];
    [messageInfo setObject:lastMessageId forKey:@"lastMessageId"];
    
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSendMessage:messageInfo];
    });
    _textfieldMessage.text = @"";
}



- (void)openCameraAction {
    @try {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.videoMaximumDuration = 15;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    @catch (NSException *exception) {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Message"
                                     message:@"Can't Access Camera"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)openGalleryAction {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [_textfieldMessage resignFirstResponder];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSMutableDictionary *messageInfo = [[NSMutableDictionary alloc] init];
    [messageInfo setObject:_receipt_id forKey:@"receipt_id"];
    [messageInfo setObject:appController.strUserId forKey:@"sender_id"];
    [messageInfo setObject:lastMessageId forKey:@"lastMessageId"];
    [messageInfo setObject:[commonUtils encodeToBase64String:image byCompressionRatio:0.3] forKey:@"image"];
    
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestSendMessage:messageInfo];
    });
    
}



#pragma mark - Request API
- (void) requestSendMessage:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_SEND_MESSAGE withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSMutableArray *arrNewMessages = [[result objectForKey:@"message_info"] mutableCopy];
            
            [arrMessage addObjectsFromArray:arrNewMessages];
            
            lastMessageId = [[arrNewMessages objectAtIndex:[arrNewMessages count] - 1] objectForKey:@"message_id"];
            
            
            
            for (NSMutableDictionary *dicMessage in arrNewMessages) {
                NSDate *date = [commonUtils stringToDate:[dicMessage objectForKey:@"datetime"] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                int type = [[dicMessage objectForKey:@"sender_id"] intValue] % [[commonUtils getBubbleArray] count];
                NSString *screenName = [dicMessage objectForKey:@"user_name"];
                if ([[dicMessage objectForKey:@"sender_id"] isEqualToString:appController.strUserId]) {
                    type = -1;
                    screenName = @"You";
                }
                
                NSBubbleData *bubble;
                if ([[dicMessage objectForKey:@"image"] isEqualToString:@""] || [dicMessage objectForKey:@"image"] == nil) {
                    bubble = [NSBubbleData dataWithText:[dicMessage objectForKey:@"content"] date: date type:type];
                }
                else {
                    bubble = [NSBubbleData dataWithImageURL:[dicMessage objectForKey:@"image"] date:date type:type];
                }
                bubble.screenName = screenName;
                
                bubble.avatar = [UIImage imageNamed:@"imgAvatar.png"];
                [bubbleData addObject:bubble];
            }
            [bubbleTable reloadData];
            
            CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
            [bubbleTable setContentOffset:bottomOffset animated:YES];
            
        } else {
            [commonUtils showAlert: @"" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestGetMessages:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_MESSAGES withJSON:(NSMutableDictionary *) params];
    [refreshControl endRefreshing];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            NSMutableArray *arrOldMessages = [[result objectForKey:@"message_info"] mutableCopy];
            
            if ([arrOldMessages count] > 0) {
                firstMessageId = [[arrOldMessages objectAtIndex:0] objectForKey:@"message_id"];
            }
            
            [arrOldMessages addObjectsFromArray:arrMessage];
            arrMessage = [arrOldMessages mutableCopy];
            if (arrOldMessages.count < 20) {
                isFinished = true;
            }
            
            [bubbleData removeAllObjects];
            for (NSMutableDictionary *dicMessage in arrMessage) {
                NSDate *date = [commonUtils stringToDate:[dicMessage objectForKey:@"datetime"] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                int type = [[dicMessage objectForKey:@"sender_id"] intValue] % [[commonUtils getBubbleArray] count];
                NSString *screenName = [dicMessage objectForKey:@"user_name"];
                if ([[dicMessage objectForKey:@"sender_id"] isEqualToString:appController.strUserId]) {
                    type = -1;
                    screenName = @"You";
                }
                
                NSBubbleData *bubble;
                if ([[dicMessage objectForKey:@"image"] isEqualToString:@""] || [dicMessage objectForKey:@"image"] == nil) {
                    bubble = [NSBubbleData dataWithText:[dicMessage objectForKey:@"content"] date: date type:type];
                }
                else {
                    bubble = [NSBubbleData dataWithImageURL:[dicMessage objectForKey:@"image"] date:date type:type];
                }

                bubble.screenName = screenName;
                bubble.avatar = [UIImage imageNamed:@"imgAvatar.png"];
                [bubbleData addObject:bubble];
            }
            
            [bubbleTable reloadData];
            
            if (isFirstLoading) {
                isFirstLoading = false;
                CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
                [bubbleTable setContentOffset:bottomOffset animated:NO];
                
                if (arrOldMessages.count == 0) {
                    lastMessageId = @"-1";
                }
                else {
                    lastMessageId = [[arrOldMessages objectAtIndex:[arrOldMessages count] - 1] objectForKey:@"message_id"];
                }
            }
            
            
        } else {
            [commonUtils showAlert: @"" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestGetUnreadMessages:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_UNREAD_MESSAGES withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            NSMutableArray *arrNewMessages = [[result objectForKey:@"message_info"] mutableCopy];
            
            [arrMessage addObjectsFromArray:arrNewMessages];
            
            if ([arrNewMessages count] > 0) {
                lastMessageId = [[arrNewMessages objectAtIndex:[arrNewMessages count] - 1] objectForKey:@"message_id"];
            }
            
            
            for (NSMutableDictionary *dicMessage in arrNewMessages) {
                NSDate *date = [commonUtils stringToDate:[dicMessage objectForKey:@"datetime"] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date = [commonUtils changeTimezone:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                int type = [[dicMessage objectForKey:@"sender_id"] intValue] % [[commonUtils getBubbleArray] count];
                NSString *screenName = [dicMessage objectForKey:@"user_name"];
                if ([[dicMessage objectForKey:@"sender_id"] isEqualToString:appController.strUserId]) {
                    type = -1;
                    screenName = @"You";
                }
                
                NSBubbleData *bubble;
                if ([[dicMessage objectForKey:@"image"] isEqualToString:@""] || [dicMessage objectForKey:@"image"] == nil) {
                    bubble = [NSBubbleData dataWithText:[dicMessage objectForKey:@"content"] date: date type:type];
                }
                else {
                    bubble = [NSBubbleData dataWithImageURL:[dicMessage objectForKey:@"image"] date:date type:type];
                }

                bubble.screenName = screenName;
                bubble.avatar = [UIImage imageNamed:@"imgAvatar.png"];
                [bubbleData addObject:bubble];
            }
            
            [bubbleTable reloadData];
            
            CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
            [bubbleTable setContentOffset:bottomOffset animated:NO];
            
        } else {
            [commonUtils showAlert: @"" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}
@end
