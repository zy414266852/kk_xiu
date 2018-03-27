//
//  LIMChartsView.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMChartsView.h"
@interface LIMChartsView()
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕

@end

@implementation LIMChartsView


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
        [self setUI];
    }
    return self;
}
- (void)setUI{
    //    [beatifulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(_displayView).offset(29.5 *kiphone6);
    //        make.bottom.equalTo(_displayView).offset(-74.5);
    //        make.width.mas_equalTo(90);
    //        make.height.mas_equalTo(40);
    //    }];
    
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.centerY.equalTo(self).offset(-20);
        make.width.mas_equalTo(321 *kiphone6);
        make.height.mas_equalTo(423 *kiphone6);
    }];
    
    
    
    //
    UIImageView *upImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"livepage"]];
    //    upImage.userInteractionEnabled = YES;
    [bigView addSubview:upImage];
    [upImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bigView).offset(0);
        make.top.equalTo(bigView).offset(0);
        make.width.equalTo(bigView.mas_width);
        make.height.mas_equalTo(321 *kiphone6);
    }];
    UITapGestureRecognizer* emptyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [upImage addGestureRecognizer:emptyTap];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    reportBtn.layer.cornerRadius = 10 ;
    reportBtn.clipsToBounds = YES;
    [reportBtn addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    [upImage addSubview:reportBtn];
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upImage).offset(14);
        make.top.equalTo(upImage).offset(14);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
    UILabel *describeTitle = [[UILabel alloc]init];
    describeTitle.text = @"我是火星人呀，火星人.火星很好玩，很好玩，很好玩";
    describeTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    describeTitle.textAlignment = NSTextAlignmentLeft;
    describeTitle.font = [UIFont systemFontOfSize:13];
    [upImage addSubview:describeTitle];
    [describeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upImage).offset(14);
        make.bottom.equalTo(upImage).offset(- 14.5);
        make.width.equalTo(upImage.mas_width);
        make.height.mas_equalTo(13);
    }];
    NSString *nameStr = @"喵～喵喵";
    CGFloat buttonW = [nameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.text = nameStr;
    nameTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.font = [UIFont systemFontOfSize:15];
    [upImage addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(describeTitle).offset(0);
        make.bottom.equalTo(describeTitle.mas_top).offset(-11.5);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *gradeImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_钻石"]];
    [gradeImageV sizeToFit];
    [upImage addSubview:gradeImageV];
    [gradeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle.mas_right).offset(6);
        make.centerY.equalTo(nameTitle.mas_centerY).offset(0);
        
    }];
    
    
    UILabel *cityTitle = [[UILabel alloc]init];
    cityTitle.text = @"ID  414266852";
    cityTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    cityTitle.textAlignment = NSTextAlignmentLeft;
    cityTitle.font = [UIFont systemFontOfSize:13];
    [upImage addSubview:cityTitle];
    [cityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gradeImageV.mas_right).offset(6);
        make.centerY.equalTo(nameTitle).offset(0);
        //        make.width.mas_equalTo(kScreenW/2.0 + 30);
        //        make.height.mas_equalTo(13);
    }];
    
    
    
    //
    UIView *clickView = [[UIView alloc]init];
    [bigView addSubview:clickView];
    [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bigView).offset(0);
        make.top.equalTo(upImage.mas_bottom).offset(0);
        make.width.equalTo(bigView.mas_width);
        make.bottom.equalTo(bigView).offset(0);
    }];
    UITapGestureRecognizer* emptyTap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [upImage addGestureRecognizer:emptyTap_2];
    
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followBtn.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    followBtn.layer.cornerRadius = 17 *kiphone6;
    followBtn.clipsToBounds = YES;
    [followBtn addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    [clickView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(clickView).offset(0);
        make.top.equalTo(clickView).offset(13.5 *kiphone6);
        make.width.mas_equalTo(247 *kiphone6);
        make.height.mas_equalTo(34 *kiphone6);
    }];
    
    NSArray *titleArr = @[@"主页",@"私信"];
    CGFloat btnW = 321*kiphone6/(CGFloat)titleArr.count;
    for (int i = 0; i< titleArr.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"3e3e3e"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleBtn addTarget:self action:@selector(pushOtherView) forControlEvents:UIControlEventTouchUpInside];
        [clickView addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(clickView).offset(btnW *i);
            make.bottom.equalTo(clickView).offset(-18 *kiphone6);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(20 *kiphone6);
        }];
        
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"c5c5c7"];
        [clickView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleBtn).offset(0);
            make.left.equalTo(titleBtn.mas_right).offset(-0.5);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(27.5 *kiphone6);
        }];
        
        
    }
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_10"]];
    [imageV sizeToFit];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigView.mas_bottom).offset(25.5 *kiphone6);
        make.centerX.equalTo(self).offset(0);
    }];
    
}
- (void)dismiss:(UITapGestureRecognizer *)tap {
    
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
}
- (void)pushOtherView{
    NSLog(@"push push  push");
}
- (void)emptyClick{
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

