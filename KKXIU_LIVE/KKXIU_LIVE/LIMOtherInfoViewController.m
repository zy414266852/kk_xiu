//
//  LIMOtherInfoViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMOtherInfoViewController.h"
#import <SDCycleScrollView.h>
#import "YYTabBarItem.h"
#import "LIMSettingViewController.h"
#import "LIMEditViewController.h"
//#import "LIMFollowViewController.h"
//#import "LIMFollowedViewController.h"
#import "LIMOtherFollowViewController.h"
#import "LIMGoldViewController.h"
#import "LIMCharmViewController.h"
#import "LIMGradeViewController.h"
#import "LIMMsgViewController.h"
#import "LIMContributeViewController.h"
#import "LIMShareViewController.h"
#import "MJRefresh.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "LIMPersonalModel.h"
#import "LIMContributeViewController.h"
#import "SDChatDetailViewController.h"
#import "LIMChatListModel.h"
#import <UIImageView+WebCache.h>
#define mThirdH 133.5
#define mViewTag 1000

@interface LIMOtherInfoViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *msgView;
@property (nonatomic, strong) UIView *contributeView;
@property (nonatomic, strong) LIMPersonalModel *personalModel;

@end

@implementation LIMOtherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refrash)];
    
    //    [self.view addSubview:[self imageArrayView]];
    [self httpForLiveList];
    
    
    
    // 设置
    YYTabBarItem *settingBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"upinfo_图层-83-拷贝"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    [settingBtn addTarget:self action:@selector(offThisView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingBtn];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(22);
        make.left.equalTo(self.view).offset(17.5);
    }];
    
    
    YYTabBarItem *bigBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [bigBtn addTarget:self action:@selector(offThisView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBtn];
    [bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(settingBtn).offset(0);
        make.centerY.equalTo(settingBtn).offset(0);
        make.size.mas_offset(CGSizeMake(40, 40));
    }];
    // 编辑
    YYTabBarItem *editBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"upinfo_椭圆-3-拷贝-2"] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(showAlertWithReport) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editBtn];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(27.5);
        make.right.equalTo(self.view).offset(-17.5);
    }];
    
    
    // Do any additional setup after loading the view.
}
- (SDCycleScrollView *)imageArrayView{
    // 图片轮播器
    SDCycleScrollView *cycleScrollView2 = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 350 *kiphone6)];
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    cycleScrollView2.showPageControl = YES;
    cycleScrollView2.delegate = self;
    cycleScrollView2.autoScroll = NO;
    //    cycleScrollView2.imageURLStringsGroup  = @[@"",@""];
    cycleScrollView2.localizationImageNamesGroup = @[@"livepage",@"timg"];
    cycleScrollView2.pageControlAliment = 0;
    cycleScrollView2.currentPageDotColor = [UIColor colorWithHexString:@"ddb104"];
    cycleScrollView2.pageDotColor = [UIColor colorWithHexString:@"a1a1a1"];
    self.cycleScrollView2 = cycleScrollView2;
    
    
    UILabel *describeTitle = [[UILabel alloc]init];
    describeTitle.text = self.personalModel.personsign;
    describeTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    describeTitle.textAlignment = NSTextAlignmentLeft;
    describeTitle.font = [UIFont systemFontOfSize:13];
    [cycleScrollView2 addSubview:describeTitle];
    [describeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cycleScrollView2).offset(9.5);
        make.bottom.equalTo(cycleScrollView2).offset(-25);
        make.width.mas_equalTo(kScreenW/2.0 + 30);
        make.height.mas_equalTo(13);
    }];
    NSString *nameStr = self.personalModel.nickname;
    CGFloat buttonW = [nameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.text = nameStr;
    nameTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.font = [UIFont systemFontOfSize:16];
    [cycleScrollView2 addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cycleScrollView2).offset(9);
        make.bottom.equalTo(describeTitle.mas_top).offset(-13.5);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *idTitle = [[UILabel alloc]init];
    idTitle.text = [NSString stringWithFormat:@"ID  %@",self.personalModel.uid];
    idTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    idTitle.textAlignment = NSTextAlignmentLeft;
    idTitle.font = [UIFont systemFontOfSize:13];
    [cycleScrollView2 addSubview:idTitle];
    [idTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle.mas_right).offset(8);
        make.bottom.equalTo(nameTitle).offset(0);
        make.width.mas_equalTo(kScreenW/2.0 + 30);
        make.height.mas_equalTo(13);
    }];
    
    
    
    return cycleScrollView2;
    
}
- (void)setUI{
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    //
    self.dataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 54)];
    self.dataView.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.dataView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dataView).offset(0);
        make.centerX.equalTo(self.dataView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(40);
    }];
    
    // 关注
    UIView *followView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [followView addGestureRecognizer:tapClick];
    followView.tag = mViewTag +0;
    [self.dataView addSubview:followView];
    [followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dataView).offset(0);
        make.top.equalTo(self.dataView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.equalTo(self.dataView);
    }];
    
    UILabel *followCount = [[UILabel alloc]init];
    followCount.text = self.personalModel.followcount;
    followCount.textColor = [UIColor colorWithHexString:@"000000"];
    followCount.textAlignment = NSTextAlignmentCenter;
    followCount.font = [UIFont systemFontOfSize:14];
    [followView addSubview:followCount];
    [followCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followView).offset(0);
        make.top.equalTo(followView).offset(12.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(14);
    }];
    
    
    
    UILabel *followTitle = [[UILabel alloc]init];
    followTitle.text = @"关注";
    followTitle.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    followTitle.textAlignment = NSTextAlignmentCenter;
    followTitle.font = [UIFont systemFontOfSize:13];
    [followView addSubview:followTitle];
    [followTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followView).offset(0);
        make.top.equalTo(followCount.mas_bottom).offset(6.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(13);
    }];
    
    //粉丝
    UIView *followedView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [followedView addGestureRecognizer:tapClick1];
    followedView.tag = mViewTag +1;
    [self.dataView addSubview:followedView];
    [followedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dataView).offset(kScreenW/2.0);
        make.top.equalTo(self.dataView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.equalTo(self.dataView);
    }];
    
    UILabel *followedCount = [[UILabel alloc]init];
    followedCount.text = self.personalModel.fanscount;
    followedCount.textColor = [UIColor colorWithHexString:@"000000"];
    followedCount.textAlignment = NSTextAlignmentCenter;
    followedCount.font = [UIFont systemFontOfSize:14];
    [followedView addSubview:followedCount];
    [followedCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followedView).offset(0);
        make.top.equalTo(followedView).offset(12.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(14);
    }];
    
    
    
    UILabel *followedTitle = [[UILabel alloc]init];
    followedTitle.text = @"粉丝";
    followedTitle.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    followedTitle.textAlignment = NSTextAlignmentCenter;
    followedTitle.font = [UIFont systemFontOfSize:13];
    [followedView addSubview:followedTitle];
    [followedTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(followedView).offset(0);
        make.top.equalTo(followedCount.mas_bottom).offset(6.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(13);
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 217)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    
    UIView *contributeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 41.5)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToContribuion)];
    [contributeView addGestureRecognizer:tap];
    [self.infoView addSubview:contributeView];
    
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [contributeView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contributeView).offset(0);
        make.left.equalTo(contributeView).offset(26.5);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(1);
    }];
    
    
    UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_1"]];
//    titleImage.clipsToBounds = YES;
//    titleImage.layer.cornerRadius = 13;
    [titleImage sizeToFit];
    [contributeView addSubview:titleImage];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contributeView).offset(0);
        make.left.equalTo(contributeView).offset(16);
    }];
    
    UILabel *titleC = [[UILabel alloc]init];
    titleC.text = @"贡献榜";
    titleC.textColor = [UIColor blackColor];
    titleC.font = [UIFont systemFontOfSize:14];
    [contributeView addSubview:titleC];
    [titleC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contributeView).offset(0);
        make.left.equalTo(titleImage.mas_right).offset(6.5);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(14);
    }];
    
    
    UIImageView *moreContri = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phonelogin_图层-1"]];
    [moreContri sizeToFit];
    [contributeView addSubview:moreContri];
    [moreContri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contributeView).offset(0);
        make.right.equalTo(contributeView).offset(-13);
    }];
    
//    self.personalModel.coverlist.count;
    CGFloat initLeft = -19 -123 +27;
    if (self.personalModel.consumelist.count == 1) {
        initLeft += 82;
    }else if (self.personalModel.consumelist.count == 2) {
        initLeft += 41;
    }
    for (int i = 0; i <self.personalModel.consumelist.count; i++) {
        NSDictionary *dict = self.personalModel.consumelist[i];
        UIImageView *numPeople = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"place_icon"]];
        [numPeople sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]]];
        numPeople.clipsToBounds = YES;
        numPeople.layer.cornerRadius = 13.5;
        [contributeView addSubview:numPeople];
        [numPeople mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contributeView).offset(0);
            make.right.equalTo(contributeView).offset(initLeft + (i*41));
            make.width.mas_equalTo(27);
            make.height.mas_equalTo(27);
        }];
    }
    
    
    UILabel *titleInfo = [[UILabel alloc]init];
    titleInfo.text = @"个人信息";
    titleInfo.textColor = [UIColor blackColor];
    titleInfo.font = [UIFont systemFontOfSize:17];
    [self.infoView addSubview:titleInfo];
    [titleInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contributeView.mas_bottom).offset(11.5);
        make.left.equalTo(contributeView).offset(16);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(17);
    }];
    
    
    
    CGFloat starH = 41.5 +41.5;
    CGFloat padding = 29;
    NSArray *titleArr = @[@"KKID",@"年龄",@"性别",@"星座",@"城市"];
    NSArray *valueArr = @[self.personalModel.uid,self.personalModel.age,self.personalModel.gender,self.personalModel.star,self.personalModel.city];
    for (int i = 0 ; i< 5; i++) {
        UILabel *titleL = [[UILabel alloc]init];
        titleL.text = titleArr[i];
        titleL.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        titleL.font = [UIFont systemFontOfSize:13];
        [self.infoView addSubview:titleL];
        
        CGFloat buttonW = [titleL.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleL.font} context:nil].size.width +2;
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoView).offset(starH +i*padding);
            make.left.equalTo(self.infoView).offset(16);
            make.width.mas_equalTo(buttonW);
            make.height.mas_equalTo(13);
        }];
        
        
        UILabel *valueL = [[UILabel alloc]init];
        valueL.text = valueArr[i];
        valueL.textColor = [UIColor colorWithHexString:@"000000"];
        valueL.font = [UIFont systemFontOfSize:13];
        [self.infoView addSubview:valueL];
        
        CGFloat valueLW = [valueL.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:valueL.font} context:nil].size.width +2;
        [valueL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoView).offset(starH +i*padding);
            make.left.equalTo(titleL.mas_right).offset(13);
            make.width.mas_equalTo(valueLW);
            make.height.mas_equalTo(13);
        }];
        if (i == 0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"(点我复制)" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.infoView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoView).offset(starH +i*padding);
                make.left.equalTo(valueL.mas_right).offset(8);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(13);
            }];
        }

    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"3-7"] forState:UIControlStateNormal];
    

    
    
    [btn setTitle:@"已关注" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithHexString:@"c7c7c7"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"透明"] forState:UIControlStateSelected];
    
    
    [btn setTitleColor:[UIColor colorWithHexString:@"ff3da8"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(followPeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(45.5);
    }];
    
    UIButton *privatebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [privatebtn setTitle:@"私信" forState:UIControlStateNormal];
    privatebtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    [privatebtn setImage:[UIImage imageNamed:@"upinfo_图层-2"] forState:UIControlStateNormal];
    [privatebtn setTitleColor:[UIColor colorWithHexString:@"f5b609"] forState:UIControlStateNormal];
    privatebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [privatebtn addTarget:self action:@selector(lookOther) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privatebtn];
    [privatebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(kScreenW/2.0);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(45.5);

    }];
    
    UILabel *white_line = [[UILabel alloc]init];
    white_line.alpha = 0.5;
    white_line.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:white_line];
    
    [white_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5);
        make.left.equalTo(self.view).offset(kScreenW/2.0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(35.5);
        
    }];
    

    if ([self.personalModel.isfollow isEqualToString:@"0"]) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat viewH = 0;
    switch (section) {
        case 0:
        {
            viewH = 54;
            break;
        }
        case 1:
        {
            viewH = 217;
            break;
        }
        case 2:
        {
            viewH = 131.5;
            break;
        }
        default:
            break;
    }
    return viewH;
}

#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return self.dataView;
            break;
        }
        case 1:
        {
            return self.infoView;
            break;
        }
        case 2:
        {
            return self.msgView;
            break;
        }
        default:
            return nil;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *grayCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    grayCell.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    return grayCell;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        footView.backgroundColor =[UIColor whiteColor];
        _tableView.tableFooterView = footView;
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}
- (void)pushToSetting{
//    [self.navigationController pushViewController:[[LIMSettingViewController alloc]init] animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)pushToEdit{
    [self.navigationController pushViewController:[[LIMEditViewController alloc]init] animated:YES];
}
- (void)allBtnViewClick:(UIGestureRecognizer *)tap{
    NSLog(@"viewtag = %ld",tap.view.tag);
    
    NSInteger viewTag = tap.view.tag -1000;
    switch (viewTag) {
        case 0:{
            LIMOtherFollowViewController *otherF = [[LIMOtherFollowViewController alloc]init];
            otherF.isFollow = YES;
            otherF.touid = self.touid;
            [self.navigationController pushViewController:otherF animated:YES];
            break;
        }
        case 1:
        {
            LIMOtherFollowViewController *otherF = [[LIMOtherFollowViewController alloc]init];
            otherF.isFollow = NO;
            otherF.touid = self.touid;
            [self.navigationController pushViewController:otherF animated:YES];
            break;
        }
        case 2:
            [self.navigationController pushViewController:[[LIMGoldViewController alloc]init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[LIMCharmViewController alloc]init] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[[LIMGradeViewController alloc]init] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[[LIMMsgViewController alloc]init] animated:YES];
            break;
        case 6:
            [self.navigationController pushViewController:[[LIMContributeViewController alloc]init] animated:YES];
            break;
        case 7:
            
            [self.navigationController pushViewController:[[LIMShareViewController alloc]init] animated:YES];
            break;
            
        default:
            break;
    }
}
- (void)refrash{
    NSLog(@"123");
    [self.tableView.mj_header beginRefreshing];
}
- (void)httpForLiveList{
    if (self.dataSource.count >0) {
        [self.dataSource removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 首页直播列表
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":self.touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mOther_Info method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict =responseObject[@"result"];
            self.personalModel = [LIMPersonalModel mj_objectWithKeyValues:dict];
            if ([self.personalModel.age isEqualToString:@""]) {
                self.personalModel.age = @"未知";
            }
            if ([self.personalModel.gender isEqualToString:@""]) {
                self.personalModel.gender = @"未知";
            }
            if ([self.personalModel.gender isEqualToString:@"1"]) {
                self.personalModel.gender = @"男";
            }
            if ([self.personalModel.gender isEqualToString:@"2"]) {
                self.personalModel.gender = @"女";
            }
            if ([self.personalModel.star isEqualToString:@""]) {
                self.personalModel.star = @"未知";
            }
            if ([self.personalModel.city isEqualToString:@""]) {
                self.personalModel.city = @"未知";
            }
            self.tableView.tableHeaderView = [self imageArrayView];
            
            
            [self setUI];
            
            NSMutableArray *coverList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *adDict in self.personalModel.coverlist) {
                [coverList addObject:adDict[@"cover"]];
            }
            _cycleScrollView2.imageURLStringsGroup  = coverList;
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
- (void)offThisView{
    NSLog(@"123123");
    if([self isKindOfClass:[self.navigationController.viewControllers.firstObject class]]){
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)copyKKID{
    NSLog(@"复制kkid");
}
- (void)followPeople:(UIButton *)sender{
    NSLog(@"复制kkid");
    if (sender.selected) {
        
    }else{
        
        CcUserModel *userModel = [CcUserModel defaultClient];
        
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":self.touid}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mFollow_other method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                sender.selected = YES;
            }else{
                NSString * resmsg = responseObject[@"resmsg"];
                NSLog(@"resmsg = %@",resmsg);
                //            [self showAlertWithMessage:resmsg];
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)lookOther{
    LIMChatListModel *chatListModel = [[LIMChatListModel alloc]init];
    chatListModel.nickName = self.personalModel.nickname;
    chatListModel.iconUrl = _cycleScrollView2.imageURLStringsGroup[0];
    chatListModel.kkID = [NSString stringWithFormat:@"kk%@",self.personalModel.uid];
    SDChatDetailViewController *v =[[SDChatDetailViewController alloc]init];
    v.chatListModel = chatListModel;
    [self.navigationController pushViewController:v animated:YES];

}
- (void)pushToContribuion{
    
    
    LIMContributeViewController *contriVC = [[LIMContributeViewController alloc]init];
    NSLog(@"%@",self.touid);
    
    contriVC.touid = self.touid;
    
    [self.navigationController pushViewController:contriVC animated:YES];
}

//弹出alert
-(void)showAlertWithReport{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择举报类型" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"广告敲诈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"淫秽色情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:@"骚扰谩骂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    
    UIAlertAction *okAction4 = [UIAlertAction actionWithTitle:@"反动政治" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction5 = [UIAlertAction actionWithTitle:@"其他内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];

    [alert addAction:okAction1];
    [alert addAction:okAction2];
    [alert addAction:okAction3];
    [alert addAction:okAction4];
    [alert addAction:okAction5];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)copylinkBtnClick {
    [self showAlertWithMessage:@"复制成功"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.personalModel.uid;
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
