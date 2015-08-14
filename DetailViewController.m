//
//  DetailViewController.m
//  Login_register_post
//
//  Created by qianfeng01 on 15-7-14.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "Define.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    AFHTTPRequestOperationManager *_manager;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc]initWithObjects:@"上传头像",@"获取相册",@"转换成json",nil];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //注册cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    //AF 下载任务管理对象
    _manager = [[AFHTTPRequestOperationManager alloc]init];
    //设置响应格式 --》返回NSData 只下载数据 不解析
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /*
    _manager GET:<#(NSString *)#> parameters:<#(id)#> success:^(AFHTTPRequestOperation *operation, id responseObject) {
        <#code#>
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        <#code#>
    }*/
}


#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://上传头像
        {
            //上传头像 必须保证登录
            //这时 我们需要把token发给服务器 这样表示登录了
            //从本地获取
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            NSDictionary *dict = @{@"m_auth":token};
            //上传 文件 post
            //第一个参数 是url
            //第二个是 url 的参数 写入一个字典
            [_manager POST:kUploadImage parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //把要上传的文件 在这里 进行上传 需要转化为 NSData
#if 0
                //方法1
                UIImage *image = [UIImage imageNamed:@"0"];
                //把图片转化为NSData -->无损转化
                NSData *data = UIImagePNGRepresentation(image);
                
                //第一个参数就是提交的文件二进制
                //第二个 是提交服务器参数的名字
                //3 文件本身的名字
                //4 文件本身的类型
                [formData appendPartWithFileData:data name:@"headeimage" fileName:@"0.png" mimeType:@"image/png"];
#else
                //方法2
                //本地文件的url地址
                NSURL *file = [[NSBundle mainBundle]URLForResource:@"0" withExtension:@"png"];
                [formData appendPartWithFileURL:file name:@"headeimage" error:nil];
#endif
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"服务器返回的数据");
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dict);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败！");
            }];
        }
            break;
        case 1://获取相册
        {
            //这时 我们需要把token发给服务器 这样表示登录了
            //从本地获取
            NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            NSDictionary *dict = @{@"m_auth":token};
            //这个post 只提交参数，不上传文件
            [_manager POST:kPhotoList parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"获取服务器数据");
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"dict:%@",dict);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");;
            }];
            
        }
            break;
        case 2://装换json
        {
            //自己写一个json格式的字符串
            //字符串 中如果要出现 双引号 必须要转义
            //我们可以把一个字典对象的内容转化为json 格式的字符串
            NSDictionary *dict = @{@"username":@"xiaohong",@"age":@(25),@"array":@[@"one",@"two"]};
            //可以把一个字典对象转化为json 格式的NSData
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *newStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"new:%@",newStr);
            
        }
            break;
        default:
            break;
    }
}


@end

























