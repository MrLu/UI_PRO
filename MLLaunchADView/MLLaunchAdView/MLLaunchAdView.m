//
//  MLLaunchAdView.m
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/1/16.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "MLLaunchAdView.h"

@implementation AdModel

+ (NSArray<AdModel *> *)initWithImageUrls:(NSArray<NSString *> *)array
{
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *imageUrl in array) {
        AdModel *ad = [AdModel new];
        ad.imageUrl = imageUrl;
        [temArray addObject:ad];
    }
    return temArray;
}

@end

@interface AdViewCell()


@end

@implementation AdViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    if (imageUrl) {
        _imageUrl = imageUrl;
        [self sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
    }
}

@end

@interface MLLaunchAdView ()
{
    BOOL _isShow;
    
    NSTimer *_timer;
    
    UIView *_parentView;
    
    NSTimeInterval _timeInterval;
    
    AdViewCell *_contentImageView;
}

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UIWindow *cusWindow;
@property (nonatomic, strong) NSArray *imagesUrlArray; //数据数组

@property (nonatomic, strong, readwrite) AdViewCell *contentImageView;
@property (nonatomic, strong, readwrite) UIButton *closeBtn;
@property (nonatomic, strong, readwrite) UIButton *timeBtn;
@property (nonatomic, strong, readwrite) UIImageView *logoImageView;
@property (nonatomic, strong) UIImage *logoImage;

@property (nonatomic, copy) DismissAction dismissAction;   //点击动作

@end

static dispatch_semaphore_t _semaphore;
static dispatch_queue_t _downloadQueue;

@implementation MLLaunchAdView

+ (instancetype)shareInstance
{
    static MLLaunchAdView *launchAdView= nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!_semaphore) {
            _semaphore = dispatch_semaphore_create(1);
        }
        if (!_downloadQueue) {
            _downloadQueue = dispatch_queue_create("launchDownloadQueue", NULL);
        }
        launchAdView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return launchAdView;
}

+ (instancetype)showInView:(UIView *)view imagesUrlArray:(NSArray<AdModel *> *)imagesUrlArray dismissAction:(DismissAction)dismissAction {
    return [self showInView:view logoImage:nil imagesUrlArray:imagesUrlArray dismissAction:dismissAction];
}

+ (instancetype)showInView:(UIView *)view logoImage:(nullable UIImage *)logoImage imagesUrlArray:(nullable NSArray<AdModel *> *)imagesUrlArray dismissAction:(nullable DismissAction)dismissAction {
    //广告定制需求
    NSArray *displayImageUrlArray = [MLLaunchAdView getCustomDisplayImage:imagesUrlArray];
    [MLLaunchAdView log:[NSString stringWithFormat:@"有效期内:%@",displayImageUrlArray]];
    if (displayImageUrlArray)
    {
        //图片有缓存就显示,没有缓存开始缓存
        if(![self checkImageCache:displayImageUrlArray])
        {
            [MLLaunchAdView cacheImages:displayImageUrlArray];
        }
    }
    
    //图片没有缓存就不显示
    if(![self checkImageCache:displayImageUrlArray]){
        dismissAction(NO,NO,nil);
        return nil;
    }
    
    MLLaunchAdView *homeAdView = [MLLaunchAdView shareInstance];
    if (!homeAdView.isShow) {
        [homeAdView showInView:view logoImage:logoImage imagesUrlArray:imagesUrlArray dismissAction:dismissAction];
    }
    return homeAdView;
}

+ (void)dismiss
{
    [[MLLaunchAdView shareInstance] dismissWitdHasCacheImages:YES isTap:NO];
}

+ (BOOL)checkImageCache:(NSArray<AdModel *> *)imagesUrlArray{
    if ([imagesUrlArray count]<=0) {
        return NO;
    }
    BOOL haveCache = NO;
    for (AdModel *model in imagesUrlArray) {
        if ([self inTheTimeRang:model] && [self cachedImageExistsForURL:[NSURL URLWithString:model.imageUrl]]) {
            haveCache = YES;
            break;
        }
    }
    return haveCache;
}

+ (BOOL)inTheTimeRang:(AdModel *)data{
    NSTimeInterval startTimeInterval = data.startTime;
    NSTimeInterval endTimeInterval = data.endTime;
    NSTimeInterval nowTimeInterval = [[NSDate new] timeIntervalSince1970];
    if ((nowTimeInterval >= startTimeInterval && (nowTimeInterval <= endTimeInterval || endTimeInterval == 0)) || (startTimeInterval==0 && endTimeInterval ==0) ) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _seconds = 5;
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    AdViewCell *contentImageView = [[AdViewCell alloc]initWithFrame:self.bounds];
    [contentImageView setContentMode:UIViewContentModeScaleAspectFill];
    _contentImageView = contentImageView;
    [self addSubview:contentImageView];
    [contentImageView setClipsToBounds:YES];
    [contentImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTapAction:)];
    [contentImageView addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [closeBtn setFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 20, 60, 35)];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [closeBtn setTitle:@"跳过>>" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn = closeBtn;
    [self addSubview:closeBtn];
    
    UIButton *delayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delayBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [delayBtn setFrame:CGRectMake(CGRectGetWidth(self.frame) - 100, 20, 40, 35)];
    [delayBtn setTitle:@"" forState:UIControlStateNormal];
    [delayBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [delayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delayBtn addTarget:self action:@selector(delayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _timeBtn = delayBtn;
    [self addSubview:delayBtn];
}

- (void)configLogoView {
    CGFloat logoheight = 150;
    if (self.logoImage) {
        logoheight = 150;
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-logoheight, CGRectGetWidth(self.bounds), logoheight)];
        _logoImageView = logoImageView;
        _logoImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:logoImageView];
    }
    self.contentImageView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 0, logoheight, 0));
}

//缓存ImageUrl
+ (void)cacheImages:(NSArray<AdModel *> *)imagesUrlArray
{
    if (imagesUrlArray && [imagesUrlArray count]>0) {
        [imagesUrlArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *imagesUrl = [(AdModel *)obj imageUrl];
            NSURL *url = [NSURL URLWithString:imagesUrl];
            if (![self cachedImageExistsForURL:url]) {
                dispatch_async(_downloadQueue, ^{
                    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
                    [MLLaunchAdView log:[NSString stringWithFormat:@"开始缓存:%@",url.description]];
                    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageContinueInBackground|SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        [MLLaunchAdView log:[NSString stringWithFormat:@"缓存中:%@",@(receivedSize)]];
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        dispatch_semaphore_signal(_semaphore);
                        if (!error) {
                            [MLLaunchAdView log:[NSString stringWithFormat:@"缓存完成:%@",imageURL.description]];
                        }
                    }];
                });
            }
        }];
    }
}

- (void)showInView:(UIView *)view imagesUrlArray:(NSArray<AdModel *> *)imagesUrlArray dismissAction:(DismissAction)dismissAction {
    [self showInView:view logoImage:nil imagesUrlArray:imagesUrlArray dismissAction:dismissAction];
}

- (void)showInView:(UIView *)view logoImage:(UIImage *)logoImage imagesUrlArray:(NSArray<AdModel *> *)imagesUrlArray dismissAction:(DismissAction)dismissAction
{
    [self configLogoView];
    _isShow = YES;
    if (!view) {
        view = self.cusWindow;
    }
    _parentView = view;
    self.dismissAction = dismissAction;
    self.logoImage = logoImage;
    
    AdModel *data = [self setDisplayImage:imagesUrlArray];
    [_contentImageView setImageUrl:data.imageUrl];
    _timeInterval = data.seconds?:self.seconds;
    
    [MLLaunchAdView log:[NSString stringWithFormat:@"显示：%@",data]];
    
    [_parentView addSubview:self];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [_timeBtn setTitle:[[@(_timeInterval) stringValue] stringByAppendingString:@"秒"]  forState:UIControlStateNormal];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

+ (NSMutableArray *)getCustomDisplayImage:(NSArray *)imagesUrlArray
{
    //保存显示时间相同的图片数
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([imagesUrlArray count] > 0) {
        //判断时间是否过期和URL是否相等
        for (AdModel *model in imagesUrlArray) {
            if ([self inTheTimeRang:model]) {
                [tempArray addObject:model];
            }
        }
    }
    if ([tempArray count]<=0) {
        tempArray = nil;
    }
    return tempArray;
}

- (AdModel *)setDisplayImage:(NSArray *)imagesUrlArray{
    
    //保存显示时间相同的图片数
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([imagesUrlArray count] > 0) {
        for (AdModel *model in imagesUrlArray) {
            if ([MLLaunchAdView inTheTimeRang:model] && [MLLaunchAdView cachedImageExistsForURL:[NSURL URLWithString:model.imageUrl]]) {
                [tempArray addObject:model];
            }
        }
    }
    AdModel *model = nil;
    if ([tempArray count]<=0) {
        model = nil;
    } else {
        //如果相同时间段中随机一个图片
        model = [tempArray objectAtIndex:(arc4random()%[tempArray count])];
        NSString *imageUrl = model.imageUrl;
        while (![MLLaunchAdView cachedImageExistsForURL:[NSURL URLWithString:imageUrl]]) {
            model = [tempArray objectAtIndex:(arc4random()%[tempArray count])];
            imageUrl = model.imageUrl;
        }
    }
    return model;
}

- (void)dismissWitdHasCacheImages:(BOOL)hasCacheImages isTap:(BOOL)isTap
{
    _isShow = NO;
    [_timer invalidate];
    _timer = nil;
    __weak typeof(self) weakself = self;
    if (self.dismissAction) {
        [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:weakself.dismissAnimations completion:^(BOOL finished) {
            [weakself removeFromSuperview];
            weakself.cusWindow.rootViewController = nil;
            [weakself.cusWindow setHidden:YES];
            weakself.cusWindow = nil;
            weakself.dismissAction(hasCacheImages,isTap,self.contentImageView.imageUrl);
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakself setAlpha:0];
        } completion:^(BOOL finished) {
            [weakself removeFromSuperview];
            weakself.cusWindow.rootViewController = nil;
            [weakself.cusWindow setHidden:YES];
            weakself.cusWindow = nil;
            weakself.dismissAction(hasCacheImages,isTap,weakself.contentImageView.imageUrl);
        }];
    }
}

#pragma mark - Internal Helpers
+ (BOOL)cachedImageExistsForURL:(NSURL *)url {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    return [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:key]?YES:NO;
}

#pragma mark - property Getter/Setter
- (UIWindow *)cusWindow
{
    if (!_cusWindow) {
        _cusWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cusWindow.rootViewController = [[UIViewController alloc] init]; // added since iOS9 to avoid the assertion
        [_cusWindow setWindowLevel:UIWindowLevelAlert - 1];
        [_cusWindow setHidden:NO];
    }
    return _cusWindow;
}

#pragma mark - event
- (void)cancelBtnAction:(UIButton *)sender
{
    [self dismissWitdHasCacheImages:YES isTap:NO];
}

- (void)delayBtnAction:(UIButton *)sender
{
    [self dismissWitdHasCacheImages:YES isTap:NO];
}

- (void)cellTapAction:(UIGestureRecognizer *)gesture{
    [self dismissWitdHasCacheImages:YES isTap:YES];
}

- (void)timerAction
{
    _timeInterval -= 1;
    [_timeBtn setTitle:[[@(_timeInterval) stringValue] stringByAppendingString:@"秒"]  forState:UIControlStateNormal];
    if (_timeInterval == 0) {
        [_timer invalidate];
        [self dismissWitdHasCacheImages:YES isTap:NO];
    }
}

+ (void)log:(NSString *)log
{
    if ([MLLaunchAdView shareInstance].enableLog) {
        NSLog(@"%@",log);
    }
}


@end
