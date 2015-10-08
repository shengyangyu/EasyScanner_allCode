//
//  Ule_ShareViewHeader.h
//  ule_flight
//
//  Created by ule_ysy on 14/11/10.
//  Copyright (c) 2014年 lizemeng. All rights reserved.
//

#ifndef ule_flight_Ule_ShareViewHeader_h
#define ule_flight_Ule_ShareViewHeader_h


// 屏幕 size
#define MScreenWidth            [UIScreen mainScreen].bounds.size.width
#define MScreenHeight           [UIScreen mainScreen].bounds.size.height
#define SV_OffSet_X             18.0 //x 起点
#define SV_BtnCount             3 //每行按钮个数
#define SV_ScreenWidth          (MScreenWidth-SV_OffSet_X*2) //分享界面宽度
#define SV_Button_Size          ((SV_ScreenWidth-2)/SV_BtnCount) //按钮大小
// 分享key
//#define WXAPPKEY                @"wx1c89dd762ce55dc8"//微信key
//#define QQAPPKEY                @"1102107679"//qq key
#define  kRedirectURI           @"http://www.sina.com"
//图片名称
#define SV_ImageFriends         @"shareview_friends" //朋友圈
#define SV_ImageQzone           @"shareview_Qzone" //qq空间
#define SV_ImageWechat          @"shareview_wechat" //微信
#define SV_ImageMessage         @"shareview_Message" //短信
#define SV_ImageSina            @"shareview_Sina" //新浪微博
#define SV_PressIconName        @"_press"// 深色图
//按钮标题
#define SV_TitleFriends         @"朋友圈" //朋友圈
#define SV_TitleQzone           @"QQ空间" //QQ空间
#define SV_TitleWechat          @"微  信" //微信
#define SV_TitleMessage         @"短  信" //短信
#define SV_TitleSina            @"新浪微博" //新浪微博
//分享
#define SV_Success              @"success"
#define SV_Fail                 @"Fail"
#define SV_Name_WXSession       @"WeChatSession"
#define SV_Name_WXTimeline      @"WeChatTimeline"
#define SV_Name_QZone           @"QZone"
#define SV_Name_SinaWeibo       @"SinaWeibo"
//提醒文字
#define SV_AlertText_URL        @"URL不能为空!"
#define SV_AlertText_URLSize    @"URL不能超过10K!"
#define SV_AlertText_Title      @"主标题不能为空!"
#define SV_AlertText_Title512   @"主标题不能大于512字节!"
#define SV_AlertText_TEXT1K     @"描述内容不能大于1K!"
#define SV_AlertText_TEXT10K    @"文字不能超过10K!"
#define SV_AlertText_Image32K   @"图片不能超过32K!"
#define SV_AlertText_Image10M   @"图片不能超过10M"
#define SV_AlertText_Faile      @"授权失败"
#define SV_AlertText_WeiboText  @"新浪微博分享文字不能大于140字节!"
/**
 *  分享类型
 */
typedef NS_ENUM(NSInteger,  UleShareType) {
    UleShareTypeWXSession = 0,              //微信
    UleShareTypeWXTimeline,                 //朋友圈
    UleShareTypeSystemMessage,              //系统短信
    UleShareTypeQzone,                      //qq空间
    UleShareTypeSinaWeibo                   //新浪微博
};


#endif
