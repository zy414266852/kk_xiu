//
//  LIMLoginViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/9.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMLoginViewController.h"
#import "YYTabBarController.h"
#import "LIMPhoneLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "HttpClient.h"
#import "CcUserModel.h"




@interface LIMLoginViewController ()
@property (nonatomic, strong) NSArray *platforemArray;
    @end

@implementation LIMLoginViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    userModel.os = @"ios";
    userModel.ver = [infoDictionary objectForKey:@"CFBundleVersion"];
    userModel.encry = @"0";
    userModel.phonetype = [[UIDevice currentDevice] model];
    userModel.imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    userModel.jwd = @"";
    userModel.province = @"北京";
    userModel.city = @"北京";
    userModel.area = @"善缘街";
    [userModel saveAllInfo];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    imageV.userInteractionEnabled = YES;
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.height.equalTo(self.view);
    }];
    
    
    
    
    // 登陆方式
    // wechat_login
    UIImage *wechatImage = [UIImage imageNamed:@"wechat_login"];
    CGFloat imageW = 49;
    CGFloat padding = (kScreenW -imageW *3)/4.0;
    NSArray *icons_login = @[@"wechat_login",@"qq_login",@"phone_login"];
    for ( int i = 0; i < 3 ; i++ ) {
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [loginBtn setImage:[UIImage imageNamed:icons_login[i]] forState:UIControlStateNormal];
        [loginBtn setBackgroundImage:[UIImage imageNamed:icons_login[i]] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.tag = 1000 +i;
        [imageV addSubview:loginBtn];
        //        [imageV sizeToFit];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageV).offset(padding * (1 +i) +imageW*i);
            make.bottom.equalTo(imageV).offset(-54 *kiphone6);
            make.size.mas_equalTo(CGSizeMake(imageW, imageW));
        }];
        
    }
    
    
    UILabel *pemptLabel = [[UILabel alloc]init];
    pemptLabel.text  = @"请选择以下方式登录";
    pemptLabel.textColor = [UIColor whiteColor];
    pemptLabel.font = [UIFont systemFontOfSize:16];
    pemptLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageV addSubview:pemptLabel];
    
    [pemptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(imageV).offset(-54 *kiphone6 -imageW -22);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(16);
    }];
    
    
    _platforemArray = @[
                        @(SSDKPlatformSubTypeQQFriend),
                        @(SSDKPlatformSubTypeWechatSession),
                        ];
    
    // Do any additional setup after loading the view.
}
- (void)login:(UIButton *)sender{
    NSInteger loginType = sender.tag -1000;
    if (loginType == 2) {  // 手机号登录
        
        [self.navigationController pushViewController:[[LIMPhoneLoginViewController alloc]init] animated:YES];
    }else if(loginType == 1){
        [self sendAuthRequest:998];
    }else{
        [self sendAuthRequest:997];
//        YYTabBarController *tabbarVC = [[YYTabBarController alloc]init];
//        tabbarVC.tabBar.translucent = NO;
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    // 微信登陆请求
-(void)sendAuthRequest:(NSInteger)myPlatformType
    {
//        NSLog(@"weixin + sendAuthRequest");
//        SendAuthReq *req = [[SendAuthReq alloc] init];
//        req.scope = @"token";
//        req.state = @"wechat_sdk_demo";
//        [WXApi sendReq:req];
        
#pragma mark - 调用授权
        // 997 微信。 998 qq
        SSDKPlatformType platformType = myPlatformType;
        [ShareSDK authorize:platformType
                   settings:nil
             onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
//
                         [self getInfoView:platformType];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         NSLog(@"%@",error);
//                         _isAuth = NO;
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败"
                                                                             message:[NSString stringWithFormat:@"%@",error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确认"
                                                                   otherButtonTitles: nil];
                         [alertView show];
                         break;
                     }
                         break;
                     case SSDKResponseStateCancel:
                     {
//                         _isAuth = NO;
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确认"
                                                                   otherButtonTitles: nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
             }];
        
 

        
    }


//获取平台授权的当前用户信息
- (void)getInfoView:(SSDKPlatformType)platformType{
//        获取平台授权用户信息
        [ShareSDK getUserInfo:platformType
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                   if(state == SSDKResponseStateSuccess)
                   {

                       //uid 可用于和自身用户系统进行用户绑定 使用
                       NSLog(@"user uid %@",user.uid);
                       NSLog(@"user nickname %@",user.nickname);
                       NSLog(@"user icon %@",user.icon);
                       NSLog(@"user icon %ld",user.gender);
                       CcUserModel *userInfo = [CcUserModel defaultClient];
                       // 第三方登录请求
                       NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                  mAllPara,
                                                  @"type":[NSString stringWithFormat:@"%ld",platformType -996],
                                                  @"openid":user.uid,
                                                  @"nickname":user.nickname,
                                                  @"cover":user.icon,
                                                  @"gender":[NSString stringWithFormat:@"%ld",(user.gender +1)]
                                                  }];
                       NSLog(@"%@",paraDict);
//                       [paraDict addEntriesFromDictionary:[userInfo httpParaDictSecret]];
//                       [paraDict addEntriesFromDictionary:[userInfo httpParaDictUnSecret]];

                       [[HttpClient defaultClient] requestWithPath:mThird_Login method:1 parameters:paraDict prepareExecute:^{
                           
                       } success:^(NSURLSessionDataTask *task, id responseObject) {
                           NSLog(@"%@",responseObject);
                           NSString * rescode = responseObject[@"rescode"];
                           if ([rescode isEqualToString:@"1"]) {
                               
                               NSDictionary *infoDict = responseObject[@"result"][@"userinfo"];
                               NSDictionary *timinfo = responseObject[@"result"][@"timinfo"];
                               userInfo.uid = infoDict[@"uid"];
                               userInfo.age = infoDict[@"age"];
                               userInfo.authstate = infoDict[@"authstate"];
                               userInfo.cover = infoDict[@"cover"];
                               userInfo.gender = infoDict[@"gender"];
                               userInfo.mobile = infoDict[@"mobile"];
                               userInfo.nickname = infoDict[@"nickname"];
                               userInfo.personsign = infoDict[@"personsign"];
                               userInfo.gender = infoDict[@"gender"];
                               userInfo.mobile = infoDict[@"mobile"];
                               userInfo.nickname = infoDict[@"nickname"];
                               userInfo.personsign = infoDict[@"personsign"];
                               userInfo.star = infoDict[@"star"];
                               userInfo.token = infoDict[@"token"];
                               userInfo.timid = timinfo[@"timid"];
                               userInfo.timsig = timinfo[@"timsig"];
                               userInfo.avatar = infoDict[@"avatar"];
                               userInfo.userlevel = infoDict[@"userlevel"];
                               userInfo.iscompere = infoDict[@"iscompere"];
                               
//                               userInfo.iscompere = infoDict[@"iscompere"];
                               
                               if (userInfo.beautyDepth.length == 0) {
                                   userInfo.beautyDepth = @"4.5";
                                   userInfo.whiteningDepth = @"4.5";
                                   userInfo.eyeScaleLevel = @"4.5";
                                   userInfo.faceScaleLevel = @"4.5";
                               }
                               
                               [userInfo saveAllInfo];
                               
                               YYTabBarController *tabbarVC = [[YYTabBarController alloc]init];
                               tabbarVC.tabBar.translucent = NO;
                               [UIApplication sharedApplication].keyWindow.rootViewController = tabbarVC;
                           }else{
                               NSString * resmsg = responseObject[@"resmsg"];
                               NSLog(@"resmsg = %@",resmsg);
                               [self showAlertWithMessage:resmsg];
                           }


                           
                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                           
                       }];

                  }
               }];
    
    
    
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
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
