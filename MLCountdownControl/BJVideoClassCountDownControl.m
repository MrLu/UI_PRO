//
//  BJVideoClassCountDownControl.m
//  UI_PRO
//
//  Created by Mrlu-bjhl on 16/7/27.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import "BJVideoClassCountDownControl.h"

@interface  BJVideoClassCountDownControl()

@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *timeContainView;
@property (nonatomic, strong) UILabel *timelabel; //完整时间3天23时10分
@property (nonatomic, strong) TimeCardView *cardView; //24小时内
@end

@implementation BJVideoClassCountDownControl

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
    [self addSubview:self.desLabel];
    [self addSubview:self.timeContainView];
    CGRect frame = self.timeContainView.frame;
    frame.origin.x = CGRectGetMaxX(self.desLabel.frame)+5;
    [self.timeContainView setFrame:frame];
}

- (void)setupTimeStyle
{
    if (self.startTimeStamp>0) {
        [_desLabel setText:@"距抢购开始"];
        if (_timelabel) {
            [_timelabel removeFromSuperview];
            _timelabel = nil;
        }
        if (_cardView) {
            return;
        }
        [self.timeContainView addSubview:self.cardView];
        
    } else {
        [_desLabel setText:@"距抢购结束"];
        if (self.timeStamp>=3600*24) {
            if (_cardView) {
                [_cardView removeFromSuperview];
                _cardView = nil;
            }
            if (_timelabel) {
                return;
            }
            [self.timeContainView addSubview:self.timelabel];
        } else {
            if (_timelabel) {
                [_timelabel removeFromSuperview];
                _timelabel = nil;
            }
            if (_cardView) {
                return;
            }
            [self.timeContainView addSubview:self.cardView];
        }
    }
}

- (UILabel *)timelabel
{
    if (!_timelabel)
    {
        _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200,CGRectGetHeight(self.frame))];
        [_timelabel setTextAlignment:NSTextAlignmentLeft];
        [_timelabel setTextColor:[UIColor grayColor]];
        [_timelabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _timelabel;
}

- (TimeCardView *)cardView
{
    if (!_cardView) {
        _cardView = [[TimeCardView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
    }
    return _cardView;
}

- (UIView *)timeContainView
{
    if (!_timeContainView) {
        _timeContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(self.frame))];
    }
    return _timeContainView;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
        [_desLabel setTextAlignment:NSTextAlignmentRight];
        [_desLabel setTextColor:[UIColor grayColor]];
        [_desLabel setFont:[UIFont systemFontOfSize:12]];
        [_desLabel setText:@"距抢购开始"];
        CGRect frame = _desLabel.frame;
        frame.size.width = 12*5+2+14+5;
        [_desLabel setFrame:frame];
        
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-16)/2, 16, 16)];
        [iconImageView setImage:[UIImage imageNamed:@"ic_ nav_history_black_n"]];
        [_desLabel addSubview:iconImageView];
    }
    return _desLabel;
}

- (void)setTimeValue
{
    if (self.startTimeStamp>0) {
        [self.cardView setTimeStamp:self.startTimeStamp];
    } else {
        if(self.timeStamp>=3600*24) {
            NSInteger ms = self.timeStamp;
            NSInteger ss = 1;
            NSInteger mi = ss * 60;
            NSInteger hh = mi * 60;
            NSInteger dd = hh * 24;
            
            // 剩余的
            NSInteger day = ms / dd;// 天
            NSInteger hour = (ms - day * dd) / hh;// 时
            NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
            NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
            
            [_timelabel setText:[NSString stringWithFormat:@"%.2ld天%.2ld时%.2ld分",day,hour,minute+(second>0?1:0)]];
        } else {
            [self.cardView setTimeStamp:self.timeStamp];
        }
    }
}

- (void)timerEvent
{
    if (self.startTimeStamp>0) {
        self.startTimeStamp--;
    } else {
        [super timerEvent];
    }
    [self setupTimeStyle];
    [self setTimeValue];
}

- (void)fire
{
    [super fire];
    [self setupTimeStyle];
    [self setTimeValue];
}

@end

