//
//  MBProgressHUD_ES.h
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD_ES : MBProgressHUD

@property (nonatomic, assign) BOOL isDoSomething;

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay dothing:(BOOL)b;

@end
