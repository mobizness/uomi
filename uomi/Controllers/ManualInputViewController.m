//
//  ManualInputViewController.m
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ManualInputViewController.h"
#import "ManualInputTableViewCell.h"
#import "ReceiptDetailViewController.h"

@interface ManualInputViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSMutableArray *arrInputs;
    NSMutableArray *arrColors;
}
@end
@implementation ManualInputViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    

    arrInputs = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dicInput = [[NSMutableDictionary alloc] init];
    [dicInput setObject:@"" forKey:@"item"];
    [dicInput setObject:@"" forKey:@"price"];
    [arrInputs addObject:dicInput];
    
    [self refreshSize];
    
    _tblInput.delegate = self;
    _tblInput.dataSource = self;
    
    
    arrColors = [commonUtils getColorArray];
    NSString *strUserName = [_dicSelectedUser objectForKey:@"user_name"];
    int nUserId = [[_dicSelectedUser objectForKey:@"user_id"] intValue];
    
    NSString *shortName = [commonUtils getShortName:strUserName];
    
    _lblUserName.text = strUserName;
    _lblShortname.text = shortName;
    
    if ([[_dicSelectedUser objectForKey:@"user_image"] isEqualToString:@""]) {
        _imgAvatar.backgroundColor = [arrColors objectAtIndex:nUserId % arrColors.count];
        _lblShortname.hidden = NO;
    }
    else {
        _imgAvatar.image = [UIImage imageNamed: [_dicSelectedUser objectForKey:@"user_image"]];
        _lblShortname.hidden = YES;
        _imgAvatar.backgroundColor = [UIColor clearColor];
    }
    
//    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.width / 2;
//    //    cell.viewReceipt.layer.masksToBounds = true;
//    
//    _imgAvatar.layer.borderColor = [UIColor clearColor].CGColor;
//    _imgAvatar.layer.borderWidth = 0.5;
//    _imgAvatar.clipsToBounds = YES;
    
    _imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgAvatar.layer.shadowOffset = CGSizeZero;
    _imgAvatar.layer.shadowRadius = 1.0;
    _imgAvatar.layer.shadowOpacity = 0.2;
    _imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:_imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
}



#pragma mark - UITableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrInputs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *strTableIdentifier = @"ManualInputTableViewCell";
    ManualInputTableViewCell* cell = (ManualInputTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[ManualInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    cell.lblItemNumber.text = [NSString stringWithFormat:@"#%d", indexPath.row + 1];
    
    NSMutableDictionary *dicInput = [arrInputs objectAtIndex:indexPath.row];
    cell.textFieldItemName.text = [dicInput objectForKey:@"item"];
    cell.textFieldPrice.text = [dicInput objectForKey:@"price"];
    
    cell.textFieldItemName.tag = 1000+ indexPath.row;
    cell.textFieldPrice.tag = 2000+ indexPath.row;
    
    [cell.textFieldPrice addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    return cell;
    
}

#pragma mark - UITextFieldDelegate-

- (void) textFieldDidChange : (UITextField*)textField {
    if (textField.tag >= 2000) {
        NSString* amount = textField.text;
        if (amount.length > 1) {
            if ([[amount substringToIndex:1] isEqualToString:@"$"]) {
                
            }
            else {
                textField.text = [NSString stringWithFormat:@"$%@", amount];
            }
            NSMutableDictionary *dicInput = [arrInputs objectAtIndex:textField.tag - 2000];
            [dicInput setObject:textField.text forKeyedSubscript:@"price"];
            [arrInputs replaceObjectAtIndex:textField.tag - 2000 withObject:dicInput];
            
            [self calculateTotalPrice];
            
        }
        else if (amount.length == 1) {
            if ([amount isEqualToString:@"$"]) {
                textField.text = @"";
            }
            else {
                textField.text = [NSString stringWithFormat:@"$%@", amount];
                NSMutableDictionary *dicInput = [arrInputs objectAtIndex:textField.tag - 2000];
                [dicInput setObject:textField.text forKeyedSubscript:@"price"];
                [arrInputs replaceObjectAtIndex:textField.tag - 2000 withObject:dicInput];
                
                [self calculateTotalPrice];
            }
        }
        else {
            
        }
        

    }
    else {
        
        NSMutableDictionary *dicInput = [arrInputs objectAtIndex:textField.tag - 2000];
        [dicInput setObject:textField.text forKeyedSubscript:@"item"];
        [arrInputs replaceObjectAtIndex:textField.tag - 1000 withObject:dicInput];
    }
    
}

- (void) calculateTotalPrice {
    Float32 totalPrice = 0;
    for (int i = 0; i < arrInputs.count; i++) {
        if ([[[arrInputs objectAtIndex:i] objectForKey:@"price"] isEqualToString:@""]) {
            continue;
        }
        Float32 price = [[[[arrInputs objectAtIndex:i] objectForKey:@"price"] substringFromIndex:1] floatValue];
        totalPrice += price;
    }
    _lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
}

- (void) refreshSize {
    CGRect rectConfirm = _viewConfirm.frame;
    CGRect rectTable = _tblInput.frame;
    rectTable.size.height = _tblInput.rowHeight * arrInputs.count;
    rectConfirm.origin.y = _tblInput.frame.origin.y + _tblInput.rowHeight * arrInputs.count;
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    
    if (rectConfirm.origin.y + rectConfirm.size.height < height) {
        rectConfirm.origin.y = height - rectConfirm.size.height - 20;
        _tblInput.frame = rectTable;
        _viewConfirm.frame = rectConfirm;
        
        return;
    }
    
    _tblInput.frame = rectTable;
    _viewConfirm.frame = rectConfirm;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, rectTable.origin.y + rectTable.size.height + rectConfirm.size.height);
    
}

- (IBAction)OnAdd:(id)sender {
    NSMutableDictionary *dicInput = [[NSMutableDictionary alloc] init];
    [dicInput setObject:@"" forKey:@"item"];
    [dicInput setObject:@"" forKey:@"price"];
    [arrInputs addObject:dicInput];
    [_tblInput reloadData];
    [self refreshSize];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnConfirm:(id)sender {
    [_dicSelectedUser setObject:arrInputs forKey:@"price_array"];
    [_dicSelectedUser setObject:_lblTotalPrice.text forKey:@"total_price"];
    [appController.selected_users addObject:_dicSelectedUser];
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}


@end
