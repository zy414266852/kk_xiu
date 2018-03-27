//
//  LIMChatModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/31.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMChatModel : NSObject
@property (nonatomic, assign) CGFloat nameLength;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, copy) NSString *sentence;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) CGFloat labelH;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIcon;

@property (nonatomic, copy) NSString *isUp;
@property (nonatomic, copy) NSString *level;


@property (nonatomic, copy) NSString *giftID;
@property (nonatomic, copy) NSString *giftCount;
@property (nonatomic, copy) NSString *giftname;
@property (nonatomic, copy) NSString *giftimg;
@end
