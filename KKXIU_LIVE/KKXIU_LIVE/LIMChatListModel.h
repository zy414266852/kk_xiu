//
//  LIMChatListModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/13.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMChatListModel : NSObject
@property (nonatomic, copy) NSString *kkID;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *chatStr;
@property (nonatomic, assign) NSInteger unReadNum;
@end
