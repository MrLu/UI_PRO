//
//  TimeCardView.h
//  UI_PRO
//
//  Created by Mrlu-bjhl on 16/7/27.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeCardView : UIView

@property (nonatomic, strong) UILabel *hourLabel; //小时
@property (nonatomic, strong) UILabel *minLabel; //分
@property (nonatomic, strong) UILabel *secLabel; //秒
@property (nonatomic, assign) long long timeStamp; //时间挫

@end

NS_ASSUME_NONNULL_END
