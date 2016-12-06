//
//  FilterViewController.m
//  uomi
//
//  Created by scs on 10/20/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "FilterViewController.h"
#import "VSDropdown.h"

@interface FilterViewController ()<VSDropdownDelegate>{
    VSDropdown*_dropdown;
    int status;
}
@end

@implementation FilterViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *dicFilter = [commonUtils getUserDefaultDicByKey:_filterType];
    
    _sliderMoney.minimumValue = 0;
    _sliderMoney.maximumValue = _maxPrice;
    if (_maxPrice == 0) {
        _sliderMoney.maximumValue = 100;
    }
    
    _sliderPeople.minimumValue = 0;
    
    _sliderPeople.maximumValue = _maxPeople;
    if (_maxPeople == 0) {
        _sliderPeople.maximumValue = 10;
    }
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    
    _btnPaid.layer.borderWidth = 1;
    _btnUnpaid.layer.borderWidth = 1;

    
    if (dicFilter.count == 0) {
        _sliderMoney.lowerValue = 0;
        _sliderMoney.upperValue = _maxPrice;

        _sliderPeople.lowerValue = 0;
        _sliderPeople.upperValue = _maxPeople;
        
        [_btnDate setTitle:@"ALL" forState:UIControlStateNormal];
        status = -1;
        
    }
    else {
        _sliderMoney.upperValue = [[dicFilter objectForKey:@"money_upper"] intValue];
        _sliderMoney.lowerValue = [[dicFilter objectForKey:@"money_lower"] intValue];
        if ([[dicFilter objectForKey:@"money_upper"] intValue] > _maxPrice) {
            _sliderMoney.upperValue = _maxPrice;
        }
        if ([[dicFilter objectForKey:@"money_lower"] intValue] > _maxPrice) {
            _sliderMoney.lowerValue = _maxPrice;
        }
        
        
        _sliderPeople.upperValue = [[dicFilter objectForKey:@"people_upper"] intValue];
        _sliderPeople.lowerValue = [[dicFilter objectForKey:@"people_lower"] intValue];
        
        if ([[dicFilter objectForKey:@"people_upper"] intValue] > _maxPeople) {
            _sliderPeople.upperValue = _maxPeople;
        }
        if ([[dicFilter objectForKey:@"people_lower"] intValue] > _maxPeople) {
            _sliderPeople.lowerValue = _maxPeople;
        }
        
        [_btnDate setTitle:[dicFilter objectForKey:@"date"] forState:UIControlStateNormal];
        status = [[dicFilter objectForKey:@"status"] intValue];
        
    }

    [self refreshStatus];
    
    _sliderMoney.tintColor = [UIColor blackColor];
    _sliderPeople.tintColor = [UIColor blackColor];
    
    if ([_filterType isEqualToString:@"filter_paid"]) {
        _viewPeople.hidden = true;
    }
    else {
        _viewMoney.hidden = true;
    }

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSliderMoney];
    [self updateSliderPeople];
    
}

#pragma mark - NMRangSlier
- (void) updateSliderMoney
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.sliderMoney.lowerCenter.x + self.sliderMoney.frame.origin.x);
    lowerCenter.y = (self.sliderMoney.center.y + 30.0f);
    self.lblMoneyLower.center = lowerCenter;
    self.lblMoneyLower.text = [NSString stringWithFormat:@"$%d", (int)self.sliderMoney.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.sliderMoney.upperCenter.x + self.sliderMoney.frame.origin.x);
    upperCenter.y = (self.sliderMoney.center.y + 30.0f);
    self.lblMoneyUpper.center = upperCenter;
    self.lblMoneyUpper.text = [NSString stringWithFormat:@"$%d", (int)self.sliderMoney.upperValue];
}

- (void) updateSliderPeople
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.sliderPeople.lowerCenter.x + self.sliderPeople.frame.origin.x);
    lowerCenter.y = (self.sliderPeople.center.y + 30.0f);
    self.lblPeopleLower.center = lowerCenter;
    self.lblPeopleLower.text = [NSString stringWithFormat:@"%d", (int)self.sliderPeople.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.sliderPeople.upperCenter.x + self.sliderPeople.frame.origin.x);
    upperCenter.y = (self.sliderPeople.center.y + 30.0f);
    self.lblPeopleUpper.center = upperCenter;
    self.lblPeopleUpper.text = [NSString stringWithFormat:@"%d", (int)self.sliderPeople.upperValue];
}

- (void)refreshStatus {
    _btnPaid.backgroundColor = [UIColor whiteColor];
    _btnUnpaid.backgroundColor = [UIColor whiteColor];
    _btnPaid.tintColor = COLOR_BROWN;
    _btnUnpaid.tintColor = COLOR_BROWN;
    _btnPaid.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.08].CGColor;
    _btnUnpaid.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.08].CGColor;
    
    if (status == 0) {
        _btnPaid.backgroundColor = COLOR_BROWN;
        _btnPaid.tintColor = [UIColor whiteColor];
        _btnPaid.layer.borderColor = COLOR_BROWN.CGColor;
    }
    else if (status == 1) {
        _btnUnpaid.backgroundColor = COLOR_BROWN;
        _btnUnpaid.tintColor = [UIColor whiteColor];
        _btnUnpaid.layer.borderColor = COLOR_BROWN.CGColor;
    }
}

// Handle control value changed events just like a normal slider

#pragma mark - VSDropDown

- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [_dropdown setDrodownAnimation:rand() % 2];
    
    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown setShouldSortItems:NO];
    //    [_dropdown setSeparatorColor:sender.titleLabel.textColor];
    [_dropdown setSeparatorColor:[UIColor clearColor]];
    
    if (_dropdown.allowMultipleSelection) {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        //        NSArray* arraytext = [[NSArray alloc] initWithObjects:@"1", nil];
        NSString *str = sender.titleLabel.text;
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[sender.titleLabel.text]];
        //        [_dropdown reloadDropdownWithContents:contents keyPath:@"name" selectedItems:@[sender.titleLabel.text]];
    }
}
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
    
}
- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown {
    //    UIButton *btn = (UIButton *)dropdown.dropDownView;
    
    //    return btn.titleLabel.textColor;
    return [UIColor grayColor];
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown {
    return 1.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown {
    return 3.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown {
    return -2.0;
}


#pragma mark - IBAction

- (IBAction)OnDate:(id)sender {
    NSMutableArray *arrDate = [[NSMutableArray alloc] initWithObjects:@"ALL",@"TODAY",@"2 DAYS AGO",@"1 WEEKS AGO",@"2 WEEKS AGO",@"1 MONTH AGO", nil];
    [self showDropDownForButton:sender adContents:arrDate multipleSelection:NO];
}

- (IBAction)sliderMoneyChanged:(NMRangeSlider*)sender
{
    [self updateSliderMoney];
}

- (IBAction)sliderPeopleChanged:(NMRangeSlider*)sender
{
    [self updateSliderPeople];
}

- (IBAction)OnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OnApplyFilters:(id)sender {
    NSMutableDictionary *dicFilter = [[NSMutableDictionary alloc] init];
    
    [dicFilter setObject:[_lblMoneyLower.text substringFromIndex:1] forKey:@"money_lower"];
    [dicFilter setObject:[_lblMoneyUpper.text substringFromIndex:1] forKey:@"money_upper"];
    [dicFilter setObject:_lblPeopleLower.text forKey:@"people_lower"];
    [dicFilter setObject:_lblPeopleUpper.text forKey:@"people_upper"];
    [dicFilter setObject:_btnDate.currentTitle forKey:@"date"];
    [dicFilter setValue:[NSString stringWithFormat:@"%d", status] forKey:@"status"];
    
    [commonUtils setUserDefaultDic:_filterType withDic:dicFilter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)OnChoosePaid:(id)sender {
    if (status == 0) {
        status = -1;
    }
    else {
        status = 0;
    }
    [self refreshStatus];
}

- (IBAction)OnChooseUnpaid:(id)sender {
    if (status == 1) {
        status = -1;
    }
    else {
        status = 1;
    }
    [self refreshStatus];
}

- (IBAction)OnClearFilters:(id)sender {
    _sliderMoney.lowerValue = 0;
    _sliderMoney.upperValue = 100;
    
    _sliderPeople.lowerValue = 0;
    _sliderPeople.upperValue = 10;
    
    [self updateSliderMoney];
    [self updateSliderPeople];
    
    [_btnDate setTitle:@"ALL" forState:UIControlStateNormal];
    status = -1;
    [self refreshStatus];
}


@end
