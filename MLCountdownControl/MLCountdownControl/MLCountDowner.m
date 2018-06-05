//
//  MLCountDowner.m
//  xdfapp
//
//  Created by Mrlu on 30/05/2017.
//  Copyright © 2017 xdf.cn. All rights reserved.
//

#import "MLCountDowner.h"

@interface MLCountDowner ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MLCountDowner

+ (instancetype)shareInstance
{
    static MLCountDowner *countdownControl= nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        countdownControl = [[self alloc] init];
    });
    return countdownControl;
}

+ (instancetype)instance
{
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeInterval = 1;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

- (void)timerEvent
{
    self.timeStamp--;
    if (self.timeStamp == 0) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        if (self.timeStopBlock) {
            self.timeStopBlock();
        }
    }
}

- (void)fire
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidate
{
    [_timer invalidate];
    _timer = nil;
}

@end
