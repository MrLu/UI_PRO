//
//  TimeCardView.m
//  UI_PRO
//
//  Created by Mrlu-bjhl on 16/7/27.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import "TimeCardView.h"

@implementation TimeCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    [self addSubview:self.hourLabel];
    
    UILabel *hourColonLabel = [self generateColonLabel];
    [self addSubview:hourColonLabel];
    CGRect frame = hourColonLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.hourLabel.frame);
    hourColonLabel.frame = frame;
    
    [self addSubview:self.minLabel];
    frame = self.minLabel.frame;
    frame.origin.x = CGRectGetMaxX(hourColonLabel.frame);
    self.minLabel.frame = frame;
    
    UILabel *minColonLabel = [self generateColonLabel];
    [self addSubview:minColonLabel];
    frame = minColonLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.minLabel.frame);
    minColonLabel.frame = frame;
    
    [self addSubview:self.secLabel];
    frame = self.secLabel.frame;
    frame.origin.x = CGRectGetMaxX(minColonLabel.frame);
    self.secLabel.frame = frame;
    
    frame = self.frame;
    frame.size.width = CGRectGetMaxX(self.secLabel.frame);
    self.frame = frame;
}

- (UILabel *)hourLabel
{
    if (!_hourLabel) {
        _hourLabel = [self generateLabel];
    }
    return _hourLabel;
}

- (UILabel *)minLabel
{
    if (!_minLabel) {
        _minLabel = [self generateLabel];
    }
    return _minLabel;
}

- (UILabel *)secLabel
{
    if (!_secLabel) {
        _secLabel = [self generateLabel];
    }
    return _secLabel;
}

- (UILabel *)generateLabel
{
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-18)/2, 20,18)];
    [cardLabel setBackgroundColor:[UIColor redColor]];
    [cardLabel setTextAlignment:NSTextAlignmentCenter];
    [cardLabel setTextColor:[UIColor whiteColor]];
    [cardLabel setText:@"00"];
    [cardLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [cardLabel.layer setCornerRadius:3];
    [cardLabel.layer setMasksToBounds:YES];
    return cardLabel;
}

- (UILabel *)generateColonLabel
{
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(CGRectGetHeight(self.frame)-18)/2, 12 ,18)];
    [cardLabel setBackgroundColor:[UIColor clearColor]];
    [cardLabel setTextAlignment:NSTextAlignmentCenter];
    [cardLabel setTextColor:[UIColor redColor]];
    [cardLabel setText:@":"];
    [cardLabel setFont:[UIFont boldSystemFontOfSize:14]];
    return cardLabel;
}

- (void)setTimeStamp:(long long)timeStamp
{
    _timeStamp = timeStamp;
    [self getDetailTimeWithTimestamp:_timeStamp];
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    
    //    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%.2ld",hour];
    self.minLabel.text = [NSString stringWithFormat:@"%.2ld",minute+(second>0?1:0)];
    self.secLabel.text = [NSString stringWithFormat:@"%.2ld",second];
}

@end
