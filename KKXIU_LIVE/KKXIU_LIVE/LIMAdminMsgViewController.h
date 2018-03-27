//
//  LIMAdminMsgViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/18.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDHeader.h"
#import "LIMChatListModel.h"
#import "IMMessageExt/IMMessageExt.h"
@class SDChat;

@interface LIMAdminMsgViewController : UIViewController<TIMMessageListener>
- (void)onNewMessage:(TIMMessage*) msg;


@property (nonatomic,strong)SDChat *chat;
@property (nonatomic, strong)LIMChatListModel *chatListModel;

@end
