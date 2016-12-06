//
//  TabbarController.m
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "TabbarController.h"
#import "AddNewViewController.h"

@implementation TabbarController
- (void)viewWillLayoutSubviews {

    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - 5, self.tabBar.frame.size.width, self.tabBar.frame.size.height + 20);
    self.tabBar.backgroundColor = [UIColor colorWithWhite:255 alpha:1];
//    self.tabBar.layer.shadowOffset = CGSizeMake(0, 1);
//    self.tabBar.layer.shadowOpacity = 0.5f;
    
    CGFloat itemWidth = self.tabBar.frame.size.width / 5;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * 2, 0, itemWidth, self.tabBar.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:124.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
    [self.tabBar insertSubview:bgView atIndex:1];
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:2];
    
    UIImage *imgPlus = [UIImage imageNamed:@"icon_tapbar_plus"];

    [tabBarItem setImage: [imgPlus imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[imgPlus imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    self.hidesBottomBarWhenPushed = YES;
}

@end
