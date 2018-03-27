//
//  LIMChatReceive.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/31.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessageExt/IMMessageExt.h"
@interface LIMChatReceive : NSObject<TIMMessageListener>
+ (LIMChatReceive *)defaultClient;
- (void)onNewMessage:(TIMMessage*) msg;

@end
