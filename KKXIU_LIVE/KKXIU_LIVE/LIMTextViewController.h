//
//  LIMTextViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/7.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMPersonalModel.h"

@interface LIMTextViewController : UIViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *valueStr;
@property (nonatomic, assign) NSInteger length;

@property (nonatomic, strong) LIMPersonalModel *personalModel;


@property (nonatomic, copy) void(^backInfo)(NSString *);
@end
