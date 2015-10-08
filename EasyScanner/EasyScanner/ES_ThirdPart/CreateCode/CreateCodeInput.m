//
//  CreateCodeInput.m
//  EasyScanner
//
//  Created by ule_shengyangyu on 15/9/28.
//  Copyright © 2015年 ule_shengyangyu. All rights reserved.
//

#import "CreateCodeInput.h"
#import "CreateCodeResult.h"

@interface CreateCodeInput ()
/**
 *  文本长度
 */
@property (weak, nonatomic) IBOutlet UILabel *textLength;
/**
 *  文本内容
 */
@property (weak, nonatomic) IBOutlet UITextView *codeText;

@end

@implementation CreateCodeInput

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -生成二维码
- (IBAction)createCode:(UIBarButtonItem *)sender {
    if(self.codeText && self.codeText.text.length) {
        [self performSegueWithIdentifier:@"CreateCodeResult" sender:self];
    }
    else {
        [self HUDShow:@"请输入文本内容" delay:1.5f];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CreateCodeResult *vc = segue.destinationViewController;
    vc.m_Data = [NSString stringWithFormat:@"%@",self.codeText.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
