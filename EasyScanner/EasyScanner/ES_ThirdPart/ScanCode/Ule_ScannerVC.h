//
//  Ule_ScannerVC.h
//  u_shop
//
//  Created by yushengyang on 15/5/14.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "ES_BaseVC.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@class Ule_ScannerVC;
/*
 * 代理
 */
@protocol UleScannerVC_Delegate <NSObject>
@optional
/**
 *  扫描成功
 */
- (void)scannerSuccessVC:(Ule_ScannerVC *)vc resultCode:(NSString *)result;
/**
 *  扫描取消(当非push切换 需要手动添加取消按钮)
 */
- (void)scannerCancleVC:(Ule_ScannerVC *)vc;
/**
 *  扫描失败
 */
- (void)scannerFailedVC:(Ule_ScannerVC *)vc;
@end

/**
 *  扫描方式
 */
typedef NS_ENUM(NSUInteger, UleScannerType){
    /**
     *  不支持扫描
     */
    UleScannerTypeNone,
    /**
     *  系统扫描
     */
    UleScannerTypeSystem
};

@interface Ule_ScannerVC : ES_BaseVC

/**
 *  扫描方式
 */
@property (nonatomic, assign) UleScannerType mType;

/**
 *  扫描结果
 */
@property (nonatomic, strong) NSString *resultString;

/**
 *  代理
 */
@property (nonatomic, assign) id <UleScannerVC_Delegate> m_delegate;

/**
 *  扫描结束
 */
- (void)resultMethod;

/**
 *  继续扫描
 */
- (void)scanVCContinue:(BOOL)animation;

/**
 *  暂停扫描
 */
- (void)scanVCStop:(BOOL)animation;

/**
 *  释放扫描器
 */
- (void)scanVCDealloc;

@end
