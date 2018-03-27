//
//  LIMShareView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/12.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMShareView : UIView
//@property (nonatomic, strong) LIMSimpleInfoModel *simpleInfoModel;

@property (nonatomic, copy) void(^backClick)(NSString *);

@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *ewmshareurl;

- (void)setUI;

@end
