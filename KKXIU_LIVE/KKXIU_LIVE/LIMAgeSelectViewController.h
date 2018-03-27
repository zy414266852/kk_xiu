//
//  LIMAgeSelectViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMAgeSelectViewController : UIViewController
@property (nonatomic, copy) void(^backInfo)(NSDictionary *);
@property (nonatomic, strong) NSString *lastTime;
@end
