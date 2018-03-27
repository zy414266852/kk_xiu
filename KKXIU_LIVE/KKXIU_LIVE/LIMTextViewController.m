//
//  LIMTextViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/7.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMTextViewController.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "MJRefresh.h"
#import <MJExtension.h>
#import "UIBarButtonItem+Helper.h"

@interface LIMTextViewController ()
@property (nonatomic, strong)UITextView *textView;

@end

@implementation LIMTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    
    
    UITextView *textView = [[UITextView alloc]init];
    textView.text = self.valueStr;
    textView.textColor = [UIColor colorWithHexString:@"000000"];
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.cornerRadius = 5;
    textView.clipsToBounds = YES;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(kScreenW -30,80));
    }];
    self.textView = textView;
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"提交" selectTitle:@"提交" target:self action:@selector(sureLogin)];
//    //sure Btn
//    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.backgroundColor = kColor_Default;
//    sureBtn.layer.cornerRadius = 37/2.0;
//    sureBtn.clipsToBounds = YES;
//    [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
//    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [sureBtn addTarget:self action:@selector(sureLogin) forControlEvents:UIControlEventTouchUpInside];
//    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:sureBtn];
//    
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-18.5);
//        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(280);
//        make.height.mas_equalTo(37);
//    }];


    
    // Do any additional setup after loading the view.
}
- (void)sureSubmit{
    NSLog(@"text  text = %@",self.textView.text);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sureLogin{
    
    
    if ([_titleStr isEqualToString:@"昵称"]) {
        self.personalModel.nickname = self.textView.text;
    }else if ([_titleStr isEqualToString:@"个性签名"]){
        self.personalModel.personsign = self.textView.text;
    }else{
        
    }
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    NSDictionary *dict100;
    if (self.personalModel.birthday == nil) {
//        self.personalModel.birthday = @"";
        dict100  = @{@"nickname":self.personalModel.nickname,@"age":self.personalModel.age,@"star":self.personalModel.star,@"updateprovince":self.personalModel.province,@"updatecity":self.personalModel.city,@"personsign":self.personalModel.personsign};
    }else{
        dict100  = @{@"nickname":self.personalModel.nickname,@"age":self.personalModel.age,@"star":self.personalModel.star,@"birthday":self.personalModel.birthday,@"updateprovince":self.personalModel.province,@"updatecity":self.personalModel.city,@"personsign":self.personalModel.personsign};
    }
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    //    NSMutableArray *valueArr = [[NSMutableArray alloc]initWithCapacity:2];
    //    for (int i = 0 ; i<8;  i++) {
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    //        LIMEditTableViewCell *cell = (LIMEditTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //        [valueArr addObject:cell.infoLabel.text];
    //    }
    
    
    
    
    
    NSLog(@"%@",paraDict);
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:dict100]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mSaveUserInfo method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            
            self.backInfo(self.textView.text);
//            [self showAlertWithMessage:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];

            
            
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
