//
//  LIMGameCollectionViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/27.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMGameCollectionViewCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
//@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
//@property (weak, nonatomic) IBOutlet UILabel *gameName;


@property (strong, nonatomic) UIImageView *coverImage;
@property (strong, nonatomic) UIImageView *giftIcon;
@property (strong, nonatomic) UILabel *money;
@property (strong, nonatomic) UIImageView *gold;
@property (strong, nonatomic) UIImageView *selectImage;


@end
