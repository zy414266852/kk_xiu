//
//  LIMMyFollowTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMMyFollowTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface LIMMyFollowTableViewCell()
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UIImageView *peopleIcon;
@property (nonatomic, strong) UILabel *peopleCountLable;
@property (nonatomic, strong) UILabel  *cityLabel;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIImageView *gameIcon;

@end

@implementation LIMMyFollowTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"#f6f6f6"];
        [self createDetailView];
    }
    return self;
}
- (void)createDetailView{
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"livepage"];
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1.5);
        
    }];
    // 城市
    UILabel *cityLabel = [[UILabel alloc]init];
    cityLabel.text = @"北京市";
    cityLabel.textColor = [UIColor colorWithHexString:@"727272" alpha:1];
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.layer.cornerRadius = 12;
    cityLabel.clipsToBounds = YES;
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    [imageV addSubview:cityLabel];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageV).offset(-10.5);
        make.left.equalTo(imageV).offset(9);
        make.size.mas_equalTo(CGSizeMake(60, 24));
        
    }];
    
    // game icon
    UIImageView *gameIcon = [[UIImageView alloc]init];
    gameIcon.image = [UIImage imageNamed:@"home_7"];
//    [gameIcon sizeToFit];
    [self.contentView addSubview:gameIcon];
    [gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageV).offset(-52);
        make.right.equalTo(imageV).offset(-4);
        make.size.mas_equalTo(CGSizeMake(130 *kiphone6, 100 *kiphone6));
        
    }];

    
    
    // 主播名字
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"主播名字";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:24];
    [imageV addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cityLabel.mas_top).offset(-15);
        make.left.equalTo(cityLabel.mas_left).offset(1);
        make.right.equalTo(gameIcon.mas_left).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    // describe
    
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.text = @"北京市是看到你撒开了你打算离开你的卢卡斯努力的卡萨诺了卡德纳斯离开你都快懒死了哭都哭了";
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.font = [UIFont systemFontOfSize:17];
    [imageV addSubview:describeLabel];
    
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cityLabel.mas_centerY).offset(0);
        make.left.equalTo(cityLabel.mas_right).offset(10.5);
        make.right.equalTo(imageV).offset(-10.5);
        make.height.mas_equalTo(17);
        
    }];
    
    
    
    // people count
    UILabel *peopleLabel = [[UILabel alloc]init];
    peopleLabel.text = @"233333";
    peopleLabel.textColor = [UIColor whiteColor];
    peopleLabel.font = [UIFont systemFontOfSize:15];
    [imageV addSubview:peopleLabel];
    CGFloat labelW = [@"233333" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
    
    peopleLabel.frame = CGRectMake(kScreenW -7 -labelW, 5, labelW+1, 15);
    //    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(imageV).offset(5);
    //        make.right.equalTo(imageV).offset(-7);
    //        make.size.mas_equalTo(CGSizeMake(labelW +1, 15));
    //
    //    }];
    // people icon
    
    UIImageView *peopleIcon = [[UIImageView alloc]init];
    peopleIcon.image = [UIImage imageNamed:@"home_14"];
    [peopleIcon sizeToFit];
    [imageV addSubview:peopleIcon];
    
    //    [peopleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(peopleLabel.mas_bottom).offset(0);
    //        make.right.equalTo(peopleLabel.mas_left).offset(-3);
    //
    //    }];
    peopleIcon.frame = CGRectMake(kScreenW -7 -labelW - 3 - peopleIcon.image.size.width, 5, 20, 15);
    
    _backImageV = imageV;
    _peopleIcon = peopleIcon;
    _peopleCountLable = peopleLabel;
    _cityLabel = cityLabel;
    _nameLabel = nameLabel;
    _describeLabel = describeLabel;
    _gameIcon = gameIcon;
    
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

@end

