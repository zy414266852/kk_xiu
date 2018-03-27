//
//  LIMContributeTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMContributeTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface LIMContributeTableViewCell()

@end


@implementation LIMContributeTableViewCell


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
    imageV.image = [UIImage imageNamed:@"livepage"];
    imageV.clipsToBounds = YES;
    imageV.layer.cornerRadius = 15;
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(40);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
    
    }];
    self.avatar = imageV;

    // 城市
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"人 名";
    nameLabel.textColor = [UIColor colorWithHexString:@"ffffff" alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(22.5);
        make.left.equalTo(imageV.mas_right).offset(35.5);
        make.size.mas_equalTo(CGSizeMake(60, 14));
        
    }];
    
    // 贡献
    UILabel *contriLabel = [[UILabel alloc]init];
    contriLabel.text = @"贡献";
    contriLabel.textColor = [UIColor colorWithHexString:@"909090"];
    contriLabel.font = [UIFont systemFontOfSize:13];
    contriLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contriLabel];
    
    [contriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(6);
        make.left.equalTo(nameLabel.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(29, 13));
        
    }];
    
    // 贡献值
    UILabel *valueLabel = [[UILabel alloc]init];
    valueLabel.text = @"1300 魅力";
    valueLabel.textColor = [UIColor colorWithHexString:@"ff4ba9"];
    valueLabel.font = [UIFont systemFontOfSize:13];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:valueLabel];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(6);
        make.left.equalTo(contriLabel.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 13));
        
    }];
    
    self.score = valueLabel;
    
    // 排名
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"NO.2";
    numLabel.textColor = [UIColor colorWithHexString:@"ffb801"];
    numLabel.font = [UIFont systemFontOfSize:17];
    numLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-41.5 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(17*4, 17));
        
    }];
    
    self.rank = numLabel;
    
    self.nameLabel = nameLabel;


//
//    
//    
//    
//    // 主播名字
//    UILabel *nameLabel = [[UILabel alloc]init];
//    nameLabel.text = @"主播名字";
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.font = [UIFont systemFontOfSize:24];
//    [imageV addSubview:nameLabel];
//    
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(cityLabel.mas_top).offset(-15);
//        make.left.equalTo(cityLabel.mas_left).offset(1);
//        make.size.mas_equalTo(CGSizeMake(120, 24));
//    }];
//    
//    
//    // describe
//    
//    UILabel *describeLabel = [[UILabel alloc]init];
//    describeLabel.text = @"北京市是看到你撒开了你打算离开你的卢卡斯努力的卡萨诺了卡德纳斯离开你都快懒死了哭都哭了";
//    describeLabel.textColor = [UIColor whiteColor];
//    describeLabel.font = [UIFont systemFontOfSize:17];
//    [imageV addSubview:describeLabel];
//    
//    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(cityLabel.mas_centerY).offset(0);
//        make.left.equalTo(cityLabel.mas_right).offset(10.5);
//        make.right.equalTo(imageV).offset(-10.5);
//        make.height.mas_equalTo(17);
//        
//    }];
//    
//    // game icon
//    UIImageView *gameIcon = [[UIImageView alloc]init];
//    gameIcon.image = [UIImage imageNamed:@"home_7"];
//    [gameIcon sizeToFit];
//    [self.contentView addSubview:gameIcon];
//    [gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(imageV).offset(-52);
//        make.right.equalTo(imageV).offset(-4);
//        
//    }];
//    
//    
//    // people count
//    UILabel *peopleLabel = [[UILabel alloc]init];
//    peopleLabel.text = @"233333";
//    peopleLabel.textColor = [UIColor whiteColor];
//    peopleLabel.font = [UIFont systemFontOfSize:15];
//    [imageV addSubview:peopleLabel];
//    CGFloat labelW = [@"233333" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
//    
//    peopleLabel.frame = CGRectMake(kScreenW -7 -labelW, 5, labelW+1, 15);
//    //    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.top.equalTo(imageV).offset(5);
//    //        make.right.equalTo(imageV).offset(-7);
//    //        make.size.mas_equalTo(CGSizeMake(labelW +1, 15));
//    //
//    //    }];
//    // people icon
//    
//    UIImageView *peopleIcon = [[UIImageView alloc]init];
//    peopleIcon.image = [UIImage imageNamed:@"home_14"];
//    [peopleIcon sizeToFit];
//    [imageV addSubview:peopleIcon];
//    
//    //    [peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.bottom.equalTo(peopleLabel.mas_bottom).offset(0);
//    //        make.right.equalTo(peopleLabel.mas_left).offset(-3);
//    //
//    //    }];
//    peopleIcon.frame = CGRectMake(kScreenW -7 -labelW - 3 - peopleIcon.image.size.width, 5, 20, 15);
//    
//    _backImageV = imageV;
//    _peopleIcon = peopleIcon;
//    _peopleCountLable = peopleLabel;
//    _cityLabel = cityLabel;
//    _nameLabel = nameLabel;
//    _describeLabel = describeLabel;
//    _gameIcon = gameIcon;
    
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
    //    NSLog(@"count = %@,btnW = %g",liveModel.usercount,buttonW);
    //    [_peopleCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_backImageV).offset(5);
    //        make.right.equalTo(_backImageV).offset(-7);
    //        make.size.mas_equalTo(CGSizeMake(buttonW +1, 15));
    //
    //    }];
    //    [_peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(_peopleCountLable.mas_bottom).offset(0);
    //        make.right.equalTo(_peopleCountLable.mas_left).offset(-3);
    //
    //    }];
    
    
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
