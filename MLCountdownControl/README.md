# MLCountDownControl
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

> 倒计时组合控件

##截图
![screen](https://github.com/MrLu/UI_PRO/blob/master/MLCountdownControl/screen/MLDowncountControl.gif)

##实例
```
    BJVideoClassCountDownControl *countdownControl = [[BJVideoClassCountDownControl alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
    [countdownControl setTimeStamp:60*60*24];
    [countdownControl fire];
```
###core
`MLCountDownControl` 基类实现倒计时计时的基本功能；
####property
`@property (nonatomic, assign) NSTimeInterval timeInterval;` //计时时间间隔

`@property (nonatomic, copy) TimeStopBlock timeStopBlock;` //倒计时结束回调

`@property (nonatomic, assign) long long timeStamp; //倒计时间`

####method
`+ (instancetype)shareInstance;` //单例计时器

`+ (instancetype)instance;` //实例计时器

`- (void)fire NS_REQUIRES_SUPER;` //开始计时

`- (void)invalidate;` //暂停

`- (void)timerEvent NS_REQUIRES_SUPER;` //计时事件

###UI
`TimeCardView` 实现卡片样式的倒计时UI样式
####property
`@property (nonatomic, assign) long long timeStamp; //时间挫`

###实现
`BJVideoClassCountDownControl` 继承自`MLCountDownControl`  自定义实现倒计时样式


### 注意事项

>用户可以参照`BJVideoClassCountDownControl`的实现组合实现自己的倒计时控件

### by
* 问题建议 to mail
* mail：haozi370198370@gmail.com
