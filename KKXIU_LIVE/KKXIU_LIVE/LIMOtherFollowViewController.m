//
//  LIMOtherFollowViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/4.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMOtherFollowViewController.h"
#import "LIMFollowTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "LIMSearchTableViewCell.h"
#import "LIMOtherInfoViewController.h"


@interface LIMOtherFollowViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> //
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UITextField *mainText;



@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *promptImage;
@property (nonatomic, strong) UIImageView *promptLabel;
@property (nonatomic, assign) BOOL isSearch;


@end

@implementation LIMOtherFollowViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isSearch = NO;
    if (self.isFollow) {
        self.title = @"他的关注";
    }else{
        self.title = @"他的粉丝";
    }

    [self creteTableView];
    
    [self httpSearch];
    
    
    // Do any additional setup after loading the view.
}
- (void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)creteTableView{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH -64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc]init];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMSearchTableViewCell class] forCellReuseIdentifier:@"LIMSearchTableViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMFollowModel *followModel = self.dataSource[indexPath.row];
    LIMOtherInfoViewController *otherV = [[LIMOtherInfoViewController alloc]init];
    otherV.touid = followModel.uid;
    [self.navigationController pushViewController:otherV animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMFollowModel *followModel = self.dataSource[indexPath.row];
    LIMSearchTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMSearchTableViewCell" forIndexPath:indexPath];
    [hotLiveCell setrankDataSource:followModel];
    if ([followModel.isfollow  isEqualToString:@"0"]) {
        
    }else if ([followModel.isfollow  isEqualToString:@"1"]){
        [hotLiveCell followSuccess];
    }else{
        [hotLiveCell followSelf];
    }
    hotLiveCell.followClick =^(NSString *test){
        [self followOther:indexPath.row];
    };
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
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


// 关注他人
- (void)followOther:(NSInteger)indexPath{
    
    NSString *urlStr;
    if (self.isFollow) {
        urlStr = mFollow_delete;
    }else{
        urlStr = mFans_delete;
    }
    
    LIMFollowModel *followModel = self.dataSource[indexPath];
    
    NSString *touid = followModel.uid;
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:urlStr method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath inSection:0];
            LIMSearchTableViewCell * followCell = [self.tableView cellForRowAtIndexPath:indexPath2];
            [followCell followSuccess];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 直播获取用户列表
- (void)httpSearch{
    
    NSString *urlStr;
    if (self.isFollow) {
        urlStr = mFollow_List;
    }else{
        urlStr = mFans_List;
    }
    
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":self.touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    NSLog(@"%@",paraDict);
    
    [[HttpClient defaultClient] requestWithPath:urlStr method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        self.isSearch = YES;
        [self.dataSource removeAllObjects];
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *daylist = dict[@"userlist"];
            for (NSDictionary *dict2 in daylist) {
                LIMFollowModel *liveModel = [LIMFollowModel mj_objectWithKeyValues:dict2];
                [self.dataSource addObject:liveModel];
            }
            [self.tableView reloadData];
//            [self creteTableView];
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
