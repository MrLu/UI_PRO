//
//  ViewController.m
//  MLCountdownControl
//
//  Created by Mrlu-bjhl on 16/7/26.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import "ViewController.h"
#import "BJVideoClassCountDownControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    BJVideoClassCountDownControl *countdownControl = [[BJVideoClassCountDownControl alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    [countdownControl setTimeStamp:60*60*24];
    [countdownControl fire];
    countdownControl.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self.view addSubview:countdownControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
