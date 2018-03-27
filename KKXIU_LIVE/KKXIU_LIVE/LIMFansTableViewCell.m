//
//  LIMFansTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/4.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMFansTableViewCell.h"
#import <UIImageView+WebCache.h>
@interface LIMFansTableViewCell()

@end


@implementation LIMFansTableViewCell

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
    imageV.layer.cornerRadius = 32;
    [self.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(14);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
        
    }];
    self.avatar = imageV;
    
    // 城市
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"人 名";
    nameLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(24);
        make.left.equalTo(imageV.mas_right).offset(7.5);
        make.size.mas_equalTo(CGSizeMake(60, 14));
        
    }];
    
    // 贡献
    UILabel *contriLabel = [[UILabel alloc]init];
    contriLabel.text = @"贡献";
    contriLabel.textColor = [UIColor colorWithHexString:@"909090"];
    contriLabel.font = [UIFont systemFontOfSize:12];
    contriLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contriLabel];
    
    [contriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.left.equalTo(nameLabel.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 13));
        
    }];
    self.score = contriLabel;
    
    // 排名
    UILabel *followedLabel = [[UILabel alloc]init];
    followedLabel.userInteractionEnabled = YES;
    followedLabel.text = @"移除";
    followedLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
    followedLabel.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    followedLabel.font = [UIFont systemFontOfSize:12];
    followedLabel.textAlignment = NSTextAlignmentCenter;
    //    followedLabel.hidden = YES;
    followedLabel.layer.cornerRadius = 21/2.0;
    followedLabel.clipsToBounds = YES;
    [self.contentView addSubview:followedLabel];
    [followedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-11.5 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(47.5, 21));
        
    }];
    
    //    UIImageView *followImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Search_Search_图层-1"]];
    UITapGestureRecognizer *tapFollow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(follow)];
    [followedLabel addGestureRecognizer:tapFollow];
    //    [self.contentView addSubview:followImageV];
    //    [followImageV mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.contentView).offset(0);
    //        make.right.equalTo(self.contentView).offset(-11.5 *kiphone6);
    //        make.size.mas_equalTo(CGSizeMake(47.5, 21));
    //
    //    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(14);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    //    self.followImageV = followImageV;
    
    self.nameLabel = nameLabel;
    
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
- (void)setrankDataSource:(LIMFollowModel *)liveModel{
    self.followModel = liveModel;
    self.nameLabel.text = liveModel.nickname;
    //    self.rank.text = [NSString stringWithFormat:@"NO.%@",liveModel.rank];
    self.score.text = [NSString stringWithFormat:@"%@",liveModel.personsign];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:liveModel.avatar] placeholderImage:[UIImage imageNamed:@"place_icon"]];
}
- (void)followSuccess{
    self.followImageV.hidden = YES;
    self.followedLabel.hidden = NO;
}
@end
