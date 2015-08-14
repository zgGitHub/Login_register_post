//
//  ViewController.m
//  Login_register_post
//
//  Created by qianfeng01 on 15-7-14.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ViewController.h"
#import "Define.h"
#import "LZXHttpRequest.h"
#import "DetailViewController.h"

@interface ViewController ()
{
    LZXHttpRequest *_httpRequest;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)loginClick:(UIButton *)sender;
- (IBAction)registerClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _httpRequest = [[LZXHttpRequest alloc]init];
    
}



- (IBAction)loginClick:(UIButton *)sender {
    if (self.nameTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        NSLog(@"登录信息不完整！");
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@",self.nameTextField.text,self.passwordTextField.text];
    //post
    [_httpRequest postDataWithUrl:kLoginUrl paramString:str success:^(NSMutableData *download) {
        //服务器有响应
        //如果登录成功了，那么服务器会给 客户端 返回一个token(密令/令牌-》标识用户登录成功)
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:download options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dict:%@",dict);
        if ([dict[@"code"] isEqualToString:@"login_success"]) {
            NSLog(@"登录成功");
            //登录成功我们可以吧token保存到本地，其他界面如果需要那么可以从本地获取
//            NSUserDefaults --》把一些轻量级的数据保存到本地沙盒中（沙盒/Library/P.../）
            //NSUserDefaults 是一个单例 每个应用程序只有一个
            //NSString NSArray NSDictionary NSNumber NSDate NSData...
            [[NSUserDefaults standardUserDefaults] setObject:dict[@"m_auth"] forKey:@"token"];
            //立即同步到磁盘
            [[NSUserDefaults standardUserDefaults]synchronize];
//            NSLog(@"%@",NSHomeDirectory());
            
            //界面跳转
            DetailViewController *detail = [[DetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            NSLog(@"登录失败");
        }
        
        
    } failed:^(NSError *error) {
        
    }];
    

}

- (IBAction)registerClick:(UIButton *)sender {
    if (self.nameTextField.text.length == 0 || self.passwordTextField.text.length == 0 || self.emailTextField.text.length == 0) {
        NSLog(@"注册信息不完整！");
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"username=%@&password=%@&email=%@",self.nameTextField.text,self.passwordTextField.text,self.emailTextField.text];
   // 发送 post 请求 注册 提交数据
    [_httpRequest postDataWithUrl:kRegisterUrl paramString:str success:^(NSMutableData *download) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:download options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"code"] isEqualToString:@"registered"]) {
            NSLog(@"%@",dict[@"message"]);
        }else{
            NSLog(@"注册失败");
            NSLog(@"%@",dict[@"message"]);
        }
        
    } failed:^(NSError *error) {
        NSLog(@"注册失败");
    }];

}

//触摸屏幕的时候调用
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
@end
























