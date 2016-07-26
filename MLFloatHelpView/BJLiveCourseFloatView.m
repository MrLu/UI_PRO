//
//  BJLiveCourseFloatView.m
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/7/3.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "BJLiveCourseFloatView.h"
#import "AppDelegate.h"

#define DefaultCenter CGPointMake([UIScreen mainScreen].bounds.size.width-35,[UIScreen mainScreen].bounds.size.height-44-25-40-40)

@interface BJLiveCourseFloatView()

@property (strong, nonatomic) UIView *control;
@property (strong, nonatomic) UIImageView *avatorImageView;
@property (strong, nonatomic) UIView *avatorImageViewContain;
@property (strong, nonatomic) UIImageView *playImageViewContainView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *textBtn;
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation BJLiveCourseFloatView

+ (instancetype)shareInstance
{
    static BJLiveCourseFloatView *sharedBJFlowHelpView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBJFlowHelpView = [[BJLiveCourseFloatView alloc] init];
    });
    return sharedBJFlowHelpView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.point = DefaultCenter;
        self.size = CGSizeMake(50, 50);
        self.edgeInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.attachBound = YES;
        self.bounces = NO;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    [self addSubview:self.control];
    [self.control addSubview:self.avatorImageViewContain];
    [self.avatorImageViewContain addSubview:self.avatorImageView];
    [self.avatorImageViewContain addSubview:self.playImageViewContainView];
    [self.control addSubview:self.imageView];
    [self.control addSubview:self.textBtn];

    //layout
    [self.control setFrame:self.bounds];
    [self.imageView setFrame:CGRectMake(0, 0, 46, 46)];
    CGPoint center =  self.imageView.center;
    center.x = self.control.frame.size.width/2;
    [self.imageView setCenter:center];
    
    [self.avatorImageViewContain setFrame:CGRectMake(0, 1, 44, 44)];
    [self.avatorImageViewContain setCenter:self.imageView.center];
    [self.avatorImageViewContain.layer setCornerRadius:self.avatorImageViewContain.frame.size.width/2.];
    [self.avatorImageViewContain.layer setMasksToBounds:YES];
    
    [self.avatorImageView setFrame:self.avatorImageViewContain.bounds];
    [self.playImageViewContainView setFrame:self.avatorImageViewContain.bounds];
    
    [self.textBtn setFrame:CGRectMake(1, CGRectGetHeight(self.control.frame) - 15, CGRectGetWidth(self.control.frame) - 2, 17)];
}

- (void)showWithView:(UIView *)view
{
    [self setData:nil];
    [self showInView:view];
}

#pragma mark - helper

#pragma mark - property Getter/Setter
- (UIView *)control
{
    if (!_control) {
        _control = [[UIView alloc]init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(controlAction:)];
        [_control addGestureRecognizer:tapGesture];
    }
    return _control;
}

- (UIView *)avatorImageViewContain
{
    if (!_avatorImageViewContain) {
        _avatorImageViewContain = [[UIView alloc]init];
        [_avatorImageViewContain setUserInteractionEnabled:NO];
    }
    return _avatorImageViewContain;
}

- (UIImageView *)avatorImageView
{
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc]init];
        [_avatorImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_avatorImageView setUserInteractionEnabled:NO];
    }
    return _avatorImageView;
}

- (UIButton *)textBtn
{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textBtn setBackgroundColor:[UIColor clearColor]];
        [_textBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_textBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_textBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_textBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
        [_textBtn setBackgroundImage:[[UIImage imageNamed:@"bg_quick_square"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [_textBtn setUserInteractionEnabled:NO];
    }
    return _textBtn;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView setImage:[UIImage imageNamed:@"ic_quick_round"]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:NO];
        [_imageView.layer setShadowColor:[UIColor grayColor].CGColor];
        [_imageView.layer setShadowRadius:4];
        [_imageView.layer setShadowOpacity:1];
        CGRect box = CGRectInset(self.bounds, self.bounds.size.width * 0.1f, self.bounds.size.height * 0.1f);
        UIBezierPath *ballBezierPath = [UIBezierPath bezierPathWithOvalInRect:box];
        [_imageView.layer setShadowPath:ballBezierPath.CGPath];
    }
    return _imageView;
}

- (UIImageView *)playImageViewContainView
{
    if (!_playImageViewContainView) {
        _playImageViewContainView = [[UIImageView alloc]init];
        [_playImageViewContainView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_playImageViewContainView setContentMode:UIViewContentModeScaleAspectFit];
        [_playImageViewContainView setUserInteractionEnabled:NO];
    }
    return _playImageViewContainView;
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self loadViewData];
}

- (void)loadViewData
{
    [self.avatorImageView setBackgroundColor:[UIColor grayColor]];
    [self.textBtn setTitle:@"点我" forState:UIControlStateNormal];
}

- (void)dismiss
{
    [super dismiss];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)controlAction:(id)action
{
    [self.avatorImageView setBackgroundColor:[UIColor colorWithWhite:(arc4random()%100)/100.0 alpha:1]];
}

@end
