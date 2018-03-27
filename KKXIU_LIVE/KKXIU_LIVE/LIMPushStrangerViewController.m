//
//  LIMPushStrangerViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/20.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPushStrangerViewController.h"
#import "ImSDK/ImSDK.h"

#import "TLSSDK/TLSHelper.h"
#import "IMGroupExt/IMGroupExt.h"
#import "IMMessageExt/IMMessageExt.h"
#import <IMFriendshipExt/IMFriendshipExt.h>
//#import "SDChatDetailViewController.h"
#import "LIMPushChatDetaiViewController.h"



#import "LIMChatListTableViewCell.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "LIMOtherInfoViewController.h"
#import "LIMChatListModel.h"
#import <UIImageView+WebCache.h>
#import "YYTabBarItem.h"

#define strangerKKID @"stranger"
#define noticeKKID @"notice"
#define adminKKID @"admin"


#define strangeIcon @"livepage"
#define noticeIcon @"livepage"
#define adminIcon @"livepage"

@interface LIMPushStrangerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LIMChatListModel *adminChat;         // 系统消息  im获取
@property (nonatomic, strong) LIMChatListModel *noticeChat;
@property (nonatomic, strong) LIMChatListModel *strangerChat;

@property (nonatomic, strong) NSMutableArray *allList;              //   存储所有会话。type == 1 的
@property (nonatomic, strong) NSMutableArray *strangerList;       // 陌生人
@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) NSMutableArray *sysNoticeList;       // 系统公告， 服务器获取


@property (nonatomic,strong)NSMutableArray *dataArr; //消息数据源


@end

@implementation LIMPushStrangerViewController

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
-(NSMutableArray *)dataArr{
    if(!_dataArr){
        
        NSArray *arr =@[
                        @{@"nickName":@"slowdony",@"lastMsg":@"哈哈",@"sendTime":@"06/06",@"nickNameID":@"1"},
                        @{@"nickName":@"danny",@"lastMsg":@"[图片]",@"sendTime":@"06/07",@"nickNameID":@"1"},
                        ];
        _dataArr =[[NSMutableArray alloc]initWithArray:arr];
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息";
    self.noticeChat = [[LIMChatListModel alloc]init];
    self.adminChat = [[LIMChatListModel alloc]init];
    self.strangerChat = [[LIMChatListModel alloc]init];
    [self creteTableView];
    [self httpSysNotice];
    // Do any additional setup after loading the view.
}
- (void)creteTableView{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - kPushMsgH, kScreenW, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"陌生人消息";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navView).offset(0);
        make.left.right.equalTo(navView).offset(0);
        make.height.mas_equalTo(18);
    }];
    
    // 设置
    YYTabBarItem *settingBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"phonelogin_图层-2"] forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    [settingBtn addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:settingBtn];
    
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel).offset(0);
        make.left.equalTo(navView).offset(13);
    }];
    
    YYTabBarItem *settingCover = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    //    [settingCover setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //    [settingCover sizeToFit];
    //    settingCover.backgroundColor = [UIColor redColor];
    [settingCover addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:settingCover];
    
    [settingCover mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(settingBtn).offset(0);
        make.center.equalTo(settingBtn).offset(0);
        make.width.height.mas_equalTo(40);
    }];
    
    
    UILabel *backLabel = [[UILabel alloc]init];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.24].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
    gradientLayer.locations = @[@0 ,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 44 , kScreenW, 4);
    [backLabel.layer addSublayer:gradientLayer];
    backLabel.frame = CGRectMake(0, 0, kScreenW, 4);
    [navView addSubview:backLabel];
    
//    [self.view addSubview:navView];
    
    
    
    UIView *hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -kPushMsgH)];
    [self.view addSubview:hiddenView];
    UITapGestureRecognizer *hiddenGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissThisView)]; 
    [hiddenView addGestureRecognizer:hiddenGest];

    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenH - kPushMsgH +44, kScreenW,kPushMsgH -44) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [[UIView alloc]init];
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView registerClass:[LIMChatListTableViewCell class] forCellReuseIdentifier:@"LIMChatListTableViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.view addSubview:navView];
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMChatListModel *chatListModel = self.dataSource[indexPath.row];
    if ([chatListModel.kkID isEqualToString:strangerKKID]) {
//        LIMStrangerMsgViewController *stranger  = [[LIMStrangerMsgViewController alloc]init];
//        [self.navigationController pushViewController:stranger animated:YES];
    }else{
        LIMPushChatDetaiViewController *v =[[LIMPushChatDetaiViewController alloc]init];
        SDChat  *chat =self.dataArr[0];
        v.chat =chat;
        v.chatListModel = chatListModel;
        v.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        v.modalPresentationStyle = UIModalPresentationOverFullScreen;
        //        [self.navigationController pushViewController:v animated:YES];
        [self presentViewController:v animated:YES completion:^{
            
        }];
//        SDChatDetailViewController *v =[[SDChatDetailViewController alloc]init];
//                v.chatListModel = chatListModel;
//        [self.navigationController pushViewController:v animated:YES];
        
        
        
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
    [hotLiveCell.avatar sd_setImageWithURL:[NSURL URLWithString:chatListModel.iconUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];
    hotLiveCell.score.text = chatListModel.chatStr;
    hotLiveCell.timeLabel.text = chatListModel.time;
    if (chatListModel.unReadNum >0) {
        [hotLiveCell.hub incrementBy:chatListModel.unReadNum];
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
        [self httpSysNotice];
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
    }];
    
}
- (void)intoGroups:(NSArray *)idList{
    
    // 清空原来数据
    [self.dataSource removeAllObjects];
    [self.friendList removeAllObjects];
    [self.strangerList removeAllObjects];
    self.adminChat = nil;
    //
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
    //
    //        self.dataSource = self.strangerList;
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
        
        for(int i = 0 ; i <self.allList.count; i++){
            LIMChatListModel *allModel = self.allList[i];
            NSString *idStr = allModel.kkID;
            BOOL isFriend = false;
            for (NSString *friendID in allFriendList) {
                if ([friendID isEqualToString:idStr]) {
                    LIMChatListModel *model = self.allList[i];
                    NSLog(@"好友 %@",model.kkID);
                    if ([model.kkID isEqualToString:@"admin"]) {
                        self.adminChat = self.allList[i];
                    }else{
                        [self.friendList addObject:self.allList[i]];
                    }
                    isFriend = true;
                    break;
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
        
        
        ///
        NSLog(@"好友 = %ld \n  陌生人= %@",self.friendList.count,self.strangerList);
        
        [self.dataSource removeAllObjects];
        
        self.dataSource = self.strangerList;
        [self.tableView reloadData];
        
    } fail:^(int code, NSString *msg) {
        
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
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSArray *sysList = responseObject[@"result"][@"list"];
            
            [self.sysNoticeList removeAllObjects];
            [self.sysNoticeList addObjectsFromArray: sysList];
            //            for (NSDictionary *dict in sysList) {
            //
            //            }
            self.noticeChat.kkID = @"sysMsg";
            self.noticeChat.nickName = @"系统公告";
            self.noticeChat.iconUrl = @"livepage";
            NSDictionary *sysLastMessage = self.sysNoticeList[0];
            self.noticeChat.chatStr = sysLastMessage[@"sysmsg"];
            self.noticeChat.time = sysLastMessage[@"time"];
            
            
            [self refreshMsg];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
        
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
- (void)dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
