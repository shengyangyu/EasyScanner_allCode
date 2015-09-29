//
//  MBProgressHUD_ES.m
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#import "MBProgressHUD_ES.h"

@implementation MBProgressHUD_ES

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay dothing:(BOOL)b{
    self.isDoSomething = YES;
    [self performSelector:@selector(dohideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}


- (void)dohideDelayed:(NSNumber *)animated {
    [self hide:[animated boolValue]];
}

@end
