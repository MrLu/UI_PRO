//
//  MLFloatHelpView.h
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-10-31.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlowHelpViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MLFloatHelpView : UIView
{
    CGPoint _point;
    @private
    CGSize _actionSize;
    UIEdgeInsets _edgeInset;
}

/** @brief  显示的大小*/
@property (assign, nonatomic) CGSize size;

/** @brief  显示的区域偏移*/
@property (assign, nonatomic) UIEdgeInsets edgeInset;

/** @brief  初始化位置*/
@property (assign, nonatomic) CGPoint point;

@property (assign, nonatomic) CGFloat verAttachVaileDistance;

@property (assign, nonatomic) BOOL attachBound;

@property (assign, nonatomic) BOOL bounces;

/**
 *	浮动框单例
 *
 *	@return	浮动框
 */
+ (instancetype)shareInstance;

/**
 *	显示浮动框
 */
- (void)showInView:(nullable UIView *)view;

/**
 *	隐藏浮动框
 */
//- (void)hidden;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
