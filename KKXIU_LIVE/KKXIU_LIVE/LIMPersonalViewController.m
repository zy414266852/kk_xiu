//
//  LIMPersonalViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPersonalViewController.h"
#import <SDCycleScrollView.h>
#import "YYTabBarItem.h"
#import "LIMSettingViewController.h"
#import "LIMEditViewController.h"
#import "LIMFollowViewController.h"
#import "LIMFollowedViewController.h"
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
#import "LIMShareView.h"
#define mThirdH 133.5
#define mViewTag 1000
@interface LIMPersonalViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) UIView *dataView;
@property (nonatomic, strong) UIView *goldView;
@property (nonatomic, strong) UIView *msgView;
@property (nonatomic, strong) LIMPersonalModel *personalModel;



@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *followedLabel;
@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UILabel *charmLabel;


@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *wordImageView;


@property (nonatomic, assign) BOOL isFirst;


@end

@implementation LIMPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFirst = YES;
    
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refrash)];
    
    //    [self.view addSubview:[self imageArrayView]];
    [self httpForLiveList];
    
    
    
    // 设置
    YYTabBarItem *settingBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"gray_setting"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    [settingBtn addTarget:self action:@selector(pushToSetting) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingBtn];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25.5);
        make.left.equalTo(self.view).offset(10.5);
    }];
    
    // 编辑
    YYTabBarItem *editBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"gray_edit"] forState:UIControlStateNormal];
    [editBtn sizeToFit];
    [editBtn addTarget:self action:@selector(pushToEdit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:editBtn];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25.5);
        make.right.equalTo(self.view).offset(-10.5);
    }];
    
    
    // Do any additional setup after loading the view.
}
- (SDCycleScrollView *)imageArrayView{
    // 图片轮播器
    SDCycleScrollView *cycleScrollView2 = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 350 *kiphone6)];
    cycleScrollView2.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    cycleScrollView2.showPageControl = YES;
    cycleScrollView2.delegate = self;
    cycleScrollView2.autoScroll = NO;
    //    cycleScrollView2.imageURLStringsGroup  = @[@"",@""];
    cycleScrollView2.localizationImageNamesGroup = @[@"livepage",@"timg"];
    cycleScrollView2.pageControlAliment = 0;
    cycleScrollView2.currentPageDotColor = [UIColor colorWithHexString:@"ddb104"];
    cycleScrollView2.pageDotColor = [UIColor colorWithHexString:@"a1a1a1"];
    self.cycleScrollView2 = cycleScrollView2;
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.2].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
    gradientLayer.locations = @[@0 ,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 1.0);
    gradientLayer.endPoint = CGPointMake(0, 0.5);
    gradientLayer.frame = CGRectMake(0, 175*kiphone6 , kScreenW, 175*kiphone6);
    [cycleScrollView2.layer addSublayer: gradientLayer];
    
    
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
    CGFloat buttonW = [nameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width +2;
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
    
    self.nameLabel = nameTitle;
    self.signLabel = describeTitle;
    
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
    
    
    self.goldView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 72.5)];
    self.goldView.backgroundColor = [UIColor whiteColor];
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.goldView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goldView).offset(0);
        make.centerX.equalTo(self.goldView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(57.5);
    }];
    // 金币
    UIView *goldView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [goldView addGestureRecognizer:tapClick2];
    goldView.tag = mViewTag +2;
    [self.goldView addSubview:goldView];
    [goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goldView).offset(0);
        make.top.equalTo(self.goldView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.equalTo(self.goldView);
    }];
    
    UILabel *goldCount = [[UILabel alloc]init];
    goldCount.text = self.personalModel.cumoney;
    goldCount.textColor = [UIColor colorWithHexString:@"fdb40c"];
    goldCount.textAlignment = NSTextAlignmentCenter;
    goldCount.font = [UIFont systemFontOfSize:14];
    [goldView addSubview:goldCount];
    [goldCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goldView).offset(0);
        make.top.equalTo(goldView).offset(12.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(14);
    }];
    
    
    
    UIImageView *goldImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_图层-2"]];
    [goldImageV sizeToFit];
    [goldView addSubview:goldImageV];
    [goldImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goldView).offset(0);
        make.top.equalTo(goldCount.mas_bottom).offset(6);
        //        make.width.mas_equalTo(kScreenW/2.0);
        //        make.height.mas_equalTo(13);
    }];
    
    
    
    // 魅力值
    UIView *charmView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [charmView addGestureRecognizer:tapClick3];
    charmView.tag = mViewTag +3;
    [self.goldView addSubview:charmView];
    [charmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goldView).offset(kScreenW/2.0);
        make.top.equalTo(self.goldView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.equalTo(self.goldView);
    }];
    
    UILabel *charmCount = [[UILabel alloc]init];
    charmCount.text = self.personalModel.score;
    charmCount.textColor = [UIColor colorWithHexString:@"ff389f"];
    charmCount.textAlignment = NSTextAlignmentCenter;
    charmCount.font = [UIFont systemFontOfSize:14];
    [charmView addSubview:charmCount];
    [charmCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(charmView).offset(0);
        make.top.equalTo(charmView).offset(12.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(14);
    }];
    
    UIImageView *charmImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_图层-1"]];
    [charmImageV sizeToFit];
    [charmView addSubview:charmImageV];
    [charmImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(charmView).offset(0);
        make.top.equalTo(charmCount.mas_bottom).offset(6);
        //        make.width.mas_equalTo(kScreenW/2.0);
        //        make.height.mas_equalTo(13);
    }];
    
    
    self.msgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 131.5)];
    self.msgView.backgroundColor = [UIColor whiteColor];
    UILabel *line3 = [[UILabel alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self.msgView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.msgView).offset(0);
        make.centerX.equalTo(self.msgView);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(112);
        
    }];
    
    // 级别
    UIView *gradeView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [gradeView addGestureRecognizer:tapClick4];
    gradeView.tag = mViewTag +4;
    [self.msgView addSubview:gradeView];
    [gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgView).offset(0);
        make.top.equalTo(self.msgView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(mThirdH/2.0);
    }];
    
//    UIImageView *gradeImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_等级"]];
//    [gradeImageV sizeToFit];
//    [gradeView addSubview:gradeImageV];
//    [gradeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(gradeView).offset(0);
//        make.centerY.equalTo(gradeView).offset(0);
//        //        make.width.mas_equalTo(kScreenW/2.0);
//        //        make.height.mas_equalTo(13);
//    }];
    NSLog(@"%@是主播,,,等级：%@",self.personalModel.iscompere,self.personalModel.userlevel);
    
    if ([self.personalModel.iscompere isEqualToString:@"1"]) {
        self.mainImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upbig_%d",[self.personalModel.userlevel intValue]]]];
        [gradeView addSubview:self.mainImageView];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeView).offset(0);
            make.top.equalTo(gradeView).offset(12.5);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        self.wordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upword_%d",[self.personalModel.userlevel intValue]]]];
        [self.wordImageView sizeToFit];
        [gradeView addSubview:self.wordImageView];
        [self.wordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeView).offset(0);
            make.top.equalTo(self.mainImageView.mas_bottom).offset(5);
            //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
        }];
//        self.mainImageView = mainImage;
//        self.wordImageView = levelImage;

    }else{
        self.mainImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_%d",[self.personalModel.userlevel intValue]]]];
        [gradeView addSubview:self.mainImageView];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeView).offset(0);
            make.top.equalTo(gradeView).offset(12.5);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        
        self.wordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word_%d",[self.personalModel.userlevel intValue]]]];
        [self.wordImageView sizeToFit];
        [gradeView addSubview:self.wordImageView];
        [self.wordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeView).offset(0);
            make.top.equalTo(self.mainImageView.mas_bottom).offset(5);
            //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
        }];

//        self.mainImageView = mainImage;
//        self.wordImageView = levelImage;
    }
    
    
//    l
    
    
    //消息
    UIView *msgView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [msgView addGestureRecognizer:tapClick5];
    msgView.tag = mViewTag +5;
    [self.msgView addSubview:msgView];
    [msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgView).offset(kScreenW/2.0);
        make.top.equalTo(self.msgView);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(mThirdH/2.0);
    }];
    
    
    UIImageView *msgImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_图层-3"]];
    [msgImageV sizeToFit];
    [msgView addSubview:msgImageV];
    [msgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(msgView).offset(0);
        make.top.equalTo(msgView).offset(12.5);
        
        //        make.width.mas_equalTo(kScreenW/2.0);
        //        make.height.mas_equalTo(13);
    }];
    
    
    UILabel *msgTitle = [[UILabel alloc]init];
    msgTitle.text = @"消息";
    msgTitle.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    msgTitle.textAlignment = NSTextAlignmentCenter;
    msgTitle.font = [UIFont systemFontOfSize:13];
    [msgView addSubview:msgTitle];
    [msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(msgView).offset(0);
        make.top.equalTo(msgImageV.mas_bottom).offset(7.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(13);
    }];
    
    
    
    //贡献榜
    UIView *contributeView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [contributeView addGestureRecognizer:tapClick6];
    contributeView.tag = mViewTag +6;
    [self.msgView addSubview:contributeView];
    [contributeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgView).offset(0);
        make.top.equalTo(self.msgView).offset(mThirdH/2.0);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(mThirdH/2.0);
    }];
    
    UIImageView *contributeImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_1"]];
    [contributeImageV sizeToFit];
    [contributeView addSubview:contributeImageV];
    [contributeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contributeView).offset(0);
        make.top.equalTo(contributeView).offset(12.5);
        
        //        make.width.mas_equalTo(kScreenW/2.0);
        //        make.height.mas_equalTo(13);
    }];
    
    
    UILabel *contributeTitle = [[UILabel alloc]init];
    contributeTitle.text = @"贡献榜";
    contributeTitle.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    contributeTitle.textAlignment = NSTextAlignmentCenter;
    contributeTitle.font = [UIFont systemFontOfSize:13];
    [contributeView addSubview:contributeTitle];
    [contributeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contributeView).offset(0);
        make.top.equalTo(contributeImageV.mas_bottom).offset(7.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(13);
    }];
    
    //分享
    UIView *shareView = [[UIView alloc]init];
    UITapGestureRecognizer *tapClick7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allBtnViewClick:)];
    [shareView addGestureRecognizer:tapClick7];
    shareView.tag = mViewTag +7;
    [self.msgView addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgView).offset(kScreenW/2.0);
        make.top.equalTo(self.msgView).offset(mThirdH/2.0);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(mThirdH/2.0);
    }];
    
    
    UIImageView *shareImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_图层-4"]];
    [shareImageV sizeToFit];
    [shareView addSubview:shareImageV];
    [shareImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shareView).offset(0);
        make.top.equalTo(shareView).offset(12.5);
        
        //        make.width.mas_equalTo(kScreenW/2.0);
        //        make.height.mas_equalTo(13);
    }];
    
    
    UILabel *shareTitle = [[UILabel alloc]init];
    shareTitle.text = @"分享";
    shareTitle.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    shareTitle.textAlignment = NSTextAlignmentCenter;
    shareTitle.font = [UIFont systemFontOfSize:13];
    [shareView addSubview:shareTitle];
    [shareTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shareView).offset(0);
        make.top.equalTo(shareImageV.mas_bottom).offset(7.5);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(13);
    }];
    
    self.followLabel = followCount;
    self.followedLabel = followedCount;
    self.goldLabel = goldCount;
    self.charmLabel = charmCount;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.dataView && !self.isFirst) {
        [self httpForRefresh];
    }else{
        if(!self.isFirst){
        [self httpForLiveList];
        }
    }
    self.isFirst = NO;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
            viewH = 72.5;
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
            return self.goldView;
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
    [grayCell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -49 -5) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = YES;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}
- (void)pushToSetting{
    [self.navigationController pushViewController:[[LIMSettingViewController alloc]init] animated:YES];
}
- (void)pushToEdit{
    LIMEditViewController *editVC = [[LIMEditViewController alloc]init];
    editVC.personalModel = self.personalModel;
    [self.navigationController pushViewController:editVC animated:YES];
}
- (void)allBtnViewClick:(UIGestureRecognizer *)tap{
    NSLog(@"viewtag = %ld",tap.view.tag);
    
    NSInteger viewTag = tap.view.tag -1000;
    switch (viewTag) {
        case 0:
        {
            
            LIMFollowViewController *followVC = [[LIMFollowViewController alloc]init];
            followVC.touid = self.personalModel.uid;
            [self.navigationController pushViewController:followVC animated:YES];
            break;
        }
        case 1:{
            
            LIMFollowedViewController *followedVC = [[LIMFollowedViewController alloc]init];
            followedVC.touid = self.personalModel.uid;
            [self.navigationController pushViewController:followedVC animated:YES];
            break;
        }
            
        case 2:
        {
            
            LIMGoldViewController *goldVC = [[LIMGoldViewController alloc]init];
            goldVC.touid = self.goldLabel.text;
            [self.navigationController pushViewController:goldVC animated:YES];
        }
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
        case 6:{
            LIMContributeViewController *contriVC = [[LIMContributeViewController alloc]init];
            contriVC.touid = self.personalModel.uid;
            [self.navigationController pushViewController:contriVC animated:YES];
            break;
        }
        case 7:
//            [self.navigationController pushViewController:[[LIMShareViewController alloc]init] animated:YES];
            [self httpForShare];
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
    }
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mPresonal_Info method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict =responseObject[@"result"];
            self.personalModel = [LIMPersonalModel mj_objectWithKeyValues:dict];
            userModel.iscompere = self.personalModel.iscompere;
            userModel.userlevel = self.personalModel.userlevel;
            userModel.cumoney = self.personalModel.cumoney;
            userModel.score = self.personalModel.score;
            [userModel saveAllInfo];
            self.tableView.tableHeaderView = [self imageArrayView];
            [self setUI];
            
            NSMutableArray *coverList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *adDict in self.personalModel.coverlist) {
                [coverList addObject:adDict[@"cover"]];
            }
            _cycleScrollView2.imageURLStringsGroup  = coverList;
            userModel.cover = coverList[0];
            [userModel saveAllInfo];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
//            [self showAlertWithMessage:resmsg];
            if ([resmsg isEqualToString:@"登录失效"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"requestReLogin" object:nil];
            }

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
- (void)httpForRefresh{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];    [[HttpClient defaultClient] requestWithPath:mPresonal_Info method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict =responseObject[@"result"];
            self.personalModel = [LIMPersonalModel mj_objectWithKeyValues:dict];
            userModel.iscompere = self.personalModel.iscompere;
            userModel.userlevel = self.personalModel.userlevel;
            userModel.cumoney = self.personalModel.cumoney;
            userModel.score = self.personalModel.score;
            [userModel saveAllInfo];
            
            NSLog(@"%@",userModel.userlevel);
            
            self.nameLabel.text = self.personalModel.nickname;
            self.signLabel.text = self.personalModel.personsign;
            self.followLabel.text = self.personalModel.followcount;
            self.followedLabel.text = self.personalModel.fanscount;
            self.goldLabel.text = self.personalModel.cumoney;
            self.charmLabel.text = self.personalModel.score;
            
            NSLog(@"golf %@ ,, level %@",self.personalModel.cumoney,self.personalModel.userlevel);
            
            if ([self.personalModel.iscompere isEqualToString:@"1"]) {
                self.mainImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"upbig_%d",[userModel.userlevel intValue]]];
                self.wordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"upword_%d",[userModel.userlevel intValue]]];
            }else{
                self.mainImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_%d",[userModel.userlevel intValue]]];
                
                self.wordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"word_%d",[userModel.userlevel intValue]]];
                
                NSLog(@"%@",[NSString stringWithFormat:@"word_%d",[userModel.userlevel intValue]]);
            }
//            self.wordImageView.image = [UIImage imageNamed:@"word_1"];
            NSMutableArray *coverList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *adDict in self.personalModel.coverlist) {
                [coverList addObject:adDict[@"cover"]];
            }
            _cycleScrollView2.imageURLStringsGroup  = coverList;
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
//            [self showAlertWithMessage:resmsg];
            if ([resmsg isEqualToString:@"登录失效"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"requestReLogin" object:nil];
            }

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)httpForShare{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mGetConf method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSString *shareUrl =responseObject[@"result"][@"ewmshareurl"];
            LIMShareView *shareView = [[LIMShareView alloc]init];
            shareView.ewmshareurl = shareUrl;
            shareView.coverUrl = _cycleScrollView2.imageURLStringsGroup[0];
            [shareView setUI];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
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
