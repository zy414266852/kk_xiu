//
//  LIMWebGameViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2018/1/9.
//  Copyright © 2018年 张洋. All rights reserved.
//

#import "LIMWebGameViewController.h"
#import <WebKit/WebKit.h>

@interface LIMWebGameViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
@property (nonatomic, strong) WKWebView *gameWebV;
@end

@implementation LIMWebGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *httpHead = self.serverinfo;
//    for (int i = 0; i<userModel.gameconflist.count; i++) {
//        NSDictionary *dict = userModel.gameconflist[i];
//        if ([dict[@"gameid"] integerValue] == 6) {
//            httpHead = dict[@"serverinfo"];
//        }
//    }
    NSLog(@"%@ /n httpHead = %@",userModel.gameconflist,httpHead);


    NSString *gameUrl = self.gameurl;//@"http://app.game.coco98.com/mhxy/";
    WKWebView *gameWeb = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    gameWeb.backgroundColor = [UIColor clearColor];
    [gameWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@&token=%@&deviceno=%@&httphead=%@",gameUrl,userModel.uid,userModel.token,@"",httpHead]]]];
    
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@?uid=%@&token=%@&deviceno=%@&httphead=%@",gameUrl,userModel.uid,userModel.token,@"",httpHead]);
    //    }
    [gameWeb setOpaque:NO];
    gameWeb.navigationDelegate = self;
    gameWeb.UIDelegate = self;
    self.gameWebV = gameWeb;
    
    if (gameUrl.length >2) {
    }
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"onbackgame"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"onRechargeScore"];
//    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"OnChangeScore"];
//    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"OnCompleteGame"];
//    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"HitCompleteGame"];
//    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"ShowCompleteGame"];
    //    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"RechargeScore"];
    
    [self.view addSubview:self.gameWebV];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //code
    NSLog(@"WKScriptMessageHandler协议方法== %@",message.name);
    if ([message.name isEqualToString:@"RechargeScore"]) {
        //        [self showAlertWithMessage:[NSString stringWithFormat:@"充钱%@",message.body]];
        
        if ([message.body isEqualToString:@"0"]) {
//            [self pushChongzhi];
        }else if ([message.body isEqualToString:@"1"]) {
//            [self noMoney];
        }
        
    }else if ([message.name isEqualToString:@"PrizeScore"]) {
        
    }else if ([message.name isEqualToString:@"onbackgame"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([message.name isEqualToString:@"OnCompleteGame"]) {
        
    }else if ([message.name isEqualToString:@"HitCompleteGame"]) {

    }else if ([message.name isEqualToString:@"ShowCompleteGame"]) {

    }
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
