//
//  LIMCharmViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMCharmViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMIncomeDetailViewController.h"
#import "LIMAuthViewController.h"
#import "LIMBingPhoneViewController.h"

@interface LIMCharmViewController ()
@property (nonatomic ,strong) NSDictionary *mainDict;
@property (nonatomic ,strong) UILabel *payText;
@property (nonatomic ,strong) UILabel *num_giftMoneyText;
@property (nonatomic ,strong) UILabel *num_goodMoneyText;
@end

@implementation LIMCharmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的收益";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"明细" selectTitle:@"明细" target:self action:@selector(pushToRecard)];
    
    
    [self httpLiveUserLevel];
//    [self setUI];
    
    // Do any additional setup after loading the view.
}
- (void)setUI{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 98, kScreenW, 104)];
    imageV.image = [UIImage imageNamed:@"charm_图层-1"];
    [self.view addSubview:imageV];
    
    UILabel *payText = [[UILabel alloc]init];
    NSString *incomeStr = self.mainDict[@"income"];
    payText.text = [NSString stringWithFormat:@"%.2lf",[incomeStr floatValue]];
    payText.font = [UIFont systemFontOfSize:26];
    payText.textColor = [UIColor colorWithHexString:@"fada1b"];
    payText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:payText];
    [payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(49.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 26));
    }];
    
    
    UILabel *promptText = [[UILabel alloc]init];
    promptText.text = @"可提现(元)";
    promptText.font = [UIFont systemFontOfSize:14];
    promptText.textColor = [UIColor colorWithHexString:@"3e3e3e"];
    promptText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:promptText];
    [promptText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(payText.mas_bottom).offset(23);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14));
    }];
    
    
    
    UIView *giftMoneyView = [[UIView alloc]init];
    [self.view addSubview:giftMoneyView];
    [giftMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(imageV.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 73));
    }];
    UILabel *giftMoneyText = [[UILabel alloc]init];
    giftMoneyText.text = @"礼物收益(元)";
    giftMoneyText.font = [UIFont systemFontOfSize:11];
    giftMoneyText.textColor = [UIColor colorWithHexString:@"3e3e3e"];
    giftMoneyText.textAlignment = NSTextAlignmentCenter;
    [giftMoneyView addSubview:giftMoneyText];
    [giftMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(giftMoneyView).offset(0);
        make.top.equalTo(giftMoneyView).offset(40.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 11));
    }];
    
    UILabel *num_giftMoneyText = [[UILabel alloc]init];
    NSString *giftincomeStr = self.mainDict[@"giftincome"];
    num_giftMoneyText.text = [NSString stringWithFormat:@"%.2lf",[giftincomeStr floatValue]];
//    num_giftMoneyText.text = @"0.00";
    num_giftMoneyText.font = [UIFont systemFontOfSize:16];
    num_giftMoneyText.textColor = [UIColor colorWithHexString:@"ff309b"];
    num_giftMoneyText.textAlignment = NSTextAlignmentCenter;
    [giftMoneyView addSubview:num_giftMoneyText];
    [num_giftMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(giftMoneyView).offset(0);
        make.top.equalTo(giftMoneyText.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 16));
    }];
    
    
    
    
    UIView *goodMoneyView = [[UIView alloc]init];
    [self.view addSubview:goodMoneyView];
    [goodMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kScreenW/2.0);
        make.top.equalTo(imageV.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 73));
    }];
    UILabel *goodMoneyText = [[UILabel alloc]init];
    goodMoneyText.text = @"优秀奖励(元)";
    goodMoneyText.font = [UIFont systemFontOfSize:11];
    goodMoneyText.textColor = [UIColor colorWithHexString:@"3e3e3e"];
    goodMoneyText.textAlignment = NSTextAlignmentCenter;
    [goodMoneyView addSubview:goodMoneyText];
    [goodMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goodMoneyView).offset(0);
        make.top.equalTo(goodMoneyView).offset(40.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 11));
    }];

    
    UILabel *num_goodMoneyText = [[UILabel alloc]init];
    num_goodMoneyText.text = @"0.00";
    NSString *roomincomeStr = self.mainDict[@"roomincome"];
    num_goodMoneyText.text = [NSString stringWithFormat:@"%.2lf",[roomincomeStr floatValue]];
    num_goodMoneyText.font = [UIFont systemFontOfSize:16];
    num_goodMoneyText.textColor = [UIColor colorWithHexString:@"ff309b"];
    num_goodMoneyText.textAlignment = NSTextAlignmentCenter;
    [goodMoneyView addSubview:num_goodMoneyText];
    [num_goodMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goodMoneyView).offset(0);
        make.top.equalTo(goodMoneyText.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 16));
    }];



    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kColor_Default;
    sureBtn.layer.cornerRadius = 37/2.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"领取收益" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(httpPopIncome) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"5f2f01"] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-91);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(375 -148);
        make.height.mas_equalTo(37);
    }];
    
    
    self.payText = payText;
    self.num_giftMoneyText = num_giftMoneyText;
    self.num_goodMoneyText = num_goodMoneyText;
    

    
}
- (void)getMoney{
    
}
- (void)pushToRecard{
    LIMIncomeDetailViewController *incomeVC = [[LIMIncomeDetailViewController alloc]init];
    [self.navigationController pushViewController:incomeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


// money
- (void)httpLiveUserLevel{
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mGetUserIncome method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            self.mainDict = responseObject[@"result"];
            [self setUI];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// money
- (void)httpLiveRefresh{
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mGetUserIncome method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            self.mainDict = responseObject[@"result"];
//            [self setUI];
            NSString *incomeStr = self.mainDict[@"income"];
            self.payText.text = [NSString stringWithFormat:@".2%lf",[incomeStr floatValue]];
            NSString *giftincomeStr = self.mainDict[@"giftincome"];
            self.num_giftMoneyText.text = [NSString stringWithFormat:@".2%lf",[giftincomeStr floatValue]];
            NSString *roomincomeStr = self.mainDict[@"roomincome"];
            self.num_goodMoneyText.text = [NSString stringWithFormat:@"%.2lf",[roomincomeStr floatValue]];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:@"刷新数据失败"];
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

// 魅力列表
- (void)httpPopIncome{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mPopIncome method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            [self showAlertWithMessage:@"提现成功"];
            
        }else if ([rescode isEqualToString:@"-4"]) {
            [self showAlertWithBing];
        }else if ([rescode isEqualToString:@"-5"]) {
            [self showAlertWithfun];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
//弹出alert
-(void)showAlertWithfun{
    //    [self offThisView];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"实名认证，GO？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不去" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[LIMAuthViewController alloc]init] animated:YES];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//弹出alert
-(void)showAlertWithBing{
    //    [self offThisView];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"绑定手机，GO？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不去" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[LIMBingPhoneViewController alloc]init] animated:YES];
    }];
    [alert addAction:cancelAction];
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
