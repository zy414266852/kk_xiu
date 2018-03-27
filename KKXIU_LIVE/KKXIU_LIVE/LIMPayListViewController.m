//
//  LIMPayListViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPayListViewController.h"
//#import "LIMFollowTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "UIBarButtonItem+Helper.h"
#import "LIMPayListTableViewCell.h"
#import "LIMPayListModle.h"

@interface LIMPayListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *kGoldArr;
@property (nonatomic, strong) NSArray *moneyArr;
@end
@implementation LIMPayListViewController


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"充值记录";
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"充值记录" selectTitle:@"充值记录" target:self action:@selector(pushToRecard)];
    
    self.kGoldArr = @[@"500 K币",@"1000 K币",@"10000 K币",@"50000 K币",@"100000 K币"];
    self.moneyArr = @[@"¥ 6",@"¥ 10",@"¥ 100",@"¥ 500",@"¥ 1000"];
    
    [self httpLiveCharmList];
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView{
    if (_tableView == nil) {
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH -64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.tableHeaderView = [self tableHeader];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMPayListTableViewCell class] forCellReuseIdentifier:@"LIMPayListTableViewCell"];
    [self.view addSubview:tableView];
    _tableView = tableView;
    }
    return _tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMPayListModle *model = self.dataSource[indexPath.row];
    LIMPayListTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMPayListTableViewCell" forIndexPath:indexPath];
    hotLiveCell.nameLabel.text = [NSString stringWithFormat:@"%@ K币",model.cumoney];
    hotLiveCell.moneyLabel.text = [NSString stringWithFormat:@"¥ %@",model.paymoney];
    hotLiveCell.timeLabel.text = model.paytime;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (void)pushToRecard{
    
}
- (void)httpLiveCharmList{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mPayList method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *daylist = dict[@"paylist"];
            for (NSDictionary *dict2 in daylist) {
                LIMPayListModle *liveModel = [LIMPayListModle mj_objectWithKeyValues:dict2];
                [self.dataSource addObject:liveModel];
            }
            [self.tableView reloadData];
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

