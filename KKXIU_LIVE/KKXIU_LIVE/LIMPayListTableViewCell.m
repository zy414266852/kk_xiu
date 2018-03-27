//
//  LIMPayListTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPayListTableViewCell.h"
#import <UIImageView+WebCache.h>
@implementation LIMPayListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"gold_金币."];
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(12);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        
    }];
    self.avatar = imageV;
    
    // 城市
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"xx K币";
    nameLabel.textColor = [UIColor colorWithHexString:@"ff349d"];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV.mas_centerY).offset(0);
        make.left.equalTo(imageV.mas_right).offset(13.5);
        make.size.mas_equalTo(CGSizeMake(120, 16));
    }];
    
    
//    // 排名
//    UILabel *followedLabel = [[UILabel alloc]init];
//    followedLabel.userInteractionEnabled = YES;
//    followedLabel.text = @"¥ 6";
//    followedLabel.textColor = [UIColor colorWithHexString:@"ff349d"];
//    followedLabel.font = [UIFont systemFontOfSize:14];
//    followedLabel.textAlignment = NSTextAlignmentCenter;
//    followedLabel.layer.cornerRadius = 5;
//    followedLabel.clipsToBounds = YES;
//    
//    followedLabel.layer.borderWidth = 1;
//    followedLabel.layer.borderColor = [UIColor colorWithHexString:@"dfb9e5"].CGColor;
//    [self.contentView addSubview:followedLabel];
//    [followedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView).offset(0);
//        make.right.equalTo(self.contentView).offset(-17.5 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(61, 19));
//        
//    }];
//    
//    UITapGestureRecognizer *tapFollow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(follow)];
//    [followedLabel addGestureRecognizer:tapFollow];
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(14);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.text = @"2017.07.23/12:16";
    timeLabel.textColor = [UIColor colorWithHexString:@"818181"];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-11.5);
        make.size.mas_equalTo(CGSizeMake(150*kiphone6, 13));
        
    }];
    
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"¥100000";
    numLabel.textColor = [UIColor colorWithHexString:@"000000"];
    numLabel.font = [UIFont boldSystemFontOfSize:15];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.centerX.equalTo(self.contentView).offset(0);
        make.size.mas_equalTo(CGSizeMake(90, 15));
        
    }];
    

    
    self.nameLabel = nameLabel;
    self.moneyLabel = numLabel;
    self.timeLabel = timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)follow{
    self.followClick(@"follow");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
