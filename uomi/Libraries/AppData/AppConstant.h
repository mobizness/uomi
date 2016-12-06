//
//  AppConstant.h
//  Dopple
//
//  Created by Mitchell Williams on 21/08/2015.
//  Copyright (c) 2015 Mitchell Williams. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h


#pragma mark - constant

#define kStrUserid              @"id_user"

#define kLoggedIn               @"loggedin"

#define kNSortType              @"selected_sorttype"

#define kArrReceipts            @"arr_receipts"
#define kArrPaid                @"arr_paid"
#define kArrUnpaid              @"arr_unpaid"
#define kArrEvent               @"arr_event"

#define kDicUserInfo            @"dic_userinfo"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


typedef enum {
    Sort_Popular = 0,
    Sort_Viewed,
    Sort_Recent
}SortType;

typedef enum {
    Type_Unisex = 0,
    Type_Men,
    Type_Women
}Type_Gender;

typedef enum {
    Size_XS = 0,
    Size_S,
    Size_M,
    Size_L,
    Size_XL
}SizeType;

#endif
