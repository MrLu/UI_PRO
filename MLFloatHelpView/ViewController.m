//
//  ViewController.m
//  MLFloatHelpView
//
//  Created by Mrlu-bjhl on 16/7/26.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import "ViewController.h"
#import "BJLiveCourseFloatView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [[BJLiveCourseFloatView shareInstance] showWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
