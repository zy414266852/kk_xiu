//
//  LIMGameHelpView.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/23.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMGameHelpView.h"
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMSimpleInfoModel.h"
#import <WebKit/WebKit.h>
@interface LIMGameHelpView()
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕
@property (nonatomic, strong) UIButton *followBtn;

@end
@implementation LIMGameHelpView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self addGestureRecognizer:singleTap];
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.windowLevel       = UIWindowLevelStatusBar;
        _actionWindow.backgroundColor   = [UIColor clearColor];
        _actionWindow.hidden = NO;
        [self.actionWindow addSubview:self];
        //        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    
    
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.centerY.equalTo(self).offset(-20);
        make.width.mas_equalTo(275 *kiphone6);
        make.height.mas_equalTo(375 *kiphone6);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor colorWithHexString:@"fc963d"];
    [bigView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bigView).offset(0);
        make.top.equalTo(bigView).offset(0);
        make.width.mas_equalTo(275 *kiphone6);
        make.height.mas_equalTo(73/2.0 *kiphone6);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"游戏规则";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView).offset(0);
        make.centerY.equalTo(titleView).offset(0);
        make.width.mas_equalTo(200 *kiphone6);
        make.height.mas_equalTo(15 *kiphone6);
    }];
    NSString *urlString;
    switch (self.gameID) {
        case 1:
            urlString = zwwUrl_help;
            break;
        case 2:
            urlString = scjlUrl_help;
            break;
        case 3:
            urlString = cartsUrl_help;
            break;
        case 4:
            urlString = wlzbUrl_help;
            break;
        case 5:
            urlString = hdczUrl_help;
            break;
            
        default:
            break;
    };

    
    WKWebView *gameWeb = [[WKWebView alloc]init];
    gameWeb.backgroundColor = [UIColor clearColor];
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:urlString withExtension:nil];
    NSLog(@"%@, %@",urlString,filePath);
    gameWeb.scrollView.showsVerticalScrollIndicator = NO;
    gameWeb.scrollView.showsHorizontalScrollIndicator = NO;
    [gameWeb loadRequest:[NSURLRequest requestWithURL:filePath]];
    [gameWeb setOpaque:NO];
    [bigView addSubview:gameWeb];
    [gameWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(11);
        make.left.equalTo(bigView).offset(11);
        make.right.equalTo(bigView).offset(-11);
        make.bottom.equalTo(bigView).offset(-11);
//        make.width.mas_equalTo(200 *kiphone6);
//        make.height.mas_equalTo(15 *kiphone6);
    }];

    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_10"]];
    [imageV sizeToFit];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigView.mas_bottom).offset(25.5 *kiphone6);
        make.centerX.equalTo(self).offset(0);
    }];
    
    
    
    
}
- (void)dismiss:(UITapGestureRecognizer *)tap {
    NSLog(@"123123");
    [UIView animateWithDuration:0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self setAlpha:0];
                         [self setUserInteractionEnabled:NO];
                         
                         //                         CGRect frame = _mainView.frame;
                         //                         frame.origin.y += frame.size.height;
                         //                         [_mainView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _actionWindow.hidden = YES;
                         [self removeFromSuperview];
                         //                         self.isShow = NO;
                     }];
}
- (void)followUser{
    NSLog(@"关注");
    if ([_followBtn.currentTitle isEqualToString:@"关注"]) {
        [self followOther:self.simpleInfoModel.uid];
    }
}
- (void)pushOtherView:(UIButton *)sender{
    if (sender.tag == 200) {
        [self dismiss:nil];
        self.backClick(@"otherinfo");
    }else{
        self.backClick(@"private");
    }
    NSLog(@"push push  push");
}
- (void)emptyClick{
    
}
// 关注他人
- (void)followOther:(NSString *)touid{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mFollow_other method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            //            [self showAlertWithMessage:resmsg];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
