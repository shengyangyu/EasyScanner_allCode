//
//  ES_BaseVC.h
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

// 版本
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
//设备屏幕大小
#define __MainScreenFrame   [[UIScreen mainScreen] bounds]
#define __MainScreen_Width        __MainScreenFrame.size.width
#define __MainView_Height_Real    __MainScreenFrame.size.height
#define __Main_Origin_y 64.0
//设备屏幕高 20
#define __MainScreen_Height __MainScreenFrame.size.height - 20
//试图内容高度 1
#define __viewContent_hight1 __MainScreen_Height - 44 + __Main_Origin_y      //-导航条

#import <UIKit/UIKit.h>
#import "MBProgressHUD_ES.h"

@interface ES_BaseVC : UIViewController<MBProgressHUDDelegate>
{
    
    MBProgressHUD_ES *HUD;           //加载动画
}

/**
 请求加载动画
 */
- (void)initHUD;
- (void)HUDShow:(NSString*)text;
- (void)HUDShow:(NSString*)text delay:(float)second;
- (void)HUDShow:(NSString*)text delay:(float)second dothing:(BOOL)bDo;
- (void)hudWasHidden:(MBProgressHUD *)hud;
- (void)HUDHidden;

@end
