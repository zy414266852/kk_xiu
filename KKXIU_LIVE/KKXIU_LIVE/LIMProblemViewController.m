//
//  LIMProblemViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/23.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMProblemViewController.h"
#import <WebKit/WebKit.h>
@interface LIMProblemViewController ()

@end

@implementation LIMProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"常见问题";
    
    
    WKWebView *gameWeb = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64)];
    gameWeb.backgroundColor = [UIColor clearColor];
    [gameWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.problemurl]]];
    
    //    }
    [gameWeb setOpaque:NO];
    //    gameWeb.navigationDelegate = self;
    //    gameWeb.UIDelegate = self;
    [self.view addSubview:gameWeb];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
