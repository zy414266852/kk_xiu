//
//  LIMPushNoticeViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/20.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDHeader.h"
#import "LIMChatListModel.h"
#import "IMMessageExt/IMMessageExt.h"
@class SDChat;

@interface LIMPushNoticeViewController : UIViewController<TIMMessageListener>
- (void)onNewMessage:(TIMMessage*) msg;


@property (nonatomic,strong)SDChat *chat;
@property (nonatomic, strong)LIMChatListModel *chatListModel;
@property (nonatomic,strong)NSMutableArray *dataArr; //消息数据源
@property (nonatomic, strong)NSArray *sysNoticeList;


@end
