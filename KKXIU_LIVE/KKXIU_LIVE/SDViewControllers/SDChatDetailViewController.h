//
//  SDChatDetailViewController.h
//  SDChat
//
//  Created by Megatron Joker on 2017/5/5.
//  Copyright © 2017年 SlowDony. All rights reserved.
//
/**
 聊天
 */
#import <UIKit/UIKit.h>
#import "SDHeader.h"
#import "LIMChatListModel.h"
#import "IMMessageExt/IMMessageExt.h"
@class SDChat;
@interface SDChatDetailViewController : UIViewController<TIMMessageListener>
- (void)onNewMessage:(TIMMessage*) msg;


@property (nonatomic,strong)SDChat *chat;
@property (nonatomic, strong)LIMChatListModel *chatListModel;

@end
