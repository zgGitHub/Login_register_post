//
//  Define.h
//  Login_register_post
//
//  Created by qianfeng01 on 15-7-14.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#ifndef Login_register_post_Define_h
#define Login_register_post_Define_h
//登录接口地址
#define kLoginUrl @"http://10.0.8.8/sns/my/login.php"
//参数—》?username=%@&password=%@

//注册接口地址
#define kRegisterUrl @"http://10.0.8.8/sns/my/register.php"
//参数?username=%@&password=%@&email=%@


//上传头像(post)
#define kUploadImage @"http://10.0.8.8/sns/my/upload_headimage.php"
//获取相册列表(post)
#define kPhotoList @"http://10.0.8.8/sns/my/album_list.php"

#endif
