//
//  TutorialViewController.m
//  uomi
//
//  Created by scs on 10/13/16.
//  Copyright © 2016 scs. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()<UIPageViewControllerDelegate, UIScrollViewDelegate> {
    
}
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
    [_pageController addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    _pageController.currentPage = 0;
    
    _scrollView.delegate = self;

}

- (IBAction) changePage:(id)sender {
    CGFloat x = _pageController.currentPage * _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(x, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int nPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _pageController.currentPage = nPage;
}

@end
