
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//
#import "YYTabBarController.h"

#import "YYTabBar.h"
#import "YYNavigationController.h"
#import "LIMMainViewController.h"
#import "LIMPushLiveViewController.h"
#import "LIMPersonalViewController.h"
#import "CcUserModel.h"
#import "UIView+Additions.h"
#import "UIImage+ImageColor.h"
#import "LIMChatSelectViewController.h"
#import "LIMPushSelectViewController.h"
#import "HttpClient.h"
#import "ImSDK/ImSDK.h"
#import "ImSDK/TIMManager.h"
#import "ImSDK/IMSdkInt.h"
#import "TLSSDK/TLSHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LIMLoginViewController.h"

#define kTabbarItemTag 100
#define BOTTOM_VIEW_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface YYTabBarController () <UITabBarControllerDelegate>{
    UIView *                 _botttomView;
}
    
@property (nonatomic, strong) YYTabBar *tabBarView;
@property (nonatomic, strong) NSString *livetype;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;


    
    @end

@implementation YYTabBarController
    
- (void)viewDidLoad
    {
        [super viewDidLoad];
        
        
        self.tabBarView = [YYTabBar initWithTabs:3 systemTabBarHeight:self.tabBar.bounds.size.height selected:^(NSUInteger index) {
            self.selectedIndex = index;
        }];
        
        
        
        [self setupMainContents];
        [self someMethod];
        
        [self setValue:self.tabBarView forKey:@"tabBar"];
        
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, .5)]];
        [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, .5)]];
        
        
        UILabel *backLabel = [[UILabel alloc]init];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.24].CGColor];
        gradientLayer.locations = @[@0 ,@1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1.0);
        gradientLayer.frame = CGRectMake(0, 0 , kScreenW, 2);
        [backLabel.layer addSublayer:gradientLayer];
        backLabel.frame = CGRectMake(0, -2, kScreenW, 2);
        [self.tabBar addSubview:backLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 30;
        btn.clipsToBounds = YES;
//        btn.backgroundColor = [UIColor redColor];
        [self.tabBar addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"home_5"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"home_5"] forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;//去除按钮的按下效果（阴影）
        [btn addTarget:self action:@selector(onLiveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(self.tabBar.frame.size.width/2-30, -10, 65, 65);
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 70, 35);
        
        [self initBottomView];
        [self loginIM];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReLogin) name:@"requestReLogin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(someMethod)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
//        [self configLocalHttpServer];
        self.myServer = [LIMHttpServer defaultClient];
    }
    
    
-(void)viewWillAppear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}
- (void)someMethod{
    
    self.myServer = [LIMHttpServer defaultClient];
    [self.myServer configLocalHttpServer];
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mGetConf method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary * result = responseObject[@"result"];
            userModel.gameconflist = result[@"gameconflist"];
            [userModel saveAllInfo];
            
        }else{
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}
    
-(void) viewWillDisappear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}
    
-(void) viewDidDisappear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}
    
- (void)setupMainContents {
    
    // 首页
    LIMMainViewController *homeVC = [[LIMMainViewController alloc] init];
    [self addChildViewControllerAtIndex:0 childViewController:homeVC title:@"资讯" normalImage:@"home_4" selectedImage:@"home_3"];
    
    // 推流直播
    LIMPushLiveViewController *measureVC = [[LIMPushLiveViewController alloc] init];
    [self addChildViewControllerAtIndex:1 childViewController:measureVC title:@"学术圈" normalImage:@"selected-login" selectedImage:@"selected-login"];
    
    // 我的
    LIMPersonalViewController *personalVC = [[LIMPersonalViewController alloc] init];
    [self addChildViewControllerAtIndex:2 childViewController:personalVC title:@"我的" normalImage:@"home_图层-1" selectedImage:@"home_图层-0"];
    

}
    
    /**
     *  Add a child view controller.
     *
     *  @param index                index of the child Controller
     *  @param childViewController  child Controller
     *  @param title                title for item within TabBar
     *  @param normalImage          unselected image for item within TabBar
     *  @param selectedImage        selected image for item within TabBar
     */
- (void)addChildViewControllerAtIndex:(NSInteger)index childViewController:(UIViewController *)childViewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    // Set content of the corresponding tab bar item for child controller.
    
    [self.tabBarView setTabAtIndex:index title:title normalImage:normalImage selectedImage:selectedImage];
    
    // Add child Controller to TabBarController.
    YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:childViewController];
    [self addChildViewController:navigationVc];
}
    
#pragma mark - Actions.
- (void)switchTab:(NSUInteger)index {
    NSLog(@"%ld",index);
    self.selectedIndex = index;
    [self.tabBarView selectTab:index];
}

    
// 直播推流
- (void)onLiveButtonClicked{
    NSLog(@"直播推流");
    if (_botttomView) {
        [_botttomView removeFromSuperview];
        [self.view addSubview:_botttomView];
        _botttomView.hidden = NO;
    }
}
- (void) initBottomView
    {
        _botttomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.size.height - BOTTOM_VIEW_HEIGHT, self.view.width, BOTTOM_VIEW_HEIGHT)];
        _botttomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//        _botttomView.alpha = 0.80;
        _botttomView.hidden = YES;
        [self.view addSubview:_botttomView];
        CGSize size = _botttomView.frame.size;
/////////////////////////////////////////////底部/////////////////////////////////////////////////////
        int btnBkgViewHeight = 229.5;
        UIView * btnBkgView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - btnBkgViewHeight, size.width, btnBkgViewHeight)];
        btnBkgView.backgroundColor = [UIColor whiteColor];
        btnBkgView.userInteractionEnabled = YES;
        [_botttomView addSubview:btnBkgView];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//        [btnBkgView addGestureRecognizer:singleTap];
        
        
        
        
        // 关闭
        UIImageView * imageHidden = [[UIImageView alloc] init];
        imageHidden.image = [UIImage imageNamed:@"startpush_图层-3"];
        imageHidden.center = CGPointMake(self.view.width / 2, btnBkgViewHeight / 2);
        imageHidden.userInteractionEnabled = YES;

        [imageHidden sizeToFit];
        [btnBkgView addSubview:imageHidden];
        [imageHidden mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnBkgView).offset(-2);
            make.centerX.equalTo(btnBkgView);
        }];

        
        // 聊天直播
        UIView *chatView = [[UIView alloc]init];
//        chatView.backgroundColor = [UIColor cyanColor];
        [btnBkgView addSubview:chatView];
        UITapGestureRecognizer* tapGoChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChatLive)];
        [chatView addGestureRecognizer:tapGoChat];
        
        
        [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnBkgView).offset(-108);
            make.left.equalTo(btnBkgView).offset(66);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(80);
        }];
        
        UILabel *chatLabel = [[UILabel alloc]init];
        chatLabel.text = @"聊天直播";
        chatLabel.textColor = [UIColor colorWithHexString:@"585352"];
        chatLabel.font = [UIFont systemFontOfSize:13];
        chatLabel.textAlignment = NSTextAlignmentCenter;
        
        [chatView addSubview:chatLabel];
        [chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(chatView).offset(0);
            make.left.equalTo(chatView).offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(13);
        }];

        
        
        UIImageView *chatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_图层-2"]];
        [chatImage sizeToFit];
        [chatView addSubview:chatImage];
        
        [chatImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(chatLabel.mas_top).offset(-14.5);
            make.centerX.equalTo(chatView).offset(0);
        }];
        
        // 游戏直播
        
        UIView *gameView = [[UIView alloc]init];
//        gameView.backgroundColor = [UIColor cyanColor];
        [btnBkgView addSubview:gameView];
        UITapGestureRecognizer* tapGoGame = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goGameLive)];
        [gameView addGestureRecognizer:tapGoGame];

        
        [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnBkgView).offset(-108);
            make.right.equalTo(btnBkgView).offset(-66);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(80);
        }];
        
        
        UILabel *gameLabel = [[UILabel alloc]init];
        gameLabel.text = @"游戏直播";
        gameLabel.textColor = [UIColor colorWithHexString:@"585352"];
        gameLabel.font = [UIFont systemFontOfSize:13];
        gameLabel.textAlignment = NSTextAlignmentCenter;
        
        [gameView addSubview:gameLabel];
        [gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(gameView).offset(0);
            make.left.equalTo(gameView).offset(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(13);
        }];
        
        
        
        UIImageView *gameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_图层-1"]];
        [gameImage sizeToFit];
        [gameView addSubview:gameImage];
        
        [gameImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(gameLabel.mas_top).offset(-14.5);
            make.centerX.equalTo(gameView).offset(0);
        }];

        
///////////////////////////////////////////////////////////////////////////////////////////////////
        
        [imageHidden addGestureRecognizer:singleTap];
        [_botttomView addGestureRecognizer:singleTap];
        
    }
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
    {
        if (_botttomView) {
            _botttomView.hidden = YES;
        }
    }
- (void)goGameLive{
    self.livetype = @"game";
    [self httpForPushUrl];
}
- (void)goChatLive{
    self.livetype = @"chat";
    [self httpForPushUrl];
}
//#pragma mark -- 本地服务器 --
//#pragma mark -服务器
//#pragma mark - 搭建本地服务器 并且启动
//- (void)configLocalHttpServer{
//    _localHttpServer = [[HTTPServer alloc] init];
//    [_localHttpServer setType:@"_http.tcp"];
//    [_localHttpServer setPort:mLocalPort];
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    NSLog(@"资源文件路径:%@",webPath);
//    
//    
//    if (![fileManager fileExistsAtPath:webPath]){
//        NSLog(@"File path error!");
//    }else{
//        NSString *webLocalPath = webPath;
//        [_localHttpServer setDocumentRoot:webLocalPath];
//        NSLog(@"服务器路径  :%@",_localHttpServer.documentRoot);
//        [self startServer];
//    }
//}
//- (void)startServer
//{
//    
//    NSError *error;
//    if([_localHttpServer start:&error]){
//        NSLog(@"Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
////        self.port = [NSString stringWithFormat:@"%d",[_localHttpServer listeningPort]];
//    }
//    else{
//        NSLog(@"Error starting HTTP Server: %@", error);
//    }
//}
- (void)httpForPushUrl{
    
//    LIMChatSelectViewController *gameVC = [[LIMChatSelectViewController alloc]init];
//    gameVC.pushvideourl = @"rtmp://10557.livepush.myqcloud.com/live/10557_10013?bizid=10557&txSecret=d654d6c1f958eb2d59d9d2367cf21e8e&txTime=599e4408";
//    [self presentViewController:gameVC animated:YES completion:nil];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    
    BOOL oKPush = YES;
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
        [self showAlertWithMessage:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        oKPush = NO;
    }
    
    //是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
        [self showAlertWithMessage:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        oKPush = NO;
    }
    NSLog(@"%@",oKPush?@"yes":@"no");
    if (oKPush) {
        // 首页直播列表
        CcUserModel *userModel = [CcUserModel defaultClient];
        
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithCapacity:2];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mStartLiveInfo method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                
                [self handleSingleTap:nil];
                NSString *url = responseObject[@"result"][@"pushvideourl"];
                if ([self.livetype isEqualToString:@"game"]) {
                    LIMChatSelectViewController *gameVC = [[LIMChatSelectViewController alloc]init];
                    gameVC.pushvideourl = url;
                    gameVC.isChat = NO;
                    [self presentViewController:gameVC animated:YES completion:nil];
                }else{
                    LIMChatSelectViewController *chatVC = [[LIMChatSelectViewController alloc]init];
                    chatVC.pushvideourl = url;
                    chatVC.isChat = YES;
                    [self presentViewController:chatVC animated:YES completion:nil];
                }
            }else{
                NSString * resmsg = responseObject[@"resmsg"];
                NSLog(@"resmsg = %@",resmsg);
                [self showAlertWithMessage:resmsg];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}
//弹出alert
-(void)showAlertWithMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)loginIM{
    
    CcUserModel *userInfo = [CcUserModel defaultClient];
    TIMSdkConfig *config = [[TIMSdkConfig alloc]init];
    config.sdkAppId = 1400037200;
    config.accountType = @"14591";
    config.disableLogPrint = YES;
    [[TIMManager sharedInstance] initSdk:config];
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.identifier = userInfo.timid;
    
    login_param.userSig = userInfo.timsig;
    
    login_param.appidAt3rd = @"1400037200";
    
    [[TIMManager sharedInstance] login: login_param succ:^(){
        NSLog(@"------------------------------ Login im Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"------------------------------- Login im Failed: %d->%@", code, err);
    }];

}
// 登录失效
- (void)requestReLogin{
    CcUserModel *userModel = [CcUserModel defaultClient];
    [userModel removeUserInfo];//清除本地存储
    [CcUserModel defaultClient];//清除缓存
    LIMLoginViewController *logVC = [[LIMLoginViewController alloc]init];
    YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:logVC];
    [self presentViewController:navigationVc animated:true completion:nil];

}

@end
