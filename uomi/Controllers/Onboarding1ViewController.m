//
//  Onboarding1ViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "Onboarding1ViewController.h"
#import "Onboarding2ViewController.h"

@implementation Onboarding1ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)OnEnable:(id)sender {
    Onboarding2ViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding2ViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
