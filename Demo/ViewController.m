//
//  ViewController.m
//  Demo
//
//  Created by BtyLiuPeng on 1/2/16.
//  Copyright © 2016 BtyLiuPeng. All rights reserved.
//

#import "ViewController.h"
#import "NESegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NESegmentedControl *segmentView = [[NESegmentedControl alloc] initWithFrame:CGRectMake(50, 100, 345, 34)];
//    segmentView.frame =
    
    segmentView.titles = @[@"年", @"月", @"周", @"日"];
    segmentView.tintColor = [UIColor redColor];
    
    
    [self.view addSubview:segmentView];
    
//    segmentView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[segmentView(34)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(segmentView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[segmentView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(segmentView)]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
