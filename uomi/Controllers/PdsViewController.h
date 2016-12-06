//
//  PdsViewController.h
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PdsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewTextviewContainer;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property (strong, nonatomic) IBOutlet UIView *viewBottomBar;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)OnAgree:(id)sender;
@end
