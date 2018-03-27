//
//  SDChatDetailViewController.m
//  SDChat
//
//  Created by Megatron Joker on 2017/5/5.
//  Copyright © 2017年 SlowDony. All rights reserved.
//

/*
 
 目前实现
 
 基本聊天对话业务,
 聊天对话UI布局,
 表情键盘弹出,
 支持emoji表情.
 待完成
 
 图文混排,
 表情键盘弹出的优化,
 支持png格式表情,
 拍照上传图片.
 未来
 
 完善SDChat
 我的邮箱:devslowdony@gmail.com
 项目更新地址 GitHub:https://github.com/SlowDony/SDChat
 如果有好的建议或者意见 ,欢迎指出 , 您的支持是对我最大的鼓励,谢谢. 求STAR ..😆
 */




#import "SDChatDetailViewController.h"

/* 聊天内容模型 */

#import "SDChatMessage.h"
#import "SDChatDetail.h"
#import "SDChatDetailFrame.h"
#import "SDChatDetailTableViewCell.h"
#import "SDChat.h"
#import "CcUserModel.h"

/* 聊天内容View */
#import "SDChatInputView.h" //输入view


#import "SDChatDetailTableView.h" //列表

#import "YYTabBarItem.h"


#import "ImSDK/ImSDK.h"
#import "TLSSDK/TLSHelper.h"
#import "IMGroupExt/IMGroupExt.h"
#import "IMMessageExt/IMMessageExt.h"
#import <IMFriendshipExt/IMFriendshipExt.h>



#define kInputViewHeight 275

#define kBjViewOriFrame CGRectMake(0, 0, SDDeviceWidth, SDDeviceHeight);

@interface TIMMessageListenerImpl : NSObject<TIMMessageListener>
- (void)onNewMessage:(TIMMessage*) msg;
@end

@implementation TIMMessageListenerImpl
- (void)onNewMessage:(NSArray*) msgs {
    NSLog(@"NewMessages: %@", msgs);
}
@end

@interface SDChatDetailViewController ()
<

UIGestureRecognizerDelegate,
SDChatInputViewDelegate,
SDChatDetailTableViewLongPress,
UIScrollViewDelegate

>
@property (nonatomic,strong)UITextField *chatTextFiled;
@property (nonatomic,strong)NSMutableArray *dataArr; //消息数据源
@property (nonatomic,strong)SDChatDetailTableView *chatTableView;





/**
 背景view
 */
@property (nonatomic,strong)UIView *bjView;

/**
 *  是否正在切换键盘
 */
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;


/**
 聊天弹出的view
 */
@property (nonatomic,strong)SDChatInputView *chatInputView;


#pragma mark -  列表上啦加载更多
/**
 下拉加载更多
 */
@property (nonatomic,assign) BOOL isRefresh;

/**
 菊花
 */
@property (nonatomic,strong) UIActivityIndicatorView * activity;

/**
 聊天列表加载的小菊花view
 */
@property (nonatomic,strong) UIView *headView;



@end

@implementation SDChatDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //系统键盘谈起通知
    [[NSNotificationCenter defaultCenter] addObserver:self.chatInputView selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //自定义键盘,系统键盘
    [[NSNotificationCenter defaultCenter] addObserver:self.chatInputView selector:@selector(keyboardResignFirstResponder:) name:SDChatKeyboardResign object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.chatInputView
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"会话"];
    [self setUI];
    
    
    TIMConversation * c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:_chatListModel.kkID];
    [c2c_conversation setReadMessage:nil succ:nil fail:nil];
    NSMutableArray *lastMessage = [[NSMutableArray alloc]initWithArray:[c2c_conversation getLastMsgs:(uint32_t)20]];
    lastMessage =(NSMutableArray *)[[lastMessage reverseObjectEnumerator] allObjects];
    for(TIMMessage * msg in lastMessage){
        //    TIMMessage * msg = lastMessage.firstObject;
        TIMTextElem * text_elem = (TIMTextElem *)[msg getElem:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:msg.timestamp];
        NSLog(@"time = %@ text = %@\n kkid = %@",strDate,text_elem.text,_chatListModel.kkID);
        
        
        NSString *sender;
        if (msg.isSelf) {
            sender = @"1";
        }else{
            sender = @"0";
        }
        
        
        NSDictionary *dict = @{@"msg":text_elem.text,@"msgID":@"1",@"sender":sender,@"sendTime":[self compareCurrentTime:strDate],@"msgType":@"0"};
//        NSDictionary *dict  = @{@"msg":@"哈哈",@"msgID":@"1",@"sender":@"0",@"sendTime":@"06-23",@"msgType":@"0"};
        SDChatMessage *msg_sd =[SDChatMessage chatMessageWithDic:dict];
        if (msg.isSelf) {
            CcUserModel *userModel = [CcUserModel defaultClient];
            msg_sd.sendIconUrl = userModel.cover;
            msg_sd.sendNickName = userModel.nickname;
        }else{
            msg_sd.sendIconUrl = self.chatListModel.iconUrl;
            msg_sd.sendNickName = self.chatListModel.nickName;
        }
        SDChatDetail *chat =[SDChatDetail sd_chatWith:msg_sd];
        SDChatDetailFrame *chatFrame =[[SDChatDetailFrame alloc]init];
        chatFrame.chat=chat;
        
//        [emptyArr addObject:chatFrame];
        [self.dataArr addObject:chatFrame];

        
    }
    [self.chatTableView reloadData];
    [self sd_scrollToBottomWithAnimated:YES];
    
    
    
    
//    TIMMessageListenerImpl * impl = [[TIMMessageListenerImpl alloc] init];
    [[TIMManager sharedInstance] addMessageListener:self];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArr{
    if(!_dataArr){
        
        NSArray *arr =@[
                        //                        @{@"msg":@"哈哈",@"msgID":@"1",@"sender":@"0",@"sendTime":@"06-23",@"msgType":@"0"},
                        //                        @{@"msg":@"就是不是搞死你大当家氨",@"msgID":@"2",@"sender":@"1",@"sendTime":@"02:20",@"msgType":@"3"},
                        //                        @{@"msg":@"你在干啥就是不是搞死你大当家氨",@"msgID":@"3",@"sender":@"0",@"sendTime":@"02:30",@"msgType":@"0"},
                        //                        @{@"msg":@"简单的",@"msgID":@"4",@"sender":@"1",@"sendTime":@"02:40",@"msgType":@"0"},
                        //                        @{@"msg":@"不告诉你不告诉你不告诉你不告诉你标题标题标题标题",@"msgID":@"4",@"sender":@"1",@"sendTime":@"02:40",@"msgType":@"0"},
                        //                        @{@"msg":@"不告诉你大手大脚二等奖饿哦我肯定破可怕大卡等奖饿哦我肯定破可怕大卡司",@"msgID":@"4",@"sender":@"0",@"sendTime":@"今天02:40",@"msgType":@"0"},
                        ];
//        NSMutableArray *emptyArr =[[NSMutableArray alloc]init];
//        
//        for (NSDictionary *dic in arr){
//            SDChatMessage *msg =[SDChatMessage chatMessageWithDic:dic];
//            SDChatDetail *chat =[SDChatDetail sd_chatWith:msg];
//            SDChatDetailFrame *chatFrame =[[SDChatDetailFrame alloc]init];
//            chatFrame.chat=chat;
//            
//            [emptyArr addObject:chatFrame];
//        }
        _dataArr =[[NSMutableArray alloc]initWithCapacity:2];
        
    }
    return _dataArr;
}

-(UIView *)bjView{
    if(!_bjView){
        _bjView =[[UIView alloc]init];
        _bjView.frame =kBjViewOriFrame;
        _bjView.backgroundColor=[UIColor clearColor];
    }
    return _bjView;
}
-(UIView *)headView{
    if (!_headView){
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SDDeviceWidth, 40)];
        _headView.backgroundColor = [UIColor clearColor];
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activity.frame = CGRectMake(_headView.frame.size.width/2, _headView.frame.size.height/2, 20, 20);
        [_headView addSubview:_activity];
        
        _headView.hidden = YES;
    }
    return _headView;
}

-(SDChatDetailTableView *)chatTableView{
    if(!_chatTableView){
        _chatTableView = [[SDChatDetailTableView alloc] initWithFrame:CGRectMake(0,0, SDDeviceWidth, SDDeviceHeight-50) style:UITableViewStylePlain];
        
        _chatTableView.sdLongDelegate=self;
        _chatTableView.tableHeaderView = self.headView;
    }
    return _chatTableView;
}
// 输入view
-(SDChatInputView *)chatInputView{
    if (!_chatInputView){
        _chatInputView =[[SDChatInputView alloc]initWithFrame:CGRectMake(0,SDDeviceHeight-50, SDDeviceWidth, kInputViewHeight)];
        _chatInputView.backgroundColor=[UIColor whiteColor];
        _chatInputView.sd_delegate=self;
    }
    return _chatInputView;
}



-(void)setUI{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
        navView.backgroundColor = [UIColor whiteColor];

    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = self.chatListModel.nickName;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView).offset(33);
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
    [settingCover addTarget:self action:@selector(popThisView) forControlEvents:UIControlEventTouchUpInside];
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
    gradientLayer.frame = CGRectMake(0, 64 , kScreenW, 4);
    [backLabel.layer addSublayer:gradientLayer];
    backLabel.frame = CGRectMake(0, 0, kScreenW, 4);
    [navView addSubview:backLabel];
    
    
    
    [self.view addSubview:self.bjView];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.bjView addSubview:self.chatTableView];
    [self.bjView addSubview:navView];
    self.chatTableView.dataArray =self.dataArr;
    [self.chatTableView reloadData];
    [self.bjView addSubview:self.chatInputView];
    
    SDLog(@"self.view :%@",NSStringFromCGRect(self.bjView.frame));
    SDLog(@"chatInputView :%@",NSStringFromCGRect(self.chatInputView.frame));
    SDLog(@"chatTableView :%@",NSStringFromCGRect(self.chatTableView.frame));
    
    
}

#pragma mark - 监听键盘弹出方法
- (void)sd_observerKeyboardFrameChange
{
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue: [NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      //
                                                      NSLog(@"%s, line = %d,note =%@", __FUNCTION__, __LINE__, note);
                                                      
                                                      CGFloat keyboardHeight = [note.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
                                                      
                                                      CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                      
                                                      CGRect chatTableFrame =self.chatTableView.frame;
                                                      
                                                      CGFloat chatInputViewHeight =CGRectGetHeight(self.chatInputView.frame);
                                                      
                                                      chatTableFrame.size.height =SDDeviceHeight-keyboardHeight-(chatInputViewHeight-keyBoardDefaultHeight);
                                                      self.chatTableView.frame=chatTableFrame;
                                                      [self sd_scrollToBottomWithAnimated:YES];
                                                      
                                                      SDLog(@"键盘之后View:%@",NSStringFromCGRect(self.view.frame));
                                                      
                                                      [UIView animateWithDuration:duration animations:^{
                                                          [self.chatTableView setNeedsLayout];
                                                      }];
                                                      
                                                      
                                                  }];
    
    
    
}


#pragma mark - SDChatDetailTableViewDelegate
-(void)SDChatDetailTableView:(id)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.chatInputView.chatText resignFirstResponder];
    [self inputViewScrollToBottom];
}


/**
 键盘消失inputView在屏幕底部
 */
-(void)inputViewScrollToBottom{
    CGFloat chatInputHeight =CGRectGetHeight(self.chatInputView.frame);
    self.chatInputView.frame =CGRectMake(0,SDDeviceHeight-(chatInputHeight-keyBoardDefaultHeight), SDDeviceWidth, chatInputHeight);
    self.chatTableView.frame =CGRectMake(0, 0, SDDeviceWidth, CGRectGetMinY(self.chatInputView.frame));
    
    [self sd_scrollToBottomWithAnimated:YES];
}


-(void)SDChatDetailTableViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0  && self.isRefresh==NO)
    {
        //        [self setChatNetWorkMoreHistoryMsg];
    }
}

#pragma mark - chatInputViewDelegate

/**
 添加文件按钮监听
 
 @param sender  添加文件按钮监听
 */
-(void)SDChatInputViewAddFileClicked:(UIButton *)sender{
    SDLog(@"添加图片");
}


/**
 添加表情按钮监听
 
 @param sender 添加表情按钮监听
 */
-(void)SDChatInputViewAddFaceClicked:(UIButton *)sender{
    SDLog(@"添加表情");
    SDLog(@"self.frame.input:%@",NSStringFromCGRect(self.chatInputView.frame));
}
-(void)SDChatInputView:(SDChatInputView *)chatInputView sendTextMessage:(NSString *)textMessage{
    
    //    [self setChatNetWorkWith:textMessage];
    int i =arc4random() %2;
    
    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:_chatListModel.kkID];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    
    [text_elem setText:textMessage];
    
    TIMMessage * msg_tim = [[TIMMessage alloc] init];
    [msg_tim addElem:text_elem];
    
    [grp_conversation sendMessage:msg_tim succ:^(){
        NSLog(@"SendMsg Succ");
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate new]];
    
    NSDictionary *dic =@{@"msg":textMessage,@"msgID":@"1",@"sender":[NSString stringWithFormat:@"%zd",1],@"sendTime":[self compareCurrentTime:strDate],@"msgType":@"0"};
    SDChatMessage *msg =[SDChatMessage chatMessageWithDic:dic];
    CcUserModel *userModel = [CcUserModel defaultClient];
    msg.sendIconUrl = userModel.cover;
    msg.sendNickName = userModel.nickname;
    SDChatDetail *chat =[SDChatDetail sd_chatWith:msg];
    SDChatDetailFrame *chatFrame =[[SDChatDetailFrame alloc]init];
    chatFrame.chat=chat;
    
    [self.dataArr addObject:chatFrame];
    [self.chatTableView reloadData];
    [self sd_scrollToBottomWithAnimated:YES];
    
    
}

-(void)SDChatInputViewFrameWillChange:(SDChatInputView *)chatInputView{
    SDLog(@"-----chatInputView.frame:%@",NSStringFromCGRect(chatInputView.frame))
    SDLog(@"-----chatTableView1-----:%@",NSStringFromCGRect(self.chatTableView.frame))
    self.chatTableView.frame =CGRectMake(0, 0, SDDeviceWidth, CGRectGetMinY(chatInputView.frame));
    [self sd_scrollToBottomWithAnimated:YES];
    SDLog(@"-----chatTableView2-----:%@",NSStringFromCGRect(self.chatTableView.frame))
}
#pragma mark - textFieldDelegate

-(void)SDChatDetailTableViewLongPress:(UILongPressGestureRecognizer *)longPressGr{
    //       [self.chatInputView.chatTextFiled becomeFirstResponder];
}


#pragma mark - 监听键盘弹出方法
- (void)sd_scrollToBottomWithAnimated:(BOOL)animate
{
    if (!self.dataArr.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow: self.dataArr.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath: lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animate];
}

#pragma mark -右按钮


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self inputViewScrollToBottom];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)popThisView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onNewMessage:(NSArray*) messages {
    NSLog(@"NewMessages: %@", messages);
    TIMMessage * msg = messages.firstObject;
    if ([msg.sender isEqualToString:_chatListModel.kkID]) {
        
        //    TIMMessage * msg = lastMessage.firstObject;
        TIMTextElem * text_elem = (TIMTextElem *)[msg getElem:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:msg.timestamp];
        NSLog(@"time = %@ text = %@\n kkid = %@",strDate,text_elem.text,_chatListModel.kkID);
//        NSLog(@"%@",self.accessibilityActivationPoint);
        
        NSString *sender;
        if (msg.isSelf) {
            sender = @"1";
        }else{
            sender = @"0";
        }
        
        
        NSDictionary *dict = @{@"msg":text_elem.text,@"msgID":@"1",@"sender":sender,@"sendTime":@"06-23",@"msgType":@"0"};
        //        NSDictionary *dict  = @{@"msg":@"哈哈",@"msgID":@"1",@"sender":@"0",@"sendTime":@"06-23",@"msgType":@"0"};
        SDChatMessage *message_sd =[SDChatMessage chatMessageWithDic:dict];
        message_sd.sendIconUrl = self.chatListModel.iconUrl;
        message_sd.sendNickName = self.chatListModel.nickName;

        SDChatDetail *chat =[SDChatDetail sd_chatWith:message_sd];
        SDChatDetailFrame *chatFrame =[[SDChatDetailFrame alloc]init];
        chatFrame.chat=chat;
        
        //        [emptyArr addObject:chatFrame];
    [self.dataArr addObject:chatFrame];
    [self.chatTableView reloadData];
    [self sd_scrollToBottomWithAnimated:YES];
    
//    int cnt = [message elemCount];
//    
//    TIMElem * elem = [message getElem:0];
//    NSLog(@"message ===================================== %d",cnt);
//    if ([elem isKindOfClass:[TIMTextElem class]]) {
//        TIMTextElem * text_elem = (TIMTextElem * )elem;
//        
//        //    for (int i = 0; i < cnt; i++) {
//        //        TIMTextElem * elem = [message getElem:0];
//        NSLog(@".........%@",text_elem.text);
//        
//            
//            
//        
//    }
//    else if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
//        TIMGroupSystemElem * image_elem = (TIMGroupSystemElem * )elem;
//    }
    }
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
    
    
    
//    // newDate
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
//    //设定时间格式,这里可以设置成自己需要的格式
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *dateString = [formatter stringFromDate:newDate];
    
    NSString *result;
    
    if (timeInterval/60 < 1) {
        
        result = [str substringWithRange:NSMakeRange(11, 5)];
//        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        result = [str substringWithRange:NSMakeRange(11, 5)];
        
//        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
//        result = [NSString stringWithFormat:@"%ld小时前",temp];
        result = [str substringWithRange:NSMakeRange(11, 5)];
        
    }
    
    else if((temp = temp/24) <30){
        
//        result = [NSString stringWithFormat:@"%ld天前",temp];
        result = [str substringWithRange:NSMakeRange(5, 5)];
        
    }
    
    else if((temp = temp/30) <12){
        
//        result = [NSString stringWithFormat:@"%ld月前",temp];
        result = [str substringWithRange:NSMakeRange(5, 5)];
        
    }
    
    else{
        
        temp = temp/12;
        
//        result = [NSString stringWithFormat:@"%ld年前",temp];
        result = [str substringWithRange:NSMakeRange(5, 5)];
        
    }
    return result;
}



@end
