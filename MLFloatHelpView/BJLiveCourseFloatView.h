//
//  BJLiveCourseFloatView.h
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/7/3.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "MLFloatHelpView.h"

@interface BJLiveCourseFloatView : MLFloatHelpView

@property (strong, nonatomic) NSDictionary *data;

+ (instancetype)shareInstance;
- (void)showWithView:(UIView *)view;

@end
