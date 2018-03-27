//
//  LIMLiveEndViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMLiveEndViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *charmCount;
@property (weak, nonatomic) IBOutlet UIButton *backHome;
- (IBAction)backHomeClick:(UIButton *)sender;

@property (nonatomic, copy) void(^backClick)(NSString *);


@end
