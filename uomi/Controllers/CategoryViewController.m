//
//  CategoryViewController.m
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "CategoryViewController.h"

@implementation CategoryViewController

- (IBAction)OnFood:(id)sender {
    [appController.selectedCategory setObject:@"Food" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_food.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnDrinks:(id)sender {
    [appController.selectedCategory setObject:@"Drinks" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_drinks.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnGift:(id)sender {
    [appController.selectedCategory setObject:@"Gifts" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_gift.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnShopping:(id)sender {
    [appController.selectedCategory setObject:@"Shopping" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_shopping.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnEntertainment:(id)sender {
    [appController.selectedCategory setObject:@"Entertainment" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_entertainment.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnBills:(id)sender {
    [appController.selectedCategory setObject:@"Bills" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_bill.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnCoffee:(id)sender {
    [appController.selectedCategory setObject:@"Coffee / Tag" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_coffee.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnTravel:(id)sender {
    [appController.selectedCategory setObject:@"Travel" forKey:@"cat_name"];
    [appController.selectedCategory setObject:@"icon_cat_travel.png" forKey:@"cat_image"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
