//
//  LIMReceiveMessageModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/1.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMReceiveMessageModel : NSObject
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@end
