//
//  AppDelegate.m
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#define WXAPPID                 @"wx6270c98aee233d11"
#define WXAPP_SECRET            @"17283d3ef4e32b69a3383170efa7f043"
#define QQZAPPID                @"100424468"
#define WEIBOkAppKey            @"2045436852"

#import "AppDelegate.h"
#import <Ule_ShareSDK/Ule_ShareView.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  iOS9 Quick Actions
 */
static NSString *applicationShortcutUserInfoIconKey = @"applicationShortcutUserInfoIconKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 注册app key分享
    [[Ule_ShareView shareViewManager] registWeChatForAppKey:WXAPPID];
    //[[Ule_ShareView shareViewManager] registQQForAppKey:QQZAPPID andDelegate:self];
    [[Ule_ShareView shareViewManager] registSinaForAppKey:WEIBOkAppKey enableDebugMode:NO];
    /**
     *  判断支持 Quick Actions
     */
    BOOL launchedFromShortCut = NO;
    UIApplicationShortcutItem *mshort = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    if (mshort) {
        launchedFromShortCut = YES;
        [self handleShortCutItem:mshort];
    }
    // 动态添加 quick actions
    // application.shortcutItems = @[[[UIApplicationShortcutItem alloc] initWithType:@"Green" localizedTitle:@"dynamic shortcut 1, green"], [[UIApplicationShortcutItem alloc] initWithType:@"Red" localizedTitle:@"dynamic shortcut 1, red"]];
    
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

#pragma mark -分享返回
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[Ule_ShareView shareViewManager] Ule_ShareViewCallBackOpenURL:url WithDelegate:[Ule_ShareView shareViewManager]];
}

// iOS9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    return [[Ule_ShareView shareViewManager] Ule_ShareViewCallBackOpenURL:url WithDelegate:[Ule_ShareView shareViewManager]];
}

#pragma mark -iOS9 Quick Actions
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    completionHandler([self handleShortCutItem:shortcutItem]);
}

- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem {
    
    if (!shortcutItem.type) {
        return NO;
    }
    id vc = self.window.rootViewController;
    if ([[vc class] isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *navvc = (UINavigationController *)vc;
        UIViewController *rootvc = navvc.viewControllers.firstObject;
        [rootvc.navigationController popToRootViewControllerAnimated:NO];
        [rootvc performSegueWithIdentifier:shortcutItem.type sender:nil];
    }
    return YES;
}

@end
