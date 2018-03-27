//
//  LIMGoldViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMGoldViewController.h"
#import "LIMFollowTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "UIBarButtonItem+Helper.h"
#import "LIMGoldTableViewCell.h"
#import "LIMPayListViewController.h"

#import<StoreKit/StoreKit.h>

@interface LIMGoldViewController ()<UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *kGoldArr;
@property (nonatomic, strong) NSArray *moneyArr;

@property (nonatomic, strong) NSString *appleUrl;
@property (nonatomic, strong) NSString *buyID;
@property (nonatomic, strong) NSString *payMoney;


@property (nonatomic, strong) NSString *currentProduct;
@property (nonatomic, strong) SKPaymentTransaction *doneTransaction;
@end

@implementation LIMGoldViewController

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
    self.title = @"充值";
    if (self.isLive) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNormalIcon:@"phonelogin_图层-2" highlightedIcon:@"phonelogin_图层-2" target:self action:@selector(dissmissThisView)];
//        [UIBarButtonItem itemWithTitle:@"充值记录" selectTitle:@"充值记录" target:self action:@selector(pushToRecard)];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"充值记录" selectTitle:@"充值记录" target:self action:@selector(pushToRecard)];
    
//    self.kGoldArr = @[@"500 K币",@"1000 K币",@"10000 K币",@"50000 K币",@"100000 K币"];
//    self.moneyArr = @[@"¥ 5",@"¥ 10",@"¥ 100",@"¥ 500",@"¥ 1000"];
    
    self.kGoldArr = @[@"420 K币",@"840 K币",@"6860 K币",@"34160 K币",@"69860 K币"];
    self.moneyArr = @[@"¥ 6",@"¥ 12",@"¥ 98",@"¥ 488",@"¥ 998"];

    [self creteTableView];
    [self tableFootView];
    
    [[SKPaymentQueue defaultQueue]  addTransactionObserver:self];
    // Do any additional setup after loading the view.
}
- (void)dissmissThisView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    tableView.tableHeaderView = [self tableHeader];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMGoldTableViewCell class] forCellReuseIdentifier:@"LIMGoldTableViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self payMoney:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableHeader{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self.view addSubview:headerView];
    
    UIView *currentLevelView = [[UIView alloc]init];
    [headerView addSubview:currentLevelView];
    [currentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 120));
    }];
    
    UIImageView *mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gold_金币."]];
    [currentLevelView addSubview:mainImage];
    [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentLevelView).offset(0);
        make.top.equalTo(currentLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(51, 55));
    }];
    
//    UIImageView *shaowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝"]];
//    [currentLevelView addSubview:shaowImage];
//    [shaowImage sizeToFit];
//    [shaowImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(currentLevelView).offset(0);
//        make.top.equalTo(mainImage.mas_bottom).offset(0);
//        //        make.size.mas_equalTo(CGSizeMake(52, 52));
//    }];
    
    
    UILabel *payText = [[UILabel alloc]init];
    payText.text = self.touid;
    payText.font = [UIFont systemFontOfSize:22];
    payText.textColor = [UIColor colorWithHexString:@"ffba01"];
    payText.textAlignment = NSTextAlignmentCenter;
    [currentLevelView addSubview:payText];
    [payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLevelView).offset(0);
        make.top.equalTo(mainImage.mas_bottom).offset(13.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 22));
    }];
    
    // next
    
    UIView *nextLevelView = [[UIView alloc]init];
    [headerView addSubview:nextLevelView];
    [nextLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(kScreenW/2.0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 127.5));
    }];
    
    UIImageView *nextmainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_%@",userModel.userlevel]]];
    [nextLevelView addSubview:nextmainImage];
    [nextmainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    UIImageView *shaowImage_next = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝"]];
    [nextLevelView addSubview:shaowImage_next];
    [shaowImage_next sizeToFit];
    [shaowImage_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextmainImage.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    
    CGFloat leftPadding = (kScreenW/2.0 - 86)/2.0;
    UILabel *nextlevelText = [[UILabel alloc]init];
    nextlevelText.text = @"当前等级:";
    nextlevelText.font = [UIFont systemFontOfSize:11];
    nextlevelText.textColor = [UIColor colorWithHexString:@"474747"];
    [nextLevelView addSubview:nextlevelText];
    [nextlevelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextLevelView).offset(leftPadding);
        make.top.equalTo(nextmainImage.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    
    UIImageView *nextlevelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word_%@",userModel.userlevel]]];
    [nextlevelImage sizeToFit];
    [nextLevelView addSubview:nextlevelImage];
    [nextlevelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextlevelText.mas_right).offset(0);
        make.bottom.equalTo(nextlevelText).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
    }];
    
    
    UILabel *payText_next = [[UILabel alloc]init];
    payText_next.text = @"充值赠送:";
    payText_next.font = [UIFont systemFontOfSize:11];
    payText_next.textColor = [UIColor colorWithHexString:@"474747"];
    [nextLevelView addSubview:payText_next];
    [payText_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextLevelView).offset(leftPadding);
        make.top.equalTo(nextlevelText.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    CGFloat rate_next;
    if ([userModel.userlevel isEqualToString:@"5"]){
        rate_next = 0.05;
    }else if ([userModel.userlevel isEqualToString:@"6"]){
        rate_next = 0.10;
    }
    else if ([userModel.userlevel isEqualToString:@"7"]){
        rate_next = 0.15;
    }else if ([userModel.userlevel isEqualToString:@"8"]){
        rate_next = 0.20;
    }else{
        rate_next = 0.00;
    }
    NSString *rateStr_next = [NSString stringWithFormat:@"%g%%",rate_next *100];
    UILabel *numText_next = [[UILabel alloc]init];
    numText_next.text = rateStr_next;
    numText_next.font = [UIFont systemFontOfSize:13];
    numText_next.textColor = [UIColor colorWithHexString:@"ff349d"];
    numText_next.textAlignment = NSTextAlignmentRight;
    [nextLevelView addSubview:numText_next];
    [numText_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payText_next.mas_right).offset(5);
        make.bottom.equalTo(payText_next).offset(0);
        make.size.mas_equalTo(CGSizeMake(25, 13));
    }];
    
    if (rate_next == 0) {
        payText_next.hidden = YES;
        numText_next.hidden = YES;
    }
    
    return headerView;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMGoldTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMGoldTableViewCell" forIndexPath:indexPath];
    hotLiveCell.nameLabel.text = self.kGoldArr[indexPath.row];
    hotLiveCell.followedLabel.text = self.moneyArr[indexPath.row];
    hotLiveCell.followClick =^(NSString *test){
        [self payMoney:indexPath.row];
    };

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}
- (void)tableFootView{
    UILabel *promptText = [[UILabel alloc]init];
    promptText.text = @"客服QQ: 414266852      客服电话: 18511694068";
    promptText.font = [UIFont systemFontOfSize:12];
    promptText.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    promptText.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:promptText];
    [promptText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.bottom.equalTo(self.view).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    
    UILabel *prompt2Text = [[UILabel alloc]init];
    prompt2Text.text = @"如果您在充值过程中遇到问题，请及时联系官方客服。";
    prompt2Text.font = [UIFont systemFontOfSize:12];
    prompt2Text.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    prompt2Text.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:prompt2Text];
    [prompt2Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptText.mas_left).offset(0);
        make.bottom.equalTo(promptText.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    UILabel *prompt3Text = [[UILabel alloc]init];
    prompt3Text.text = @"温馨提示:请理性消费，适度娱乐！";
    prompt3Text.font = [UIFont systemFontOfSize:14];
    prompt3Text.textColor = [UIColor colorWithHexString:@"ffbd0c"];
    prompt3Text.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:prompt3Text];
    [prompt3Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptText.mas_left).offset(0);
        make.bottom.equalTo(prompt2Text.mas_top).offset(-8);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14));
    }];

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
    [self.navigationController pushViewController:[[LIMPayListViewController alloc]init] animated:YES];
}
- (void)payMoney:(NSInteger)row{
    
    
    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductData:row];
        
    }else{
        [self showAlertWithMessage:@"不允许内付费"];
    }
}
-(void)RequestProductData:(NSInteger)row{
    [SVProgressHUD showWithStatus:@"正在请求苹果服务器"];
    NSArray *moneyArr = @[@"6",@"12",@"98",@"488",@"998"];
    NSArray *array = @[@"com.kkxiu01",@"com.kkxiu02",@"com.kkxiu03",@"com.kkxiu04",@"com.kkxiu05"];
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                     }
                                     ];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{
                                                                       @"paymoney":moneyArr[row],
                                                                       @"paysite":@"-1",
                                                                       }]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mPay method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
//            self.buyID
            NSDictionary *result = responseObject[@"result"];
            self.buyID = result[@"orderid"];
            self.appleUrl = result[@"notifyurl"];
            self.payMoney = moneyArr[row];
            NSSet *nsset = [NSSet setWithObjects:array[row], nil];
            self.currentProduct = array[row];
            SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
            request.delegate=self;
            [request start];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
    
    
    

}

// 收到 付费消息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [SVProgressHUD dismiss];

    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    SKProduct *last;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
        
        if ([product.productIdentifier isEqualToString:self.currentProduct]) {
            last = product;
        }
    }

    SKPayment *myPayment = [SKPayment paymentWithProduct:last];
    [[SKPaymentQueue defaultQueue] addPayment:myPayment];
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                
//                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
//                                                                    message:@"购买成功"
//                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
//                [alerView show];
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            {
                [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
//                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}


//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    
    self.doneTransaction = transaction;
//    NSLog(@"%@",transaction.transactionDate);
    NSLog(@"%@",transaction.transactionReceipt);

    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSLog(@"%@",tt);
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
//            [self recordTransaction:bookid];
//            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];//苹果推荐
    NSError *error = nil;
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    NSLog(@"%@",receiptData);
    
    
    
    NSArray *moneyArr = @[@"6",@"12",@"98",@"488",@"998"];
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                     }
                                     ];
    
    NSLog(@"%@",paraDict);
    
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{
                                                                       @"paymoney":self.payMoney,
                                                                       @"orderid":self.buyID,
                                                                       @"receipt-data":[receiptData base64EncodedStringWithOptions:0]
                                                                       }
]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:self.appleUrl method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self showAlertWithMessage:@"充值成功"];
        }else{
            [self showAlertWithMessage:responseObject[@"resmsg"]];
            [self completeTransaction:self.doneTransaction];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
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

