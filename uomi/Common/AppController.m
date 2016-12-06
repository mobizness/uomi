//
//  AppController.m


#import "AppController.h"
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Data
        _dicUserInfo = [[NSMutableDictionary alloc] init];
        
        // Utility Data
        _appMainColor = RGBA(227, 6, 19, 1.0f);
        
        [self initBaseData];
    }
    return self;
}


#pragma mark - Set Base Data
- (void)initBaseData {
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:@"1" forKey:@"user_id"];
    
    _dicUserInfo = [userInfo mutableCopy];
    _arrAllUsers = [[NSMutableArray alloc] init];
    _arrContacts = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dicFilter = [[NSMutableDictionary alloc] init];
    
    dicFilter = [@{@"money_lower"     : @"0",
                   @"money_upper"     : @"100",
                   @"people_lower"    : @"0",
                   @"people_upper"    : @"10",
                   @"date"            : @"ALL",
                   @"status"          : @"-1"
                   } mutableCopy];
    if ([commonUtils getUserDefaultDicByKey:@"filter_paid"] == nil || [commonUtils getUserDefaultDicByKey:@"filter_paid"].count == 0) {
    
        [commonUtils setUserDefaultDic:@"filter_paid" withDic:dicFilter];
    }
    if ([commonUtils getUserDefaultDicByKey:@"filter_received"] == nil || [commonUtils getUserDefaultDicByKey:@"filter_received"].count == 0) {
        
        [commonUtils setUserDefaultDic:@"filter_received" withDic:dicFilter];
    }

}

@end
