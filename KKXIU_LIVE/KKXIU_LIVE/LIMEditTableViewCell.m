//
//  LIMEditTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMEditTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation LIMEditTableViewCell
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
    
    // 城市
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"昵称";
    nameLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(18);
        make.size.mas_equalTo(CGSizeMake(64 +2, 16));
        
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"right"];
//    [imageV sizeToFit];
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-18.5);
        make.size.mas_equalTo(CGSizeMake(6.5, 11));
    }];
    self.avatar = imageV;
    
    
    
    
    // 城市
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.text = @"姓名";
    infoLabel.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(nameLabel.mas_right).offset(14.5);

        make.right.equalTo(imageV.mas_left).offset(-14.5);
//        make.size.mas_equalTo(CGSizeMake(200, 16));
        make.height.mas_equalTo(16);
    }];
    
    
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(18);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    
    
    self.nameLabel = nameLabel;
    self.infoLabel = infoLabel;
    
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

