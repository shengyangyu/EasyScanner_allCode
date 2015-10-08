//
//  Ule_ShareView.h
//  Ule_ShareView
//
//  Created by yushengyang on 14/11/17.
//  Copyright (c) 2014年 yushengyang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "Ule_ShareViewHeader.h"
#import "TRUrlToData.h"
/* 注释QQ分享
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>
 */

// 分享class
//*****************************************************//
@interface Ule_ShareClass : NSObject
{
    
}
@property (nonatomic, assign) UleShareType shareType;   //类型
@property (nonatomic, strong) NSString *titleStr;       //标题
@property (nonatomic, strong) NSString *textStr;        //内容
@property (nonatomic, strong) NSString *messageUrl;     //图片url
@property (nonatomic, strong) NSData   *imageData;      //分享图片icon
@property (nonatomic, assign, getter=isNeedImage) BOOL needImage; //分享图片icon
@property (nonatomic, strong) NSString *mIconStr;       //按钮显示图片
@property (nonatomic, strong) NSString *mLabelStr;      //按钮显示名称
// 初始化
- (instancetype)initForShareType:(UleShareType)mShareType
                    withTitleStr:(NSString *)mTitleStr
                     withTextStr:(NSString *)mTextStr
                  withMessageUrl:(NSString *)mMessageUrl
                   withImageData:(NSData *)mImageData
                   withNeedImage:(BOOL)mNeedImage;
@end
//*****************************************************//


//**** 控件按钮 ****//
@interface Ule_ShareButton : UIButton

// 按钮 属性
@property (nonatomic, strong) Ule_ShareClass *btnStatus;

@end


//分享view
//*****************************************************//
@interface Ule_ShareView : UIView<MFMessageComposeViewControllerDelegate>
{
    
}
// 分享的类型 数组
@property (nonatomic, strong) NSMutableArray *mShareArray;
// 分享的图片
@property (nonatomic, strong) NSString *mShareURL;
@property (nonatomic, strong) NSData *mShareData;
// 当前分享类型记录
@property (nonatomic, strong) Ule_ShareClass *mShareClass;
/* 注释QQ分享
// qq分享授权
@property (nonatomic, strong) TencentOAuth *mOauth;
 */
// 显示的父UIViewController
@property (nonatomic, strong) UIViewController *mSuperController;
// 当前点击的分享类型
@property (nonatomic, assign) UleShareType mShareType;
// 背景view
@property (nonatomic, strong) UIView *mTmpView;
// 单例
+ (Ule_ShareView *)shareViewManager;
// 初始化分享类型数组 数据格式统一
- (void)shareInitWithTypeArray:(NSArray *)typeArray
                  withTitleStr:(NSString *)mTitleStr
                   withTextStr:(NSString *)mTextStr
                withMessageUrl:(NSString *)mMessageUrl
                 withImageData:(NSData *)mImageData
                 withNeedImage:(BOOL)mNeedImage;
// 显示分享view
- (void)showShareViewMethod:(UIViewController *)superController;
// 分享方法对应单独类 
- (void)shareMethod:(Ule_ShareClass *)mClass withViewController:(UIViewController *)mVC;
// 移除分享view
- (void)dismissViewMethod;
// 赋nil 停止分享
- (void)setNilMethod;
// 分享注册
- (void)registWeChatForAppKey:(NSString *)appKey;
/* 注释QQ分享
- (void)registQQForAppKey:(NSString *)appKey andDelegate:(id)QDelegate;
 */
- (void)registSinaForAppKey:(NSString *)appKey enableDebugMode:(BOOL)debugMode;
// 分享完成后的回调
- (BOOL)Ule_ShareViewCallBackOpenURL:(NSURL *)url WithDelegate:(id)delegate;
// 分享成功 block 参数一个是当前的类名 一个是失败或成功
typedef void(^Ule_ShareViewResult) (NSString *,NSString *);
@property (nonatomic, copy) Ule_ShareViewResult resultBlock;

@end
//*****************************************************//


