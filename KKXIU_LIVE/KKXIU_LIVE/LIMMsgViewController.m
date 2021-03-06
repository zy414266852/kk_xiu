
//
//  LIMMsgViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMMsgViewController.h"
#import "ImSDK/ImSDK.h"
//#import "ImSDK/TIMManager.h"
//#import "ImSDK/IMSdkInt.h"

#import "TLSSDK/TLSHelper.h"
#import "IMGroupExt/IMGroupExt.h"
#import "IMMessageExt/IMMessageExt.h"
#import <IMFriendshipExt/IMFriendshipExt.h>
#import "MJRefresh.h"
#import "UIBarButtonItem+Helper.h"


#import "LIMChatListTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import <RKNotificationHub.h>
#import "LIMOtherInfoViewController.h"
#import "LIMChatListModel.h"
#import <UIImageView+WebCache.h>
#import "LIMStrangerMsgViewController.h"
#import "SDChatDetailViewController.h"
#import "SDChat.h" //聊天对话模型
#import "LIMAdminMsgViewController.h"
#import "LIMNoticeMsgViewController.h"

#define strangerKKID @"stranger"
#define noticeKKID @"notice"
#define adminKKID @"admin"


#define strangeIcon @"msglist_1"
#define noticeIcon @"msglist_3"
#define adminIcon @"msglist_2"

@interface LIMMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LIMChatListModel *adminChat;         // 系统消息  im获取
@property (nonatomic, strong) LIMChatListModel *noticeChat;
@property (nonatomic, strong) LIMChatListModel *strangerChat;

@property (nonatomic, strong) NSMutableArray *allList;              //   存储所有会话。type == 1 的
@property (nonatomic, strong) NSMutableArray *strangerList;       // 陌生人
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NSMutableArray *sysNoticeList;       // 系统公告， 服务器获取



//@property (nonatomic,strong)NSMutableArray *dataArr; //消息数据源
@end

@implementation LIMMsgViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (NSMutableArray *)strangerList{
    if (_strangerList == nil) {
        _strangerList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _strangerList;
}
- (NSMutableArray *)friendList{
    if (_friendList == nil) {
        _friendList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _friendList;
}
- (NSMutableArray *)sysNoticeList{
    if (_sysNoticeList == nil) {
        _sysNoticeList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _sysNoticeList;
}
- (NSMutableArray *)allList{
    if (_allList == nil) {
        _allList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _allList;
}
/**
 总数据源
 
 @return 总数据
 */
//-(NSMutableArray *)dataArr{
//    if(!_dataArr){
//
//        NSArray *arr =@[
//                        @{@"nickName":@"slowdony",@"lastMsg":@"哈哈",@"sendTime":@"06/06",@"nickNameID":@"1"},
//                        @{@"nickName":@"danny",@"lastMsg":@"[图片]",@"sendTime":@"06/07",@"nickNameID":@"1"},
//                        ];
//        _dataArr =[[NSMutableArray alloc]initWithArray:arr];
//    }
//    return _dataArr;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"忽略未读" selectTitle:@"忽略未读" target:self action:@selector(overlook)];
    self.noticeChat = [[LIMChatListModel alloc]init];
    self.adminChat = [[LIMChatListModel alloc]init];
    self.strangerChat = [[LIMChatListModel alloc]init];
    [self creteTableView];
    [self httpSysNotice];
    // Do any additional setup after loading the view.
}
- (void)creteTableView{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH -64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
//    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc]init];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMChatListTableViewCell class] forCellReuseIdentifier:@"LIMChatListTableViewCell"];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpSysNotice)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMChatListModel *chatListModel = self.dataSource[indexPath.row];
    if ([chatListModel.kkID isEqualToString:strangerKKID]) {     // 陌生人消息
        LIMStrangerMsgViewController *stranger  = [[LIMStrangerMsgViewController alloc]init];
        [self.navigationController pushViewController:stranger animated:YES];
    }else if ([chatListModel.kkID isEqualToString:noticeKKID]) { // 系统公告
        LIMNoticeMsgViewController *stranger  = [[LIMNoticeMsgViewController alloc]init];
        stranger.sysNoticeList = self.sysNoticeList;
        [self.navigationController pushViewController:stranger animated:YES];
    }else if ([chatListModel.kkID isEqualToString:adminKKID]) { // 系统消息
        LIMAdminMsgViewController *v =[[LIMAdminMsgViewController alloc]init];
        v.chatListModel = chatListModel;
        [self.navigationController pushViewController:v animated:YES];
    }else
    {
        SDChatDetailViewController *v =[[SDChatDetailViewController alloc]init];
        v.chatListModel = chatListModel;
        [self.navigationController pushViewController:v animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMChatListModel *chatListModel = self.dataSource[indexPath.row];
    LIMChatListTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMChatListTableViewCell" forIndexPath:indexPath];
    hotLiveCell.nameLabel.text = chatListModel.nickName;
    NSLog(@"icon  ==== %@",chatListModel.iconUrl);
    if (chatListModel.iconUrl.length <10) {
        hotLiveCell.avatar.image = [UIImage imageNamed:chatListModel.iconUrl];
        hotLiveCell.nameLabel.textColor = [UIColor colorWithHexString:@"643300"];
        hotLiveCell.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    }else{
        hotLiveCell.nameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        hotLiveCell.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [hotLiveCell.avatar sd_setImageWithURL:[NSURL URLWithString:chatListModel.iconUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];}
    hotLiveCell.score.text = chatListModel.chatStr;
    hotLiveCell.timeLabel.text = [self compareCurrentTime:chatListModel.time];
    
    if (chatListModel.unReadNum >0) {
        if(indexPath.row !=0){
            [hotLiveCell.hub incrementBy:chatListModel.unReadNum];}
        else{
            [hotLiveCell.hub hideCount];
            }
    }else{
        [hotLiveCell.hub decrement];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return hotLiveCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if(self.dataSource.count > 0){
        [self.tableView.mj_header beginRefreshing];
//        [self httpSysNotice];
    }
    
}


- (void)refreshMsg{
    
    NSMutableArray *type_1List = [[NSMutableArray alloc]initWithCapacity:2];
    // 拿到会话列表
    NSArray * conversations = [[TIMManager sharedInstance] getConversationList];
    for (int i = 0; i <conversations.count; i++) {
        NSArray *infoStr = [[NSString stringWithFormat:@"%@",conversations[i]] componentsSeparatedByString:@" "];
        NSString *type = [[NSString stringWithFormat:@"%@",infoStr[1]] substringWithRange:NSMakeRange(5, 1)];
        if ([type isEqualToString:@"1"]) {
            
            NSArray *receiver = [[NSString stringWithFormat:@"%@",infoStr[2]] componentsSeparatedByString:@"="];
            
            [type_1List addObject:[NSString stringWithFormat:@"%@",receiver[1]]];
        }
    }
    NSLog(@"kkidList = %@",type_1List);
    
    [[TIMFriendshipManager sharedInstance] getUsersProfile:type_1List succ:^(NSArray * arr) {
        [arr enumerateObjectsUsingBlock:^(TIMUserProfile * profile, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"user=%@", profile);
            // kkid
            TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:profile.identifier];
            NSArray *lastMessage = [c2c_conversation getLastMsgs:(uint32_t)1];
            
            
            TIMMessage * msg = lastMessage.firstObject;
            TIMTextElem * text_elem = (TIMTextElem *)[msg getElem:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:msg.timestamp];
            
            NSLog(@"time = %@ text = %@\n kkid = %@",strDate,text_elem.text,profile.identifier);
            // 会话列表model
            LIMChatListModel *chatListModel = [[LIMChatListModel alloc]init];
            chatListModel.chatStr = text_elem.text;
            chatListModel.time = strDate;
            chatListModel.kkID = profile.identifier;
            chatListModel.iconUrl = profile.faceURL;
            chatListModel.nickName = profile.nickname;
            chatListModel.unReadNum = (NSInteger)[c2c_conversation getUnReadMessageNum];
            [self.allList addObject:chatListModel];
            //            [self.tableView reloadData];
            
        }];
        [self intoGroups:type_1List];
    }fail:^(int code, NSString * err) {
        NSLog(@"GetFriendsProfile fail: code=%d err=%@", code, err);
        NSLog(@"用户列表为空");
        [self.dataSource removeAllObjects];
        // 系统公告
        [self.dataSource addObject:self.noticeChat];
        [self.tableView reloadData];
        
    }];
    
}
- (void)intoGroups:(NSArray *)idList{
    
    // 清空原来数据
    [self.dataSource removeAllObjects];
    [self.friendList removeAllObjects];
    [self.strangerList removeAllObjects];
    self.adminChat = nil;
    //
    
    //    NSMutableArray * users = [[NSMutableArray alloc] init];
    //    for (NSString *kkid in idList) {
    //        TIMAddFriendRequest* req = [[TIMAddFriendRequest alloc] init];
    //        // 添加好友 iOS_002
    //        req.identifier = kkid;//[NSString stringWithUTF8String:"iOS_002"];
    //        [users addObject:req];
    //    }
    //    [[TIMFriendshipManager sharedInstance] addFriend:users succ:^(NSArray * arr) {
    //        [arr enumerateObjectsUsingBlock:^(TIMFriendResult * res, NSUInteger idx, BOOL * _Nonnull stop) {
    //            if (res.status == TIM_ADD_FRIEND_STATUS_ALREADY_FRIEND) {  // 好友消息
    //                LIMChatListModel *model = self.allList[idx];
    //                NSLog(@"好友 %@",model.kkID);
    //                if ([model.kkID isEqualToString:@"admin"]) {
    //                    self.adminChat = self.allList[idx];
    //                }else{
    //                    [self.friendList addObject:self.allList[idx]];
    //                }
    //
    //            }else{// 非好友关系
    //                LIMChatListModel *model = self.allList[idx];
    //                NSLog(@"陌生人 %@",model.kkID);
    //                if ([model.kkID isEqualToString:@"admin"]) {
    //                    self.adminChat = self.allList[idx];
    //                }else{
    //                    [self.strangerList addObject:self.allList[idx]];
    //                }
    //
    //            }
    //        }];
    //
    //        NSLog(@"好友 = %ld \n  陌生人= %@",self.friendList.count,self.strangerList);
    //
    //        [self.dataSource removeAllObjects];
    //        NSLog(@"最开始  好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
    //        // 陌生人消息
    //        if (self.strangerList.count >0) {
    //            LIMChatListModel *model = self.strangerList[0];
    //            model.kkID = strangerKKID;
    //            model.iconUrl = strangeIcon;
    //            model.nickName = @"陌生人消息";
    //            [self.dataSource addObject:model];
    //        }
    //        // 系统公告
    //        [self.dataSource addObject:self.noticeChat];
    //
    //        // 系统通知
    //        if (self.adminChat) {
    //            self.adminChat.kkID = adminKKID;
    //            self.adminChat.iconUrl = adminIcon;
    //            self.adminChat.nickName = @"系统通知";
    //            [self.dataSource addObject:self.adminChat];
    //        }
    //
    //        NSLog(@"前三行 %ld",self.dataSource.count);
    //        NSLog(@"未加 之前  好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
    //        // 好友消息
    //        NSArray *array = self.friendList;
    //        [self.dataSource addObjectsFromArray:array];
    //        NSLog(@"好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
    //
    //        [self.tableView reloadData];
    //
    //    } fail:^(int code, NSString * err) {
    //        NSLog(@"add friend fail: code=%d err=%@", code, err);
    //    }];
    NSMutableArray *allFriendList = [[NSMutableArray alloc]init];
    [[TIMFriendshipManager sharedInstance] getFriendList:^(NSArray *friends) {
        for (TIMUserProfile * profile in friends) {
            [allFriendList addObject:profile.identifier];
        }
        NSLog(@"好友列表 %@",self.allList);
        
        for(int i = 0 ; i <self.allList.count; i++){
            LIMChatListModel *allModel = self.allList[i];
            NSString *idStr = allModel.kkID;
            
            BOOL isFriend = false;
            for (NSString *friendID in allFriendList) {
                if ([friendID isEqualToString:idStr]) {
                    LIMChatListModel *model = self.allList[i];
                    NSLog(@"id %@",idStr);
                    NSLog(@"好友 %@",model.kkID);
                    if ([model.kkID isEqualToString:adminKKID]) {
                        self.adminChat = self.allList[i];
                    }else{
                        [self.friendList addObject:self.allList[i]];
                    }
                    isFriend = true;
//                    break;
                }
            }
            if (!isFriend) {
                LIMChatListModel *model = self.allList[i];
                NSLog(@"陌生人 %@",model.kkID);
                if ([model.kkID isEqualToString:@"admin"]) {
                    self.adminChat = self.allList[i];
                }else{
                    [self.strangerList addObject:self.allList[i]];
                }
            }
        }
        
        
        NSLog(@"好友 = %ld \n  陌生人= %@",self.friendList.count,self.strangerList);
        
        [self.dataSource removeAllObjects];
        NSLog(@"最开始  好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
        // 陌生人消息
        if (self.strangerList.count >0) {
            LIMChatListModel *model = self.strangerList[0];
            model.kkID = strangerKKID;
            model.iconUrl = strangeIcon;
            model.nickName = @"陌生人消息";
            [self.dataSource addObject:model];
        }
        // 系统公告
        [self.dataSource addObject:self.noticeChat];
        
        // 系统通知
        if (self.adminChat) {
            self.adminChat.kkID = adminKKID;
            self.adminChat.iconUrl = adminIcon;
            self.adminChat.nickName = @"系统通知";
            [self.dataSource addObject:self.adminChat];
        }
        
        NSLog(@"前三行 %ld",self.dataSource.count);
        NSLog(@"未加 之前  好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
        // 好友消息
        NSArray *array = self.friendList;
        [self.dataSource addObjectsFromArray:array];
        NSLog(@"好友 %ld。=====所有 %ld",self.friendList.count,self.dataSource.count);
        
        [self.tableView reloadData];
        
    } fail:^(int code, NSString *msg) {
        
        NSLog(@"用户列表为空");
        [self.dataSource removeAllObjects];
        // 系统公告
        [self.dataSource addObject:self.noticeChat];
        [self.tableView reloadData];
    }];
    
}
// 系统公告。  开始请求会话列表
- (void)httpSysNotice{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mSysNotice method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.allList removeAllObjects];
        [self.dataSource removeAllObjects];
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSArray *sysList = responseObject[@"result"][@"list"];
            
            [self.sysNoticeList removeAllObjects];
            [self.sysNoticeList addObjectsFromArray: sysList];
            //            for (NSDictionary *dict in sysList) {
            //
            //            }
            self.noticeChat.kkID = noticeKKID;
            self.noticeChat.nickName = @"系统公告";
            self.noticeChat.iconUrl = @"msglist_3";
            NSDictionary *sysLastMessage = self.sysNoticeList[0];
            self.noticeChat.chatStr = sysLastMessage[@"sysmsg"];
            self.noticeChat.time = sysLastMessage[@"time"];
            [self refreshMsg];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//// 取关他人
//- (void)followOther:(NSInteger)indexPath{
//
//    LIMFollowModel *followModel = self.dataSource[indexPath];
//
//    NSString *touid = followModel.uid;
//
//    CcUserModel *userModel = [CcUserModel defaultClient];
//
//    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"touid":touid}];
//    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret]];
//    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
//    [[HttpClient defaultClient] requestWithPath:mFollow_delete method:1 parameters:paraDict prepareExecute:^{
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSString * rescode = responseObject[@"rescode"];
//        if ([rescode isEqualToString:@"1"]) {
//            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath inSection:0];
//            [self.dataSource removeObjectAtIndex:indexPath2.row];
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView reloadData];
//        }else{
//            NSString * resmsg = responseObject[@"resmsg"];
//            NSLog(@"resmsg = %@",resmsg);
//            [self showAlertWithMessage:resmsg];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//}

- (void)overlook{
    
}


- (NSString *) compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if([str rangeOfString:@"-"].location !=NSNotFound){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval/60 < 1) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return result;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
