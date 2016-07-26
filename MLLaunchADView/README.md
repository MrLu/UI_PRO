# MLLaunchAdView

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

> IOS app 启屏广告

##截图
![screen](https://github.com/MrLu/UI_PRO/blob/master/MLLaunchADView/screen/MLLanuchAdView.gif)

##使用:
###示例代码
```
 [MLLaunchAdView shareInstance].enableLog = YES;
 [MLLaunchAdView showInView:nil imagesUrlArray:[AdModel initWithImageUrls:@[
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/902397dda144ad348dec21dcd6a20cf431ad851e.jpg",
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/a2cc7cd98d1001e90d5d6414ba0e7bec54e79743.jpg",
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/574e9258d109b3de70616b84ccbf6c81810a4c04.jpg",
                                                                               @"http://img4.duitang.com/uploads/item/201307/24/20130724211454_JRiRm.thumb.600_0.jpeg",
                                                                               @"http://h.hiphotos.baidu.com/zhidao/pic/item/f703738da97739123c6dc373fe198618367ae25d.jpg"]]
                 dismissAction:^(BOOL hasCacheImages, BOOL isTap, NSString * _Nullable imageUrl) {
 }];
```
1.创建并显示图片
```
 + (instancetype)showInView:(nullable UIView *)view
            imagesUrlArray:(nullable NSArray<AdModel *> *)imagesUrlArray
             dismissAction:(nullable DismissAction)dismissAction;
```
2.开启log
```
 @property (nonatomic, assign) BOOL enableLog; //是否开启log
```
3.自定义小时动画
```
@property (nonatomic, copy) void (^dismissAnimations)(void);
```
4.主动调用缓存图片
```
 //利用线程信号来控制下载并发
 + (void)cacheImages:(nullable NSArray *)imagesUrlArray;
```
5.消失
```
 + (void)dismiss;
```
### 注意事项
>代码下载实现依赖 `#import <SDWebImage/SDWebImageManager.h>` 库，如果利用此控件，必须导入。

>或者自己实现现在存储，修改此库原文件。

### by
* 问题建议 to mail
* mail：haozi370198370@gmail.com
