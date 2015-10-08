//
//  CreateCodeResult.m
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#import "CreateCodeResult.h"
#import <Ule_ShareSDK/Ule_ShareView.h>

@interface CreateCodeResult ()

// 生成的二维码图
@property (weak, nonatomic) IBOutlet UIImageView *resultImg;
// 文本内容
@property (weak, nonatomic) IBOutlet UITextView *mCodeText;

@end

@implementation CreateCodeResult

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI {
    // 二维码文本
    NSString *t_codeText = [NSString stringWithFormat:@"%@",self.m_Data];
    self.mCodeText.text = t_codeText;
    // 二维码图片
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:t_codeText] withSize:250.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    self.resultImg.image = customQrcode;
}

#pragma mark -点击事件
- (IBAction)saveCode:(UIButton *)sender {
    
    if (self.resultImg.image) {
        UIImageWriteToSavedPhotosAlbum(self.resultImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil ;
    if (error != NULL) {
        msg = @"保存图片失败";
    }
    else {
        msg = @"保存图片成功";
    }
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}

- (IBAction)shareCode:(UIButton *)sender {
    //标题
    NSString *combine_Weixf=[[NSString alloc] initWithFormat:@"%@",@"[随手扫'ta']"];
    //内容
    NSString *combine_Weixfcontext=[[NSString alloc] initWithFormat:@"分享一个二维码给你,有惊喜呦!"];
    //链接地址
    //NSString *messageUrl = [NSString stringWithFormat:@"http://www.jianshu.com/users/487da02dbdb0/latest_articles"] ;
    //图片
    NSData *imgData = UIImagePNGRepresentation(self.resultImg.image);
    NSData *passData = [TRUrlToData  dataScaleToBytes:25 * 1024 withImageData:imgData];
    //分享方式
    Ule_ShareClass *class1 = [[Ule_ShareClass alloc] initForShareType:UleShareTypeWXTimeline withTitleStr:nil withTextStr:combine_Weixf withMessageUrl:nil withImageData:passData withNeedImage:YES];
    Ule_ShareClass *class2 = [[Ule_ShareClass alloc] initForShareType:UleShareTypeWXSession withTitleStr:nil withTextStr:combine_Weixf withMessageUrl:nil withImageData:passData withNeedImage:YES];
    Ule_ShareClass *class3 = [[Ule_ShareClass alloc] initForShareType:UleShareTypeSinaWeibo withTitleStr:combine_Weixf withTextStr:combine_Weixfcontext withMessageUrl:nil withImageData:passData withNeedImage:NO];
    [Ule_ShareView shareViewManager].mShareArray = [[NSMutableArray alloc] initWithObjects:class1, class2, class3, nil];
    // 分享显示
    [[Ule_ShareView shareViewManager] showShareViewMethod:self.navigationController];
    // 分享结果
    [Ule_ShareView shareViewManager].resultBlock = ^(NSString *name,NSString *result){
        if ([result isEqualToString:@"success"]) {
            
            [self HUDShow:@"分享成功" delay:1.5f];
        }
    };
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
