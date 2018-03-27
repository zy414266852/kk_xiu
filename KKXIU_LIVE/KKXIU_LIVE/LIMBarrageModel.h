//
//  LIMBarrageModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/12/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMBarrageModel : NSObject
@property (nonatomic, copy) NSString *videoTime;
@property (nonatomic, copy) NSString *barrageType;
@property (nonatomic, copy) NSString *fontSize;
@property (nonatomic, copy) NSString *barrageColor;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *barragePoolId;
@property (nonatomic, copy) NSString *userHash;
@property (nonatomic, copy) NSString *barrageID;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, copy) NSAttributedString *attString;

@end
