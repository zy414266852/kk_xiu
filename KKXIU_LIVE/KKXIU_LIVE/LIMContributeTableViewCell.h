//
//  LIMContributeTableViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMLiveListModel.h"
#import "LIMRankModel.h"
@interface LIMContributeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UIImageView *peopleIcon;
@property (nonatomic, strong) UILabel *peopleCountLable;
@property (nonatomic, strong) UILabel  *cityLabel;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIImageView *gameIcon;



@property (nonatomic, strong) UILabel  *score;
@property (nonatomic, strong) UILabel  *rank;
@property (nonatomic, strong) UIImageView *avatar;

- (void)setDataSource:(LIMLiveListModel *)liveModel;

- (void)setrankDataSource:(LIMRankModel *)liveModel;
@end
