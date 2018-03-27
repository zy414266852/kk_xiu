//
//  LIMGoldTableViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/5.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMGoldTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UIImageView *peopleIcon;
@property (nonatomic, strong) UILabel *peopleCountLable;
@property (nonatomic, strong) UILabel  *cityLabel;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIImageView *gameIcon;
@property (nonatomic, strong) UILabel  *score;
@property (nonatomic, strong) UIImageView  *followImageV;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel  *followedLabel;
@property (nonatomic, copy) void(^followClick)(NSString *);

@end

