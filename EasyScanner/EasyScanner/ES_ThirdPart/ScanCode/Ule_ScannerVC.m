//
//  Ule_ScannerVC.m
//  u_shop
//
//  Created by yushengyang on 15/5/14.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//
#if ! __has_feature(objc_arc)
#error file is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#import "Ule_ScannerVC.h"
#import "Ule_Scanner.h"
#import "Ule_BGView.h"
#import "ZXingObjC.h"

@interface Ule_ScannerVC ()<Ule_ScannerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**
 *  系统扫描器
 */
@property (strong, nonatomic) Ule_Scanner *mScanner;
/**
 *  扫描器滚动动画View 为Zbar添加
 */
@property (strong, nonatomic) Ule_BGView *mOtherView;
/**
 *  CustomerUI View 自定义按钮
 */
@property (strong, nonatomic) UIView *mCustomerUI;
/**
 *  获取相册图片 View
 */
@property (nonatomic, strong) UIImagePickerController *mImagePicker;

@end

@implementation Ule_ScannerVC

- (void)becomeActiveMethod:(NSNotification *)notification {
   [self.mOtherView initLine];
}

- (void)WillEnterForegroundMethod:(NSNotification *)notification {
    [self.mOtherView removeLine];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self titleLabel:@"扫描条形码"];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    if (IOS7_OR_LATER) {
        self.mType = UleScannerTypeSystem;
    }else {
        self.mType = UleScannerTypeNone;
        [self HUDShow:@"当前设备不支持!" delay:1.0 dothing:YES];
    }
    //加载UI
    [self customerUI];
    // 进入后台返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveMethod:) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForegroundMethod:) name:UIApplicationWillEnterForegroundNotification object:nil];
}
// 返回
- (void)HUDdelayDo {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.mOtherView startLineAnimation];
    if (self.mType == UleScannerTypeSystem) {
        [self HUDShow:@"加载中"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scanVCContinue:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self scanVCStop:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self scanVCDealloc];
}

// 自定义页面UI
- (void)customerUI {
    // 扫描背景
    self.mOtherView = [[Ule_BGView alloc] initWithFrame:self.view.bounds withClearFrame:CGRectMake(SCan_Offset_x, SCan_Offset_y+__Main_Origin_y, SCan_Size, SCan_Size)];
    [self.view addSubview:self.mOtherView];
    // 自定义UI
    self.mCustomerUI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight1)];
    self.mCustomerUI.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.mCustomerUI];
    // 提示文字
    ({
        UILabel *lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor clearColor];
        lab.frame = CGRectMake(0, __Main_Origin_y, ScreenWidth, SCan_Offset_y);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"将条码置于框内,即可自动扫描";
        [self.mCustomerUI addSubview:lab];
    });
    CGFloat BottomBtnSize_h = 82.0f;
    // 阴影
    ({
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, __viewContent_hight1-BottomBtnSize_h, __MainScreen_Width, BottomBtnSize_h)];
        backView.alpha = 0.3;
        backView.backgroundColor = [UIColor blackColor];
        [self.mCustomerUI addSubview:backView];
    });
    // 底部两个按钮
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, __viewContent_hight1-BottomBtnSize_h, __MainScreen_Width/2, BottomBtnSize_h)];
        [btn setTitle:@"结束扫描" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn setImage:[UIImage imageNamed:@"scan_cancel"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.mCustomerUI addSubview:btn];
        [self setButtonEdge:btn withSize:BottomBtnSize_h];
        
    });
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(__MainScreen_Width/2, __viewContent_hight1-BottomBtnSize_h, __MainScreen_Width/2, BottomBtnSize_h)];
        [btn setTitle:@"打开闪光灯" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [btn setImage:[UIImage imageNamed:@"scan_torch"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(torchMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.mCustomerUI addSubview:btn];
        [self setButtonEdge:btn withSize:BottomBtnSize_h];
    });
}

- (void)setButtonEdge:(UIButton *)btn withSize:(CGFloat)BottomBtnSize_h {
    // 设置图片和标题的位置
    CGPoint btnBoundsCenter = CGPointMake(CGRectGetMidX(btn.bounds), CGRectGetMidY(btn.bounds));
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(btnBoundsCenter.x, CGRectGetMidY(btn.imageView.bounds));
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(btnBoundsCenter.x, CGRectGetHeight(btn.bounds)-CGRectGetMidY(btn.titleLabel.bounds));
    // 取得imageView最初的center
    CGPoint startImageViewCenter = btn.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = btn.titleLabel.center;
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    btn.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop+BottomBtnSize_h*0.30, imageEdgeInsetsLeft, imageEdgeInsetsBottom-BottomBtnSize_h*0.10, imageEdgeInsetsRight);
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop-BottomBtnSize_h*0.10, titleEdgeInsetsLeft, titleEdgeInsetsBottom-BottomBtnSize_h*0.10, titleEdgeInsetsRight);
}

- (void)cancelMethod {
    if ([self.m_delegate respondsToSelector:@selector(scannerCancleVC:)]) {
        [self.m_delegate scannerCancleVC:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)torchMethod:(UIButton *)sender {
    
    if (self.mType == UleScannerTypeSystem && [self.mScanner torchMode]) {
        if (self.mScanner.isOpenTorch) {
            [sender setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
        }
        else {
            [sender setTitle:@"打开闪光灯" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 系统扫描iOS7
#pragma mark -Scanner
- (Ule_Scanner *)mScanner {
    if (SIMULATOR) {
        // 隐藏加载view
        [HUD hide:YES];
        return nil;
    }
    if (!_mScanner) {
        _mScanner = [[Ule_Scanner alloc] initWithPreviewView:self.view];
        _mScanner.delegate = self;
        [self startScanning];
    }
    return _mScanner;
}

#pragma mark -Scanning
- (void)startScanning {
    
    [self.mScanner startScanningWithResultBlock:^(NSArray *codes) {
        if (codes.count > 0) {
            // 结果
            self.resultString = nil;
            AVMetadataMachineReadableCodeObject *obj = codes[0];
            if (obj.stringValue &&
                ![obj.stringValue isEqualToString:@""] &&
                obj.stringValue.length > 0) {
                AudioServicesPlaySystemSound(1106);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                NSLog(@"Found unique code: %@", obj.stringValue);
                // 结果
                self.resultString = [NSString stringWithFormat:@"%@",obj.stringValue];
                if ([self.m_delegate respondsToSelector:@selector(scannerSuccessVC:resultCode:)]) {
                    [self.m_delegate scannerSuccessVC:self resultCode:obj.stringValue];
                }
            }
            else {
                if ([self.m_delegate respondsToSelector:@selector(scannerFailedVC:)]) {
                    [self.m_delegate scannerFailedVC:self];
                }
            }
        } else {
            if ([self.m_delegate respondsToSelector:@selector(scannerFailedVC:)]) {
                [self.m_delegate scannerFailedVC:self];
            }
        }
        [self scanVCStop:NO];
        [self resultMethod];
    }];
}

- (void)scanVCContinue:(BOOL)animation {
    if (self.mType == UleScannerTypeSystem) {
        // 开始扫描
        [self.mScanner startSessionScann];
    }
    else {
        
    }
    // 开始扫描动画
    [self.mOtherView startLineAnimation];
}

- (void)scanVCStop:(BOOL)animation {
    if (self.mType == UleScannerTypeSystem) {
        if (self.mScanner.isOpenTorch) {
            [self.mScanner torchMode];
        }
        [self.mScanner stopSessionScann];
    }
    else {
        
    }
    // 结束扫描动画
    [self.mOtherView stopLineAnimation];
}

- (void)scanVCDealloc {
    
    //[self baseVCDealloc];
    if (self.mType == UleScannerTypeSystem) {
        if (_mScanner) {
            [_mScanner stopScanning];
            _mScanner = nil;
        }
    }
    else {
        
    }
}

- (void)resultMethod {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -选取相册图片
- (IBAction)choicePhotos:(UIBarButtonItem *)sender {
    
    // 跳转到相册页面
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    self.mImagePicker = [[UIImagePickerController alloc] init];
    self.mImagePicker.delegate = self;
    self.mImagePicker.sourceType = sourceType;
    [self presentViewController:self.mImagePicker animated:YES completion:^{
    }];
}

#pragma mark -image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *t_image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self getInfoWithImage:t_image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.mImagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - zxing 从相册获取二维码
-(void)getInfoWithImage:(UIImage *)img {
    
    UIImage *loadImage= img;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        NSString *contents = result.text;
        NSLog(@"相册图片contents == %@",contents);
    }
    else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"解析失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
    }
}

- (void)showInfoWithMessage:(NSString *)message andTitle:(NSString *)title {
    
    
}

#pragma mark -Ule_ScannerDelegate
- (void)scannerViewDidLoad {
    // 隐藏加载view
    [HUD hide:YES];
}

@end
