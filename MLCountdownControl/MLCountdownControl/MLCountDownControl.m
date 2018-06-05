//
//  MLCountDownControl.m
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 16/5/5.
//  Copyright © 2016年 Baijiahulian. All rights reserved.
//

#import "MLCountDownControl.h"

@interface MLCountDownControl ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MLCountDownControl

+ (instancetype)shareInstance
{
    static MLCountDownControl *countdownControl= nil;
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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


