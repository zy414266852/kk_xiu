//
//  LIMCharmView.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMCharmView.h"
#import "YYTabBarItem.h"
#import "LIMSegment.h"
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

@interface LIMCharmView()<LIMSegmentDelegate,LIMPageViewDataSource,LIMPageViewDelegate, UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕
@property(nonatomic, strong) LIMSegment *segment;
@property(nonatomic, strong) LIMPageView *pageView;


@property (nonatomic, strong) NSMutableArray *dayDataSource;
@property (nonatomic, strong) NSMutableArray *allDataSource;

@end


@implementation LIMCharmView
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

- (instancetype)initWithTouid:(NSString *)touid
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:singleTap];
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.windowLevel       = UIWindowLevelStatusBar;
        _actionWindow.backgroundColor   = [UIColor clearColor];
        _actionWindow.hidden = NO;
        self.actionWindow.userInteractionEnabled = YES;
        [self.actionWindow addSubview:self];
        [self setUI];
        self.touid = touid;
        NSLog(@"%@",self.touid);
        [self httpLiveCharmList];
    }
    return self;
}
- (void)setUI{
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.top.equalTo(self).offset(kScreenH - 364.5*kiphone6);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(364.5 *kiphone6);
    }];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [bigView addGestureRecognizer:singleTap];

    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"魅力贡献榜";
    titleLabel.textColor = [UIColor colorWithHexString:@"ff4ba9"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [bigView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bigView).offset(0);
                make.top.equalTo(bigView).offset(7.5);
                make.width.equalTo(bigView.mas_width);
                make.height.mas_equalTo(17 );
            }];

    
    
    
    _segment = [[LIMSegment alloc] initWithFrame:CGRectMake((kScreenW - 62)/4.0, 35, kScreenW, 27)];
    [_segment updateChannels:@[@"日榜",@"总榜"]];
    _segment.delegate = self;
    [_segment didChengeToIndex:0];
    [bigView addSubview:_segment];
    
    
    _pageView =[[LIMPageView alloc] initWithFrame:CGRectMake(0, 63, kScreenW,364.5 -63)];
    _pageView.datasource = self;
    _pageView.delegate = self;
    _pageView.backgroundColor = [UIColor clearColor];
    [_pageView reloadData];
    [_pageView changeToItemAtIndex:0];
    [bigView addSubview:_pageView];
    
    
}
- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self setAlpha:0];
                         [self setUserInteractionEnabled:NO];
                         
                         //                         CGRect frame = _mainView.frame;
                         //                         frame.origin.y += frame.size.height;
                         //                         [_mainView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _actionWindow.hidden = YES;
                         [self removeFromSuperview];
                         //                         self.isShow = NO;
                     }];
}
- (void)followUser{
    NSLog(@"关注");
}
- (void)pushOtherView{
    NSLog(@"push push  push");
}
- (void)emptyClick{
    
}
#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInLIMPageView:(LIMPageView *)pageView{
    return 4;
}

-(UIView*)pageView:(LIMPageView *)pageView viewAtIndex:(NSInteger)index{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,364.5 -63) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.tag = 200 +index;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    LIMLiveViewController *liveVC = [[LIMLiveViewController alloc]init];
//    
//    LIMLiveListModel *liveModel = self.dataSource[indexPath.row];
//    liveVC.liveuid = liveModel.uid;
//    liveVC.roomid  = liveModel.roomid;
//    [self presentViewController:liveVC animated:YES completion:^{
//        
//    }];
//}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 200) {
        return self.dayDataSource.count;
    }else{
        return self.allDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMContributeTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMContributeTableViewCell" forIndexPath:indexPath];
    LIMRankModel *rankModel;
    if (tableView.tag == 200) {
        rankModel = self.dayDataSource[indexPath.row];
    }else{
        rankModel = self.allDataSource[indexPath.row];
    }
    [hotLiveCell setrankDataSource:rankModel];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
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
////弹出alert
//-(void)showAlertWithMessage:(NSString*)message{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//    //            [alert addAction:cancelAction];
//    [alert addAction:okAction];
//    [self presentViewController:alert animated:YES completion:nil];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
