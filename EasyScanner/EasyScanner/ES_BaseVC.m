//
//  ES_BaseVC.m
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#import "ES_BaseVC.h"

@interface ES_BaseVC ()

@end

@implementation ES_BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - MBProgressHUD Delegate
- (void)initHUD
{
    if (!HUD) {
        HUD = [[MBProgressHUD_ES alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
}
- (void)HUDShow:(NSString*)text
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD show:YES];
}
- (void)HUDShow:(NSString*)text delay:(float)second
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second];
}
- (void)HUDShow:(NSString*)text delay:(float)second dothing:(BOOL)bDo
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second dothing:bDo];
}
- (void)HUDdelayDo
{
}
- (void)hudWasHidden:(MBProgressHUD *)hud{
    if (HUD.isDoSomething) {
        [self HUDdelayDo];
    }
    [HUD removeFromSuperview];
    HUD = nil;
}
- (void)HUDHidden{
    [HUD hide:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
