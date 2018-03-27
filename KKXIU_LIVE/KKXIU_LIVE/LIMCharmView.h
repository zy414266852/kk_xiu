//
//  LIMCharmView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMCharmView : UIImageView
@property (nonatomic, strong) NSString *touid;
- (instancetype)initWithTouid:(NSString *)touid;
@end
