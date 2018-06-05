//
//  MLCountDowner.h
//  xdfapp
//
//  Created by Mrlu on 30/05/2017.
//  Copyright © 2017 xdf.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于绑定在数据对象上来保证数据不错乱问题，可以用于cell重用上
 */

NS_ASSUME_NONNULL_BEGIN

typedef void(^TimeStopBlock)(void);

@interface MLCountDowner : NSObject

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
