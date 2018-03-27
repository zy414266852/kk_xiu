//
//  LIMUserListCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMUserListCell.h"

@implementation LIMUserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageV.layer.cornerRadius = 15;
    self.iconImageV.clipsToBounds = YES;
    // Initialization code
}

@end
