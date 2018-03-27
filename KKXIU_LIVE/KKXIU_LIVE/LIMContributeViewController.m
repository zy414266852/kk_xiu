//
//  LIMContributeViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMContributeViewController.h"
#import "YYTabBarItem.h"
#import "LIMCharmSegment.h"
#import "LIMPageView.h"
#import "LIMHotViewController.h"
#import "LIMMyFollowViewController.h"
#import "LIMPushLiveViewController.h"
#import "LIMLastLiveViewController.h"
#import "HttpClient.h"
#import "LIMLiveListModel.h"
#import <MJExtension.h>
#import "LIMChatSelectViewController.h"  // 聊天直播选项
#import "LIMPushSelectViewController.h"  // 游戏直播选项
#import "LIMContributeTableViewCell.h"
#import "CcUserModel.h"
#import "LIMRankModel.h"
#import <UIImageView+WebCache.h>

@interface LIMContributeViewController ()<LIMSegmentDelegate,LIMPageViewDataSource,LIMPageViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕
@property(nonatomic, strong) LIMCharmSegment *segment;
@property(nonatomic, strong) LIMPageView *pageView;
@property (nonatomic, strong) NSMutableArray *dayDataSource;
@property (nonatomic, strong) NSMutableArray *allDataSource;


@end

@implementation LIMContributeViewController

- (NSMutableArray *)dayDataSource{
    if (_dayDataSource == nil) {
        _dayDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dayDataSource;
}

- (NSMutableArray *)allDataSource{
    if (_allDataSource == nil) {
        _allDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _allDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"魅力贡献榜";
    
    
//    UILabel *backLabel = [[UILabel alloc]init];
//    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.24].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
//    gradientLayer.locations = @[@0 ,@1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1.0);
//    gradientLayer.frame = CGRectMake(0, 0 , kScreenW, 5);
//    [backLabel.layer addSublayer:gradientLayer];
//    backLabel.frame = CGRectMake(0, 0, kScreenW, 5);
//    [self.view addSubview:backLabel];

    [self httpLiveCharmList];
    
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
- (void)setUI{
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self.view addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH -64);
    }];
    
    _segment = [[LIMCharmSegment alloc] initWithFrame:CGRectMake((kScreenW - 62)/4.0, 15, kScreenW, 30)];
    [_segment updateChannels:@[@"日榜",@"总榜"]];
    _segment.delegate = self;
    [_segment didChengeToIndex:0];
    [bigView addSubview:_segment];
    
    
    _pageView =[[LIMPageView alloc] initWithFrame:CGRectMake(0, 30 +15, kScreenW,kScreenH -64 -45)];
    _pageView.datasource = self;
    _pageView.delegate = self;
    _pageView.backgroundColor = [UIColor clearColor];
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:0];
    [bigView addSubview:_pageView];
    
    
}- (void)followUser{
    NSLog(@"关注");
}
- (void)pushOtherView{
    NSLog(@"push push  push");
}
- (void)emptyClick{
    
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInLIMPageView:(LIMPageView *)pageView{
    return 2;
}

-(UIView*)pageView:(LIMPageView *)pageView viewAtIndex:(NSInteger)index{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH -64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.tag = 200 +index;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc]init];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMContributeTableViewCell class] forCellReuseIdentifier:@"LIMContributeTableViewCell"];
    return tableView;
    
}

#pragma mark - JXSegmentDelegate
- (void)LIMSegment:(LIMSegment*)segment didSelectIndex:(NSInteger)index{
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

#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    LIMLiveViewController *liveVC = [[LIMLiveViewController alloc]init];
//
//    LIMLiveListModel *liveModel = self.dataSource[indexPath.row];
//    liveVC.liveuid = liveModel.uid;
//    liveVC.roomid  = liveModel.roomid;
//    [self presentViewController:liveVC animated:YES completion:^{
//
//    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dayDataSource.count < 2  && tableView.tag == 200) {
        return 0;
    }
    if (self.allDataSource.count < 2 && tableView.tag != 200) {
        return 0;
    }

    if (tableView.tag == 200) {
        return self.dayDataSource.count -1;
    }else{
        return self.allDataSource.count -1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    LIMContributeTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMContributeTableViewCell" forIndexPath:indexPath];
    LIMRankModel *rankModel;
    if (tableView.tag == 200) {
        rankModel = self.dayDataSource[indexPath.row +1];
    }else{
        rankModel = self.allDataSource[indexPath.row +1];
    }
    [hotLiveCell setrankDataSource:rankModel];
    hotLiveCell.nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dayDataSource.count == 0 && tableView.tag == 200) {
        return nil;
    }
    if (self.allDataSource.count == 0 && tableView.tag != 200) {
        return nil;
    }

    LIMRankModel *rankModel;
    if (tableView.tag == 200) {
        rankModel = self.dayDataSource[0];
    }else{
        rankModel = self.allDataSource[0];
    }
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
    UIImageView *backImagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"charm_图层-1"]];
    [backImagev sizeToFit];
    [headView addSubview:backImagev];
    [backImagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView).offset(0);
        make.bottom.equalTo(headView).offset(0);
    }];
    
    
    UIImageView *iconBack = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"charm_图层-2"]];
//    [iconBack sizeToFit];
    [headView addSubview:iconBack];
    [iconBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView).offset(0);
        make.top.equalTo(headView).offset(23.5);
        make.width.mas_equalTo(134);
        make.height.mas_equalTo(108.5);
    }];
    
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = 32;
    [icon sd_setImageWithURL:[NSURL URLWithString:rankModel.avatar] placeholderImage:[UIImage imageNamed:@"place_icon"]];
    //    [iconBack sizeToFit];
    [iconBack addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconBack).offset(0);
        make.top.equalTo(iconBack).offset(27.5);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
    }];

    
    // 排名
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"NO.1";
    numLabel.textColor = [UIColor colorWithHexString:@"ffb801"];
    numLabel.font = [UIFont systemFontOfSize:17];
    numLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconBack).offset(0);
        make.right.equalTo(headView).offset(-41.5 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(17*4, 17));
        
    }];

    
    // 贡献值
    UILabel *valueLabel = [[UILabel alloc]init];
    valueLabel.text = [NSString stringWithFormat:@"%@ 魅力",rankModel.score];
    valueLabel.textColor = [UIColor colorWithHexString:@"ff4ba9"];
    valueLabel.font = [UIFont systemFontOfSize:13];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:valueLabel];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView).offset(-36);
        make.centerX.equalTo(headView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 13));
        
    }];
    
    
    // name
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = rankModel.nickname;
    nameLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(valueLabel.mas_top).offset(-8);
        make.centerX.equalTo(headView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14));
        
    }];



    
    return headView;
}
// 魅力列表
- (void)httpLiveCharmList{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":self.touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mRank_gift method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self setUI];
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *daylist = dict[@"daylist"];
            
            for (NSDictionary *dict2 in daylist) {
                LIMRankModel *liveModel = [LIMRankModel mj_objectWithKeyValues:dict2];
                [self.dayDataSource addObject:liveModel];
            }
            NSArray *alllist = dict[@"alllist"];
            for (NSDictionary *dict2 in alllist) {
                LIMRankModel *liveModel = [LIMRankModel mj_objectWithKeyValues:dict2];
                [self.allDataSource addObject:liveModel];
            }
            UITableView *tableV = (UITableView *)[_pageView viewWithTag:200];
            [tableV reloadData];
            
            
            UITableView *alltableV = (UITableView *)[_pageView viewWithTag:201];
            [alltableV reloadData];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            //            [self showAlertWithMessage:resmsg];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
