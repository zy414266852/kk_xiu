//
//  LIMEditTableViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMLiveListModel.h"
#import "LIMRankModel.h"

@interface LIMEditTableViewCell : UITableViewCell
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




//@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *priceLabel;
@property (nonatomic, strong) UILabel  *timeLabel;
@property (nonatomic, strong) UILabel  *stateLabel;



@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *infoLabel;


- (void)setDataSource:(LIMLiveListModel *)liveModel;

- (void)setrankDataSource:(LIMRankModel *)liveModel;
@end


