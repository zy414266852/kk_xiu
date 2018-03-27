//
//  LIMImageView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIMImageView : UIImageView

@property (nonatomic, strong)NSArray *imageArr;

@property (nonatomic, assign)NSInteger currIndex;

@property (nonatomic, assign)CGFloat after;

@end
