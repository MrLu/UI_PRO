# MLFloatHelpView
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

*自定义悬浮窗口，可实现任意喜欢的样式*

##截图
![SCREEN](https://github.com/MrLu/UI_PRO/blob/master/MLFloatHelpView/screen/MLFloatHelpView.gif)

##实例代码
```
  [[MLFloatHelpView shareInstance] showInView:nil];
```
##属性
```
/** @brief  显示的大小*/
@property (assign, nonatomic) CGSize size;
```
```
/** @brief  显示的区域偏移*/
@property (assign, nonatomic) UIEdgeInsets edgeInset;
```
```
/** @brief  初始化位置*/
@property (assign, nonatomic) CGPoint point;
```
```
/**吸附边缘的判断边界距离*/
@property (assign, nonatomic) CGFloat verAttachVaileDistance;
```
```
/**是否贴边*/
@property (assign, nonatomic) BOOL attachBound;
```
```
/**是否保留边距*/
@property (assign, nonatomic) BOOL bounces;
```

##方法
```
/**
 *	浮动框单例
 *
 *	@return	浮动框
 */
+ (instancetype)shareInstance;
```
```
/**
 *	显示浮动框
 */
- (void)showInView:(nullable UIView *)view;
```
```
/**
 *	隐藏浮动框
 */
//- (void)hidden;
```
```
- (void)dismiss;
```

### 注意事项
>`MLFloatHelperView` 实现了基本滑动响应事件，用户可以继承`MLFloatHelperView`来达到定制细节UI样式

>或者自己实现现在存储，修改此库原文件。

### by
* 问题建议 to mail
* mail：haozi370198370@gmail.com
