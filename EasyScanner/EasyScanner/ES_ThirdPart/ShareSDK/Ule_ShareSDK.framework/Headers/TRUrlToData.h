//
//  TRUrlToData.h
//  MyShare
//
//  Created by yushengyang on 14/11/17.
//  Copyright (c) 2014年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TRUrlToData_TimeOut 20.0

@interface TRUrlToData : NSURL

+ (NSData *)urlScaledToDataBytes:(long)bytes withImageUrl:(NSString *)imageUrl;
+ (NSData *)urlToData:(NSString *)imageUrl;
//异步下载
+ (void)asyurlToData:(NSString *)imageUrl withHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;
+ (NSData *)dataScaleToBytes:(long)bytes withImageData:(NSData *)imageData;

@end
