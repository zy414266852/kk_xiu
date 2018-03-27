//
//  LIMGradeViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMGradeViewController.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import "LIMUPLevelModel.h"
#import "LIMUserLevelModel.h"
#import <MJExtension.h>

@interface LIMGradeViewController ()
@property (nonatomic, strong)LIMUPLevelModel *upLevelModel;
@property (nonatomic, strong)LIMUserLevelModel *userLevelModel;
@end

@implementation LIMGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的等级";
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    self.iscompere = userModel.iscompere;
    
    [self httpLiveUserLevel];

    // Do any additional setup after loading the view.
}
- (void)setUpHeaderUI{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 189.5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ff595e"];
    [self.view addSubview:headerView];
    
    
    UIView *currentLevelView = [[UIView alloc]init];
    [headerView addSubview:currentLevelView];
    [currentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 127.5));
    }];
    
    UIImageView *mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upbig_%@",self.upLevelModel.level]]];
    [currentLevelView addSubview:mainImage];
    [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentLevelView).offset(0);
        make.top.equalTo(currentLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    UIImageView *smallImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upsmall_%@",self.upLevelModel.level]]];
    [smallImage sizeToFit];
    [currentLevelView addSubview:smallImage];
    [smallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainImage.mas_right).offset(1);
        make.bottom.equalTo(mainImage).offset(0);
//        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UIImageView *shaowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝-red"]];
    [currentLevelView addSubview:shaowImage];
    [shaowImage sizeToFit];
    [shaowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentLevelView).offset(0);
        make.top.equalTo(mainImage.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    
    //
    CGFloat leftPadding = (kScreenW/2.0 - 86)/2.0 -20;
    UILabel *levelText = [[UILabel alloc]init];
    levelText.text = @"当前等级:";
    levelText.font = [UIFont systemFontOfSize:11];
    levelText.textColor = [UIColor colorWithHexString:@"ffffff"];
    [currentLevelView addSubview:levelText];
    [levelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLevelView).offset(leftPadding);
        make.top.equalTo(mainImage.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 11));
    }];
    
    
    UIImageView *levelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upword_%@",self.upLevelModel.level]]];
    [levelImage sizeToFit];
    [currentLevelView addSubview:levelImage];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelText.mas_right).offset(0);
        make.bottom.equalTo(levelText).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
    }];
    
    
    UILabel *payText = [[UILabel alloc]init];
    
    payText.text = [NSString stringWithFormat:@"当前奖励%@",self.upLevelModel.award];
    payText.font = [UIFont systemFontOfSize:13];
    payText.textAlignment= NSTextAlignmentCenter;
    payText.textColor = [UIColor colorWithHexString:@"ffffff"];
    [currentLevelView addSubview:payText];
    [payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLevelView).offset(0);
        make.top.equalTo(levelText.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2, 13));
    }];
//    
//    CGFloat rate = [self.userLevelModel.giverate floatValue];
//    NSString *rateStr = [NSString stringWithFormat:@"%g%%",rate *100];
//    
//    
//    UILabel *numText = [[UILabel alloc]init];
//    numText.text = rateStr;
//    numText.font = [UIFont systemFontOfSize:13];
//    numText.textColor = [UIColor colorWithHexString:@"ff349d"];
//    numText.textAlignment = NSTextAlignmentRight;
//    [currentLevelView addSubview:numText];
//    [numText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(payText.mas_right).offset(5);
//        make.bottom.equalTo(payText).offset(0);
//        make.size.mas_equalTo(CGSizeMake(25, 13));
//    }];
    
    
    // next
    
    UIView *nextLevelView = [[UIView alloc]init];
    [headerView addSubview:nextLevelView];
    [nextLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(kScreenW/2.0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 127.5));
    }];
    
    UIImageView *nextmainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upbig_%@",self.upLevelModel.nextlevel]]];
    [nextLevelView addSubview:nextmainImage];
    [nextmainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UIImageView *smallImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upsmall_%@",self.upLevelModel.level]]];
    [smallImage2 sizeToFit];
    [nextLevelView addSubview:smallImage2];
    [smallImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextmainImage.mas_right).offset(1);
        make.bottom.equalTo(nextmainImage).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];

    UIImageView *shaowImage_next = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝-red"]];
    [nextLevelView addSubview:shaowImage_next];
    [shaowImage_next sizeToFit];
    [shaowImage_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextmainImage.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    
    //    CGFloat leftPadding = (kScreenW - 86)/2.0;
    UILabel *nextlevelText = [[UILabel alloc]init];
    nextlevelText.text = @"下一等级:";
    nextlevelText.font = [UIFont systemFontOfSize:11];
    nextlevelText.textColor = [UIColor colorWithHexString:@"ffffff"];
    [nextLevelView addSubview:nextlevelText];
    [nextlevelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextLevelView).offset(leftPadding);
        make.top.equalTo(nextmainImage.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    
    UIImageView *nextlevelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upword_%@",self.upLevelModel.nextlevel]]];
    [nextlevelImage sizeToFit];
    [nextLevelView addSubview:nextlevelImage];
    [nextlevelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextlevelText.mas_right).offset(0);
        make.bottom.equalTo(nextlevelText).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
    }];
    
    
    UILabel *payText_next = [[UILabel alloc]init];
    payText_next.text = [NSString stringWithFormat:@"当前奖励%@",self.upLevelModel.nextaward];
    payText_next.font = [UIFont systemFontOfSize:13];
    payText_next.textAlignment = NSTextAlignmentCenter;
    payText_next.textColor = [UIColor colorWithHexString:@"ffffff"];
    [nextLevelView addSubview:payText_next];
    [payText_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextlevelText.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 13));
    }];
    
//    CGFloat rate_next = [self.userLevelModel.nextgiverate floatValue];
//    NSString *rateStr_next = [NSString stringWithFormat:@"%g%%",rate_next *100];
//    UILabel *numText_next = [[UILabel alloc]init];
//    numText_next.text = rateStr_next;
//    numText_next.font = [UIFont systemFontOfSize:13];
//    numText_next.textColor = [UIColor colorWithHexString:@"ff349d"];
//    numText_next.textAlignment = NSTextAlignmentRight;
//    [nextLevelView addSubview:numText_next];
//    [numText_next mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(payText_next.mas_right).offset(5);
//        make.bottom.equalTo(payText_next).offset(0);
//        make.size.mas_equalTo(CGSizeMake(25, 13));
//    }];
    
    UIImageView *maddingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"213"]];
    [nextLevelView addSubview:maddingImage];
    [headerView sizeToFit];
    [maddingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(38);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"等级特权";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(24.5);
        make.top.equalTo(headerView.mas_bottom).offset(13.5);
        make.size.mas_equalTo(CGSizeMake(70, 16));
    }];
    
    
    
    
    
    UILabel *promptText = [[UILabel alloc]init];
    promptText.text = @"当月累积魅力值，达到升级目标自动升级";
    promptText.font = [UIFont systemFontOfSize:10];
    promptText.textColor = [UIColor colorWithHexString:@"ffffff"];
    promptText.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:promptText];
    [promptText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.bottom.equalTo(headerView.mas_bottom).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 10));
    }];
    
    
    CGFloat progressW = kScreenW/3 *2;
    CGFloat cornerRad = 5;
    
    CGFloat currentProgressW = progressW * [self.upLevelModel.monthscore floatValue] /([self.upLevelModel.monthscore floatValue] +[self.upLevelModel.nextmonthscore floatValue]);
    
    
    UILabel *progressLabel = [[UILabel alloc]init];
    progressLabel.backgroundColor = [UIColor colorWithHexString:@"cd4346"];
    progressLabel.layer.cornerRadius = cornerRad;
    progressLabel.clipsToBounds = YES;
    [headerView addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView).offset(0);
        make.bottom.equalTo(promptText.mas_top).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(progressW, cornerRad *2));
    }];
    
    
    UILabel *currProgress = [[UILabel alloc]init];
    currProgress.backgroundColor = [UIColor colorWithHexString:@"ffca14"];
    [progressLabel addSubview:currProgress];
    [currProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel).offset(0);
        make.bottom.equalTo(progressLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(currentProgressW, cornerRad *2));
    }];
    
    
    UILabel *leftText = [[UILabel alloc]init];
    //    self.userLevelModel.pay
    leftText.text = [NSString stringWithFormat:@"当月魅力值: %@",self.upLevelModel.monthscore];
    leftText.font = [UIFont systemFontOfSize:11];
    leftText.textColor = [UIColor colorWithHexString:@"474747"];
    leftText.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel).offset(cornerRad);
        make.bottom.equalTo(progressLabel.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 11));
    }];
    
    UILabel *rightText = [[UILabel alloc]init];
    rightText.text = [NSString stringWithFormat:@"离升级还差:%@",self.upLevelModel.nextmonthscore];
    rightText.font = [UIFont systemFontOfSize:11];
    rightText.textColor = [UIColor colorWithHexString:@"474747"];
    rightText.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:rightText];
    [rightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progressLabel).offset(cornerRad *-1);
        make.bottom.equalTo(leftText).offset(0);
        make.size.mas_equalTo(CGSizeMake(150, 11));
    }];
    
    
    
    
    

    
    
    
    NSArray *rateArray = @[@"新人主播",@"10万魅力值",@"30万魅力值",@"50万魅力值",@"80万魅力值",@"150万魅力值"];
    NSArray *other = @[@"",@"",@"奖励500元",@"奖励1000元",@"奖励1500元",@"奖励2000元"];
    ///////////////////
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view).offset(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(19);
    }];
    
    CGFloat kViewW = kScreenW/3.0;
    CGFloat kViewH = 130;
    for (int i = 0; i <6; i++) {
        int arrange = i%3;
        int row = i/3;
        
        UIView *gradeV = [[UIView alloc]init];
        //        gradeV.backgroundColor = [self randomColor];
        [footView addSubview:gradeV];
        [gradeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(arrange *kViewW);
            make.top.equalTo(footView).offset(row *kViewH);
            make.size.mas_equalTo(CGSizeMake(kViewW, kViewH));
        }];
        
        
        
        
        UIImageView *mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upbig_%d",i+1]]];
        [gradeV addSubview:mainImage];
        [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(gradeV).offset(0);
            make.size.mas_equalTo(CGSizeMake(52, 52));
        }];
        
        UIImageView *smallImage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upsmall_%d",i+1]]];
        [smallImage3 sizeToFit];
        [gradeV addSubview:smallImage3];
        [smallImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainImage.mas_right).offset(1);
            make.bottom.equalTo(mainImage).offset(0);
            //        make.size.mas_equalTo(CGSizeMake(52, 52));
        }];

        
        UIImageView *shaowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝"]];
        [gradeV addSubview:shaowImage];
        [shaowImage sizeToFit];
        [shaowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(mainImage.mas_bottom).offset(0);
            //        make.size.mas_equalTo(CGSizeMake(52, 52));
        }];
        
        
        
        UIImageView *levelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"upword_%d",i+1]]];
        [levelImage sizeToFit];
        [gradeV addSubview:levelImage];
        [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(shaowImage.mas_bottom).offset(5);
            //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
        }];
        
        
        UILabel *numText = [[UILabel alloc]init];
        numText.text = rateArray[i];
        numText.font = [UIFont systemFontOfSize:11];
        numText.textColor = [UIColor colorWithHexString:@"474747"];
        numText.textAlignment = NSTextAlignmentCenter;
        [gradeV addSubview:numText];
        [numText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeV).offset(0);
            make.top.equalTo(levelImage.mas_bottom).offset(5.5);
            make.size.mas_equalTo(CGSizeMake(kViewW, 13));
        }];
        
        if (i >1) {
            UILabel *otherText = [[UILabel alloc]init];
            otherText.text = other[i];
            otherText.font = [UIFont systemFontOfSize:11];
            otherText.textColor = [UIColor colorWithHexString:@"ff349d"];
            otherText.textAlignment = NSTextAlignmentCenter;
            [gradeV addSubview:otherText];
            [otherText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(gradeV).offset(0);
                make.top.equalTo(numText.mas_bottom).offset(5.5);
                make.size.mas_equalTo(CGSizeMake(kViewW, 13));
            }];
        }
        
        
        
        
    }
    
    if ([self.upLevelModel.award isEqualToString:@"0"]) {
        payText.hidden = YES;
    }
    
    if ([self.userLevelModel.nextgiverate isEqualToString:@"0"]) {
        payText_next.hidden = YES;
    }

    

    
}
- (void)setUserHeaderUI{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 189.5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    [self.view addSubview:headerView];
    
    
    UIView *currentLevelView = [[UIView alloc]init];
    [headerView addSubview:currentLevelView];
    [currentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 127.5));
    }];
    
    UIImageView *mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_%@",self.userLevelModel.level]]];
    [currentLevelView addSubview:mainImage];
    [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentLevelView).offset(0);
        make.top.equalTo(currentLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UIImageView *shaowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝-2"]];
    [currentLevelView addSubview:shaowImage];
    [shaowImage sizeToFit];
    [shaowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentLevelView).offset(0);
        make.top.equalTo(mainImage.mas_bottom).offset(0);
//        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    

    
//    
    CGFloat leftPadding = (kScreenW/2.0 - 86)/2.0;
    UILabel *levelText = [[UILabel alloc]init];
    levelText.text = @"当前等级:";
    levelText.font = [UIFont systemFontOfSize:11];
    levelText.textColor = [UIColor colorWithHexString:@"474747"];
    [currentLevelView addSubview:levelText];
    [levelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLevelView).offset(leftPadding);
        make.top.equalTo(mainImage.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    
    UIImageView *levelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word_%@",self.userLevelModel.level]]];
    [levelImage sizeToFit];
    [currentLevelView addSubview:levelImage];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelText.mas_right).offset(5);
        make.bottom.equalTo(levelText).offset(0);
//        make.size.mas_equalTo(CGSizeMake(52, 127.5));
    }];
    
    
    UILabel *payText = [[UILabel alloc]init];
    payText.text = @"充值赠送:";
    payText.font = [UIFont systemFontOfSize:11];
    payText.textColor = [UIColor colorWithHexString:@"474747"];
    [currentLevelView addSubview:payText];
    [payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLevelView).offset(leftPadding);
        make.top.equalTo(levelText.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    CGFloat rate = [self.userLevelModel.giverate floatValue];
    NSString *rateStr = [NSString stringWithFormat:@"%g%%",rate *100];
    
    
    UILabel *numText = [[UILabel alloc]init];
    numText.text = rateStr;
    numText.font = [UIFont systemFontOfSize:13];
    numText.textColor = [UIColor colorWithHexString:@"ff349d"];
    numText.textAlignment = NSTextAlignmentRight;
    [currentLevelView addSubview:numText];
    [numText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payText.mas_right).offset(5);
        make.bottom.equalTo(payText).offset(0);
        make.size.mas_equalTo(CGSizeMake(25, 13));
    }];

    
    // next
    
    UIView *nextLevelView = [[UIView alloc]init];
    [headerView addSubview:nextLevelView];
    [nextLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(kScreenW/2.0);
        make.top.equalTo(headerView).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 127.5));
    }];
    
    UIImageView *nextmainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_%@",self.userLevelModel.nextlevel]]];
    [nextLevelView addSubview:nextmainImage];
    [nextmainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextLevelView).offset(25);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    UIImageView *shaowImage_next = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝-2"]];
    [nextLevelView addSubview:shaowImage_next];
    [shaowImage_next sizeToFit];
    [shaowImage_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nextLevelView).offset(0);
        make.top.equalTo(nextmainImage.mas_bottom).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];

    
    
//    CGFloat leftPadding = (kScreenW - 86)/2.0;
    UILabel *nextlevelText = [[UILabel alloc]init];
    nextlevelText.text = @"下一等级:";
    nextlevelText.font = [UIFont systemFontOfSize:11];
    nextlevelText.textColor = [UIColor colorWithHexString:@"474747"];
    [nextLevelView addSubview:nextlevelText];
    [nextlevelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextLevelView).offset(leftPadding);
        make.top.equalTo(nextmainImage.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(55, 11));
    }];
    
    
    UIImageView *nextlevelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word_%@",self.userLevelModel.nextlevel]]];
    [nextlevelImage sizeToFit];
    [nextLevelView addSubview:nextlevelImage];
    [nextlevelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nextlevelText.mas_right).offset(5);
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
    
    CGFloat rate_next = [self.userLevelModel.nextgiverate floatValue];
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

    UIImageView *maddingImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"213"]];
    [nextLevelView addSubview:maddingImage];
    [headerView sizeToFit];
    [maddingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(38);
        //        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"等级特权";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(24.5);
        make.top.equalTo(headerView.mas_bottom).offset(13.5);
        make.size.mas_equalTo(CGSizeMake(70, 16));
    }];
    
    
    
    
    
    UILabel *promptText = [[UILabel alloc]init];
    promptText.text = @"历史累计消费，达到升级标准自动升级";
    promptText.font = [UIFont systemFontOfSize:10];
    promptText.textColor = [UIColor colorWithHexString:@"ffffff"];
    promptText.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:promptText];
    [promptText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.bottom.equalTo(headerView.mas_bottom).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 10));
    }];
    
    
    CGFloat progressW = kScreenW/3 *2;
    CGFloat cornerRad = 5;
    
    CGFloat currentProgressW = progressW * [self.userLevelModel.pay floatValue] /([self.userLevelModel.pay floatValue] +[self.userLevelModel.nextpay floatValue]);
    
    
    UILabel *progressLabel = [[UILabel alloc]init];
    progressLabel.backgroundColor = [UIColor colorWithHexString:@"967724"];
    progressLabel.layer.cornerRadius = cornerRad;
    progressLabel.clipsToBounds = YES;
    [headerView addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView).offset(0);
        make.bottom.equalTo(promptText.mas_top).offset(-8.5);
        make.size.mas_equalTo(CGSizeMake(progressW, cornerRad *2));
    }];
    
    
    UILabel *currProgress = [[UILabel alloc]init];
    currProgress.backgroundColor = [UIColor colorWithHexString:@"ff394d"];
    [progressLabel addSubview:currProgress];
    [currProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel).offset(0);
        make.bottom.equalTo(progressLabel).offset(0);
        make.size.mas_equalTo(CGSizeMake(currentProgressW, cornerRad *2));
    }];
    
    
    UILabel *leftText = [[UILabel alloc]init];
//    self.userLevelModel.pay
    leftText.text = [NSString stringWithFormat:@"当前消费: %@",self.userLevelModel.pay];
    leftText.font = [UIFont systemFontOfSize:11];
    leftText.textColor = [UIColor colorWithHexString:@"474747"];
    leftText.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressLabel).offset(cornerRad);
        make.bottom.equalTo(progressLabel.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 11));
    }];
    
    UILabel *rightText = [[UILabel alloc]init];
    rightText.text = [NSString stringWithFormat:@"离升级还差: %@",self.userLevelModel.nextpay];
    rightText.font = [UIFont systemFontOfSize:11];
    rightText.textColor = [UIColor colorWithHexString:@"474747"];
    rightText.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:rightText];
    [rightText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(progressLabel).offset(cornerRad *-1);
        make.bottom.equalTo(leftText).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 11));
    }];

    
    
    
    
    ///////////////////
    NSMutableAttributedString * aAttributedString1 = [[NSMutableAttributedString alloc] initWithString:@"充值赠送： 5%"];
    [aAttributedString1 addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:[UIColor colorWithHexString:@"474747"]
                              range:NSMakeRange(0, 5)];
    
    [aAttributedString1 addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:11]
                              range:NSMakeRange(0, 5)];
    
    //富文本样式
    [aAttributedString1 addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:[UIColor colorWithHexString:@"ff349d"]
                              range:NSMakeRange(5, 3)];
    
    [aAttributedString1 addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:13]
                              range:NSMakeRange(5, 3)];
    NSMutableAttributedString * aAttributedString2 = [[NSMutableAttributedString alloc] initWithString:@"充值赠送： 10%"];
    [aAttributedString2 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"474747"]
                               range:NSMakeRange(0, 5)];
    
    [aAttributedString2 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:11]
                               range:NSMakeRange(0, 5)];
    
    //富文本样式
    [aAttributedString2 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"ff349d"]
                               range:NSMakeRange(5, 4)];
    
    [aAttributedString2 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:13]
                               range:NSMakeRange(5, 4)];
    NSMutableAttributedString * aAttributedString3 = [[NSMutableAttributedString alloc] initWithString:@"充值赠送： 15%"];
    [aAttributedString3 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"474747"]
                               range:NSMakeRange(0, 5)];
    
    [aAttributedString3 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:11]
                               range:NSMakeRange(0, 5)];
    
    //富文本样式
    [aAttributedString3 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"ff349d"]
                               range:NSMakeRange(5, 4)];
    
    [aAttributedString3 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:13]
                               range:NSMakeRange(5, 4)];
    NSMutableAttributedString * aAttributedString4 = [[NSMutableAttributedString alloc] initWithString:@"充值赠送： 20%"];
    [aAttributedString4 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"474747"]
                               range:NSMakeRange(0, 5)];
    
    [aAttributedString4 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:11]
                               range:NSMakeRange(0, 5)];
    
    //富文本样式
    [aAttributedString4 addAttribute:NSForegroundColorAttributeName  //文字颜色
                               value:[UIColor colorWithHexString:@"ff349d"]
                               range:NSMakeRange(5, 4)];
    
    [aAttributedString4 addAttribute:NSFontAttributeName             //文字字体
                               value:[UIFont systemFontOfSize:13]
                               range:NSMakeRange(5, 4)];

    
    
    NSArray *rateArray = @[@"无特权",@"可开启直播",@"可开启直播",@"黄金专属进场特效",@"白金专属进场特效",aAttributedString1,aAttributedString2,aAttributedString3,aAttributedString4];
    
    ///////////////////
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view).offset(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(19);
    }];
    
    CGFloat kViewW = kScreenW/3.0;
    CGFloat kViewH = 110;
    for (int i = 0; i <9; i++) {
        int arrange = i%3;
        int row = i/3;
        
        UIView *gradeV = [[UIView alloc]init];
//        gradeV.backgroundColor = [self randomColor];
        [footView addSubview:gradeV];
        [gradeV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footView).offset(arrange *kViewW);
            make.top.equalTo(footView).offset(row *kViewH);
            make.size.mas_equalTo(CGSizeMake(kViewW, kViewH));
        }];
        
        
        
        
        UIImageView *mainImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"user_%d",i]]];
        [gradeV addSubview:mainImage];
        [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(gradeV).offset(0);
            make.size.mas_equalTo(CGSizeMake(52, 52));
        }];
        
        UIImageView *shaowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-69-拷贝"]];
        [gradeV addSubview:shaowImage];
        [shaowImage sizeToFit];
        [shaowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(mainImage.mas_bottom).offset(0);
            //        make.size.mas_equalTo(CGSizeMake(52, 52));
        }];
        
        
        
        UIImageView *levelImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"word_%d",i]]];
        [levelImage sizeToFit];
        [gradeV addSubview:levelImage];
        [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(gradeV).offset(0);
            make.top.equalTo(shaowImage.mas_bottom).offset(5);
            //        make.size.mas_equalTo(CGSizeMake(52, 127.5));
        }];
        
        
        UILabel *numText = [[UILabel alloc]init];
        if (i <5) {
            numText.text = rateArray[i];
            numText.font = [UIFont systemFontOfSize:11];
            numText.textColor = [UIColor colorWithHexString:@"474747"];
        }else{
            numText.attributedText = rateArray[i];
        }
        numText.textAlignment = NSTextAlignmentCenter;
        [gradeV addSubview:numText];
        [numText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gradeV).offset(0);
            make.top.equalTo(levelImage.mas_bottom).offset(5.5);
            make.size.mas_equalTo(CGSizeMake(kViewW, 13));
        }];

        

    }
    if ([self.userLevelModel.giverate isEqualToString:@"0"]) {
        payText.hidden = YES;
        numText.hidden = YES;
    }
    
    if ([self.userLevelModel.nextgiverate isEqualToString:@"0"]) {
        payText_next.hidden = YES;
        numText_next.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// 等级
- (void)httpLiveUserLevel{
    
    NSString *urlStr;
    if([self.iscompere isEqualToString:@"1"]){
        urlStr = mUp_Level;
    }else{
        urlStr = mUser_Level;
    }
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:urlStr method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict = responseObject[@"result"];
            if([self.iscompere isEqualToString:@"1"]){
                self.upLevelModel = [LIMUPLevelModel mj_objectWithKeyValues:dict];
                [self setUpHeaderUI];
            }else{
                self.userLevelModel = [LIMUserLevelModel mj_objectWithKeyValues:dict];
                [self setUserHeaderUI];
            }
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

- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
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
