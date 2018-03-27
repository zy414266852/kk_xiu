//
//  LIMUPInfo.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/24.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMSimpleInfoModel.h"

@interface LIMUPInfo : UIView

@property (nonatomic, strong) LIMSimpleInfoModel *simpleInfoModel;

@property (nonatomic, copy) void(^backClick)(id);


- (void)setUI;
- (void)dismiss:(UITapGestureRecognizer *)tap;
@end
