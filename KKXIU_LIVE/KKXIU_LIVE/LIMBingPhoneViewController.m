//
//  LIMBingPhoneViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMBingPhoneViewController.h"
#import "HttpClient.h"
#import <MJExtension.h>
#import "CcUserModel.h"

@interface LIMBingPhoneViewController ()
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *prefixLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *vcodeTF;
@end
@implementation LIMBingPhoneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"绑定手机";
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(offKeyBoard)];
    [self.view addGestureRecognizer:tapGest];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}
- (void)setupUI{
    
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"绑定手机不会产生任何通信费用";
    promptLabel.font = [UIFont systemFontOfSize:10];
    promptLabel.textColor = [UIColor colorWithHexString:@"595959"];
    [self.view addSubview:promptLabel];
    
    CGFloat labelW = [promptLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:promptLabel.font} context:nil].size.width;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(12);
        make.width.mas_equalTo(labelW +10);
        make.height.mas_equalTo(10);
    }];

    
    
    // 分割线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"c5c5c7"];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(48 +40);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"c5c5c7"];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(48 *2 +40);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *line3 = [[UILabel alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"c5c5c7"];
    [self.view addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(48 *3 +40);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    //sure Btn
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kColor_Default;
    sureBtn.layer.cornerRadius = 37/2.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"绑  定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn addTarget:self action:@selector(sureLogin) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3).offset(108);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(37);
    }];
    
    // agreement Btn
    
//    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [agreementBtn setTitle:@"点击即同意《kk秀用户协议》" forState:UIControlStateNormal];
//    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    [agreementBtn setTitleColor:[UIColor colorWithHexString:@"767676"] forState:UIControlStateNormal];
//    [agreementBtn addTarget:self action:@selector(readAgreement) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:agreementBtn];
//    
//    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(sureBtn.mas_bottom).offset(30);
//        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(280);
//        make.height.mas_equalTo(11);
//    }];
//    
    
    
    // 国家 地区 city
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.backgroundColor = [UIColor clearColor];
    [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line.mas_top).offset(0);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(47);
    }];
    
    
    UILabel *citySelectLabel = [[UILabel alloc]init];
    citySelectLabel.text = @"国家与地区";
    citySelectLabel.font = [UIFont systemFontOfSize:14];
    citySelectLabel.textColor = kBlackColor_Default;
    [cityBtn addSubview:citySelectLabel];
    
    CGFloat buttonW = [citySelectLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:citySelectLabel.font} context:nil].size.width;
    [citySelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityBtn).offset(0);
        make.left.equalTo(cityBtn).offset(12);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(47);
    }];
    
    UIImageView *nextImageV = [[UIImageView alloc]init];
    nextImageV.image = [UIImage imageNamed:@"phonelogin_图层-1"];
    [nextImageV sizeToFit];
    [cityBtn addSubview:nextImageV];
    
    [nextImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityBtn).offset(0);
        make.right.equalTo(cityBtn).offset(-12);
    }];
    
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"中国";
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.textColor = kBlackColor_Default;
    cityLabel.textAlignment = NSTextAlignmentRight;
    [cityBtn addSubview:cityLabel];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityBtn).offset(0);
        make.right.equalTo(nextImageV.mas_left).offset(-5);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(47);
    }];
    
    // phone
    UIView *phoneView = [[UIView alloc]init];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line2.mas_top).offset(0);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(47);
    }];
    
    UILabel *prefixLabel = [[UILabel alloc]init];
    prefixLabel.text = @"+86";
    prefixLabel.font = [UIFont systemFontOfSize:14];
    prefixLabel.textColor = kBlackColor_Default;
    prefixLabel.textAlignment = NSTextAlignmentLeft;
    [phoneView addSubview:prefixLabel];
    
    [prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView).offset(0);
        make.left.equalTo(phoneView).offset(12);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(47);
    }];
    
    UITextField *phoneTF = [[UITextField alloc]init];
    phoneTF.textColor = kBlackColor_Default;
    phoneTF.font = [UIFont systemFontOfSize:12];
    phoneTF.placeholder = @"请输入您的手机号";
    [phoneView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView).offset(0);
        make.left.equalTo(prefixLabel.mas_right).offset(0);
        make.width.mas_equalTo(11 *12);
        make.height.mas_equalTo(47);
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = kColor_Default;
    sendBtn.layer.cornerRadius = 3;
    sendBtn.clipsToBounds = YES;
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendBtn setTitleColor:kBlackColor_Default forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendVcodeRequest:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneView).offset(0);
        make.right.equalTo(phoneView).offset(-17);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(24);
    }];
    
    
    // vcode
    UIView *vcodeView = [[UIView alloc]init];
    [self.view addSubview:vcodeView];
    [vcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line3.mas_top).offset(0);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(47);
    }];
    
    UILabel *vcodeLabel = [[UILabel alloc]init];
    vcodeLabel.text = @"验证码";
    vcodeLabel.font = [UIFont systemFontOfSize:14];
    vcodeLabel.textColor = kBlackColor_Default;
    vcodeLabel.textAlignment = NSTextAlignmentLeft;
    [vcodeView addSubview:vcodeLabel];
    
    [vcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vcodeView).offset(0);
        make.left.equalTo(vcodeView).offset(12);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(47);
    }];
    
    
    UITextField *vcodeTF = [[UITextField alloc]init];
    vcodeTF.textColor = kBlackColor_Default;
    vcodeTF.font = [UIFont systemFontOfSize:12];
    vcodeTF.placeholder = @"请输入验证码";
    [vcodeView addSubview:vcodeTF];
    [vcodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vcodeView).offset(0);
        make.left.equalTo(vcodeLabel.mas_right).offset(0);
        make.width.mas_equalTo(11 *12);
        make.height.mas_equalTo(47);
    }];
    
    _cityLabel = cityLabel;
    _prefixLabel = prefixLabel;
    _sendBtn = sendBtn;
    _phoneTF = phoneTF;
    _vcodeTF = vcodeTF;
    
    
}
- (void)sendVcodeRequest:(UIButton *)sender{
    if (![self valiMobile:_phoneTF.text]) {
        [self showAlertWithMessage:@"请确认电话号码是否输入正确"];
        return;
    }
    //发送获取验证码请求
    [[HttpClient defaultClient] requestWithPath:mVcode_Login method:1 parameters:@{@"os":@"ios",@"ver":@"1.0.0",@"encry":@"0",@"mobile":_phoneTF.text} prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            
            
            //倒计时时间
            __block NSInteger timeOut = 59;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            //每秒执行一次
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(_timer, ^{
                
                //倒计时结束，关闭
                if (timeOut <= 0) {
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setBackgroundColor:kColor_Default];
                        [sender setTitleColor:kBlackColor_Default forState:UIControlStateNormal];
                        [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = true;
                    });
                } else {
                    int allTime = 60;
                    int seconds = timeOut % allTime;
                    NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setBackgroundColor:[UIColor colorWithHexString:@"#c5c5c7"]];
                        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [sender setTitle: [NSString stringWithFormat:@"%@ S",timeStr] forState:UIControlStateNormal];
                        sender.userInteractionEnabled = false;
                    });
                    timeOut--;
                }
            });
            dispatch_resume(_timer);
            
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    
}
- (void)sureLogin{
    [self offKeyBoard];
    

    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"code":_vcodeTF.text,@"mobile":_phoneTF.text}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mBindMobile method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
//           [self showAlertWithMessage:@"绑定成功"];
            [self showAlertWithPopView];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)selectCity{
    
}
- (void)readAgreement{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
- (void)offKeyBoard{
    [_vcodeTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
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



//弹出alert
-(void)showAlertWithPopView{
    //    [self offThisView];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"绑定成功，返回继续😊" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
//    [alert addAction:cancelAction];
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

