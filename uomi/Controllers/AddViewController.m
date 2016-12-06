//
//  AddViewController.m
//  uomi
//
//  Created by scs on 10/14/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "AddViewController.h"
#import "AddNewViewController.h"

@interface AddViewController() {
    BOOL isNew;
}
@end
@implementation AddViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    isNew = true;

}

- (void)viewDidAppear:(BOOL)animated {
    if (isNew) {
        isNew = false;
        AddNewViewController* addMembersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewViewController"];
//        [self.navigationController pushViewController:addMembersViewController animated:YES];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addMembersViewController];
        [navigationController setNavigationBarHidden:YES];
        [self presentViewController:navigationController animated:YES completion:^{}];

    }
    else {
        isNew = true;
        self.tabBarController.selectedIndex = 1;
    }
}

@end
