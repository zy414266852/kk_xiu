//
//  LIMLiveShareView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMSimpleInfoModel.h"
@interface LIMLiveShareView : UIView
@property (nonatomic, strong) LIMSimpleInfoModel *simpleInfoModel;

@property (nonatomic, copy) void(^backClick)(NSString *);
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *ewmshareurl;

- (void)setUI;
@end
