//
//  HomeViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "HomeViewController.h"
#import "FeedTableViewCell.h"
#import "FilterViewController.h"
#import "ContactScan.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *arrEvent;
    UIRefreshControl *refreshControl;
    int count;
    BOOL isFinished;
    BOOL state;
}
@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    arrEvent = [[NSMutableArray alloc] init];
    
    count = 0;
    isFinished = false;

    
    ContactScan *contactscan = [[ContactScan alloc] init];
    [contactscan contactScan];
    
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    
//    [commonUtils showActivityIndicator:self.view];
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestContacts:userInfo];
    });
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_tblFeed addSubview:refreshControl];
    
    _tblFeed.delegate = self;
    _tblFeed.dataSource = self;
    
    arrEvent = [[AppData sharedData].arrEvent mutableCopy];
    [_tblFeed reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void) handleRefresh: (id)sender {
    count = 0;
    [self getFeeds];
    
}

- (void)getFeeds {
    NSString *user_id = [appController.dicUserInfo objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:user_id forKey:@"user_id"];
    [userInfo setObject:[NSString stringWithFormat:@"%d", count]  forKey:@"count"];
    
    [commonUtils showSmallIndicator:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (appController.isLoading) return;
        appController.isLoading = YES;
        
        [self requestGetFeed:userInfo];
    });
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
            if (flag) break;
        }
    }
}


- (void)scrollViewDidScroll:(UITableView *)tableView {
    CGPoint offset = tableView.contentOffset;
    CGRect bounds = tableView.bounds;
    CGSize size = tableView.contentSize;
    UIEdgeInsets inset = tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        if (isFinished) {
            return;
        }
        
        [self getFeeds];
    }
}

#pragma mark-UITableViewDelegate-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *strTableIdentifier = @"FeedTableViewCell";
    FeedTableViewCell* cell = (FeedTableViewCell*) [tableView dequeueReusableCellWithIdentifier:strTableIdentifier];
    
    if (cell == nil) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strTableIdentifier];
    }
    
    NSMutableDictionary *dicEvent = [arrEvent objectAtIndex:indexPath.row];
    NSString *type = [dicEvent objectForKey:@"type"];
    if ([type isEqualToString:@"1"]) {
        cell.imgEventType.image = [UIImage imageNamed:@"icon_up.png"];
        NSString *detail = [NSString stringWithFormat:@"You paid %@ for '%@'", [dicEvent objectForKey:@"user_name"], [dicEvent objectForKey:@"receipt_title"]];
        cell.lblDetail.text = detail;
    }
    else if ([type isEqualToString:@"2"]) {
        cell.imgEventType.image = [UIImage imageNamed:@"icon_down.png"];
        NSString *detail = [NSString stringWithFormat:@"%@ paid you for '%@'", [dicEvent objectForKey:@"user_name"], [dicEvent objectForKey:@"receipt_title"]];
        cell.lblDetail.text = detail;
    }
    else if ([type isEqualToString:@"3"]) {
        cell.imgEventType.image = [UIImage imageNamed:@"icon_plus.png"];
        NSString *detail = [NSString stringWithFormat:@"You created '%@' and added %d people", [dicEvent objectForKey:@"receipt_title"], [[dicEvent objectForKey:@"count"] intValue]];
        cell.lblDetail.text = detail;
    }
    
//    cell.lblDetail.text = [dicEvent objectForKey:@"detail"];
    NSString *strDateTime = [dicEvent objectForKey:@"create_at"];
    NSDate *date = [commonUtils stringToDate:strDateTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [commonUtils changeTimezone:date dateFormat:@"yyyy-MM-dd hh:mm a"];
    if ([commonUtils checkToday:date]) {
        cell.lblTime.text = [commonUtils dateToString:date dateFormat:@"hh:mm a"];
    }
    else if ([commonUtils checkYesterday:date]) {
        cell.lblTime.text = [commonUtils dateToString:date dateFormat:@"hh:mm a"];
    }
    
    
    return cell;
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
            [self getFeeds];
            
        } else {
            [commonUtils showAlert: @"Login" withMessage:[result objectForKey:@"message"] view:self];
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

- (void) requestGetFeed:(id) params {
    appController.isLoading = NO;
    [commonUtils hideActivityIndicator];
    [refreshControl endRefreshing];
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_GET_FEED withJSON:(NSMutableDictionary *) params];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            NSMutableArray *arrFeeds = [result objectForKey:@"receipts_info"];
            if (count == 0) {
                [arrEvent removeAllObjects];
            }
            count += arrFeeds.count;
            [arrEvent addObjectsFromArray:arrFeeds];
            if (arrFeeds.count < 10) {
                isFinished = true;
            }
            [AppData sharedData].arrEvent = arrEvent;
            [_tblFeed reloadData];
            [refreshControl endRefreshing];
        } else {
        }
        
    } else {
        [commonUtils showAlert: @"Connection Error" withMessage:@"Please check your internet connection status" view:self];
        
    }
}

@end
