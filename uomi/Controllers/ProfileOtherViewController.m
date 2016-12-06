//
//  ProfileOtherViewController.m
//  uomi
//
//  Created by scs on 10/24/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "ProfileOtherViewController.h"
@interface ProfileOtherViewController () {
    NSMutableArray *arrColors;
}
@end
@implementation ProfileOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrColors = [commonUtils getColorArray];
    
    [self showDetail];
}

- (void)showDetail {
    _imgAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
    _imgAvatar.layer.shadowOffset = CGSizeZero;
    _imgAvatar.layer.shadowRadius = 1.0;
    _imgAvatar.layer.shadowOpacity = 0.2;
    _imgAvatar.layer.masksToBounds = NO;
    
    [commonUtils setCircleBorderImage:_imgAvatar withBorderWidth:0.5 withBorderColor:[UIColor clearColor]];
    
    _lblPaid.text = [NSString stringWithFormat:@"$%.2f", [[_dicUserInfo objectForKey:@"paid"] floatValue]];
    _lblReceived.text = [NSString stringWithFormat:@"$%.2f", [[_dicUserInfo objectForKey:@"received"] floatValue]];
    _lblUserName.text = [_dicUserInfo objectForKey:@"user_name"];
    _lblShortName.text = [commonUtils getShortName:[_dicUserInfo objectForKey:@"user_name"]];
    
    if ([[_dicUserInfo objectForKey:@"user_image"] isEqualToString:@""]) {
        _imgAvatar.backgroundColor = [arrColors objectAtIndex: [[_dicUserInfo objectForKey:@"user_id"] intValue] % arrColors.count];
        _lblShortName.hidden = NO;
    }
    else {
        [commonUtils setImageViewAFNetworking:_imgAvatar withImageUrl:[_dicUserInfo objectForKey:@"user_image"] withPlaceholderImage:[UIImage imageNamed:@"blank"]];
        _lblShortName.hidden = YES;
        _imgAvatar.backgroundColor = [UIColor clearColor];
    }
    
}

- (IBAction)OnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnSend:(id)sender {
}

- (IBAction)OnRequest:(id)sender {
}

- (IBAction)OnSearch:(id)sender {
}

@end
