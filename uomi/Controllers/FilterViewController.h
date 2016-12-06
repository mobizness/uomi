//
//  FilterViewController.h
//  uomi
//
//  Created by scs on 10/20/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface FilterViewController : UIViewController

@property (strong, nonatomic) IBOutlet NMRangeSlider *sliderMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblMoneyLower;
@property (strong, nonatomic) IBOutlet UILabel *lblMoneyUpper;

@property (strong, nonatomic) IBOutlet NMRangeSlider *sliderPeople;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleLower;
@property (strong, nonatomic) IBOutlet UILabel *lblPeopleUpper;

@property (strong, nonatomic) IBOutlet UIButton *btnDate;
@property (strong, nonatomic) IBOutlet UIButton *btnPaid;
@property (strong, nonatomic) IBOutlet UIButton *btnUnpaid;
@property (strong, nonatomic) IBOutlet UIView *viewMoney;
@property (strong, nonatomic) IBOutlet UIView *viewPeople;

@property (strong, strong) NSString *filterType;
@property (nonatomic, assign) float maxPrice;
@property (nonatomic, assign) int maxPeople;

- (IBAction)OnClose:(id)sender;
- (IBAction)OnApplyFilters:(id)sender;
- (IBAction)OnChoosePaid:(id)sender;
- (IBAction)OnChooseUnpaid:(id)sender;
- (IBAction)OnClearFilters:(id)sender;

@end
