//
//  LIMGameCollectionViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/27.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMGameCollectionViewCell.h"

@implementation LIMGameCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat iconW = (kScreenW - 17*5)/4;
    
    self.coverImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gamecover_图层-35"]];
    [self.contentView addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.centerX.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(iconW);
        make.width.mas_equalTo(iconW);
    }];
    self.coverImage.hidden = YES;
    
    self.giftIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"push_add0817_图层-1"]];
    [self.contentView addSubview:self.giftIcon];
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImage).offset(5);
        make.right.bottom.equalTo(self.coverImage).offset(-5);
//        make.height.mas_equalTo(65);
//        make.width.mas_equalTo(65);
    }];
    
//    self.giftIcon.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bringsss)];
//    [self.contentView addGestureRecognizer:tap];
    
    self.money = [[UILabel alloc]init];
    self.money.text = @"游戏名字";
    self.money.font = [UIFont systemFontOfSize:13];
    self.money.textColor = [UIColor colorWithHexString:@"ffffff"];
    self.money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.centerX.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(iconW);
    }];
    // Initialization code
}
//- (void)bringsss{
//    NSLog(@"123");
//    
//}

@end

