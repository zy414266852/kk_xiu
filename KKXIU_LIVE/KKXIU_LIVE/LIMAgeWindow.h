//
//  LIMAgeWindow.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMSimpleInfoModel.h"

@interface LIMAgeWindow : UIView
@property (nonatomic, strong) LIMSimpleInfoModel *simpleInfoModel;

@property (nonatomic, copy) void(^backClick)(NSString *);


- (void)setUI;

@end
