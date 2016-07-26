# MLLaunchAdView
IOS app 启屏广告

##截图
![screen](https://github.com/MrLu/UI_PRO/blob/master/MLLaunchADView/screen/IMG_0689.PNG)

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
>`+ (instancetype)showInView:(nullable UIView *)view
>            imagesUrlArray:(nullable NSArray<AdModel *> *)imagesUrlArray
>             dismissAction:(nullable DismissAction)dismissAction;`
2.
