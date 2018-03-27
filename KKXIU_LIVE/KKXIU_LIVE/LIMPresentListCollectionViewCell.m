//
//  LIMPresentListCollectionViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPresentListCollectionViewCell.h"

@implementation LIMPresentListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.giftIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_19"]];
    
//    [_giftIcon sizeToFit];
    
    [self.contentView addSubview:self.giftIcon];
    [self.giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-7.0);
        make.centerX.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(65);
        make.width.mas_equalTo(65);
    }];
    
    
    
    self.money = [[UILabel alloc]init];
//    self.money.text = @"2013";
//    self.money.font = [UIFont systemFontOfSize:13];
//    self.money.textColor = [UIColor colorWithHexString:@"ffbe3a"];

    self.money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.money];
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.centerX.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(16);
        make.width.equalTo(self.contentView);
    }];
    
//    self.money = [[UILabel alloc]init];
//    self.money.text = @"2013";
//    self.money.font = [UIFont systemFontOfSize:13];
//    self.money.textColor = [UIColor colorWithHexString:@"ffbe3a"];
//    self.money.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.money];
//    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView).offset(-10);
//        make.centerX.equalTo(self.contentView).offset(-8);
//        make.height.mas_equalTo(13);
//        make.width.mas_equalTo(33);
//    }];
//
    
    
//    self.gold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_9"]];
//    
//    [self.gold sizeToFit];
//    [self.contentView addSubview:self.gold];
//    [self.gold mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.money).offset(0);
//        make.left.equalTo(self.money.mas_right).offset(0);
//    }];

    self.selectImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-2-拷贝-2"]];
    self.selectImage.hidden = YES;
    //    [_giftIcon sizeToFit];
    
    [self.contentView addSubview:self.selectImage];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(10);
    }];
    
    UILabel *line_bottom = [[UILabel alloc]init];
    
    line_bottom.alpha = 0.5;
    line_bottom.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:line_bottom];
    [line_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *line_right = [[UILabel alloc]init];
    line_right.alpha = 0.5;
    line_right.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:line_right];
    self.line_right = line_right;
    [line_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView);
        make.width.mas_equalTo(1);
        make.height.equalTo(self.contentView);
    }];

    
    
    // Initialization code
}

@end
