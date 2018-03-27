//
//  LIMSearchViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/4.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMSearchViewController.h"
#import "LIMFollowTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "LIMSearchTableViewCell.h"
#import "LIMOtherInfoViewController.h"

@interface LIMSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> //
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UITextField *mainText;



@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *promptImage;
@property (nonatomic, strong) UIImageView *promptLabel;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation LIMSearchViewController
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
    [self setUI];
    
    
    
    [self httpLiveFollowList];
    // Do any additional setup after loading the view.
}
- (void)setUI{
    UIView *topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBackView];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"757575"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView).offset(32);
        make.right.equalTo(topBackView).offset(-21.5 *kiphone6);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = @"";
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.cornerRadius = 15;
    textField.clipsToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    textField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    textField.adjustsFontSizeToFitWidth = YES;
    textField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [textField setValue:[NSNumber numberWithInt:25] forKey:@"paddingLeft"];
    textField.returnKeyType = UIReturnKeySearch;
    [topBackView addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelBtn.mas_centerY).offset(0);
        make.left.equalTo(topBackView).offset(11);
        make.right.equalTo(cancelBtn.mas_left).offset(-11);
        make.height.mas_equalTo(30);
    }];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Search_图层-2"]];
    [imageV sizeToFit];
    [textField addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textField.mas_centerY).offset(0);
        make.left.equalTo(textField).offset(7);
    }];
    imageV.hidden = YES;
    self.mainText = textField;
    
    
    
    
    
    NSString *string = @"请输入要搜索的用户昵称或ID";
    
    CGFloat buttonW = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    
    
    CGFloat leftPadding = (kScreenW - 40 - 22 - 21.5 - 11.5 - buttonW -7)/2.0;
    NSLog(@"%g  ... %g",buttonW,leftPadding);
    UIImageView *imageV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Search_图层-2"]];
    [textField addSubview:imageV2];
    [imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textField.mas_centerY).offset(0);
        make.left.equalTo(textField).offset(leftPadding);
        make.size.mas_equalTo(CGSizeMake(11.5, 11.5));
    }];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.text = string;
    textLabel.textColor = [UIColor colorWithHexString:@"8b8b90"];
    [textField addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(textField.mas_centerY).offset(0);
        make.left.equalTo(imageV2.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(buttonW +1, 16));
        
    }];
    
    self.promptLabel = textLabel;
    self.promptImage = imageV2;
    self.leftView = imageV;
    
    
    
    
    
    UILabel *backLabel = [[UILabel alloc]init];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.24].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
    gradientLayer.locations = @[@0 ,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0 , kScreenW, 5);
    [backLabel.layer addSublayer:gradientLayer];
    backLabel.frame = CGRectMake(0, 63, kScreenW, 2);
    [topBackView addSubview:backLabel];
    
}
- (void)cancelClick{
    
    [self.mainText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;{
    self.promptImage.hidden = YES;
    self.promptLabel.hidden = YES;
    self.leftView.hidden = NO;
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.promptImage.hidden = NO;
        self.promptLabel.hidden = NO;
        self.leftView.hidden = YES;
    }
}



- (void)creteTableView{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW,kScreenH -64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.000001)];
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.000001)];
    [tableView registerClass:[LIMSearchTableViewCell class] forCellReuseIdentifier:@"LIMSearchTableViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return 0;
    }
    return 41;
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
        hotLiveCell.followImageV.hidden = NO;
        hotLiveCell.followedLabel.hidden = YES;
    }else if ([followModel.isfollow  isEqualToString:@"1"]){
//        [hotLiveCell followSuccess];
        hotLiveCell.followImageV.hidden = YES;
        hotLiveCell.followedLabel.hidden = NO;
    }else{

    }
    hotLiveCell.followClick =^(NSString *test){
        [self followOther:indexPath.row];
    };
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return nil;
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 41)];
//    headView.backgroundColor = [UIColor cyanColor];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"猜你喜欢";
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    titleLabel.font = [UIFont  systemFontOfSize:16];
    [headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(19);
        make.left.equalTo(headView).offset(15.5);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    return headView;
}

// 猜你喜欢列表
- (void)httpLiveFollowList{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":userModel.uid,@"pageindex":@"1",@"pagesize":@"20"}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mLike_guess method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            NSArray *daylist = dict[@"userlist"];
            for (NSDictionary *dict2 in daylist) {
                LIMFollowModel *liveModel = [LIMFollowModel mj_objectWithKeyValues:dict2];
                [self.dataSource addObject:liveModel];
            }
            [self creteTableView];
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


// 关注他人
- (void)followOther:(NSInteger)indexPath{
    
    LIMFollowModel *followModel = self.dataSource[indexPath];
    
    NSString *touid = followModel.uid;
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mFollow_other method:1 parameters:paraDict prepareExecute:^{
        
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
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"keyword":self.mainText.text}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    
    
    NSLog(@"%@",paraDict);
    
    [[HttpClient defaultClient] requestWithPath:mSearch method:1 parameters:paraDict prepareExecute:^{
        
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
            [self creteTableView];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self httpSearch];
    [textField resignFirstResponder];
    return YES;
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
