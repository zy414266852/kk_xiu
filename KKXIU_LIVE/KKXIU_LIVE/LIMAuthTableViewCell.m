//
//  LIMAuthTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMAuthTableViewCell.h"
#import <UIImageView+WebCache.h>

@implementation LIMAuthTableViewCell

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
    nameLabel.text = @"xx K币";
    nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(18);
        make.size.mas_equalTo(CGSizeMake(120, 16));
    }];
    
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.image = [UIImage imageNamed:@"right"];
    [imageV sizeToFit];
        [self.contentView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(-18.5);
    
        }];
        self.avatar = imageV;
    
    
    // 城市
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.text = @"xx K币";
    infoLabel.textColor = [UIColor colorWithHexString:@"c7c7cc"];
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(0);
        make.right.equalTo(imageV.mas_left).offset(-14.5);
        make.size.mas_equalTo(CGSizeMake(200, 16));
    }];
    
    
  
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(14);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    
    
    self.nameLabel = nameLabel;
    self.infoLabel = infoLabel;

    
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
