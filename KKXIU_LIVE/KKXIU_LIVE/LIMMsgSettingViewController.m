//
//  LIMMsgSettingViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/12/1.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMMsgSettingViewController.h"

@interface LIMMsgSettingViewController ()

@end

@implementation LIMMsgSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.title = @"消息设置";
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI{
    // 接收/// 白
    UIView *noficSetting = [[UIView alloc]init];
    noficSetting.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noficSetting];
    [noficSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(20);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(44);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.text = @"接收新消息通知";
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.textColor = [UIColor blackColor];
    [noficSetting addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noficSetting).offset(8);
        make.centerY.equalTo(noficSetting);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
    }];
    
    
    NSString *kaiguan;
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        kaiguan = @"已开启";
    }else{
        kaiguan = @"已关闭";
    }
    UILabel *kaiguanLabel = [[UILabel alloc]init];
    kaiguanLabel.text = kaiguan;
    kaiguanLabel.font = [UIFont systemFontOfSize:15];
    kaiguanLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
    kaiguanLabel.textAlignment = NSTextAlignmentRight;
    [noficSetting addSubview:kaiguanLabel];
    [kaiguanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(noficSetting.mas_right).offset(-8);
        make.centerY.equalTo(noficSetting);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
    }];
    

    
    // 提示
    UILabel *premptLabel = [[UILabel alloc]init];
    premptLabel.text = @"请在iPhone的“设置”-“通知”中修改";
    premptLabel.font = [UIFont systemFontOfSize:15];
    premptLabel.textColor = [UIColor grayColor];
    [self.view addSubview:premptLabel];
    [premptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noficSetting).offset(8);
        make.top.equalTo(noficSetting.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(15);
    }];
    
    // 消息免打扰 //白
    UIView *noficSetting2 = [[UIView alloc]init];
    noficSetting2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noficSetting2];
    [noficSetting2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(110);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(60);
    }];

    
    
    UILabel *titleLabel2 = [[UILabel alloc]init];
    titleLabel2.text = @"消息免打扰";
    titleLabel2.font = [UIFont systemFontOfSize:15];
    titleLabel2.textColor = [UIColor blackColor];
    [noficSetting2 addSubview:titleLabel2];
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noficSetting2).offset(8);
        make.centerY.equalTo(noficSetting2);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
    }];
    
    // 提示
    UILabel *premptLabel2 = [[UILabel alloc]init];
    premptLabel2.text = @"晚上11点至早睡9点不会收到消息";
    premptLabel2.font = [UIFont systemFontOfSize:15];
    premptLabel2.textColor = [UIColor grayColor];
    [self.view addSubview:premptLabel2];
    [premptLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noficSetting2).offset(8);
        make.top.equalTo(noficSetting2.mas_bottom).offset(5);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(15);
    }];
    
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    UISwitch *mySwitch = [[UISwitch alloc]init];
//    mySwitch.frame=CGRectMake(100, 200, 180, 40);
    if ([userModel.noNight isEqualToString:@"1"]) {
        mySwitch.on = YES;
    }else{
        mySwitch.on = NO;
    }
    
    [self.view addSubview:mySwitch];
    [mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    [mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(noficSetting2.mas_right).offset(-18);
        make.centerY.equalTo(noficSetting2);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(20);
    }];
    
    
}
- (void) swChange:(UISwitch*) sw{
    CcUserModel *userModel = [CcUserModel defaultClient];
    if(sw.on == YES){
        userModel.noNight = @"1";
        NSLog(@"开关被打开");
        
        [userModel saveAllInfo];
    }else{
        userModel.noNight = @"0";
        NSLog(@"开关被关闭");
        [userModel saveAllInfo];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
