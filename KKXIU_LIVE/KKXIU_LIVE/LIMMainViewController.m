//
//  LIMMainViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMMainViewController.h"
#import "YYTabBarItem.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "LIMHotViewController.h"
#import "LIMMyFollowViewController.h"
#import "LIMPushLiveViewController.h"
#import "LIMLastLiveViewController.h"
#import "HttpClient.h"
#import "LIMLiveListModel.h"
#import <MJExtension.h>
#import "LIMChatSelectViewController.h"  // 聊天直播选项
#import "LIMPushSelectViewController.h"  // 游戏直播选项
#import "LIMSearchViewController.h"
#import "YYNavigationController.h"
#import "LIMGameHallViewController.h"
#import "XGPush.h"
@interface LIMMainViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,XGPushTokenManagerDelegate>
    @property(nonatomic, strong) JXSegment *segment;
    @property(nonatomic, strong) JXPageView *pageView;
    @property(nonatomic, strong) UIView *topBackView;
    @end

@implementation LIMMainViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setupUI];
    
    NSInteger number1 = arc4random()%1000;
    [XGPushTokenManager defaultTokenManager].delegatge = self;
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:[NSString stringWithFormat:@"kkid%ld",number1] type:XGPushTokenBindTypeAccount];
    
//    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:[NSString stringWithFormat:@"kkid618"] type:XGPushTokenBindTypeAccount];

    
    // 注册直播通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goGameLive) name:@"goGameLive" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goChatLive) name:@"goChatLive" object:nil];
    // Do any additional setup after loading the view.
}
- (void)setupUI{
    // 状态栏 导航条背景
    self.navigationController.navigationBar.hidden = YES;
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    self.topBackView = backView;
    
    // 搜索
    YYTabBarItem *searchBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"home_11"] forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(goSeacchPage) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(33.5);
        make.left.equalTo(backView).offset(12);
    }];
    
    [self setupSlideBar];
    
    
}
- (void)setupSlideBar {
    _segment = [[JXSegment alloc] initWithFrame:CGRectMake(kScreenW -256*kiphone6 -14*kiphone6, 35, 256*kiphone6, 27)];
    [_segment updateChannels:@[@"关注",@"热门",@"最新",@"游戏大厅"]];
    _segment.delegate = self;
    [_segment didChengeToIndex:1];
    [self.topBackView addSubview:_segment];


    _pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH -64 -49)];
    _pageView.datasource = self;
    _pageView.delegate = self;
    _pageView.backgroundColor = [UIColor redColor];
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:1];
    [self.view addSubview:_pageView];
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return 4;
}
-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    
    if (index == 1) {
        LIMHotViewController *hotVC = [[LIMHotViewController alloc]init];

        [self addChildViewController:hotVC];
        return hotVC.view;
    }
    if (index == 0) {
        LIMMyFollowViewController *followVC = [[LIMMyFollowViewController alloc]init];
        
        [self addChildViewController:followVC];
        return followVC.view;
    }
    if (index == 2) {
        LIMLastLiveViewController *lastLiveVC = [[LIMLastLiveViewController alloc]init];
        
        [self addChildViewController:lastLiveVC];
        return lastLiveVC.view;
    }
    else{
        
        
        LIMGameHallViewController *lastLiveVC = [[LIMGameHallViewController alloc]init];
        
        [self addChildViewController:lastLiveVC];
        return lastLiveVC.view;

    ////////////////////////////
//    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenW, kScreenH -148 -5) style:UITableViewStyleGrouped];
//    tableView.backgroundColor = [self randomColor];
////    tableView.dataSource = self;
////    tableView.delegate = self;
//    tableView.rowHeight = kScreenW *77/320.0 +10;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.showsVerticalScrollIndicator = NO;
//        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//        return tableView;
    }
    
    
    ////////////////////////////
    
}
    
#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [_pageView changeToItemAtIndex:index];
}
    
#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [_segment didChengeToIndex:index];
}
    
    
- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)golive{

    [self presentViewController:[[LIMPushLiveViewController alloc]init] animated:YES completion:nil];
}

- (void)goSeacchPage{
    YYNavigationController *navSearch = [[YYNavigationController alloc]initWithRootViewController:[[LIMSearchViewController alloc]init]];
    [self presentViewController:navSearch animated:YES completion:nil];
//    [self.navigationController pushViewController:navSearch animated:YES];
}
//
- (void)goGameLive{
    UINavigationController *navGame = [[UINavigationController alloc]initWithRootViewController:[[LIMPushSelectViewController alloc]init]];
    [self presentViewController:navGame animated:YES completion:nil];
//    [self presentViewController:[[LIMPushSelectViewController alloc]init] animated:YES completion:nil];
}
- (void)goChatLive{
    NSLog(@"go chat");
//    [self.navigationController pushViewController:[[LIMChatSelectViewController alloc]init] animated:YES];
        [self presentViewController:[[LIMChatSelectViewController alloc]init] animated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - XGPushTokenManagerDelegate
- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    //    [self.alertCtr setMessage:[NSString stringWithFormat:@"绑定%@%@%@", ((type == XGPushTokenBindTypeAccount)?@"账号":@"标签"), ((error == nil)?@"成功":@"失败"), identifier]];
    //    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifier, error);
}

@end
