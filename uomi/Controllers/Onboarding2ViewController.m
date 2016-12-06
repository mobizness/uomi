//
//  Onboarding2ViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "Onboarding2ViewController.h"
#import "Onboarding3ViewController.h"

@implementation Onboarding2ViewController

- (IBAction)OnEnable:(id)sender {
    Onboarding3ViewController* VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding3ViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
