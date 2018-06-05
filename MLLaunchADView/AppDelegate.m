//
//  AppDelegate.m
//  MLLaunchADView
//
//  Created by Mrlu-bjhl on 16/7/22.
//  Copyright © 2016年 Mrlu. All rights reserved.
//

#import "AppDelegate.h"
#import "MLLaunchAdView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MLLaunchAdView shareInstance].enableLog = YES;
    [MLLaunchAdView showInView:nil imagesUrlArray:[AdModel initWithImageUrls:@[
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/902397dda144ad348dec21dcd6a20cf431ad851e.jpg",
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/a2cc7cd98d1001e90d5d6414ba0e7bec54e79743.jpg",
                                                                               @"http://e.hiphotos.baidu.com/zhidao/pic/item/574e9258d109b3de70616b84ccbf6c81810a4c04.jpg",
                                                                               @"http://img4.duitang.com/uploads/item/201307/24/20130724211454_JRiRm.thumb.600_0.jpeg",
                                                                               @"http://h.hiphotos.baidu.com/zhidao/pic/item/f703738da97739123c6dc373fe198618367ae25d.jpg"]]
                 dismissAction:^(BOOL hasCacheImages, BOOL isTap, NSString * _Nullable imageUrl) {
        
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
