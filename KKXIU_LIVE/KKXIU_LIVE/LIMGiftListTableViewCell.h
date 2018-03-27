//
//  LIMGiftListTableViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMLiveListModel.h"
#import "LIMRankModel.h"
@interface LIMGiftListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UIImageView *peopleIcon;
@property (nonatomic, strong) UILabel *peopleCountLable;
@property (nonatomic, strong) UILabel  *cityLabel;

@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIImageView *gameIcon;



@property (nonatomic, strong) UILabel  *score;
@property (nonatomic, strong) UILabel  *rank;




@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *giftV;

@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *timeLabel;

@property (nonatomic, strong) UILabel  *countLabel;
@property (nonatomic, strong) UILabel  *priceLabel;

- (void)setDataSource:(LIMLiveListModel *)liveModel;

- (void)setrankDataSource:(LIMRankModel *)liveModel;
@end
