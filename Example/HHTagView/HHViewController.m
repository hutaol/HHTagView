//
//  HHViewController.m
//  HHTagView
//
//  Created by 1325049637@qq.com on 04/26/2021.
//  Copyright (c) 2021 1325049637@qq.com. All rights reserved.
//

#import "HHViewController.h"
#import <HHTagView.h>

@interface HHViewController () <HHTagViewDelegate>

@property (nonatomic, strong) HHTagView *tagView;

@end

@implementation HHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tagView = [[HHTagView alloc] init];
    _tagView.frame = CGRectMake(0, 100, self.view.frame.size.width, 300);
    _tagView.backgroundColor = [UIColor redColor];
    _tagView.delegate = self;
    _tagView.tagAlignment = HHTagAlignmentRight;
    
    _tagView.tagArray = @[@"12", @"23", @"345"];
    
    [self.view addSubview:_tagView];
    
    _tagView.frame = CGRectMake(0, 100, self.view.frame.size.width, _tagView.tagHeight);
        
}

- (void)onClick {
    NSLog(@"onClick");

}

#pragma mark - HHTagViewDelegate

- (void)tagView:(HHTagView *)view didSelectTagAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%@", text);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
