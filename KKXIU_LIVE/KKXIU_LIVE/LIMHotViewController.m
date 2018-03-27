//
//  LIMHotViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/10.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMHotViewController.h"
#import "LIMHotTableViewCell.h"
#import <SDCycleScrollView.h>
#import "HttpClient.h"
#import <MJExtension.h>
#import "LIMLiveListModel.h"
#import "LIMLiveViewController.h"
#import "MJRefresh.h"

@interface LIMHotViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) NSArray *adlist;

@end

@implementation LIMHotViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -49 -5) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpForLiveList)];
        
        [_tableView registerClass:[LIMHotTableViewCell class] forCellReuseIdentifier:@"LIMHotTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        _tableView.tableHeaderView = [self bannerInfomation];
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpForLiveList)];
//    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 64;
    [self httpForLiveList];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 439;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LIMLiveViewController *liveVC = [[LIMLiveViewController alloc]init];
    LIMLiveListModel *liveModel = self.dataSource[indexPath.row];
    liveVC.liveuid = liveModel.uid;
    liveVC.roomid  = liveModel.roomid;
    liveVC.coverUrl = liveModel.cover;
    [self presentViewController:liveVC animated:YES completion:^{
        
    }];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count != 0) {
        return self.dataSource.count;
    }else{
        return self.dataSource.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMHotTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMHotTableViewCell" forIndexPath:indexPath];
//    if (self.dataSource.count >0) {
            LIMLiveListModel *liveModel = self.dataSource[indexPath.row];
            [hotLiveCell setDataSource:liveModel];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}
    
- (UIView *)bannerInfomation{
    
    // 图片轮播器
    SDCycleScrollView *cycleScrollView2 = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 116)];
//    cycleScrollView2.backgroundColor = [UIColor cyanColor];
    cycleScrollView2.showPageControl = YES;
    cycleScrollView2.delegate = self;
//    cycleScrollView2.imageURLStringsGroup  = @[@"",@""];
    cycleScrollView2.localizationImageNamesGroup = @[@"home_banner代替图",@"home_banner代替图"];
    
    self.cycleScrollView2 = cycleScrollView2;
    return cycleScrollView2;
}

- (void)httpForLiveList{
//    if (self.dataSource.count >0) {
//        [self.tableView.mj_header beginRefreshing];
//    }
   
    WS(ws);
    
    // 首页直播列表
//    NSDictionary *paraDict = @{
//                               mAllPara,
//                               @"pageindex":@"1",
//                               @"pagesize":@"20"
//                               };
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                     }];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{
                                                                       @"pageindex":@"1",
                                                                       @"pagesize":@"20"
                                                                       }]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    
    [[HttpClient defaultClient] requestWithPath:mHot_Home method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
             [self.dataSource removeAllObjects];
            [ws.tableView.mj_header endRefreshing];
            NSArray *liveList = responseObject[@"result"][@"userlist"];
            self.adlist = responseObject[@"result"][@"adlist"];
            NSMutableArray * bannerList = [[NSMutableArray alloc]initWithCapacity:2];
                for (NSDictionary *dict in liveList) {
                LIMLiveListModel *liveModel = [LIMLiveListModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:liveModel];
                
            }
            [self.tableView reloadData];
            for (NSDictionary *adDict in self.adlist) {
                [bannerList addObject:adDict[@"imgurl"]];
            }
            _cycleScrollView2.imageURLStringsGroup  = bannerList;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
