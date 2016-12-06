//
//  MessageLabel.m
//  uomi
//
//  Created by scs on 10/26/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "MessageLabel.h"

@implementation MessageLabel
- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {3, 3, 3, 3};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
