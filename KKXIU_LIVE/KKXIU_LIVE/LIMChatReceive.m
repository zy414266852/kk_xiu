//
//  LIMChatReceive.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/31.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMChatReceive.h"
#import "LIMChatModel.h"
#import "LIMWinPrize.h"
@implementation LIMChatReceive

+ (LIMChatReceive *)defaultClient{
    static LIMChatReceive *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc]init];
    });
    return userModel;
}
- (void)onNewMessage:(NSArray*) msgs {
   
    TIMMessage * message = msgs.firstObject;
     NSLog(@"NewMessages: %@,,,%@", msgs,[message getConversation].getReceiver);
    int cnt = [message elemCount];
    TIMElem * elem = [message getElem:0];
    NSLog(@"message ===================================== %d ,,%@",cnt,msgs);
    
    if ([elem isKindOfClass:[TIMTextElem class]]) {
        TIMTextElem * text_elem = (TIMTextElem * )elem;
    
//    for (int i = 0; i < cnt; i++) {
//        TIMTextElem * elem = [message getElem:0];
    NSLog(@".........%@",text_elem.text);
    
    
    NSData *jsonData = [text_elem.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
    }else{
        NSLog(@"%@",dic);
        NSNumber *num = dic[@"userAction"];
        if ([num integerValue] == 1 || [num integerValue] == 5) {            // 聊天消息
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            NSString *userName = dic[@"nickName"];
            NSString *userIcon = dic[@"headPic"];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.sentence = [NSString stringWithFormat:@"%@:%@",nickeName,msg];
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = [NSString stringWithFormat:@"%@",num];
            chatModel.isUp = isUp;
            chatModel.level = level;
            chatModel.msg = msg;
            chatModel.userIcon = userIcon;
            chatModel.userName = userName;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
        }else if ([num integerValue] == 2) {     // 用户进入
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.sentence = [NSString stringWithFormat:@"%@ %@",nickeName,msg];
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = @"2";
            chatModel.isUp = isUp;
            chatModel.level = level;
            chatModel.userName = nickeName;
            chatModel.userIcon = dic[@"headPic"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
            if ([level intValue] >0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserList" object:nil];
            }
        }
        else if ([num integerValue] == 6) {        // 礼物
            NSString *userName = dic[@"nickName"];
            NSString *userIcon = dic[@"headPic"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *giftCount = dic[@"giftCount"];
            NSString *giftID = dic[@"giftId"];
            NSString *giftname = dic[@"giftName"];
            NSString *giftIcon = dic[@"giftIcon"];
            
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.sentence = [NSString stringWithFormat:@"%@ %@",nickeName,msg];
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = @"6";
            chatModel.isUp = isUp;
            chatModel.level = level;
            chatModel.giftID = giftID;
            chatModel.giftCount = giftCount;
            chatModel.giftname = giftname;
            chatModel.giftimg = giftIcon;
            chatModel.userName = userName;
            chatModel.userIcon = userIcon;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
        }
        else if ([num integerValue] == 7) {            // 分享
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.sentence = [NSString stringWithFormat:@"%@ %@",nickeName,msg];
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = @"7";
            chatModel.isUp = isUp;
            chatModel.level = level;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
        }
        else if ([num integerValue] == 8) {         // 关注
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.sentence = [NSString stringWithFormat:@"%@ %@",nickeName,msg];
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = @"8";
            chatModel.isUp = isUp;
            chatModel.level = level;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
        }else if ([num integerValue] == 9) {         // 关注
            NSString *nickeName = dic[@"nickName"];
            NSString *msg = dic[@"msg"];
            NSString *level = dic[@"level"];
            NSString *isUp = dic[@"isHost"];
            
            NSData *jsonData = [msg dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            
            NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            if(err) {
                
                NSLog(@"json解析失败：%@",err);
                
            }else{
            NSString *winmoney = dic2[@"winmoney"];
                NSString *prizeInfo = dic2[@"msg"];
                NSLog(@"%@",dic2);
                
            LIMWinPrize *infoModel = [LIMWinPrize mj_objectWithKeyValues:dic2];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
                if (prizeInfo.length >0) {
                    chatModel.sentence = [NSString stringWithFormat:@"%@ %@",nickeName,prizeInfo];
                }else{
                    chatModel.sentence = [NSString stringWithFormat:@"%@ 赢得了%@个金币",nickeName,winmoney];
                }
            chatModel.nameLength = nickeName.length +1;
            chatModel.type = @"9";
            chatModel.isUp = isUp;
            chatModel.level = level;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveMessage" object:chatModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"receivePrize" object:infoModel];
            }
        }else{
            
        }
    }
    }
    else if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
        TIMGroupSystemElem * image_elem = (TIMGroupSystemElem * )elem;
        NSString *result = [[NSString alloc] initWithData:image_elem.userData  encoding:NSUTF8StringEncoding];
        if([result hasPrefix:@"#GameServerMsg#"]){
            NSString *infoString = [result substringFromIndex:15];
            
            
            NSData *jsonData = [infoString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                 
                                                                options:NSJSONReadingMutableContainers
                                 
                                                                  error:&err];
            NSLog(@"%@",dic);
            
            if(err) {
                
                NSLog(@"json解析失败：%@",err);
                
            }else{
                    LIMWinPrize *infoModel = [LIMWinPrize mj_objectWithKeyValues:dic];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"receivePrize" object:infoModel];
            }
        }
        
    }

}

@end
