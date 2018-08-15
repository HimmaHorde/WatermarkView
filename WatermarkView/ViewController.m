//
//  ViewController.m
//  WatermarkView
//
//  Created by yanglin on 2018/8/15.
//  Copyright © 2018 yanglin. All rights reserved.
//

#import "ViewController.h"
#import "WatermarkView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WatermarkView * markView =  [[WatermarkView alloc] initWithFrame:self.view.bounds WithText:@"测试1998"];
    [self.view addSubview:markView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
