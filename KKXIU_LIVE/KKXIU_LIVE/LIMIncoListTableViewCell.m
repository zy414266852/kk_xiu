//
//  LIMIncoListTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMIncoListTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface LIMIncoListTableViewCell()

@end

@implementation LIMIncoListTableViewCell
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
//    UIImageView *imageV = [[UIImageView alloc]init];
//    imageV.image = [UIImage imageNamed:@"livepage"];
//    imageV.clipsToBounds = YES;
//    imageV.layer.cornerRadius = 17.5;
//    [self.contentView addSubview:imageV];
//    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView).offset(0);
//        make.left.equalTo(self.contentView).offset(15);
//        make.width.mas_equalTo(35);
//        make.height.mas_equalTo(35);
//        
//    }];
    
    
    
    // 城市
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"用户昵称";
    nameLabel.textColor = [UIColor colorWithHexString:@"ff349d" alpha:1];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(19.5);
        make.size.mas_equalTo(CGSizeMake(67, 15));
        
    }];
    
    UIImageView *giftV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rigt"]];
    [giftV sizeToFit];
    [self.contentView addSubview:giftV];
    [giftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel).offset(0);
        make.left.equalTo(nameLabel.mas_right).offset(18.5 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(55, 55));
        
    }];
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"¥100000";
    numLabel.textColor = [UIColor colorWithHexString:@"000000"];
    numLabel.font = [UIFont boldSystemFontOfSize:15];
    numLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel).offset(0);
        make.left.equalTo(giftV.mas_right).offset(11 );
        make.size.mas_equalTo(CGSizeMake(90, 15));
        
    }];

    
    // 贡献
    UILabel *contriLabel = [[UILabel alloc]init];
    contriLabel.text = @"2017.07.23/12:16";
    contriLabel.textColor = [UIColor colorWithHexString:@"818181"];
    contriLabel.font = [UIFont systemFontOfSize:13];
    contriLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:contriLabel];
    
    [contriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9.5);
        make.right.equalTo(self.contentView).offset(-11.5);
        make.size.mas_equalTo(CGSizeMake(120, 13));
        
    }];
    //
    //    self.score = contriLabel;
    //    // 排名

    
    // 价格
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"成 功";
    priceLabel.textColor = [UIColor colorWithHexString:@"ffb801"];
    priceLabel.font = [UIFont boldSystemFontOfSize:18];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contriLabel.mas_bottom).offset(12);
        make.centerX.equalTo(contriLabel.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 18));
        
    }];
    
    
    
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(25);
        make.width.mas_equalTo(kScreenW -25);
        make.height.mas_equalTo(1);
    }];
    
    
    
    
    
//    self.giftV = giftV;
//    self.avatar = imageV;
//    
    self.nameLabel = nameLabel;
    self.timeLabel = contriLabel;
    
    self.stateLabel = priceLabel;
    self.priceLabel = numLabel;
    
}
- (void)showPeople:(NSString *)peopleCount{
    
    // people count
    
    
    // people icon
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setDataSource:(LIMLiveListModel *)liveModel{
    
    [_backImageV sd_setImageWithURL:[NSURL URLWithString:liveModel.cover] placeholderImage:[UIImage imageNamed:@"livepage"]];
    // 人数
    _peopleCountLable.text = liveModel.usercount;
    CGFloat buttonW = [liveModel.usercount boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    
    _peopleIcon.frame = CGRectMake(kScreenW -7 -buttonW - 3 - _peopleIcon.image.size.width, 5, 20, 15);
    _peopleCountLable.frame = CGRectMake(kScreenW -7 -buttonW, 5, buttonW+1, 15);
    if ([liveModel.city isEqualToString:@""]) {
        _cityLabel.text = @"火星";
    }else{
        _cityLabel.text = liveModel.city;
    }
    _nameLabel.text = liveModel.nickname;
    if ([liveModel.livetitle isEqualToString:@""]) {
        _describeLabel.text = @"主播是火星人，她写的签名我们看不懂";
    }else{
        _describeLabel.text = liveModel.livetitle;
    }
    //    _peopleIcon;
    //    _gameIcon;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted  animated:animated];
    
    //加上这句哦
    
    //    _cityLabel.backgroundColor= [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    
}
- (void)setrankDataSource:(LIMRankModel *)liveModel{
    self.nameLabel.text = liveModel.nickname;
    self.rank.text = [NSString stringWithFormat:@"NO.%@",liveModel.rank];
    self.score.text = [NSString stringWithFormat:@"%@ 魅力",liveModel.score];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:liveModel.avatar] placeholderImage:[UIImage imageNamed:@"place_icon"]];
}
@end

