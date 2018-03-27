//
//  LIMAddCoverViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMAddCoverViewController : UIViewController
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *valueStr;
@property (nonatomic, assign) NSInteger length;



@property (nonatomic, copy) void(^backInfo)(NSString *);

@end
