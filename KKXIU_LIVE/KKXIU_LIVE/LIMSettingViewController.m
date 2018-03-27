//
//  LIMSettingViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMSettingViewController.h"
#import "CcUserModel.h"
#import "LIMLoginViewController.h"
#import "YYNavigationController.h"
#import <UIImageView+WebCache.h>
#import "HttpClient.h"
#import "LIMAboutUsViewController.h"
#import "LIMProblemViewController.h"
#import "YYFeedbackViewController.h"
#import "LIMMsgSettingViewController.h"
@interface LIMSettingViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;



@property(nonatomic, strong) NSString *agreementurl;
@property(nonatomic, strong) NSString *aboutusurl;
@property(nonatomic, strong) NSString *problemurl;

@end

@implementation LIMSettingViewController


- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
//        [_tableView registerClass:[YYPInfomationTableViewCell class] forCellReuseIdentifier:@"YYPInfomationTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpForShare];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"消息设置",@"清理缓存"],@[@"关于我们",@"常见问题",@"意见反馈"],@[@"退出"]]];
//    self.iconList =@[@[@"18511694068",@"男",@"布依族",@"24"],@[@"黑龙江哈尔滨",@"程序员",@"未婚"],@[@"2016-10-23"]];
    
    
    [self tableView];
    UIButton *sureBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.cornerRadius = 1.5 *kiphone6;
    sureBtn.layer.borderWidth = 0.5 *kiphone6;
    sureBtn.layer.borderColor = [UIColor colorWithHexString:@"e00610"].CGColor;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"e00610"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //     [sureBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [sureBtn addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LIMMsgSettingViewController *aboutVC = [[LIMMsgSettingViewController alloc]init];
//            aboutVC.aboutusurl = self.aboutusurl;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }else if(indexPath.row == 1){
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [[SDImageCache sharedImageCache] clearMemory];//可不写
            
            [self showAlertWithMessage:@"缓存清理完成"];
        }else if(indexPath.row == 2){

        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            LIMAboutUsViewController *aboutVC = [[LIMAboutUsViewController alloc]init];
            aboutVC.aboutusurl = self.aboutusurl;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }else if(indexPath.row == 1){
            LIMProblemViewController *pronblemVC = [[LIMProblemViewController alloc]init];
            pronblemVC.problemurl = self.problemurl;
            [self.navigationController pushViewController:pronblemVC animated:YES];
        }else if(indexPath.row == 2){
            YYFeedbackViewController *feedback = [[YYFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedback animated:YES];
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你确定退出吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            CcUserModel *userModel = [CcUserModel defaultClient];
            [userModel removeUserInfo];//清除本地存储
            [CcUserModel defaultClient];//清除缓存
            LIMLoginViewController *logVC = [[LIMLoginViewController alloc]init];
            YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:logVC];
            [self presentViewController:navigationVc animated:true completion:nil];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *section_row = self.dataSource[section];
    return section_row.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40 *kiphone6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10 *kiphone6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    //    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
    
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
            self.aboutusurl =responseObject[@"result"][@"aboutusurl"];
            self.problemurl =responseObject[@"result"][@"problemurl"];
            self.agreementurl =responseObject[@"result"][@"agreementurl"];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end

