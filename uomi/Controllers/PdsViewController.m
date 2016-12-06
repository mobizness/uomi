//
//  PdsViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "PdsViewController.h"
#import "Onboarding1ViewController.h"
#import "DGActivityIndicatorView.h"

@interface PdsViewController () {
    DGActivityIndicatorView *activityIndicatorView;
}
@end

@implementation PdsViewController
- (void)viewDidLoad {
    _viewTextviewContainer.layer.borderWidth = 2;
    _viewTextviewContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [commonUtils setButtonMultiLineText:_btnNext];
    
    
}
- (IBAction)OnAgree:(id)sender {

    [commonUtils showSmallIndicator:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        Onboarding1ViewController* onboarding1ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Onboarding1ViewController"];
        [self.navigationController pushViewController:onboarding1ViewController animated:YES];

    });

}
@end
