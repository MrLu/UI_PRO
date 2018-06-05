//
//  MLCountDownControl.h
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 16/5/5.
//  Copyright © 2016年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TimeStopBlock)(void);

@interface MLCountDownControl : UIControl

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) TimeStopBlock timeStopBlock;
@property (nonatomic, assign) long long timeStamp; //倒计时间

+ (instancetype)shareInstance;

+ (instancetype)instance;

- (void)fire NS_REQUIRES_SUPER;
- (void)invalidate;
- (void)timerEvent NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
