//
//  LIMGameHelpView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/23.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMSimpleInfoModel.h"

@interface LIMGameHelpView : UIView

@property (nonatomic, strong) LIMSimpleInfoModel *simpleInfoModel;

@property (nonatomic, copy) void(^backClick)(NSString *);

@property (nonatomic, assign) NSInteger gameID;


- (void)setUI;

@end
