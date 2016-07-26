//
//  MLLaunchAdView.h
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/1/16.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>

#define EleFont @"DBLCDTempBlack"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DismissAction)(BOOL hasCacheImages, BOOL isTap,  NSString * _Nullable imageUrl);

@interface AdModel : NSObject

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) NSTimeInterval startTime; //开始时间 qa: =0 的话一直有效
@property (nonatomic, assign) NSTimeInterval endTime; //结束时间 qa: =0 的话一直有效
@property (nonatomic, assign) NSTimeInterval seconds; //delay seconds;

+ (NSArray<AdModel *> *)initWithImageUrls:(NSArray<NSString *>*)array;

@end

@interface AdViewCell : UIImageView

@property (copy, nonatomic) NSString *imageUrl;

@end

@interface MLLaunchAdView : UIView

@property (nonatomic, strong, readonly) UIButton *closeBtn; //关闭按钮
@property (nonatomic, strong, readonly) UIButton *timeBtn; //倒计时按钮

@property (nonatomic, strong, readonly) AdViewCell *contentImageView; //内容视图
@property (nonatomic, assign) NSTimeInterval seconds; //default 5s;
@property (nonatomic, assign) BOOL enableLog; //是否开启log

@property (nonatomic, copy) void (^dismissAnimations)(void);

+ (instancetype)shareInstance;

+ (instancetype)showInView:(nullable UIView *)view
            imagesUrlArray:(nullable NSArray<AdModel *> *)imagesUrlArray
             dismissAction:(nullable DismissAction)dismissAction;

+ (void)dismiss;

+ (void)cacheImages:(nullable NSArray *)imagesUrlArray;

@end

NS_ASSUME_NONNULL_END