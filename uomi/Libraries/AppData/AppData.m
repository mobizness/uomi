//
//  AppData.m
//  Dopple
//
//  Created by Mitchell Williams on 21/08/2015.
//  Copyright (c) 2015 Mitchell Williams. All rights reserved.
//

#import "AppData.h"

@implementation AppData

#pragma mark - Initialization
+ (AppData*) sharedData
{
    static AppData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc]init];
    });
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark - Getter and Setter
#pragma mark- NSString
- (void) setStrUserid:(NSString*)strUserid
{
    [[NSUserDefaults standardUserDefaults] setValue:strUserid forKey:kStrUserid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) strUserid
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kStrUserid];
}


#pragma mark- BOOL
- (void) setBLoggedIn:(BOOL)bLoggedIn
{
    [[NSUserDefaults standardUserDefaults] setBool:bLoggedIn forKey:kLoggedIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) bLoggedIn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoggedIn];
}



#pragma mark- int

- (void) setNSortType:(int)nSortType
{
    [[NSUserDefaults standardUserDefaults] setInteger:nSortType forKey:kNSortType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int) nSortType
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:kNSortType];
}



#pragma mark- NSArray
- (void) setArrReceipts:(NSMutableArray *)arrReceipts
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrReceipts];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kArrReceipts];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*) arrReceipts
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kArrReceipts];
    
    NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSMutableArray* arrResult = nil;
    if (!arrTemp)
    {
        arrResult = [NSMutableArray new];
    }
    else
    {
        arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
    }
    
    return arrResult;
}

- (void) setArrPaid:(NSMutableArray *)arrPaid
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrPaid];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kArrPaid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*) arrPaid
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kArrPaid];
    
    NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSMutableArray* arrResult = nil;
    if (!arrTemp)
    {
        arrResult = [NSMutableArray new];
    }
    else
    {
        arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
    }
    
    return arrResult;
}

- (void) setArrUnpaid:(NSMutableArray *)arrUnpaid
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrUnpaid];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kArrUnpaid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*) arrUnpaid
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kArrUnpaid];
    
    NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSMutableArray* arrResult = nil;
    if (!arrTemp)
    {
        arrResult = [NSMutableArray new];
    }
    else
    {
        arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
    }
    
    return arrResult;
}


- (void) setArrEvent:(NSMutableArray *)arrEvent
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrEvent];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kArrEvent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray*) arrEvent
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kArrEvent];
    
    NSArray* arrTemp = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSMutableArray* arrResult = nil;
    if (!arrTemp)
    {
        arrResult = [NSMutableArray new];
    }
    else
    {
        arrResult = [[NSMutableArray alloc] initWithArray:arrTemp];
    }
    
    return arrResult;
}


#pragma mark- NSDictionary

- (void) setDicUserInfo:(NSMutableDictionary *)dicUserInfo
{
    [[NSUserDefaults standardUserDefaults] setValue:dicUserInfo forKey:kDicUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary*) dicUserInfo
{
    NSMutableDictionary* dicTemp = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kDicUserInfo]];
    
    return dicTemp;
}


@end
