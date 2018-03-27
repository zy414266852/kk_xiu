//
//  LIMPushLiveViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPushLiveViewController.h"
#import "YYTabBarItem.h"
#import "TXLiteAVSDK_Professional/TXLivePush.h"
#import "TXLiteAVSDK_Professional/TXLivePushConfig.h"
#import "TXLiteAVSDK_Professional//TXLiveBase.h"
#import <sys/sysctl.h>
#import "CcUserModel.h"
#import "HttpClient.h"
#import <UIImageView+WebCache.h>
#import "LIMUPInfo.h"
#import "LIMUserListModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "LIMUserListCell.h"
#import "LIMPresentModel.h"
#import "LIMPresentListCollectionViewCell.h"
#import "LIMCharmView.h"
#import "LIMLiveEndViewController.h"
#import "LIMSimpleInfoModel.h"
#import "LIMOtherInfoViewController.h"
#import "YYNavigationController.h"
#import "IMMessageExt/IMMessageExt.h"
#import "LIMChatReceive.h"
#import "LIMChatAVRoomTableViewCell.h"
#import "LIMChatModel.h"
#import "LIMPushLiveModel.h"
#import "LiveGiftShowCustom.h"
#import "LIMPushMsgCenterViewController.h"
#import "LIMLiveShareView.h"
#import "LIMWinPrize.h"
// js
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "LivePrizeShowCustom.h"
#import "LIMTurnHitView.h"
#import "LIMHttpServer.h"

#import "LIMGameHelpView.h"

#import "LIMImageView.h"
#import "LIMGiftArrModel.h"
#import "LIMGoldViewController.h"


#import "LIMChatListModel.h"
#import "LIMPushChatDetaiViewController.h"

#import<BarrageRenderer/BarrageRenderer.h>
#import "LIMBarrageModel.h"
#import "LQXSwitch.h"
#import "UIImage+Barrage.h"
#import "AvatarBarrageView.h"


#define upH 30
#define userListTag 500
#define userListGradeTag  600

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define SCREEN [UIScreen mainScreen].bounds.size
//#define webUrl @"http://app.game.kkxiu.com/carts/"

static NSInteger kTag = 200;


//@interface TIMMessageListenerImpl : NSObject<TIMMessageListener>
//- (void)onNewMessage:(TIMMessage*) msg;
//@end
//
//@implementation TIMMessageListenerImpl
//- (void)onNewMessage:(NSArray*) msgs {
//    NSLog(@"NewMessages: %@", msgs);
//}
//@end


@interface LIMPushLiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,LiveGiftShowCustomDelegate,UIWebViewDelegate,JSObjcDelegate,UIAlertViewDelegate,WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,BarrageRendererDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *playView;
@property (nonatomic, strong) UIView *fontView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) LIMTurnHitView *turnView;
@property (nonatomic, strong) TXLivePush *txLivePush;
@property (nonatomic, strong) UIView  *botttomView;

@property (nonatomic, strong) UIView  *botttomFaceView;
@property (nonatomic, strong) UIView *sliderV;
@property (nonatomic, strong) UIView *btnBkgView;

@property (nonatomic, assign) CGFloat beautyDepth;
@property (nonatomic, assign) CGFloat whiteningDepth;
@property (nonatomic, assign) CGFloat eyeScaleLevel;
@property (nonatomic, assign) CGFloat faceScaleLevel;


@property (nonatomic, strong) UILabel *userCountLabel;
@property (nonatomic, strong) NSMutableArray *userList;


// 用户列表
@property (nonatomic, strong) UIScrollView *userListS;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *myTimer;


// 礼物列表
@property (nonatomic, strong) UIView *allPresentView;
@property (nonatomic, strong) UICollectionView *presentView;
@property (nonatomic, strong) NSMutableArray *presentList;



@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UILabel *charm_countLabel;

// 游戏
@property (nonatomic, strong) WKWebView *gameWebV;
@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chatH;


// 关注
@property (nonatomic, strong) UIButton *followBtn;
// 键盘
@property (nonatomic, strong) UITextField *hiddenText;
@property (nonatomic, strong) UITextField *mainText;

// 工具
@property (nonatomic, strong) UIButton *torchBtn;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *turnTypeBtn;

// 礼物
@property (nonatomic ,strong) LiveGiftShowCustom * customGiftShow;
@property (nonatomic ,strong) LivePrizeShowCustom * customPrizeShow;

@property (nonatomic ,strong) LivePrizeShowCustom * customBigPrizeShow;

@property (nonatomic ,strong) NSArray <LiveGiftListModel *>* giftArr;
@property (nonatomic ,strong) NSArray * giftDataSource;
@property (nonatomic ,strong) UILabel * sendCount;
@property (nonatomic ,strong) UIView * sendCountView;


@property (nonatomic, strong) UIView *bigGift;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) NSMutableArray *animationArr;


@property (nonatomic, strong) UIView *loginGift;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) NSMutableArray *loginArr;



@property (nonatomic ,assign) NSInteger currentGiftIndex;
@property (nonatomic ,strong) NSString *currentGiftCount;

@property (nonatomic, strong) NSTimer *animation1;
@property (nonatomic, strong) NSTimer *animation2;
@property (nonatomic, strong) NSTimer *animation3;
@property (nonatomic, strong) NSTimer *animation4;
@property (nonatomic, strong) NSTimer *animation5;


@property (nonatomic, assign) NSInteger animationTime;

//@property (nonatomic, strong) BarrageRenderer *myDanmaku;
//@property (nonatomic, assign) NSInteger goldTimes;
@property (nonatomic, strong) BarrageRenderer *renderer;
@property (nonatomic, assign) NSTimeInterval predictedTime;
@property (nonatomic, strong) NSDate *startDate;

// 弹幕 开关
@property (nonatomic, strong) LQXSwitch *swit;

@property (nonatomic, strong) UILabel *grayLabel;
@property (nonatomic, strong) UILabel *yellowLabel;
@end

@implementation LIMPushLiveViewController
- (NSMutableArray *)userList{
    if (_userList == nil) {
        _userList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _userList;
}
- (NSMutableArray *)chatH{
    if (_chatH == nil) {
        _chatH = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _chatH;
}
- (NSMutableArray *)animationArr{
    if (_animationArr == nil) {
        _animationArr = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _animationArr;
}
- (NSMutableArray *)loginArr{
    if (_loginArr == nil) {
        _loginArr = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _loginArr;
}



- (NSMutableArray *)presentList{
    if (_presentList == nil) {
        _presentList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _presentList;
}
- (LivePrizeShowCustom *)customPrizeShow{
    if (!_customPrizeShow) {
        _customPrizeShow = [[LivePrizeShowCustom alloc]init];//[LiveGiftShowCustom addToView:self.view];
        [_customPrizeShow setMaxGiftCount:1];
        [_customPrizeShow setShowMode:LiveGiftShowModeFromTopToBottom];
        [_customGiftShow setAppearModel:LiveGiftAppearModeLeft];
        [_customPrizeShow setHiddenModel:LiveGiftHiddenModeLeft];
        [_customPrizeShow enableInterfaceDebug:YES];
        _customPrizeShow.delegate = self;
        [_fontView addSubview:_customPrizeShow];
        [_customPrizeShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fontView).offset(90 +65);
            make.right.equalTo(_fontView).offset(0);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(45);
        }];
        _customPrizeShow. backgroundColor = [UIColor clearColor];
    }
    return _customPrizeShow;
}
- (LivePrizeShowCustom *)customBigPrizeShow{
    if (!_customBigPrizeShow) {
        _customBigPrizeShow = [[LivePrizeShowCustom alloc]init];//[LiveGiftShowCustom addToView:self.view];
        [_customBigPrizeShow setMaxGiftCount:1];
        [_customBigPrizeShow setShowMode:LiveGiftShowModeFromTopToBottom];
        [_customBigPrizeShow setAppearModel:LiveGiftAppearModeLeft];
        [_customBigPrizeShow setHiddenModel:LiveGiftHiddenModeLeft];
        [_customBigPrizeShow enableInterfaceDebug:YES];
        _customBigPrizeShow.delegate = self;
        [_fontView addSubview:_customBigPrizeShow];
        [_customBigPrizeShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fontView).offset(90);
            make.right.equalTo(_fontView).offset(0);
            make.width.mas_equalTo(kScreenW);
            make.height.mas_equalTo(45);
        }];
        _customBigPrizeShow. backgroundColor = [UIColor clearColor];
    }
    return _customBigPrizeShow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setBackUI];
    [self setFontUI];
    [self httpLivePresentList];
    
    
    
    
    LIMChatReceive * impl = [LIMChatReceive defaultClient];
    [[TIMManager sharedInstance] addMessageListener:impl];
    
    //    [self httpLiveUserList];
//    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshUserList) userInfo:nil repeats:YES];
    self.myTimer =  [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refreshUserList) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer  forMode:NSRunLoopCommonModes];

    //    [self refreshUserList];
    
    
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    
    
    self.followBtn.hidden = YES;
    self.currentGiftIndex = 0;
    self.animationTime = 0;
//    self.goldTimes = 0;
    self.upView.frame = CGRectMake(8, 21.5, 100, upH);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"receiveMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePrize:) name:@"receivePrize" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserList) name:@"refreshUserList" object:nil];
    
    self.isAnimation = NO;
    self.isLogin = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        [self loadImageArray];
    });
    
}
// 播放器层
- (void)setBackUI{
    _playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _playView.image = [UIImage imageNamed:@""];
    _playView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_playView];
    [self.view sendSubviewToBack:_playView];
    TXLivePushConfig* _config = [[TXLivePushConfig alloc] init];
    _txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    
    CcUserModel *userInfo = [CcUserModel defaultClient];
    _beautyDepth = [userInfo.beautyDepth floatValue];
    _whiteningDepth = [userInfo.whiteningDepth floatValue];
    _eyeScaleLevel = [userInfo.eyeScaleLevel floatValue];
    _faceScaleLevel = [userInfo.faceScaleLevel floatValue];
    NSLog(@"%g_________%g_________%g_________%g_________",_beautyDepth,_whiteningDepth,_eyeScaleLevel,_faceScaleLevel);
    [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
    [_txLivePush setEyeScaleLevel:_eyeScaleLevel];
    [_txLivePush setFaceScaleLevel:_faceScaleLevel];
    
    [_txLivePush startPreview:_playView];  //_playView用来承载我们的渲染控件
    
    
    
    if (self.rtmpUrl >0) {
        [_txLivePush startPush:self.rtmpUrl];
    }else{
        [self showAlertWithMessage:@"开启直播间失败"];
    }
    
    
    [self createBottomView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.turnFront) {
            [_txLivePush switchCamera];
        }
        
    });
    
    
    
}
// 显示层
- (void)setFontUI{
    _fontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH )];
    _fontView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    // 关闭按钮
    YYTabBarItem *offBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [offBtn setImage:[UIImage imageNamed:@"pushpage_10"] forState:UIControlStateNormal];
    [offBtn addTarget:self action:@selector(showAlertWithPushView) forControlEvents:UIControlEventTouchUpInside];
    [offBtn sizeToFit];
    [_fontView addSubview:offBtn];
    WS(ws);
    [offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.fontView).offset(21.5);
        make.right.equalTo(ws.fontView).offset(-12.5);
    }];
    
    // 主播view
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(8, 21.5, 150, upH)];
    upView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    upView.layer.cornerRadius = upH/2;
    upView.clipsToBounds = YES;
    [_fontView addSubview:upView];
    self.upView = upView;
    //    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(ws.fontView).offset(21.5);
    //        make.left.equalTo(ws.fontView).offset(8);
    //        make.width.mas_equalTo(150);
    //        make.height.mas_equalTo(upH);
    //    }];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
    [upView addGestureRecognizer:singleTap];
    
    UIImageView *upImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"place_icon"]];
    upImageV.layer.cornerRadius = upH/2.0;
    upImageV.contentMode =UIViewContentModeScaleAspectFill;

    upImageV.clipsToBounds = YES;
    [upView addSubview:upImageV];
    [upImageV sd_setImageWithURL:[NSURL URLWithString:self.livePushModel.cover]];
    [upImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView).offset(0);
        make.left.equalTo(upView).offset(0);
        make.width.mas_equalTo(upH);
        make.height.mas_equalTo(upH);
    }];
    
    // 魅力值view
    UIView *charmAllView = [[UIView alloc]init];
    charmAllView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    charmAllView.layer.cornerRadius = 23/2.0;
    charmAllView.clipsToBounds = YES;
    [_fontView addSubview:charmAllView];
    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCharm)];
    [charmAllView addGestureRecognizer:singleTap3];
    ////////////////
    //    [self customGiftShow];
    _customGiftShow = [[LiveGiftShowCustom alloc]init];//[LiveGiftShowCustom addToView:self.view];
    [_customGiftShow setMaxGiftCount:2];
    [_customGiftShow setShowMode:LiveGiftShowModeFromTopToBottom];
    //    [_customGiftShow setAppearModel:leftAppear];
    [_customGiftShow setHiddenModel:LiveGiftHiddenModeLeft];
    [_customGiftShow enableInterfaceDebug:YES];
    _customGiftShow.delegate = self;
    [_fontView addSubview:_customGiftShow];
    [_customGiftShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fontView).offset(90);
        make.left.equalTo(_fontView).offset(0);
        make.width.mas_equalTo(kScreenW/2.0);
        make.height.mas_equalTo(150);
    }];
    
    _customGiftShow.backgroundColor = [UIColor clearColor];
    
    
    ////////////////
    
    
    UILabel *charm_nameLabel = [[UILabel alloc]init];
    charm_nameLabel.text = @"魅力:";
    charm_nameLabel.textColor = [UIColor whiteColor];
    charm_nameLabel.font = [UIFont systemFontOfSize:12];
    charm_nameLabel.textAlignment = NSTextAlignmentLeft;
    [charmAllView addSubview:charm_nameLabel];
    [charm_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(charmAllView).offset(0);
        make.left.equalTo(charmAllView).offset(6);
        make.width.mas_equalTo(35*kiphone6);
        make.height.mas_equalTo(13);
    }];
    UILabel *charm_countLabel = [[UILabel alloc]init];
    //    self.livePushModel.score;
    CGFloat buttonW = [self.livePushModel.score boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width + 13;
    charm_countLabel.text = self.livePushModel.score;
    charm_countLabel.textColor = [UIColor colorWithHexString:@"ff3da8"];
    charm_countLabel.font = [UIFont systemFontOfSize:13];
    charm_countLabel.textAlignment = NSTextAlignmentLeft;
    [charmAllView addSubview:charm_countLabel];
    [charm_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(charmAllView).offset(1);
        make.left.equalTo(charm_nameLabel.mas_right).offset(0);
        make.width.mas_equalTo(buttonW);
        make.height.mas_equalTo(13);
    }];
    [charmAllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom).offset(12);
        make.left.equalTo(_fontView).offset(7.5);
        make.width.mas_equalTo(57+buttonW);
        make.height.mas_equalTo(23);
    }];
    self.charm_countLabel = charm_countLabel;
    
    UIButton *charm_click = [UIButton buttonWithType:UIButtonTypeCustom];
    charm_click.backgroundColor = [UIColor clearColor];
    [charm_click setTitle:@">" forState:UIControlStateNormal];
    //    [charm_click sizeToFit];
    [charm_click addTarget:self action:@selector(showCharm) forControlEvents:UIControlEventTouchUpInside];
    [charmAllView addSubview:charm_click];
    [charm_click mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(charmAllView).offset(0);
        make.right.equalTo(charmAllView).offset(-3);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *kk_nameLabel = [[UILabel alloc]init];
    kk_nameLabel.text = [NSString stringWithFormat:@"KKID: %@",self.livePushModel.uid];
    kk_nameLabel.textColor = [UIColor whiteColor];
    kk_nameLabel.font = [UIFont systemFontOfSize:12];
    kk_nameLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat buttonW2 = [kk_nameLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width +2;
    [_playView addSubview:kk_nameLabel];
    [kk_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playView).offset(69);
        make.right.equalTo(_playView).offset(-10);
        make.width.mas_equalTo(buttonW2);
        make.height.mas_equalTo(12);
    }];
    
    //    UIImageView *coverView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_14"]];
    ////    [coverView sizeToFit];
    //    [upImageV addSubview:coverView];
    //    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(upImageV).offset(-15.5);
    //        make.left.equalTo(upImageV).offset(0);
    //        make.width.mas_equalTo(17.5);
    //        make.height.mas_equalTo(15.5);
    //    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    //    nameLabel.text = @"主播名字";
    nameLabel.text = self.livePushModel.nickname;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [upView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView).offset(3);
        make.left.equalTo(upImageV.mas_right).offset(3);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(10);
    }];
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = @"1024人";
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:10];
    countLabel.textAlignment = NSTextAlignmentLeft;
    [upView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(3);
        make.left.equalTo(upImageV.mas_right).offset(3);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(10);
    }];
    self.userCountLabel = countLabel;
    
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage = [UIImage imageNamed:@"pushpage_12"];
    followBtn.backgroundColor = [UIColor clearColor];
    [followBtn setImage: btnImage forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(followOther:) forControlEvents:UIControlEventTouchUpInside];
    [followBtn sizeToFit];
    [upView addSubview:followBtn];
    _followBtn = followBtn;
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(upView).offset(0);
        make.right.equalTo(upView).offset(-3);
    }];
    
    
    // 用户列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 2;
    // 2.设置行间距
    layout.minimumLineSpacing = 2;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(35, 30);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -49) collectionViewLayout:layout];
    _collectionView.tag = 77;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    UINib *collectNib = [UINib nibWithNibName:NSStringFromClass([LIMUserListCell class]) bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:collectNib forCellWithReuseIdentifier:@"LIMUserListCell"];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_fontView addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.fontView).offset(21.5);
        make.left.equalTo(upView.mas_right).offset(5);
        make.right.equalTo(offBtn.mas_left).offset(-5);
        make.height.mas_equalTo(30);
    }];
    // 礼物
    self.turnView = [[LIMTurnHitView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.turnView.clickY = kScreenH - 160*kiphone6-35*kiphone6;
    self.turnView.backgroundColor = [UIColor clearColor];
    //    self.turnView.alpha = 0.5;
    [self.view addSubview:self.turnView];
    //    [self.turnView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(ws.view).offset(0);
    //        make.left.equalTo(ws.view).offset(0);
    //        make.width.mas_equalTo(kScreenW);
    //        make.height.mas_equalTo(kScreenH);
    //    }];
    
    
    CGFloat presentW = kScreenW/4;
    
    
    
    
    UIView *presentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 160 *kiphone6 -35*kiphone6, kScreenW, 160 *kiphone6 +35*kiphone6)];
    presentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [self.turnView addSubview:presentView];
    //    [presentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.turnView).offset(0);
    //        make.left.equalTo(self.turnView).offset(0);
    //        make.width.mas_equalTo(kScreenW);
    //        make.height.mas_equalTo(160 *kiphone6 +35);
    //
    //    }];
    
    self.allPresentView = presentView;
    
    // 礼物列表
    UICollectionViewFlowLayout *presentLayout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    presentLayout.minimumInteritemSpacing = 0;
    // 2.设置行间距
    presentLayout.minimumLineSpacing = 0;
    // 3.设置每个item的大小
    presentLayout.itemSize = CGSizeMake(presentW, 80 *kiphone6);
    // 5.设置布局方向
    presentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    presentLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    _presentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160 *kiphone6) collectionViewLayout:presentLayout];
    _presentView.dataSource = self;
    _presentView.delegate = self;
    _presentView.tag = 78;
    _presentView.backgroundColor = [UIColor clearColor];
    _presentView.pagingEnabled = YES;
    _presentView.bounces = NO;
    UINib *presentCollectNib = [UINib nibWithNibName:NSStringFromClass([LIMPresentListCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [_presentView registerNib:presentCollectNib forCellWithReuseIdentifier:@"LIMPresentListCollectionViewCell"];
    
    _presentView.showsHorizontalScrollIndicator = NO;
    [presentView addSubview:_presentView];
    
    //    [_presentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.equalTo(presentView).offset(0);
    //        make.height.mas_equalTo(160 *kiphone6);
    //    }];
    
    
    
    
    UIView *moneyView = [[UIView alloc]init];
    moneyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [presentView addSubview:moneyView];
    [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(presentView).offset(0);
        make.left.equalTo(presentView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(35*kiphone6);
    }];
    
    UIButton *topUPBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topUPBtn setTitle:@"充值  >" forState:UIControlStateNormal];
    [topUPBtn setTitleColor:[UIColor colorWithHexString:@"ffbe3a"] forState:UIControlStateNormal];
    topUPBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
    [topUPBtn sizeToFit];
    topUPBtn.backgroundColor = [UIColor clearColor];
    [moneyView addSubview:topUPBtn];
    [topUPBtn addTarget:self action:@selector(pushChongzhi) forControlEvents:UIControlEventTouchUpInside];
    
    [topUPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyView).offset(0);
        make.left.equalTo(moneyView).offset(10);
        //        make.width.mas_equalTo(kScreenW);
        //        make.height.mas_equalTo(40);
    }];
    
    UILabel *goldLabel = [[UILabel alloc]init];
    goldLabel.font = [UIFont systemFontOfSize:13.5];
    goldLabel.textColor = [UIColor colorWithHexString:@"ffbe3a"];
    goldLabel.textAlignment = NSTextAlignmentRight;
    goldLabel.text = @"0";
    [moneyView addSubview:goldLabel];
    [goldLabel sizeToFit];
    [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyView).offset(0);
        make.left.equalTo(topUPBtn.mas_right).offset(5);
//        make.width.mas_equalTo(45).priority(750);
//        make.height.mas_equalTo(14);
    }];
    self.goldLabel = goldLabel;
    
    UIImageView *goldImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_9"]];
    [goldImage  sizeToFit];
    [moneyView addSubview:goldImage];
    [goldImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyView).offset(0);
        make.left.equalTo(goldLabel.mas_right).offset(2);
    }];
    
    YYTabBarItem *sendBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [sendBtn setImage:[UIImage imageNamed:@"pushpage_7"] forState:UIControlStateNormal];
    
    [sendBtn addTarget:self action:@selector(sengGift) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn sizeToFit];
    [moneyView addSubview:sendBtn];
    
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyView).offset(0);
        make.right.equalTo(moneyView).offset(-4);
    }];
    
    //    ..
    YYTabBarItem *countBtn = [YYTabBarItem buttonWithType:UIButtonTypeCustom];
    [countBtn setImage:[UIImage imageNamed:@"pushpage_8"] forState:UIControlStateNormal];
    [countBtn sizeToFit];
    [countBtn addTarget:self action:@selector(sendCountClick) forControlEvents:UIControlEventTouchUpInside];
    [moneyView addSubview:countBtn];
    
    [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyView).offset(0);
        make.right.equalTo(sendBtn.mas_left).offset(0);
    }];
    
    UILabel *sendCountLabel = [[UILabel alloc]init];
    sendCountLabel.font = [UIFont systemFontOfSize:13.5];
    sendCountLabel.textColor = [UIColor colorWithHexString:@"c7c7c7"];
    sendCountLabel.textAlignment = NSTextAlignmentLeft;
    sendCountLabel.text = @"     ×1";
    [moneyView addSubview:sendCountLabel];
    [sendCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(countBtn).offset(0);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(14);
    }];
    self.sendCount = sendCountLabel;
    
    
    UIView *back_sendCountV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCountClick)];
//    back_sendCountV.backgroundColor = [UIColor cyanColor];
//    sendCountClick
    [back_sendCountV addGestureRecognizer:tapGest];
    [self.turnView addSubview:back_sendCountV];
    
    // 礼物数量选择
    UIView *sendContView = [[UIView alloc]init];
    sendContView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    sendContView.layer.cornerRadius = 5;
    sendContView.clipsToBounds = YES;
//    [presentView addSubview:sendContView];
//    [sendContView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(moneyView.mas_top).offset(0);
//        make.right.equalTo(presentView).offset(-50);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(80);
//    }];
//    self.sendCountView = sendContView;
        [back_sendCountV addSubview:sendContView];
        [sendContView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(back_sendCountV.mas_bottom).offset(-40);
            make.right.equalTo(back_sendCountV).offset(-50);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(80);
        }];
        self.sendCountView = back_sendCountV;

    self.sendCountView.hidden = YES;
    NSArray *sendCountArray = @[@"×500",@"×100",@"×10",@"×1"];
    for (int i = 0; i <sendCountArray.count; i++) {
        UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [toolBtn setImage:[UIImage imageNamed:toolIcon[i]] forState:UIControlStateNormal];
        [toolBtn setTitle:sendCountArray[i] forState:UIControlStateNormal];
        [toolBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        toolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        toolBtn.tag = 850 +i;
        [sendContView addSubview:toolBtn];
        
        [toolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sendContView).offset(0);
            make.top.equalTo(sendContView).offset(20 *i);
            make.width.equalTo(sendContView);
            make.height.mas_equalTo(19);
        }];
        if (i != sendCountArray.count -1) {
            UILabel *line = [[UILabel alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"c5c5c7"];
            [sendContView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(toolBtn.mas_bottom).offset(0);
                make.left.equalTo(sendContView);
                make.width.equalTo(sendContView);
                make.height.mas_equalTo(0.5);
            }];
        }
        [toolBtn addTarget:self action:@selector(countSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 工具
    //    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fontView.frame) -40, kScreenW, 40)];
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 160*kiphone6-35*kiphone6 -40, kScreenW, 40)];
    
    //    toolView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    
    
    [self.fontView addSubview:toolView];
    self.toolView = toolView;
    //    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(ws.fontView).offset(0);
    //        make.left.equalTo(ws.fontView).offset(0);
    //        make.width.mas_equalTo(kScreenW);
    //        make.height.mas_equalTo(40);
    //    }];
    
    NSArray *toolIcon = @[@"pushpage_2",@"pushpage_4",@"push_add0817_a-(5)",@"push_add0817_a-(3)",@"push_add0817_a-(2)",@"tool_1"];
    for (int i = 0; i <6; i++) {
        UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn setImage:[UIImage imageNamed:toolIcon[i]] forState:UIControlStateNormal];
        [toolBtn sizeToFit];
        [toolView addSubview:toolBtn];
        
        [toolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(toolView).offset(0);
            make.left.equalTo(toolView).offset(7 +i*41*kiphone6);
        }];
        if (i == 0) {
            [toolBtn addTarget:self action:@selector(showKedBoard:) forControlEvents:UIControlEventTouchUpInside];
        }
        //        if (i == 1) {  // 分享
        //            [toolBtn addTarget:self action:@selector(showSharView) forControlEvents:UIControlEventTouchUpInside];
        //        }
        if (i == 1) {   // 消息
            [toolBtn addTarget:self action:@selector(showMsg) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 2) {   // 闪光灯
            [toolBtn setImage:[UIImage imageNamed:@"push_add0817_a-(4)"] forState:UIControlStateSelected];
            [toolBtn addTarget:self action:@selector(showTorch:) forControlEvents:UIControlEventTouchUpInside];
            self.torchBtn = toolBtn;
        }
        if (i == 3) {   // 编辑标题
            [toolBtn addTarget:self action:@selector(editTitle) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 4) {   // 美颜
            [toolBtn addTarget:self action:@selector(beatifulFace) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 5) {   // 转换摄像头
            [toolBtn addTarget:self action:@selector(turnFont) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIButton *changeTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeTypeBtn setImage:[UIImage imageNamed:@"pushpage_6"] forState:UIControlStateNormal];
    [changeTypeBtn addTarget:self action:@selector(turnGameOrGitf:) forControlEvents:UIControlEventTouchUpInside];
    [changeTypeBtn sizeToFit];
    changeTypeBtn.selected = YES;
    [toolView addSubview:changeTypeBtn];
    [changeTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView).offset(0);
        make.right.equalTo(toolView).offset(-7);
    }];
    
    
    
    self.turnTypeBtn = changeTypeBtn;
    if (self.gameID == 0) {
        //        [self.turnView addSubview:gameWeb];
        //        self.turnTypeBtn.selected = NO;
        self.turnTypeBtn.userInteractionEnabled = NO;
        [self.turnTypeBtn setImage:[UIImage imageNamed:@"tool_图层-1"] forState:UIControlStateNormal];
        
    }
    
    
    UIButton *meauBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [meauBtn setImage:[UIImage imageNamed:@"?"] forState:UIControlStateNormal];
    [meauBtn sizeToFit];
    [meauBtn addTarget:self action:@selector(showGameHelp) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:meauBtn];
    
    [meauBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView).offset(0);
        make.right.equalTo(toolView).offset(-7 -41);
    }];
    
    // 聊天窗口
    
    UITableView *chatTableV = [self chatTableView];
    [_fontView addSubview:chatTableV];
    chatTableV.frame = CGRectMake(2, kScreenH - 160*kiphone6-35*kiphone6 -40 -130, kScreenW *0.66, 120);
//    [chatTableV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(toolView.mas_top).offset(-20);
//        make.left.equalTo(ws.fontView).offset(2);
//        make.width.mas_equalTo(kScreenW *0.66);
//        make.height.mas_equalTo(200);
//    }];
    
    [self.view addSubview:_fontView];
    [self.view bringSubviewToFront:_fontView];
    [self.view bringSubviewToFront:_turnView];
    
    
    UIView *danmakuView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH/4.0,kScreenW, kScreenH/2.0)];
    danmakuView.userInteractionEnabled = NO;
    [self.fontView addSubview:danmakuView];
    
    self.renderer = [[BarrageRenderer alloc]init];
    self.renderer.view.userInteractionEnabled = NO;
    self.renderer.masked = NO;
    self.renderer.delegate = self;
    self.renderer.redisplay = YES;
    self.renderer.canvasMargin = UIEdgeInsetsMake(30, 0, 30, 0);
    self.predictedTime = 0.0f;
    [self start];
    [danmakuView addSubview:self.renderer.view];
    

    
    
    UISwipeGestureRecognizer *recognizer_up = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer_up setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizer_up];
    
    UISwipeGestureRecognizer *recognizer_down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer_down setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizer_down];
    
    UISwipeGestureRecognizer *recognizer_right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer_right setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer_right];
    
    UISwipeGestureRecognizer *recognizer_left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer_left setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer_left];
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *gameUrl;
    switch (self.gameID) {
        case 0:{
            gameUrl = @"";
            meauBtn.hidden = YES;
            break;
        }
        case 1:
            gameUrl = zwwUrl;
            break;
        case 2:
            gameUrl = scjlUrl;
            break;
        case 3:
            gameUrl = cartsUrl;
            break;
        case 4:
            gameUrl = wlzbUrl;
            break;
        case 5:
            gameUrl = hdczUrl;
            break;
        default:
            gameUrl = @"";
            break;
    }
    
    NSString *httpHead;
    for (int i = 0; i<userModel.gameconflist.count; i++) {
        NSDictionary *dict = userModel.gameconflist[i];
        if ([dict[@"gameid"] integerValue] == self.gameID) {
            httpHead = dict[@"serverinfo"];
        }
    }
    NSLog(@"%@ /n httpHead = %@",userModel.gameconflist,httpHead);
    
    WKWebView *gameWeb = [[WKWebView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
    gameWeb.backgroundColor = [UIColor clearColor];
    //    if (self.gameID == 3) {
    //        [gameWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:gameUrl]]];
    //    }else{
    [gameWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@&token=%@&deviceno=%@&roomid=%@&httphead=%@",gameUrl,userModel.uid,userModel.token,@"",self.groupID,httpHead]]]];
    
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@?uid=%@&token=%@&deviceno=%@&roomid=%@&httphead=%@",gameUrl,userModel.uid,userModel.token,@"",self.groupID,httpHead]);
    //    }
    [gameWeb setOpaque:NO];
    gameWeb.navigationDelegate = self;
    gameWeb.UIDelegate = self;
    self.gameWebV = gameWeb;
    
    if (gameUrl.length >2) {
        [self.turnView addSubview:gameWeb];
        //        self.turnTypeBtn.selected = NO;
        //        self.turnTypeBtn.userInteractionEnabled = NO;
        //        [self.turnTypeBtn setImage:[UIImage imageNamed:@"tool_图层-1"] forState:UIControlStateNormal];
        
    }
    
    
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"RechargeScore"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"PrizeScore"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"OnChangeScore"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"OnCompleteGame"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"HitCompleteGame"];
    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"ShowCompleteGame"];
    //    [[_gameWebV configuration].userContentController addScriptMessageHandler:self name:@"RechargeScore"];
    
    
    [self settingKeyBoard];
    
    [self.turnView bringSubviewToFront:back_sendCountV];
    
}
- (void)start
{
    self.startDate = [NSDate date];
    [self.renderer start];
}

- (void)sendBarrageWithModel:(LIMBarrageModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.renderer receive:[self walkImageTextSpriteDescriptorAWithData:model]];
//        [self.renderer receive:[self avatarBarrageViewSpriteDescriptorWith]];
        
    });
}


//加载弹幕描述符
- (BarrageDescriptor *)walkImageTextSpriteDescriptorAWithData:(LIMBarrageModel *)model
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc] init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    descriptor.params[@"attributedText"] = model.attString;
    descriptor.params[@"trackNumber"] = @5;
//    descriptor.params[@"text"] = model.attString?:@"";
//    descriptor.params[@"textColor"] = [UIColor whiteColor];
//    descriptor.params[@"shadowColor"] = [UIColor darkGrayColor];
    descriptor.params[@"speed"] = @(0.5 * model.message.length + 100);
    return descriptor;
}


- (void)buttonDidClick:(LIMChatModel *)chatModel
{
    NSString *text = chatModel.msg;
    NSString *nameStr1 = [NSString stringWithFormat:@"%@:",chatModel.userName];
    LIMBarrageModel *model = [[LIMBarrageModel alloc] init];
//    model.message = @"我是个弹幕，弹幕，弹幕啊!";
    model.message = text;
    model.barrageColor = @"ffb412";
    model.fontSize = [NSString stringWithFormat:@"%f", 15.0f];
    model.delay = 0;
    
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
//    // 名字
//    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
//                              value:[UIColor colorWithHexString:@"d95147"]
//                              range:NSMakeRange(0, text.length)];
//    
//    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
//                              value:[UIFont systemFontOfSize:12]
//                              range:NSMakeRange(0, text.length)];
    //
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
//    attch.image = [UIImage imageNamed:@"pushpage_9"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:chatModel.userIcon]]];
    
    
    CGFloat imageW = 24;
    CGFloat imageH = 24;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // borderColor表示边框的颜色
//    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat borderWidth = 0.00001;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    [image drawInRect:CGRectMake(borderWidth, borderWidth, 24, 24)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    attch.image = newImage;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -6, 24, 24);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [aAttributedString appendAttributedString:string];
    
    
    
    NSMutableAttributedString * nameStr = [[NSMutableAttributedString alloc] initWithString:nameStr1];
    
    // 名字
    [nameStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                        value:[UIColor colorWithHexString:@"#F00000"]
                        range:NSMakeRange(0, nameStr1.length)];
    
    [nameStr addAttribute:NSFontAttributeName             //文字字体
                        value:[UIFont systemFontOfSize:15]
                        range:NSMakeRange(0, nameStr1.length)];
    
    [aAttributedString appendAttributedString:nameStr];

    
//    NSString *secondString = [NSString stringWithFormat:@"text"];
    NSMutableAttributedString * countString = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 名字
    [countString addAttribute:NSForegroundColorAttributeName  //文字颜色
                        value:[UIColor colorWithHexString:@"ffffff"]
                        range:NSMakeRange(0, text.length)];
    
    [countString addAttribute:NSFontAttributeName             //文字字体
                        value:[UIFont systemFontOfSize:15]
                        range:NSMakeRange(0, text.length)];
    
    [aAttributedString appendAttributedString:countString];
    model.attString = aAttributedString;
    
    [self sendBarrageWithModel:model];
}
#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:self.startDate];
    interval += self.predictedTime;
    return interval;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"123456");
}
- (void)showGameHelp{
    if(self.gameID >0){
        LIMGameHelpView *userInfoV = [[LIMGameHelpView alloc]init];
        NSLog(@"%ld",self.gameID);
        userInfoV.gameID = self.gameID;
        [userInfoV setUI];
    }
}
//WKScriptMessageHandler协议方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //code
    NSLog(@"WKScriptMessageHandler协议方法== %@",message.name);
    if ([message.name isEqualToString:@"RechargeScore"]) {
//        [self showAlertWithMessage:[NSString stringWithFormat:@"充钱%@",message.body]];
        
        if ([message.body isEqualToString:@"0"]) {
            [self pushChongzhi];
        }else if ([message.body isEqualToString:@"1"]) {
            [self noMoney];
        }
        
    }else if ([message.name isEqualToString:@"PrizeScore"]) {
        NSLog(@"%@",message.body);
        //        [self showAlertWithMessage:@"中奖通知"];
        NSLog(@"%@",message.body);
        
        NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
        }else{
            LIMWinPrize *infoModel = [LIMWinPrize mj_objectWithKeyValues:dic];
            [self winMoneyChat:message.body];
            //            if ([infoModel.msgtype isEqualToString:@"1"]) {
            [self prizeFly:infoModel];
            //            }
            //            NSLog(@"%@",dic);
        }
        
    }else if ([message.name isEqualToString:@"OnChangeScore"]) {
        //        [self showAlertWithMessage:@"分数改变通知"];
    }else if ([message.name isEqualToString:@"OnCompleteGame"]) {
        
        //        [self showAlertWithMessage:@"通知游戏加载完成"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = self.gameWebV.frame;
            frame.origin.y = 0;
            self.gameWebV.frame = frame;
            [self turnGameOrGitf:self.turnTypeBtn];
        });
        
    }else if ([message.name isEqualToString:@"HitCompleteGame"]) {
        NSLog(@"123%@",message.body);
        
//        [self showAlertWithMessage:@"隐藏"];
    }else if ([message.name isEqualToString:@"ShowCompleteGame"]) {
        //        [self showAlertWithMessage:@"显示"];
    }
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    completionHandler();
    NSLog(@"message,%@",message);
}

// 手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
        
        if(self.toolView.frame.origin.y != CGRectGetMaxY(self.view.frame) -40){
            //        [self showAlertWithMessage:@"swipe down"];
            NSString *inputValueJS = @"glidegame(1)";
            //执行JS
            [self.gameWebV evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
            }];
            [UIView animateWithDuration:0.3 animations:^{
                self.turnView.clickY = kScreenH;
                self.allPresentView.frame = CGRectMake(0, kScreenH, kScreenW, 160 *kiphone6 +35*kiphone6);
                self.toolView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) -40, kScreenW, 40);
                //    toolView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
                CGRect frame = self.tableView.frame;
                frame.origin.y = CGRectGetMaxY(self.view.frame) -40 -130;
                self.tableView.frame = frame;
            }];
        }
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
        if(self.toolView.frame.origin.y == CGRectGetMaxY(self.view.frame) -40){
            NSString *inputValueJS = @"glidegame(1)";
            //执行JS
            [self.gameWebV evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"value: %@ error: %@", response, error);
            }];
            //        [UIView animateWithDuration:0.5 animations:^{
            self.turnView.clickY = kScreenH - 160*kiphone6-35*kiphone6;
            if (self.turnTypeBtn.selected) {
                self.allPresentView.frame = CGRectMake(0, kScreenH- 160 *kiphone6 -35*kiphone6, kScreenW, 160 *kiphone6 +35*kiphone6);
            }
            CGRect frame = self.tableView.frame;
            frame.origin.y = kScreenH - 160*kiphone6-35*kiphone6 -40 -130;
            self.tableView.frame = frame;
//            self.tableView.frame = CGRectMake(2, kScreenH - 160*kiphone6-35*kiphone6 -40 -130, kScreenW *0.66, 120);
            self.toolView.frame = CGRectMake(0, kScreenH - 160*kiphone6-35*kiphone6  -40, kScreenW, 40);
            //    toolView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
            //        }];
        }
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        //        [self showAlertWithMessage:@"swipe left"];
        [UIView animateWithDuration:0.5 animations:^{
            self.fontView.frame = CGRectMake(0 *kScreenW, 0,kScreenW, kScreenH);
            self.turnView.frame = CGRectMake(0 *kScreenW, 0,kScreenW, kScreenH);
        }];
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        //        [self showAlertWithMessage:@"swipe right"];
        [UIView animateWithDuration:0.5 animations:^{
            self.fontView.frame = CGRectMake(2 *kScreenW, 0,kScreenW, kScreenH);
            self.turnView.frame = CGRectMake(2 *kScreenW, 0,kScreenW, kScreenH);
        }];
        
    }
}

// 键盘
- (void)settingKeyBoard{
    self.hiddenText = [[UITextField alloc]initWithFrame:CGRectMake(0, -300, 100, 100)];
    [_fontView addSubview:self.hiddenText];
    UIView *hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 500)];
    hiddenView.backgroundColor = [UIColor clearColor];
    hiddenView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapHiddenKedBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddKedBoard)];
    [hiddenView addGestureRecognizer:tapHiddenKedBoard];
    
    
    UIView *mainViw = [[UIView alloc]init];
    mainViw.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapEmpty = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emptyClick)];
    [mainViw addGestureRecognizer:tapEmpty];
    [hiddenView addSubview:mainViw];
    
    [mainViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(hiddenView).offset(0);
        make.left.equalTo(hiddenView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMessage setTitle:@"发送" forState:UIControlStateNormal];
    sendMessage.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendMessage.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    sendMessage.clipsToBounds = YES;
    sendMessage.layer.cornerRadius = 5;
    [sendMessage addTarget:self action:@selector(chatchatchat) forControlEvents:UIControlEventTouchUpInside];
    //    sendMessage.layer.borderWidth = 0.5;
    
    [mainViw addSubview:sendMessage];
    [sendMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mainViw).offset(0);
        make.right.equalTo(mainViw).offset(-10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    
    LQXSwitch *swit = [[LQXSwitch alloc] initWithFrame:CGRectMake(10, 10, 50, 24) onColor:[UIColor colorWithHexString:@"ffba01"] offColor:[UIColor colorWithHexString:@"dee1e9"] font:[UIFont systemFontOfSize:15] ballSize:20];
    swit.onText = @"女";
    swit.offText = @"男";
    swit.backClick = ^(){
        if (self.mainText.text.length ==0) {
            
            if (self.swit.isOn) {
                self.yellowLabel.hidden = NO;
                self.grayLabel.hidden = YES;
            }else{
                self.yellowLabel.hidden = YES;
                self.grayLabel.hidden = NO;
            }
        }
    };
    [mainViw addSubview:swit];
//    [swit addTarget:self action:@selector(switchSex:) forControlEvents:UIControlEventTouchUpInside];
    
    self.swit = swit;

//    UILabel *swit = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,30, 30)];
//    swit.backgroundColor = [UIColor redColor];
//    [mainViw addSubview:swit];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.text = @"";
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.cornerRadius = 5;
    textField.clipsToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    textField.adjustsFontSizeToFitWidth = YES;
    [textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    [mainViw addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mainViw).offset(0);
        make.left.equalTo(swit.mas_right).offset(10);
        make.right.equalTo(sendMessage.mas_left).offset(-20);
        make.height.mas_equalTo(30);
    }];
    self.mainText = textField;
    UILabel *grayLabel = [[UILabel alloc]init];
    grayLabel.textColor = [UIColor colorWithHexString:@"dee1e9"];
    grayLabel.text = @"说点什么吧";
    grayLabel.font = [UIFont systemFontOfSize:16];
    [self.mainText addSubview:grayLabel];
    [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainText).offset(0);
        make.left.equalTo(self.mainText).offset(10);
        make.right.equalTo(sendMessage.mas_left).offset(-20);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *yellowLabel = [[UILabel alloc]init];
    yellowLabel.textColor = [UIColor colorWithHexString:@"ffba01"];
    yellowLabel.text = @"开启弹幕，10K币/条";
    yellowLabel.font = [UIFont systemFontOfSize:16];
    [self.mainText addSubview:yellowLabel];
    yellowLabel.hidden = yellowLabel;
    [yellowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainText).offset(0);
        make.left.equalTo(self.mainText).offset(10);
        make.right.equalTo(sendMessage.mas_left).offset(-20);
        make.height.mas_equalTo(16);
    }];
    self.grayLabel = grayLabel;
    self.yellowLabel = yellowLabel;
    
    [self.mainText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 说点什么吧
    // 开启弹幕，10K币/条
    
    //    self.hiddenText.frame = CGRectMake(0, 0, kScreenW, 30);
    //    self.hiddenText.backgroundColor = [UIColor redColor];
    //    [mainViw addSubview:self.hiddenText];
    //
    
    
    
    
    
    
    
    _hiddenText.inputAccessoryView  = hiddenView;
    //    [_fontView addSubview:_hiddenText];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.mainText.text.length == 0) {
        if (self.swit.isOn) {
            self.yellowLabel.hidden = NO;
            self.grayLabel.hidden = YES;
        }else{
            self.yellowLabel.hidden = YES;
            self.grayLabel.hidden = NO;
        }
        
    }else{
        self.yellowLabel.hidden = YES;
        self.grayLabel.hidden = YES;
    }

}
- (void)textFieldShouldReturn{
    
    if (self.swit.isOn) {
        self.yellowLabel.hidden = NO;
        self.grayLabel.hidden = YES;
    }else{
        self.yellowLabel.hidden = YES;
        self.grayLabel.hidden = NO;
    }
}

//- (void)switchSex:(LQXSwitch *)swit
//{
//    
//    if (self.mainText.text.length ==0) {
//        
//    if (self.swit.isOn) {
//        self.yellowLabel.hidden = NO;
//        self.grayLabel.hidden = YES;
//    }else{
//        self.yellowLabel.hidden = YES;
//        self.grayLabel.hidden = NO;
//    }
//    }
//}

// 中奖飞屏
- (void)prizeFly:(LIMWinPrize *)winModel{
    //    1.
    
    NSLog(@"%@",winModel.nickname);
    
    NSInteger prizeType = 1; // 默认
    
    LiveUserModel *firstUser = [[LiveUserModel alloc]init];
    firstUser.iconUrl = winModel.avatar;//@"http://ww1.sinaimg.cn/large/c6a1cfeagy1ffbg8tb6wqj20gl0qogni.jpg";
    NSString *string;
    if (winModel.msg.length > 0 || [winModel.gameid isEqualToString:@"1"]) {
        if ([winModel.msgtype isEqualToString:@"1"]) {
            prizeType = 0;
        }else{
            prizeType = 2;
        }
        if (winModel.msg.length <= 0) {
            winModel.msg = [NSString stringWithFormat:@"在抓娃娃游戏中  抓到了%@",winModel.resultname];
        }
        string = [NSString stringWithFormat:@"%@  %@",winModel.nickname,winModel.msg];
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        // 名字
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor colorWithHexString:@"d95147"]
                                  range:NSMakeRange(0, winModel.nickname.length)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:11]
                                  range:NSMakeRange(0, winModel.nickname.length)];
        
        // 奖励内容
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor colorWithHexString:@"ffffff"]
                                  range:NSMakeRange(winModel.nickname.length, string.length -winModel.nickname.length)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:12]
                                  range:NSMakeRange(winModel.nickname.length, string.length -winModel.nickname.length)];
        
        firstUser.name = aAttributedString;
    }else{
        if ([winModel.msgtype isEqualToString:@"1"]) {
            prizeType = 1;
        }else{
            prizeType = 3;
        }
        string = [NSString stringWithFormat:@"  恭喜%@  在%@游戏中 赢得",winModel.nickname,winModel.gamename];
        
        
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        // 名字
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor colorWithHexString:@"d95147"]
                                  range:NSMakeRange(4, winModel.nickname.length)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:12]
                                  range:NSMakeRange(4, winModel.nickname.length)];
        
        // 奖励内容
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor colorWithHexString:@"ffffff"]
                                  range:NSMakeRange(0, 4)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:13]
                                  range:NSMakeRange(0, 4)];
        
        
        [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                                  value:[UIColor colorWithHexString:@"ffffff"]
                                  range:NSMakeRange(winModel.nickname.length +4, string.length -winModel.nickname.length-4)];
        
        [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                                  value:[UIFont systemFontOfSize:13]
                                  range:NSMakeRange(winModel.nickname.length +4, string.length -winModel.nickname.length-4)];
        
        // 添加表情
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"pushpage_9"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, -2, 16, 16);
        
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [aAttributedString appendAttributedString:string];
        
        NSString *secondString = [NSString stringWithFormat:@"x%@",winModel.winmoney];
        NSMutableAttributedString * countString = [[NSMutableAttributedString alloc] initWithString:secondString];
        
        // 名字
        [countString addAttribute:NSForegroundColorAttributeName  //文字颜色
                            value:[UIColor colorWithHexString:@"ffe119"]
                            range:NSMakeRange(0, secondString.length)];
        
        [countString addAttribute:NSFontAttributeName             //文字字体
                            value:[UIFont systemFontOfSize:13]
                            range:NSMakeRange(0, secondString.length)];
        
        [aAttributedString appendAttributedString:countString];
        firstUser.name = aAttributedString;
    }
    
    if(winModel.resultimg.length == 0)
        winModel.resultimg = @"";
    NSLog(@"%@",winModel.uid);
    
    
    NSDictionary *dict = @{
                           @"name": winModel.uid,
                           @"rewardMsg": string,
                           @"personSort": @"0",
                           @"goldCount": @"3",
                           @"type": winModel.uid,
                           @"picUrl": winModel.resultimg,
                           };
    
    LivePrizeListModel *listModel = [LivePrizeListModel mj_objectWithKeyValues:dict];
    LivePrizeShowModel * model = [LivePrizeShowModel giftModel:listModel userModel:firstUser];
    /**
     *  0  = 大奖   -有图片
     *  1  = 大奖   -没有图片
     *  2  = 特大奖 -有图片
     *  3  = 特大奖 -没有图片
     */
    model.type = prizeType;
    
    if ([winModel.msgtype isEqualToString:@"1"]) {
        [self.customPrizeShow animatedWithGiftModel:model];
    }else if ([winModel.msgtype isEqualToString:@"2"]){
        [self.customBigPrizeShow animatedWithGiftModel:model];
    }
    
    
    
}
- (void)offThisView{
    //    [stop];
    //    [self.gameWebV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",nil]]]];
    
    NSString *inputValueJS = @"colseScoket()";
    //执行JS
    [self.gameWebV evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"value: %@ error: %@", response, error);
    }];
    //    self.gameWebV = nil;
    //
    //    LIMHttpServer *myServer = [LIMHttpServer defaultClient];
    //    myServer.localHttpServer = nil;
    if ([self respondsToSelector:@selector(presentingViewController)]){
        self.presentingViewController.view.alpha = 0;
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isSuitableMachine:(int)targetPlatNum
{
    int mib[2] = {6, 1};
    size_t len = 0;
    char* machine;
    
    sysctl(mib, 2, NULL, &len, NULL, 0);
    
    machine = (char*)malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString* platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform length] > 6) {
        NSString * platNum = [NSString stringWithFormat:@"%C", [platform characterAtIndex: 6 ]];
        return ([platNum intValue] >= targetPlatNum);
    } else {
        return NO;
    }
    
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
//弹出alert
-(void)showAlertWithPushView{
    //    [self offThisView];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认关闭直播？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.animationArr removeAllObjects];
        [self cancelAnimation];
        
        [[TIMGroupManager sharedInstance] deleteGroup:self.groupID succ:^() {
            NSLog(@"delete group succ");
        }fail:^(int code, NSString* err) {
            NSLog(@"failed code: %d %@", code, err);
        }];
        
        NSLog(@"确认");
        _rtmpUrl = @"";
        if(_txLivePush != nil)
        {
            _txLivePush.delegate = nil;
            [self stopRtmpPublish];
            [self.myTimer setFireDate:[NSDate distantFuture]];
        }
        
        LIMLiveEndViewController *liveEnd = [[LIMLiveEndViewController alloc]init];
        liveEnd.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        liveEnd.backClick = ^(NSString *test){
            [self offThisView];
        };
        [self addChildViewController:liveEnd];
        [self.view addSubview:liveEnd.view];
        [self.view bringSubviewToFront:liveEnd.view];
        [liveEnd.iconImageV sd_setImageWithURL:[NSURL URLWithString:_livePushModel.avatar]];
        liveEnd.nameLabel.text = _livePushModel.nickname;
        
        CcUserModel *userModel = [CcUserModel defaultClient];
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"roomid":self.groupID}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mStop_Push method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                NSLog(@"ghjkl");
                NSDictionary * result = responseObject[@"result"];
                liveEnd.peopleCount.text = result[@"usercount"];
                liveEnd.charmCount.text = result[@"score"];
            }else{
                NSString * resmsg = responseObject[@"resmsg"];
                NSLog(@"resmsg = %@",resmsg);
                //                [self showAlertWithMessage:resmsg];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (_botttomView) {
        _botttomView.hidden = YES;
        CcUserModel *userInfo = [CcUserModel defaultClient];
        userInfo.beautyDepth = [NSString stringWithFormat:@"%g",_beautyDepth];
        userInfo.whiteningDepth = [NSString stringWithFormat:@"%g",_whiteningDepth];
        userInfo.eyeScaleLevel = [NSString stringWithFormat:@"%g",_eyeScaleLevel];
        userInfo.faceScaleLevel = [NSString stringWithFormat:@"%g",_faceScaleLevel];
        [userInfo saveAllInfo];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    //    [self stopRtmpPublish];
    [self.txLivePush pausePush];
}
- (void)viewWillAppear:(BOOL)animated{
    LIMHttpServer *myServer = [LIMHttpServer defaultClient];
    [myServer.localHttpServer start:nil];
    NSLog(@"%@",myServer.localHttpServer.isRunning?@"yes":@"NO");
    NSLog(@"%lu,,%lu",(unsigned long)myServer.localHttpServer.numberOfHTTPConnections,myServer.localHttpServer.numberOfWebSocketConnections);
    
    if (self.txLivePush) {
        [self.txLivePush resumePush];
    }
}
//结束推流，注意做好清理工作
- (void)stopRtmpPublish {
    [_txLivePush stopPreview];
    [_txLivePush stopPush];
    _txLivePush.delegate = nil;
    
    
    //    CcUserModel *userModel = [CcUserModel defaultClient];
    //
    //    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"roomid":self.groupID}];
    //    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret]];
    //    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    //
    //
    //    [[HttpClient defaultClient] requestWithPath:mStop_Push method:1 parameters:paraDict prepareExecute:^{
    //
    //    } success:^(NSURLSessionDataTask *task, id responseObject) {
    //        NSLog(@"%@",responseObject);
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //
    //    }];
    
    // 解散
    [[TIMGroupManager sharedInstance] deleteGroup:self.groupID succ:^() {
        NSLog(@"delete group succ");
    }fail:^(int code, NSString* err) {
        NSLog(@"failed code: %d %@", code, err);
    }];
    
    
    
}
- (void)showUserInfo{
    [self httpLivemLive_SimpleInfo:self.livePushModel.uid];
    //    LIMUPInfo *userInfoV = [[LIMUPInfo alloc]init];
    
    
    
    //    int x = arc4random() % 3;
    //    NSArray *arr = @[@"xxx：啊上课绝对是你的喀什地区哦 i 我激动 i 钱我就跑去挖掘潜力可没钱了；，啊什么的，。啊什么的了晴空万里；开",@"yyy：啊上课绝对是你的喀什",@"zzz：我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的我是最长的"];
    //    NSString *string = arr[x];
    //    [self addChatMessage:string];
}
- (void)showCharm{
    LIMCharmView *charmView = [[LIMCharmView alloc]initWithTouid:self.livePushModel.uid];
}
// 直播获取礼物列表
- (void)httpLivePresentList{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mLive_presentList method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSArray *liveList = responseObject[@"result"][@"giftlist"];
            for (NSDictionary *dict in liveList) {
                LIMPresentModel *liveModel = [LIMPresentModel mj_objectWithKeyValues:dict];
                [self.presentList addObject:liveModel];
            }
            NSLog(@"礼物个数 YYTabBarItem %ld",self.presentList.count);
            
            [self sequencePresentList];
            
            [self.presentView reloadData];
            //初始化数据源
            self.giftArr = [LiveGiftListModel mj_objectArrayWithKeyValuesArray:self.giftDataSource];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)sequencePresentList{
    NSInteger pages;
    if (self.presentList.count%8 == 0) {
        pages = self.presentList.count/8;
    }else{
        pages = self.presentList.count/8 +1;
    }
    NSInteger remainder = self.presentList.count%8;
    NSLog(@"%ld",remainder);
    
    for (int i = 0; i<8-remainder; i++) {
        LIMPresentModel *liveModel = [[LIMPresentModel alloc]init];
        liveModel.giftid = @"-100";
        [self.presentList addObject:liveModel];
    }
    NSMutableArray *reloadArray = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i < pages; i++ ) {              //  8个一组 重新排序
        NSArray *newArray = [self.presentList subarrayWithRange:NSMakeRange(i*8, 8)];
        [reloadArray addObject:newArray[1-1]];
        [reloadArray addObject:newArray[5-1]];
        [reloadArray addObject:newArray[2-1]];
        [reloadArray addObject:newArray[6-1]];
        [reloadArray addObject:newArray[3-1]];
        [reloadArray addObject:newArray[7-1]];
        [reloadArray addObject:newArray[4-1]];
        [reloadArray addObject:newArray[8-1]];
    }
    self.presentList = reloadArray;
}
// 刷新用户列表
- (void)refreshUserList{
    //    NSLog(@"---%@",self.groupID);
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"roomid":self.groupID,@"liveuid":self.livePushModel.uid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mLive_userList method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self.userList removeAllObjects];
            NSArray *liveList = responseObject[@"result"][@"userlist"];
            //            NSMutableArray * bannerList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *dict in liveList) {
                LIMUserListModel *liveModel = [LIMUserListModel mj_objectWithKeyValues:dict];
                [self.userList addObject:liveModel];
            }
            NSString *userCount = responseObject[@"result"][@"usercount"];
            NSString *comperescore = responseObject[@"result"][@"comperescore"];
            NSString *cumoney = responseObject[@"result"][@"cumoney"];
            self.userCountLabel.text = [NSString stringWithFormat:@"%@人",userCount];
            self.goldLabel.text = cumoney;
            self.charm_countLabel.text = comperescore;
            CGFloat buttonW = [cumoney boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width +2;
            NSLog(@"------------%g",buttonW);
            
//            self.goldTimes ++;
//            [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(buttonW).priority(1000);
//            }];
            
            LIMHttpServer *myServer = [LIMHttpServer defaultClient];
            //    [myServer.localHttpServer start:nil];
            NSLog(@"%@",myServer.localHttpServer.isRunning?@"yes":@"NO");
            NSLog(@"%lu,,%lu",(unsigned long)myServer.localHttpServer.numberOfHTTPConnections,myServer.localHttpServer.numberOfWebSocketConnections);
            
            [self.collectionView reloadData];
            
        }else{
            
            // 判断是否是当前页面
            
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            
            _rtmpUrl = @"";
            if(_txLivePush != nil)
            {
                _txLivePush.delegate = nil;
                [self stopRtmpPublish];
                [self.myTimer setFireDate:[NSDate distantFuture]];
            }
            
            LIMLiveEndViewController *liveEnd = [[LIMLiveEndViewController alloc]init];
            liveEnd.view.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            liveEnd.view.alpha = 0.7;
            liveEnd.backClick = ^(NSString *test){
                [self offThisView];
            };
            [self addChildViewController:liveEnd];
            [self.view addSubview:liveEnd.view];
            [self.view bringSubviewToFront:liveEnd.view];
            [liveEnd.iconImageV sd_setImageWithURL:[NSURL URLWithString:_livePushModel.avatar]];
            liveEnd.nameLabel.text = _livePushModel.nickname;
            
            CcUserModel *userModel = [CcUserModel defaultClient];
            NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
            [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"roomid":self.groupID}]];
            [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
            [[HttpClient defaultClient] requestWithPath:mStop_Push method:1 parameters:paraDict prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"%@",responseObject);
                NSString * rescode = responseObject[@"rescode"];
                if ([rescode isEqualToString:@"1"]) {
                    NSLog(@"ghjkl");
                    NSDictionary * result = responseObject[@"result"];
                    liveEnd.peopleCount.text = result[@"usercount"];
                    liveEnd.charmCount.text = result[@"score"];
                }else{
                    NSString * resmsg = responseObject[@"resmsg"];
                    NSLog(@"resmsg = %@",resmsg);
                    //                [self showAlertWithMessage:resmsg];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 77) {
        return self.userList.count;
    }else if(collectionView.tag == 78){
        return self.presentList.count;
    }
    
    else{
        return 0;
    }
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"collerct tag = %ld",collectionView.tag);
    if (collectionView.tag == 77) {
        
        LIMUserListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LIMUserListCell" forIndexPath:indexPath];
        LIMUserListModel *model = self.userList[indexPath.row];
        [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"place_icon"]];
        NSString *gradeName;
        if ([model.iscompere isEqualToString:@"1"]) {
            gradeName = [NSString stringWithFormat:@"upicon_%@",model.level];
        }else{
            gradeName = [NSString stringWithFormat:@"live_%@",model.level];
        }
        cell.gradeImageV.image = [UIImage imageNamed:gradeName];
        
        return cell;
    }else if(collectionView.tag == 78){
        LIMPresentModel *model = self.presentList[indexPath.row];
        
        
        LIMPresentListCollectionViewCell *cell = [_presentView dequeueReusableCellWithReuseIdentifier:@"LIMPresentListCollectionViewCell" forIndexPath:indexPath];
        
        if (![model.giftid isEqualToString:@"-100"]) {
            [cell.giftIcon sd_setImageWithURL:[NSURL URLWithString:model.giftimg]];
            if (indexPath.row == self.currentGiftIndex) {
                cell.selectImage.hidden = NO;
            }else{
                cell.selectImage.hidden = YES;
            }
            // 创建一个富文本
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.giftprice]];
            
            // 修改富文本中的不同文字的样式
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffbe3a"] range:NSMakeRange(0, model.giftprice.length)];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, model.giftprice.length)];
            
            // 设置数字为红色
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(model.giftprice.length, 1)];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(model.giftprice.length, 1)];
            
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"pushpage_9"];
            // 设置图片大小
            attch.bounds = CGRectMake(0, -2, 16, 16);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri appendAttributedString:string];
            
            // 用label的attributedText属性来使用富文本
            cell.money.attributedText = attri;
        }else{
            cell.money.attributedText = nil;
            cell.giftIcon.image = nil;
        }
        
        //        cell.money.text = model.giftprice;
        return cell;
        
    }else{
        return nil;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 77) {
        LIMUserListModel *model = self.userList[indexPath.row];
        [self httpLivemLive_SimpleInfo:model.uid];
    }else{
        if (indexPath.row == self.currentGiftIndex) {
//            LIMPresentListCollectionViewCell *presentCell = (LIMPresentListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//            presentCell.selectImage.hidden = YES;
//            self.currentGiftIndex = -1;
        }else{
            
            LIMPresentModel *model = self.presentList[indexPath.row];
            if (![model.giftid isEqualToString:@"-100"]) {
                
                self.currentGiftCount = @"1";
                self.sendCount.text = [NSString stringWithFormat:@"%@",@"     ×1"];
                // !!!!!!添加label显示
                for (int i = 0; i<self.presentList.count; i++) {
                    NSIndexPath *allPath = [NSIndexPath indexPathForRow:i inSection:0];
                    LIMPresentListCollectionViewCell *presentCell = (LIMPresentListCollectionViewCell *)[collectionView cellForItemAtIndexPath:allPath];
                    presentCell.selectImage.hidden = YES;
                }
                LIMPresentListCollectionViewCell *presentCell = (LIMPresentListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                presentCell.selectImage.hidden = NO;
                self.currentGiftIndex = indexPath.row;
            }
        }
    }
    
}
// 个人信息弹窗
- (void)httpLivemLive_SimpleInfo:(NSString *)touid{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mLive_SimpleInfo method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *infoDict = responseObject[@"result"];
            LIMSimpleInfoModel *infoModel = [LIMSimpleInfoModel mj_objectWithKeyValues:infoDict];
            LIMUPInfo *userInfoV = [[LIMUPInfo alloc]init];
            userInfoV.simpleInfoModel = infoModel;
            [userInfoV setUI];
            __block LIMUPInfo *userInfoV_block = userInfoV;
            userInfoV.backClick = ^(id type){
                if ([type isKindOfClass:[NSString class]]) {
                    [self showOtherInfo:touid];
                }else{
                    LIMSimpleInfoModel *back_model = type;
                    LIMChatListModel *chatListModel = [[LIMChatListModel alloc]init];
                    chatListModel.kkID = [NSString stringWithFormat:@"kk%@",back_model.uid];
                    chatListModel.uid = back_model.uid;
                    chatListModel.iconUrl = back_model.cover;
                    chatListModel.time = @"";
                    chatListModel.nickName = back_model.nickname;
                    chatListModel.chatStr = @"";
                    chatListModel.unReadNum = 0;
            
                    LIMPushChatDetaiViewController *v =[[LIMPushChatDetaiViewController alloc]init];
                    v.chatListModel = chatListModel;
                    v.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
                    v.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    //        [self.navigationController pushViewController:v animated:YES];
                    [self presentViewController:v animated:YES completion:^{
                        
                    }];
                    // 私信
                    [userInfoV_block dismiss:nil];
                }
            };
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)showOtherInfo:(NSString *)touid{
    LIMOtherInfoViewController *otherV = [[LIMOtherInfoViewController alloc]init];
    otherV.touid = touid;
    YYNavigationController *otherNV = [[YYNavigationController alloc]initWithRootViewController:otherV];
    [self presentViewController:otherNV animated:YES completion:^{

    }];
}

- (void)turnGameOrGitf:(UIButton *)sender{
    NSLog(@"%g",self.toolView.frame.origin.y);
    if(self.toolView.frame.origin.y != CGRectGetMaxY(self.view.frame) -40){
        // 0  =  游戏
        sender.selected = !sender.selected;
        
        if (!sender.selected) {
            [sender setImage:[UIImage imageNamed:@"tool_图层-1"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3 animations:^{
                self.gameWebV.alpha = 1;
                self.allPresentView.frame = CGRectMake(0, kScreenH, kScreenW, 160 *kiphone6 +35*kiphone6);
            }];
        }else{
            [sender setImage:[UIImage imageNamed:@"pushpage_6"] forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.gameWebV.alpha = 0;
                self.allPresentView.frame = CGRectMake(0, kScreenH- 160 *kiphone6 -35*kiphone6, kScreenW, 160 *kiphone6 +35*kiphone6);
            }];
        }
    }else{
        NSString *inputValueJS = @"glidegame(1)";
        //执行JS
        [self.gameWebV evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"value: %@ error: %@", response, error);
        }];
        //        [UIView animateWithDuration:0.5 animations:^{
        self.turnView.clickY = kScreenH - 160*kiphone6-35*kiphone6;
        self.allPresentView.frame = CGRectMake(0, kScreenH- 160 *kiphone6 -35*kiphone6, kScreenW, 160 *kiphone6 +35*kiphone6);
        self.toolView.frame = CGRectMake(0, kScreenH - 160*kiphone6-35*kiphone6  -40, kScreenW, 40);
    }
}
- (void)showKedBoard:(UIButton *)sender{
    if (sender.selected == NO) {
        // 弹出键盘
        [self.hiddenText becomeFirstResponder];
    }else{
        
    }
    sender.selected = !sender.selected;
}
- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    
    
    CGFloat systemKeyBoardHeight =[notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue].size.height -500;
    NSLog(@"pushVC.keyboardH = %g",systemKeyBoardHeight);

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"keybordshow" object:[NSString stringWithFormat:@"%g",systemKeyBoardHeight]];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.tableView.frame;
        frame.origin.y = kScreenH-systemKeyBoardHeight-130;
        self.tableView.frame = frame;
//        self.tableView.frame = CGRectMake(2, kScreenH-systemKeyBoardHeight-130-44, kScreenW *0.66, 120);
    }];
    
    [self.mainText becomeFirstResponder];
}
- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    
    
    
    
    //    [UIView animateWithDuration:0.1 animations:^{
    //        self.toolView.alpha = 1;
    //    }];
    
    if (self.turnView.clickY != kScreenH) {
        // 显示礼物时
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.origin.y = kScreenH - 160*kiphone6-35*kiphone6 -40 -130;
            self.tableView.frame = frame;
//            self.tableView.frame = CGRectMake(2, kScreenH - 160*kiphone6-35*kiphone6 -40 -130, kScreenW *0.66, 120);
        }];
        
        
    }else{
        // 显示礼物时
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.tableView.frame;
            frame.origin.y = CGRectGetMaxY(self.view.frame) -40 -130;
            self.tableView.frame = frame;
//            self.tableView.frame = CGRectMake(2, CGRectGetMaxY(self.view.frame) -40 -130, kScreenW *0.66, 120);
        }];
        
        
    }
    
}
- (void)receiveMessage:(NSNotification*)notification //新消息
{
    //    CcUserModel *userModel = [CcUserModel defaultClient];
    LIMChatModel *chatModel = notification.object;
    [self addChatMessage:chatModel];
    if ([chatModel.type isEqualToString:@"6"]) {
        NSLog(@"%@, %@,%@，%@",chatModel.giftname,chatModel.giftID,chatModel.giftimg,chatModel.giftCount);
        
        NSDictionary *dict = @{
                               @"name": chatModel.giftname,
                               @"rewardMsg": [NSString stringWithFormat:@"送出了一个%@",chatModel.giftname],
                               @"personSort": @"2",
                               @"goldCount": @"8",
                               @"type": chatModel.giftID,
                               @"picUrl": chatModel.giftimg
                               };
        
        LiveGiftListModel *listModel = [LiveGiftListModel mj_objectWithKeyValues:dict];
        //        for (int i = 0; i<[chatModel.giftCount intValue]; i++) {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i *0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LiveUserModel *fourthUser = [[LiveUserModel alloc]init];
        fourthUser.name = chatModel.userName;
        fourthUser.iconUrl = chatModel.userIcon;
        
        LiveGiftShowModel * model = [LiveGiftShowModel giftModel:listModel userModel:fourthUser];
        model.toNumber = [chatModel.giftCount intValue];
        [self.customGiftShow animatedWithGiftModel:model];
        
//        for (int i = 0; i<[chatModel.giftCount intValue]; i++) {
        
//        }
        LIMGiftArrModel *giftArrModel = [[LIMGiftArrModel alloc]init];
        giftArrModel.giftID = chatModel.giftID;
        giftArrModel.count = [chatModel.giftCount integerValue];
//        giftArrModel.animationTime = self.animationTime;
        giftArrModel.isFirst = YES;
        
        NSString *giftID = giftArrModel.giftID;
                // 组合动画  3 32 - 9 12 15 -16 21 22 23 -26   -------- 10个
        if ([giftID isEqualToString:@"4"]||[giftID isEqualToString:@"6"]||[giftID isEqualToString:@"14"]||[giftID isEqualToString:@"17"]||[giftID isEqualToString:@"18"]||[giftID isEqualToString:@"19"]||[giftID isEqualToString:@"25"]||[giftID isEqualToString:@"28"]||[giftID isEqualToString:@"29"]||[giftID isEqualToString:@"31"]||[giftID isEqualToString:@"3"]||[giftID isEqualToString:@"32"]||[giftID isEqualToString:@"9"]||[giftID isEqualToString:@"12"]||[giftID isEqualToString:@"15"]||[giftID isEqualToString:@"16"]||[giftID isEqualToString:@"21"]||[giftID isEqualToString:@"22"]||[giftID isEqualToString:@"23"]||[giftID isEqualToString:@"26"]) {
            [self bigGiftAnimation:giftArrModel];
        }
//        [self bigGiftAnimation:chatModel.giftID];
        //            });
        
        //        }
    }else if([chatModel.type isEqualToString:@"2"]){
        [self loginAnimation:chatModel.level andUserName:chatModel.userName andUserIcon:chatModel.userIcon];
    }
}
- (void)receivePrize:(NSNotification*)notification //新消息
{
    LIMWinPrize *chatModel = notification.object;
    [self prizeFly:chatModel];
}


//-(void)sendMessageToIM{
//
//}
- (void)hiddKedBoard{
    NSLog(@"123");
    [self.hiddenText resignFirstResponder];
    [self.mainText resignFirstResponder];
}

- (void)chatchatchat{
    NSLog(@"%@",_groupID);
    NSNumber *number;
    if (self.swit.isOn) {
        number = @5; // 发弹幕
        CcUserModel * userModel = [CcUserModel defaultClient];
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"roomid":self.groupID,@"liveuid":self.livePushModel.uid,@"msg":self.mainText.text}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mFlyMsg method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                CcUserModel *userModel = [CcUserModel defaultClient];
                //    self.mainText;
                NSLog(@"SendMsg Succ,%@",userModel.iscompere);
                NSDictionary *dict = @{
                                       @"headPic":self.livePushModel.avatar,
                                       @"msg":self.mainText.text,
                                       @"nickName":self.livePushModel.nickname,
                                       @"userAction":number,
                                       @"userId":self.livePushModel.uid,
                                       @"level":self.livePushModel.level,
                                       @"isHost":userModel.iscompere
                                       };
                NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
                
                TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
                TIMTextElem * text_elem = [[TIMTextElem alloc] init];
                [text_elem setText:jsonString];
                TIMMessage * msg = [[TIMMessage alloc] init];
                [msg addElem:text_elem];
                [grp_conversation sendMessage:msg succ:^(){
                    NSLog(@"SendMsg Succ,%@",userModel.iscompere);
                    NSString *string = [NSString stringWithFormat:@"%@:%@",self.livePushModel.nickname,self.mainText.text];
                    LIMChatModel *chatModel = [[LIMChatModel alloc]init];
                    chatModel.nameLength = self.livePushModel.nickname.length +1;
                    chatModel.sentence = string;
                    chatModel.type = @"1";
                    
                    chatModel.isUp =  userModel.iscompere;
                    chatModel.level = userModel.userlevel;
                    chatModel.userName = userModel.nickname;
                    chatModel.userIcon = userModel.cover;
                    chatModel.msg = self.mainText.text;
                    
                    [self addChatMessage:chatModel];
                    
                    if ([number integerValue] == 5) {
                        [self buttonDidClick:chatModel];
                    }
                    [self textFieldShouldReturn];
                    self.mainText.text = @"";
                }fail:^(int code, NSString * err) {
                    NSLog(@"SendMsg Failed:%d->%@", code, err);
                }];

            }else{
                NSString * resmsg = responseObject[@"resmsg"];
                NSLog(@"resmsg = %@",resmsg);
                //                [self showAlertWithMessage:resmsg];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    }else{
        number = @1;
        CcUserModel *userModel = [CcUserModel defaultClient];
        //    self.mainText;
        NSLog(@"SendMsg Succ,%@",userModel.iscompere);
        NSDictionary *dict = @{
                               @"headPic":self.livePushModel.avatar,
                               @"msg":self.mainText.text,
                               @"nickName":self.livePushModel.nickname,
                               @"userAction":number,
                               @"userId":self.livePushModel.uid,
                               @"level":self.livePushModel.level,
                               @"isHost":userModel.iscompere
                               };
        NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
        
        TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
        TIMTextElem * text_elem = [[TIMTextElem alloc] init];
        [text_elem setText:jsonString];
        TIMMessage * msg = [[TIMMessage alloc] init];
        [msg addElem:text_elem];
        [grp_conversation sendMessage:msg succ:^(){
            NSLog(@"SendMsg Succ,%@",userModel.iscompere);
            NSString *string = [NSString stringWithFormat:@"%@:%@",self.livePushModel.nickname,self.mainText.text];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.nameLength = self.livePushModel.nickname.length +1;
            chatModel.sentence = string;
            chatModel.type = @"1";
            
            chatModel.isUp =  userModel.iscompere;
            chatModel.level = userModel.userlevel;
            chatModel.userName = userModel.nickname;
            chatModel.userIcon = userModel.cover;
            chatModel.msg = self.mainText.text;
            
            [self addChatMessage:chatModel];
            
            if ([number integerValue] == 5) {
                [self buttonDidClick:chatModel];
            }
            [self textFieldShouldReturn];
            self.mainText.text = @"";
        }fail:^(int code, NSString * err) {
            NSLog(@"SendMsg Failed:%d->%@", code, err);
        }];

    }
    
    
    

}
- (void)giftChat:(NSString *)giftCount andGift:(LIMPresentModel *)gift{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSDictionary *dict = @{
                           @"headPic":self.livePushModel.avatar,
                           @"nickName":self.livePushModel.nickname,
                           @"userAction":@(6),
                           @"userId":self.livePushModel.uid,
                           @"giftId":gift.giftid,
                           @"giftName":gift.giftname,
                           @"giftIcon":gift.giftimg,
                           @"giftCount":giftCount,
                           @"addSource":gift.giftprice,
//                           @"effect":@"0",
                           @"isLocal":@"1",
                           @"level":self.livePushModel.level,
                           @"msg":[NSString stringWithFormat:@"送给了主播%ld%@%@",[giftCount integerValue],gift.unit,gift.giftname],
                           @"isHost":userModel.iscompere,
                           @"giftUnit":gift.unit,
                           @"effect":gift.effect
                           };
    NSLog(@"%@",dict);
    
    
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
    
    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:jsonString];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    [grp_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
        NSString *string = [NSString stringWithFormat:@"%@ 送给了主播%ld%@%@",self.livePushModel.nickname,[giftCount integerValue],gift.unit,gift.giftname];
        LIMChatModel *chatModel = [[LIMChatModel alloc]init];
        chatModel.nameLength = self.livePushModel.nickname.length +1;
        chatModel.sentence = string;
        chatModel.type = @"6";
        
        chatModel.isUp =  userModel.iscompere;
        chatModel.level = userModel.userlevel;
        [self addChatMessage:chatModel];
        self.mainText.text = @"";
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}
- (void)enterChat{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSLog(@"%@",_groupID);
    NSString *text = @"大驾光临";
    //    self.mainText;
    
    NSDictionary *dict = @{
                           @"headPic":self.livePushModel.avatar,
                           @"msg":text,
                           @"nickName":self.livePushModel.nickname,
                           @"userAction":@(2),
                           @"userId":self.livePushModel.uid,
                           @"level":self.livePushModel.level,
                           @"isHost":userModel.iscompere
                           };
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
    
    
    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:jsonString];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    [grp_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
        NSString *string = [NSString stringWithFormat:@"%@ %@",self.livePushModel.nickname,self.mainText.text];
        LIMChatModel *chatModel = [[LIMChatModel alloc]init];
        chatModel.nameLength = self.livePushModel.nickname.length +1;
        chatModel.sentence = string;
        chatModel.type = @"1";
        chatModel.isUp =  userModel.iscompere;
        chatModel.level = userModel.userlevel;
        [self addChatMessage:chatModel];
        self.mainText.text = @"";
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}
- (void)danmuChat{
    
}
- (void)shareChat{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *text = @"分享了主播，小伙伴们马上就来了";
    NSDictionary *dict = @{@"headPic":self.livePushModel.avatar,@"msg":text,@"nickName":self.livePushModel.nickname,@"userAction":@(7),@"userId":self.livePushModel.uid,@"level":self.livePushModel.level,@"isHost":userModel.iscompere};
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
    
    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:jsonString];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    [grp_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
        NSString *string = [NSString stringWithFormat:@"%@ %@",self.livePushModel.nickname,self.mainText.text];
        LIMChatModel *chatModel = [[LIMChatModel alloc]init];
        chatModel.nameLength = self.livePushModel.nickname.length +1;
        chatModel.sentence = string;
        chatModel.type = @"1";
        chatModel.isUp =  userModel.iscompere;
        chatModel.level = userModel.userlevel;
        [self addChatMessage:chatModel];
        self.mainText.text = @"";
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}
- (void)followChat{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *text = @"二话不说就关注了主播";
    NSDictionary *dict = @{@"headPic":self.livePushModel.avatar,@"msg":text,@"nickName":self.livePushModel.nickname,@"userAction":@(8),@"userId":self.livePushModel.uid,@"level":self.livePushModel.level,@"isHost":userModel.iscompere};
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
    
    TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
    TIMTextElem * text_elem = [[TIMTextElem alloc] init];
    [text_elem setText:jsonString];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:text_elem];
    [grp_conversation sendMessage:msg succ:^(){
        NSLog(@"SendMsg Succ");
        
        NSString *string = [NSString stringWithFormat:@"%@ %@",self.livePushModel.nickname,self.mainText.text];
        LIMChatModel *chatModel = [[LIMChatModel alloc]init];
        chatModel.nameLength = self.livePushModel.nickname.length +1;
        chatModel.sentence = string;
        chatModel.type = @"1";
        chatModel.isUp =  userModel.iscompere;
        chatModel.level = userModel.userlevel;
        
        [self addChatMessage:chatModel];
        self.mainText.text = @"";
        
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}
- (void)winMoneyChat:(NSString *)winMoney{
    
    NSData *jsonData = [winMoney dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
    }else{
        CcUserModel *userModel = [CcUserModel defaultClient];
        NSString *text = [NSString stringWithFormat:@"赢得了%@个金币",dic[@"winmoney"]];
        LIMWinPrize *infoModel = [LIMWinPrize mj_objectWithKeyValues:dic];
        if(infoModel.msg.length >0){
            text = infoModel.msg;
        }
        NSDictionary *dict = @{@"headPic":self.livePushModel.avatar,@"msg":winMoney,@"nickName":self.livePushModel.nickname,@"userAction":@(9),@"userId":self.livePushModel.uid,@"level":self.livePushModel.level,@"isHost":userModel.iscompere};
        NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
        
        TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:_groupID];
        TIMTextElem * text_elem = [[TIMTextElem alloc] init];
        [text_elem setText:jsonString];
        TIMMessage * msg = [[TIMMessage alloc] init];
        [msg addElem:text_elem];
        NSLog(@"%@",jsonString);
        [grp_conversation sendMessage:msg succ:^(){
            NSLog(@"SendMsg Succ");
            
            NSString *string = [NSString stringWithFormat:@"%@ %@",self.livePushModel.nickname,text];
            LIMChatModel *chatModel = [[LIMChatModel alloc]init];
            chatModel.nameLength = self.livePushModel.nickname.length +1;
            chatModel.sentence = string;
            chatModel.type = @"9";
            chatModel.isUp =  userModel.iscompere;
            chatModel.level = userModel.userlevel;
            [self addChatMessage:chatModel];
            self.mainText.text = @"";
            
        }fail:^(int code, NSString * err) {
            NSLog(@"SendMsg Failed:%d->%@", code, err);
        }];
    }
}

-(UITableView *)chatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,364.5 -63) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = kScreenW *77/320.0 +10;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[LIMChatAVRoomTableViewCell class] forCellReuseIdentifier:@"LIMChatAVRoomTableViewCell"];
    return self.tableView;
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMChatModel *chatModel = self.chatH[indexPath.row];
    return chatModel.labelH;
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatH.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMChatAVRoomTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMChatAVRoomTableViewCell" forIndexPath:indexPath];
    LIMChatModel *chatModel = self.chatH[indexPath.row];
    [hotLiveCell setCellInfo:chatModel];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    hotLiveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return hotLiveCell;
}

- (void)addChatMessage:(LIMChatModel *)chatModel{
    NSString *longString = [NSString stringWithFormat:@"          %@",chatModel.sentence];
    CGFloat buttonH = [longString boundingRectWithSize:CGSizeMake(kScreenW *0.66, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    //    LIMChatModel *chatModel = [[LIMChatModel alloc]init];
    //    chatModel.nameLength = 4.0;
    chatModel.labelH = buttonH +2.0;
    //    chatModel.sentence = string;
    //    chatModel.type = @"1";
    [self.chatH addObject:chatModel];
    [self.tableView reloadData];
    // 切换到底部
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_chatH.count - 1 inSection:0];
    if (indexPath.row < [_tableView numberOfRowsInSection:0]) {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    if ([chatModel.type isEqualToString:@"5"]) {
        [self buttonDidClick:chatModel];
    }
    
}
// 关注他人
- (void)followOther:(NSString *)touid{
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"touid":touid}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mFollow_other method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self followChat];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)emptyClick{
    
}


//- (LiveGiftShowCustom *)customGiftShow{
//    if (!_customGiftShow) {
//
//
//    }
//    return _customGiftShow;
//}


///////////////////////// gift


///////////////////////////////

- (NSArray *)giftDataSource{
    if (!_giftDataSource) {
        //        _giftDataSource = @[
        //                            @{
        //                                @"name": @"松果",
        //                                @"rewardMsg": @"扔出一颗松果",
        //                                @"personSort": @"0",
        //                                @"goldCount": @"3",
        //                                @"type": @"0",
        //                                @"picUrl": @"http://ww3.sinaimg.cn/large/c6a1cfeagw1fbks9dl7ryj205k05kweo.jpg",
        //                                },
        //                            @{
        //                                @"name": @"花束",
        //                                @"rewardMsg": @"献上一束花",
        //                                @"personSort": @"6",
        //                                @"goldCount": @"66",
        //                                @"type": @"1",
        //                                @"picUrl": @"http://ww1.sinaimg.cn/large/c6a1cfeagw1fbksa4vf7uj205k05kaa0.jpg",
        //                                },
        //                            @{
        //                                @"name": @"果汁",
        //                                @"rewardMsg": @"递上果汁",
        //                                @"personSort": @"3",
        //                                @"goldCount": @"18",
        //                                @"type": @"2",
        //                                @"picUrl": @"http://ww2.sinaimg.cn/large/c6a1cfeagw1fbksajipb8j205k05kjri.jpg",
        //                                },
        //                            @{
        //                                @"name": @"棒棒糖",
        //                                @"rewardMsg": @"递上棒棒糖",
        //                                @"personSort": @"2",
        //                                @"goldCount": @"8",
        //                                @"type": @"3",
        //                                @"picUrl": @"http://ww2.sinaimg.cn/large/c6a1cfeagw1fbksasl9qwj205k05kt8k.jpg",
        //                                },
        //                            @{
        //                                @"name": @"泡泡糖",
        //                                @"rewardMsg": @"一起吃泡泡糖吧",
        //                                @"personSort": @"2",
        //                                @"goldCount": @"8",
        //                                @"type": @"4",
        //                                @"picUrl": @"http://a3.qpic.cn/psb?/V12A6SP10iIW9i/AL.CfLAFH*W.Ge1n*.LwpXSImK.Hm1eCMtt4rm5WvCA!/b/dFOyjUpCBwAA&bo=yADIAAAAAAABACc!&rf=viewer_4"
        //                                },
        //                            ];
        NSMutableArray *tempGiftList = [[NSMutableArray alloc]initWithCapacity:2];
        for (LIMPresentModel *persentModel in self.presentList) {
            if (![persentModel.giftid isEqualToString:@"-100"]) {
                
                
                NSDictionary *dict = @{
                                       @"name": persentModel.giftname,
                                       @"rewardMsg": [NSString stringWithFormat:@"送出了一个%@",persentModel.giftname],
                                       @"personSort": @"2",
                                       @"goldCount": @"8",
                                       @"type": persentModel.giftid,
                                       @"picUrl": persentModel.giftimg
                                       };
                [tempGiftList addObject:dict];
            }
        }
        _giftDataSource = tempGiftList;
    }
    return _giftDataSource;
}
- (void)showSharView{
    LIMLiveShareView *liveShare = [[LIMLiveShareView alloc]init];
}
- (void)showMsg{
    NSLog(@"showMsg");
    LIMPushMsgCenterViewController* pushMsg = [[LIMPushMsgCenterViewController alloc]init];
    pushMsg.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    pushMsg.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pushMsg animated:YES completion:^{
        
    }];
}
- (void)showTorch:(UIButton *)sender{
    NSLog(@"摄像头前置？%@",_txLivePush.frontCamera?@"前置摄像头":@"后置摄像头");
    if(!self.turnFront) {
        NSLog(@"闪光灯");
        sender.selected = !sender.selected;
        [_txLivePush toggleTorch:sender.selected];
    }else{
        //        [self webShowText];
        [self showAlertWithMessage:@"需开启前置摄像头"];
    }
}
- (void)editTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入您要更改的标题" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"请输入标题";
    [alert show];
    
}

#pragma mark - 点击代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        CcUserModel * userModel = [CcUserModel defaultClient];
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"roomid":self.groupID,@"livetitle":txt.text}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mSaveTitle method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                
                // 获取txt内容即可
                //        NSLog(@"更改标题为:%@",txt.text);
                NSString *string = [NSString stringWithFormat:@"%@ 更改标题为  %@",self.livePushModel.nickname,txt.text];
                LIMChatModel *chatModel = [[LIMChatModel alloc]init];
                chatModel.nameLength = self.livePushModel.nickname.length +1;
                chatModel.sentence = string;
                chatModel.type = @"1";
                chatModel.isUp =  userModel.iscompere;
                chatModel.level = userModel.userlevel;
                [self addChatMessage:chatModel];

            }else{
                NSString * resmsg = responseObject[@"resmsg"];
                NSLog(@"resmsg = %@",resmsg);
                //                [self showAlertWithMessage:resmsg];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    }
    
    
}

- (void)createBottomView
{
    //    1111
    
    // 美颜整体视图
    _botttomFaceView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
    _botttomFaceView.hidden = YES;
    [self.playView addSubview:_botttomFaceView];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap2:)];
    [_botttomFaceView addGestureRecognizer:singleTap];
    UIView * btnBkgView = [[UIView alloc] init ];//WithFrame:CGRectMake(0, size.height - btnBkgViewHeight, size.width, btnBkgViewHeight)];
    btnBkgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    btnBkgView.userInteractionEnabled = YES;
    [_botttomFaceView addSubview:btnBkgView];
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [btnBkgView addGestureRecognizer:singleTap2];
    
    [btnBkgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_botttomFaceView).offset(0);
        make.left.equalTo(_botttomFaceView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(103.5 +44);
    }];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"787878"];
    [btnBkgView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBkgView).offset(44);
        make.left.equalTo(btnBkgView);
        make.width.equalTo(btnBkgView.mas_width);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"美颜";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14];
    [title sizeToFit];
    [btnBkgView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnBkgView).offset(15);
        make.left.equalTo(btnBkgView).offset(17.5 *kiphone6);
    }];
    
    
    UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [defaultBtn setTitle:@"恢复默认" forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    defaultBtn.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    defaultBtn.layer.cornerRadius = 12;
    defaultBtn.clipsToBounds = YES;
    defaultBtn.tag = 1000 +12;
    [defaultBtn addTarget:self action:@selector(setBeautyLeave:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBkgView addSubview:defaultBtn];
    _btnBkgView = btnBkgView;
    
    [defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title).offset(0);
        make.right.equalTo(btnBkgView).offset(-10);
        make.width.mas_offset(80);
        make.height.mas_equalTo(24);
    }];
    CGFloat padding = (kScreenW - 17.5*2 *kiphone6  - 43 *5 *kiphone6)/4.0;
    for (int i = 0; i < 5; i++) {
        UIButton *gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gradeBtn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        gradeBtn.backgroundColor = [UIColor clearColor];
        gradeBtn.layer.cornerRadius = 43/2.0 *kiphone6;
        gradeBtn.clipsToBounds = YES;
        [gradeBtn addTarget:self action:@selector(setBeautyLeave:) forControlEvents:UIControlEventTouchUpInside];
        gradeBtn.tag = 1000 +i;
        [btnBkgView addSubview:gradeBtn];
        [gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnBkgView).offset(17.5*kiphone6 + i*(43 *kiphone6 +padding));
            make.bottom.equalTo(btnBkgView).offset(-29.5);
            make.width.mas_offset(43 *kiphone6);
            make.height.mas_equalTo(43 *kiphone6);
        }];
        if (i == 2) {
            gradeBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            [gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    
    //
    //
    
    // 美颜 滑动条
    
    UIView *sliderV = [[UIView alloc]init];
    sliderV.backgroundColor = [UIColor clearColor];
    [_botttomFaceView addSubview:sliderV];
    _sliderV = sliderV;
    [sliderV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnBkgView.mas_top).offset(0);
        make.left.equalTo(btnBkgView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(72.5);
    }];
    UITapGestureRecognizer* sliderVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [sliderV addGestureRecognizer:sliderVTap];
    
    NSArray *titleArray = @[@"白皙",@"磨皮",@"大眼",@"瘦脸"];
    CGFloat yDefault = 0;
    for (int i = 0; i<4; i++) {
        if (i > 1) {
            yDefault = 43.5 +0;
        }
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [sliderV addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sliderV).offset(yDefault);
            make.left.equalTo(sliderV).offset(17.5 *kiphone6 + ((i%2)+1) *kScreenW/2.0 - kScreenW/2.0);
            make.width.mas_equalTo(33);
            make.height.mas_equalTo(15);
        }];
        
        UISlider *mySlider =  [[ UISlider alloc ] init ];//WithFrame:CGRectMake(0,100,200 ,40) ];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
        mySlider.minimumValue = 0.0;//下限
        mySlider.maximumValue = 1.0;//上限
        switch (i) {
            case 0:
                mySlider.value = _whiteningDepth/9.0;
                break;
            case 1:
                mySlider.value = _beautyDepth/9.0;
                break;
            case 2:
                mySlider.value = _eyeScaleLevel/9.0;
                break;
            case 3:
                mySlider.value = _faceScaleLevel/9.0;
                break;
                
            default:
                break;
        }
        //        mySlider.value = 0.5;//开始默认值
        //        mySlider.backgroundColor =[UIColor redColor];//测试用,
        [mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        mySlider.continuous = YES;//当放开手., 值才确定下来
        mySlider.minimumTrackTintColor = [UIColor colorWithHexString:@"f5d732"];
        mySlider.tag = 400 +i;
        [mySlider setThumbImage:[UIImage imageNamed:@"sliderYello"] forState:UIControlStateNormal];
        
        [sliderV addSubview:mySlider];
        [mySlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel).offset(0);
            make.left.equalTo(titleLabel.mas_right).offset(5 *kiphone6);
            make.width.mas_equalTo(120 *kiphone6);
            make.height.mas_equalTo(20);
        }];
        [mySlider trackRectForBounds:CGRectMake(0, 0, 100, 2)];
        
    }
    [_botttomFaceView addGestureRecognizer:singleTap];
}

- (void)beatifulFace{
    _fontView.hidden  = YES;
    _botttomFaceView.hidden = NO;
    _gameWebV.hidden = YES;
    _turnView.hidden = YES;
    _playView.userInteractionEnabled = YES;
    [_playView bringSubviewToFront:_botttomView];
    [UIView animateWithDuration:0.5 animations:^{
        _botttomFaceView.frame =  CGRectMake(0, 0, kScreenW, kScreenH);
    }];
    
}
- (void)handleSingleTap2:(UITapGestureRecognizer *)sender
{
    //    NSLog(@"隐藏");
    if (_botttomFaceView) {
        _botttomFaceView.hidden = YES;
        _botttomFaceView.frame = CGRectMake(0, kScreenH, kScreenW, kScreenH);
        _fontView.hidden = NO;
        _gameWebV.hidden = NO;
        _turnView.hidden = NO;
        CcUserModel *userInfo = [CcUserModel defaultClient];
        userInfo.beautyDepth = [NSString stringWithFormat:@"%g",_beautyDepth];
        userInfo.whiteningDepth = [NSString stringWithFormat:@"%g",_whiteningDepth];
        userInfo.eyeScaleLevel = [NSString stringWithFormat:@"%g",_eyeScaleLevel];
        userInfo.faceScaleLevel = [NSString stringWithFormat:@"%g",_faceScaleLevel];
        [userInfo saveAllInfo];
        
    }
}
-(void)sliderValueChanged:(UISlider *)paramSender{
    
    NSInteger sliderTag = paramSender.tag -400;
    NSLog(@"value = %g",paramSender.value *9);
    switch (sliderTag) {
        case 0:
        {
            _whiteningDepth = paramSender.value *9;
            [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
            break;
        }
        case 1:
        {
            _beautyDepth = paramSender.value *9;
            [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
            break;
        }
        case 2:
        {
            _eyeScaleLevel = paramSender.value *9;
            [_txLivePush setEyeScaleLevel:_eyeScaleLevel];
            break;
        }
        case 3:
        {
            _faceScaleLevel = paramSender.value *9;
            [_txLivePush setFaceScaleLevel:_faceScaleLevel];
            break;
        }
            
            
        default:
            break;
    }
    NSLog(@"New value=%ld",sliderTag);
    
    
    
}
- (void)setBeautyLeave:(UIButton *)sender{
    
    CGFloat sliderValue;
    if (sender.tag == 1012) {   // 恢复默认
        sliderValue = 0.5;
    }
    else{
        NSInteger senderTag = sender.tag -1000;
        sliderValue = senderTag *0.25;
        
    }
    for (int i = 0; i<4; i++) {
        UISlider *slider = (UISlider *)[_sliderV viewWithTag:400 +i];
        slider.value = sliderValue;
    }
    
    _beautyDepth = sliderValue *9;
    _whiteningDepth = sliderValue *9;
    _eyeScaleLevel = sliderValue *9;
    _faceScaleLevel = sliderValue *9;
    [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
    [_txLivePush setEyeScaleLevel:_eyeScaleLevel];
    [_txLivePush setFaceScaleLevel:_faceScaleLevel];
    
    for(int i = 0; i <5 ;i++)
    {
        UIButton *btn = (UIButton *)[_btnBkgView viewWithTag:1000 +i];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    
    if (sender.tag <1012) {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    }else{
        UIButton *btn = (UIButton *)[_btnBkgView viewWithTag:1002];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    }
}

- (void)turnFont{
    self.turnFront = !self.turnFront;
    [_txLivePush switchCamera];
    self.torchBtn.selected = NO;
}
- (void)sengGift{
    if (self.currentGiftIndex >-1) {
        //    [self showAlertWithMessage:[NSString stringWithFormat:@"送出了第%ld的礼物，%@个 ",self.currentGiftIndex,self.currentGiftCount]];
        //    NSLog(@"送出了第%ld的礼物，%@个 ",self.currentGiftIndex,self.currentGiftCount);
        LIMPresentModel *giftModel = self.presentList[self.currentGiftIndex];
        CcUserModel *userModel = [CcUserModel defaultClient];
        
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"liveuid":self.livePushModel.uid,@"giftid":giftModel.giftid,@"giftcount":self.currentGiftCount}]];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
        [[HttpClient defaultClient] requestWithPath:mGive_gift method:1 parameters:paraDict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"送礼物。———————————— %@",responseObject);
            
            NSString * rescode = responseObject[@"rescode"];
            if ([rescode isEqualToString:@"1"]) {
                //            getscore
                //            cumoney
                NSDictionary * result = responseObject[@"result"];
                NSString *cumoney = result[@"cumoney"];
                self.goldLabel.text = cumoney;
                // gift
                //            for (int i = 0; i<[self.currentGiftCount intValue]; i++) {
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i *0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LiveUserModel *fourthUser = [[LiveUserModel alloc]init];
                fourthUser.name = self.livePushModel.nickname;
                fourthUser.iconUrl = self.livePushModel.cover;
                LiveGiftShowModel * model = [LiveGiftShowModel giftModel:self.giftArr[self.currentGiftIndex] userModel:fourthUser];
                model.toNumber = [self.currentGiftCount intValue];
                [self.customGiftShow animatedWithGiftModel:model];
                //                    [self.customGiftShow addLiveGiftShowModel:model];
                //                });
                //
                //
            
                
            
            
            LIMGiftArrModel *giftArrModel = [[LIMGiftArrModel alloc]init];
            giftArrModel.giftID = giftModel.giftid;
            giftArrModel.count = [self.currentGiftCount integerValue];
            giftArrModel.isFirst = YES;
//                giftArrModel.animationTime = self.animationTime;
                NSString *giftID = giftModel.giftid;
       if ([giftID isEqualToString:@"4"]||[giftID isEqualToString:@"6"]||[giftID isEqualToString:@"14"]||[giftID isEqualToString:@"17"]||[giftID isEqualToString:@"18"]||[giftID isEqualToString:@"19"]||[giftID isEqualToString:@"25"]||[giftID isEqualToString:@"28"]||[giftID isEqualToString:@"29"]||[giftID isEqualToString:@"31"]||[giftID isEqualToString:@"3"]||[giftID isEqualToString:@"32"]||[giftID isEqualToString:@"9"]||[giftID isEqualToString:@"12"]||[giftID isEqualToString:@"15"]||[giftID isEqualToString:@"16"]||[giftID isEqualToString:@"21"]||[giftID isEqualToString:@"22"]||[giftID isEqualToString:@"23"]||[giftID isEqualToString:@"26"]) {
                    [self bigGiftAnimation:giftArrModel];
                }
            
//            [self loginAnimation:[NSString stringWithFormat:@"%ld",self.currentGiftIndex] andUserName:userModel.nickname andUserIcon:userModel.avatar];
        
                
                [self giftChat:self.currentGiftCount andGift:giftModel];
            
            }else{
                if ([rescode isEqualToString:@"-2"]) {
                    [self noMoney];
                }else{
                    NSString * resmsg = responseObject[@"resmsg"];
                    NSLog(@"resmsg = %@",resmsg);
                    [self showAlertWithMessage:resmsg];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}
- (void)pushChongzhi{
    LIMGoldViewController *otherV = [[LIMGoldViewController alloc]init];
    otherV.isLive = YES;
    otherV.touid = self.goldLabel.text;
    YYNavigationController *otherNV = [[YYNavigationController alloc]initWithRootViewController:otherV];
    
    [self presentViewController:otherNV animated:YES completion:^{
        
    }];

}
- (void)noMoney{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"余额不足，前去充值？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self pushChongzhi];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)bigGiftAnimation:(LIMGiftArrModel *)giftArrModel{
    NSString *giftID = giftArrModel.giftID;
    if(!self.isAnimation){
        self.animationTime++;
        giftArrModel.animationTime = self.animationTime;
        NSArray *photoNameArr = @[@""
                                  ,@"cucumber_000",@"drink_000",@"romantic",@"gift_car_000",@"microphone_000",@"fedemon",@"kiss_000"
                                  ,@"棒棒糖",@"girl_light_000",@"praise_000",@"restrict_000",@"cake",@"hand_000",@"ring_000",@"boat"
                                  ,@"cannon",@"rose_000",@"motor_000",@"diamond_000",@"packet_000",@"plane_000",@"castle",@"starry"
                                  ,@"啤酒",@"brick_000",@"island_",@"heart",@"fileworks_000",@"Cupid_000",@"goldcoin_000",@"gold_bri_000"
                                  ,@"feichuang"];
        //    NSArray *photoNameArr = @[@"",@"gift_car_000",@"drink_000",@"cucumber_000",@"microphone_000",@"fedemon",@"",@"kiss_000",@""];
        
        NSArray *photoNumArr = @[@""
                                 ,@"4",@"10",@"",@"56",@"16",@"12",@"16"
                                 ,@"1",@"",@"2",@"5",@"",@"8",@"14",@""
                                 ,@"",@"40",@"51",@"38",@"13",@"",@"",@""
                                 ,@"1",@"32",@"",@"3",@"100",@"40",@"17",@"23"
                                 ,@""
                                 ];
        self.bigGift = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.bigGift.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        if ([giftID isEqualToString:@"32"]||[giftID isEqualToString:@"12"]||[giftID isEqualToString:@"19"]||[giftID isEqualToString:@"23"]) {
            UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeArrModel)];
            [self.bigGift addGestureRecognizer:tapGest];
        }else{
            self.bigGift.userInteractionEnabled = NO;
        }
        
        // 组合动画  3 32 - 9 12 15 -16 21 22 23 -26   -------- 10个
        // 简单屏幕动画 4 6 - 14 -17 18 19 -25 28 29 31 --------- 10个
        if ([giftID isEqualToString:@"4"]||[giftID isEqualToString:@"6"]||[giftID isEqualToString:@"14"]||[giftID isEqualToString:@"17"]||[giftID isEqualToString:@"18"]||[giftID isEqualToString:@"19"]||[giftID isEqualToString:@"25"]||[giftID isEqualToString:@"28"]||[giftID isEqualToString:@"29"]||[giftID isEqualToString:@"31"]) {
            
            self.isAnimation = YES;
            [self.view addSubview:self.bigGift];
            
            
            
            //            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            //            for (int i = 0; i < [photoNumArr[[giftID integerValue]] integerValue]; i++) {
            //                NSString *imageName = [NSString stringWithFormat:@"%@%02d", photoNameArr[[giftID integerValue]],i];
            //                //            animrose_00019
            //                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            //                UIImage *image = [UIImage imageWithContentsOfFile:path];
            //
            //                //            UIImage *image = [UIImage imageNamed:imageName];
            //                if (image) {
            //                    [imageArray addObject:image];
            //                }else{
            //
            //                    NSLog(@"%@,%d",path,i);
            //
            //                }
            //
            //            }
            
            CGFloat imageW = kScreenW;
            CGFloat imageH = kScreenH;
            CGFloat paddingY = 0;
            CGFloat time = 3;
            CGFloat count = 1;
            CGFloat alphaTime = 0;
            CGFloat perTime = 0.06;
            if ([giftID isEqualToString:@"4"]){   // 法拉利
                imageW = kScreenW;
                imageH = 350 *kiphone6;
            }else if ([giftID isEqualToString:@"6"]){ // 蓝色妖姬
                imageW = 250 *kiphone6;
                imageH = 270 *kiphone6;
                count = 3;
                time = 1;
                perTime = 0.09;
                alphaTime = 0.5;
            }else if ([giftID isEqualToString:@"14"]){ // 戒指
                imageW = 194 *kiphone6;
                imageH = 211 *kiphone6;
                time = 2.5;
                alphaTime = 1;
                perTime = 0.08;
                // 增加 6 次后三帧 1.5s渐隐
            }else if ([giftID isEqualToString:@"17"]){ // 玫瑰花
                imageW = 250 *kiphone6;
                imageH = 250 *kiphone6;
                // 增加 20次 最后一帧
                //            imageV.image  =
                //                for(int i = 0 ;i<20; i++){
                //                    NSString *imageName = [NSString stringWithFormat:@"%@%02d", photoNameArr[[giftID integerValue]],39];
                //                    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                //                    UIImage *image = [UIImage imageWithContentsOfFile:path];
                //
                //
                //                    //                UIImage *image11 = [UIImage imageNamed:imageName];
                //                    [imageArray addObject:image];
                //                }
                alphaTime = 0.5;
                // 1s渐隐
            }else if ([giftID isEqualToString:@"18"]){ // 摩托
                
            }else if ([giftID isEqualToString:@"19"]){ // 黄钻
                perTime = 0.08;
                
            }else if ([giftID isEqualToString:@"25"]){ // 板砖
                time = 5;
                // 增加 48次 最后一帧
                //                for(int i = 0 ;i<48; i++){
                //                    NSString *imageName = [NSString stringWithFormat:@"%@%02d.png", photoNameArr[[giftID integerValue]],31];
                //                    UIImage *image11 = [UIImage imageNamed:imageName];
                //                    [imageArray addObject:image11];
                //                }
            }else if ([giftID isEqualToString:@"28"]){// 烟花
                paddingY = -120 *kiphone6;
                imageW = 300 *kiphone6;
                imageH = 300 *kiphone6;
                
            }else if ([giftID isEqualToString:@"29"]){// 丘比特
                
            }else if ([giftID isEqualToString:@"31"]){// 金砖
                imageW = 270 *kiphone6;
                imageH = 270 *kiphone6;
                //                for(int i = 0 ;i<11; i++){
                //                    NSString *imageName = [NSString stringWithFormat:@"%@%02d.png", photoNameArr[[giftID integerValue]],22];
                //                    UIImage *image11 = [UIImage imageNamed:imageName];
                //                    [imageArray addObject:image11];
                //                }
                alphaTime = 0.5;
                // 增加11次最后一针 1s渐隐
            }
            
            //            UIImageView *imageV = [[UIImageView alloc]init];
            //            [self.bigGift addSubview:imageV];
            CGFloat imageY = (kScreenH-imageH)/2.0 -paddingY;
            CGFloat imageX = (kScreenW - imageW)/2.0;
            
            LIMImageView *imageV_paolight1 = [self imageViewWithFrame:CGRectMake(imageX, imageY, imageW , imageH) andImage:@"" andArrayName:photoNameArr[[giftID integerValue]] andArrayCount:[photoNumArr[[giftID integerValue]] integerValue] andTime:perTime andCount:count andAfter:0 andTimerID:1];
            
            
            NSLog(@"%@",giftID);
            
            
            //            imageV.animationImages = imageArray;// 序列帧动画的uiimage数组
            //            imageV.animationDuration = time;// 序列帧全部播放完所用时间
            //            imageV.animationRepeatCount = count;// 序列帧动画重复次数
            //            [imageV startAnimating];//开始动画
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time*count -alphaTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                [UIView animateWithDuration:alphaTime animations:^{
                    self.bigGift.alpha = 0;
                }];
                }
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time*count) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                    [self cancelAnimation];
                }
            });
            
        }else if([giftID isEqualToString:@"32"]){ // 飞船
            self.isAnimation = YES;
            [self.view addSubview:self.bigGift];
            
            // 背景
            UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bj.png"]];
            [self.bigGift addSubview:backImage];
            [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.bigGift).offset(0);
                make.width.mas_equalTo(kScreenW);
                make.height.mas_equalTo(kScreenH);
            }];
            
            // 地球
            UIImageView *backImage_diqiu = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diqiu.png"]];
            backImage_diqiu.frame = CGRectMake(0, 30, kScreenW, kScreenH);
            [self.bigGift addSubview:backImage_diqiu];
            //        [backImage_diqiu mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.equalTo(self.bigGift).offset(0);
            //            make.centerY.equalTo(self.bigGift).offset(30).priority(750);
            //            make.width.mas_equalTo(kScreenW);
            //            make.height.mas_equalTo(kScreenH);
            //        }];
            
            // 月球
            UIImageView *backImage_yueqiu = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yueqiu.png"]];
            backImage_yueqiu.frame = CGRectMake(-20, 40, 100, 100);
            [self.bigGift addSubview:backImage_yueqiu];
            
            // 飞船
            //            UIImageView *feichuang = [[UIImageView alloc]init];
            //            [self.bigGift addSubview:feichuang];
            //            [feichuang mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.center.equalTo(self.bigGift).offset(0);
            //                make.width.mas_equalTo(kScreenW);
            //                make.height.mas_equalTo(kScreenH);
            //            }];
            
            // 光点
//            UIImageView *guangdian = [[UIImageView alloc]init];
//            [self.bigGift addSubview:guangdian];
//            [guangdian mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.equalTo(self.bigGift).offset(0);
//                make.width.mas_equalTo(kScreenW);
//                make.height.mas_equalTo(kScreenH);
//            }];
            
            
            
//            NSMutableArray *guangdianArray = [[NSMutableArray alloc] init];
//            for (int i = 0; i < 67; i++) {
//                NSString *imageName = [NSString stringWithFormat:@"guangdian_000%02d",i];
//                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//                UIImage *image = [UIImage imageWithContentsOfFile:path];
//                
//                //            UIImage *image = [UIImage imageNamed:imageName];
//                [guangdianArray addObject:image];
//            }
            
            //         开始动画
            
            self.bigGift.alpha = 0;
            [UIView animateWithDuration:1 animations:^{
                self.bigGift.alpha =1;
            }];
            
            
            
            
            //    //位移动画
            CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(-20, 70)];
            NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(60, 70)];
            anima1.values = [NSArray arrayWithObjects:value0,value1,nil];
            //旋转动画
            CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            anima3.toValue = [NSNumber numberWithFloat:M_PI/3.0];
            //组动画
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima3, nil];
            groupAnimation.duration = 4.5f;
            groupAnimation.removedOnCompletion = NO;
            groupAnimation.fillMode = kCAFillModeForwards;
            [backImage_yueqiu.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
            
            
            
            [UIView animateWithDuration:4 animations:^{
                backImage_diqiu.frame = CGRectMake(0, 0, kScreenW, kScreenH);
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.animationTime == giftArrModel.animationTime) {
                    LIMImageView *feichuang = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) andImage:@"" andArrayName:@"feichuan000" andArrayCount:27 andTime:0.075 andCount:1 andAfter:1 andTimerID:1];
                }

            });
            
            
            
//            guangdian.animationImages = guangdianArray;// 序列帧动画的uiimage数组
//            guangdian.animationDuration = 4.5f;// 序列帧全部播放完所用时间
//            guangdian.animationRepeatCount = 1;// 序列帧动画重复次数
//            [guangdian startAnimating];//开始动画
            
            LIMImageView *guangdian_new = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) andImage:@"" andArrayName:@"guangdian_000" andArrayCount:67 andTime:0.068 andCount:1 andAfter:0 andTimerID:2];
            self.bigGift.alpha = 0;
            
            [UIView animateWithDuration:1 animations:^{
                self.bigGift.alpha = 1;
            } completion:^(BOOL finished) {
                self.bigGift.alpha = 1;
            }];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                }];
                }
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                    [self cancelAnimation];
                }
            });
        }else if([giftID isEqualToString:@"3"]){ // 浪漫
            self.isAnimation = YES;
            
            [self.view addSubview:self.bigGift];
            
            UIImageView *imageV = [[UIImageView alloc]init];
            //    [imageV sizeToFit];
            [self.bigGift addSubview:imageV];
            
            CGFloat imageW = kScreenW;
            CGFloat imageH = 559/2.0;
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bigGift).offset(40);
                make.centerX.equalTo(self.bigGift).offset(0);
                make.width.mas_equalTo(imageW);
                make.height.mas_equalTo(imageH);
            }];
            
            UIImageView *imageV_back = [[UIImageView alloc]init];
            imageV_back.alpha = 0.75;
            //    [imageV sizeToFit];
            [self.bigGift addSubview:imageV_back];
            
            CGFloat imageV_backW = kScreenW;
            CGFloat imageV_backH = 393/2.0;
            [imageV_back mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.bigGift).offset(0);
                make.centerX.equalTo(self.bigGift).offset(0);
                make.width.mas_equalTo(imageV_backW);
                make.height.mas_equalTo(imageV_backH);
            }];
            
            
            //  开始动画
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < 63; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d", @"romantic_000",i];
                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                
                //            UIImage *image = [UIImage imageNamed:imageName];
                [imageArray addObject:image];
            }
            
            for (int i = 0; i < 7; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d", @"romantic_000",62];
                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                
                //            UIImage *image = [UIImage imageNamed:imageName];
                [imageArray addObject:image];
            }
            
            imageV.animationImages = imageArray;// 序列帧动画的uiimage数组
            imageV.animationDuration = 4.5f;// 序列帧全部播放完所用时间
            imageV.animationRepeatCount = 1;// 序列帧动画重复次数
            [imageV startAnimating];//开始动画
            
            
            NSMutableArray *imageArray_back = [[NSMutableArray alloc] init];
            for (int i = 0; i < 10; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d", @"romantic_back_000",i];
                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                
                //            UIImage *image = [UIImage imageNamed:imageName];
                [imageArray_back addObject:image];
            }
            imageV_back.animationImages = imageArray_back;// 序列帧动画的uiimage数组
            imageV_back.animationDuration = 1.f;// 序列帧全部播放完所用时间
            imageV_back.animationRepeatCount = 5;// 序列帧动画重复次数
            [imageV_back startAnimating];//开始动画
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    imageV.alpha = 0;
                    imageV_back.alpha = 0;
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
        }else if([giftID isEqualToString:@"9"]){  // 女神
            self.isAnimation = YES;
            [self.view addSubview:self.bigGift];
            UIImageView *imageV_fireWork2 = [self imageViewWithFrame:CGRectMake(0, 400 *kiphone6, kScreenW, 243 *kiphone6) andImage:@"" andArrayName:@"girl_faguang_000" andArrayCount:5 andTime:0.3 andCount:20];
            
            UIImageView *imageV_kapai = [self imageViewWithFrame:CGRectMake(0, 180 *kiphone6, kScreenW, 400 *kiphone6) andImage:@"girl_poker_00003" andArrayName:@"girl_poker_000" andArrayCount:4 andTime:0.12 andCount:50];
            imageV_kapai.alpha = 0;
            
            
            [imageV_fireWork2 startAnimating];
            [imageV_kapai startAnimating];
            
            [UIView animateWithDuration:0.5 animations:^{
                imageV_kapai.alpha = 1;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_kapai stopAnimating];
                
                // 1.5 - 1  0.5S
                
                //创建基本动画(用于放缩)
                CABasicAnimation *animScale = [[CABasicAnimation alloc]init];
                //设置形变属性为放缩属性值
                animScale.keyPath = @"transform.scale";
                //设置放缩初值
                animScale.fromValue = @(1);
                //设置放缩终值
                animScale.toValue = @(1.5);
                //            animScale.autoreverses = NO;
                animScale.removedOnCompletion = NO;
                animScale.fillMode = kCAFillModeForwards;
                
                animScale.duration = 0.25;
                
                CABasicAnimation *animScale2 = [[CABasicAnimation alloc]init];
                //设置形变属性为放缩属性值
                animScale2.keyPath = @"transform.scale";
                //设置放缩初值
                animScale2.fromValue = @(1.5);
                //设置放缩终值
                animScale2.toValue = @(1);
                animScale2.duration = 0.25;
                animScale2.beginTime = 0.25;
                //            animScale.autoreverses = NO;
                animScale2.removedOnCompletion = NO;
                animScale2.fillMode = kCAFillModeForwards;
                
                //组动画
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                groupAnimation.animations = [NSArray arrayWithObjects:animScale, animScale2,nil];
                groupAnimation.duration = 0.5f;
                //            groupAnimation.autoreverses = NO;
                groupAnimation.removedOnCompletion = NO;
                groupAnimation.fillMode = kCAFillModeForwards;
                [imageV_kapai.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
                
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
            
            
        }else if([giftID isEqualToString:@"12"]){  // 蛋糕
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            
            UIImageView *imageV = [[UIImageView alloc]init]; // 蛋糕盒子
            [self.bigGift addSubview:imageV];
            imageV.image = [UIImage imageNamed:@"cake_start"];
            CGFloat imageW = kScreenW;
            CGFloat imageH = 656/2.0 *kiphone6;
            imageV.frame = CGRectMake((kScreenW - imageW)/2.0,580/2.0 *kiphone6 , imageW, imageH);
//            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.bigGift).offset(580/2.0 *kiphone6);
//                make.centerX.equalTo(self.bigGift).offset(0);
//                make.width.mas_equalTo(imageW);
//                make.height.mas_equalTo(imageH);
//            }];
            UIImageView *imageV_cake = [[UIImageView alloc]init]; // 蛋糕
            imageV_cake.hidden = YES;
            imageV_cake.image = [UIImage imageNamed:@"cake"];
            
            UIImageView *imageV_birthday = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW- 257.5*kiphone6)/2.0, 0, 515/2.0*kiphone6, 39.5 *kiphone6)];                                                             // birthday
            imageV_birthday.hidden = YES;
            imageV_birthday.image = [UIImage imageNamed:@"cake_birthday"];
            
            [self.bigGift addSubview:imageV_cake];
            [self.bigGift addSubview:imageV_birthday];
            
            imageV_cake.frame = CGRectMake((kScreenW - (336/2.0 *kiphone6))/2.0,CGRectGetMidY(imageV.frame) - (531-393)/4.0, 336/2.0 *kiphone6, 531/2.0 *kiphone6);
            
//            [imageV_cake mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(imageV.mas_centerY).offset(0);
//                make.centerX.equalTo(self.bigGift).offset(0);
//                make.width.mas_equalTo(336/2.0 *kiphone6);
//                make.height.mas_equalTo(531/2.0 *kiphone6);
//            }];
            
            imageV.userInteractionEnabled = NO;
            imageV_cake.userInteractionEnabled = NO;
            imageV_birthday.userInteractionEnabled = NO;
            
            ///////////////////////////////////////////////////////// 动画
            //创建基本动画(用于放缩)
            CABasicAnimation *animScale = [[CABasicAnimation alloc]init];
            //设置形变属性为放缩属性值
            animScale.keyPath = @"transform.scale";
            //设置放缩初值
            animScale.fromValue = @(0);
            //设置放缩终值
            animScale.toValue = @(1);
            //设置放缩动画持续时间
            animScale.duration = 0.5f;
            //设置动画放缩结束后不恢复原状
            animScale.removedOnCompletion = NO;
            animScale.fillMode = kCAFillModeForwards;
            //旋转动画
            CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            anima3.toValue = [NSNumber numberWithFloat:M_PI*8];
            //组动画
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            groupAnimation.animations = [NSArray arrayWithObjects:animScale,anima3, nil];
            groupAnimation.duration = 0.5f;
            [imageV.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                //创建基本动画(用于放缩)
                CABasicAnimation *animScale = [[CABasicAnimation alloc]init];
                //设置形变属性为放缩属性值
                animScale.keyPath = @"transform.scale";
                //设置放缩初值
                animScale.fromValue = @(1);
                //设置放缩终值
                animScale.toValue = @(1.1);
                //            animScale.autoreverses = NO;
                animScale.removedOnCompletion = NO;
                animScale.fillMode = kCAFillModeForwards;
                
                animScale.duration = 0.25;
                
                CABasicAnimation *animScale2 = [[CABasicAnimation alloc]init];
                //设置形变属性为放缩属性值
                animScale2.keyPath = @"transform.scale";
                //设置放缩初值
                animScale2.fromValue = @(1.1);
                //设置放缩终值
                animScale2.toValue = @(0.8);
                animScale2.duration = 0.25;
                animScale2.beginTime = 0.25;
                //            animScale.autoreverses = NO;
                animScale2.removedOnCompletion = NO;
                animScale2.fillMode = kCAFillModeForwards;
                
                //组动画
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                groupAnimation.animations = [NSArray arrayWithObjects:animScale, animScale2,nil];
                groupAnimation.duration = 0.5f;
                //            groupAnimation.autoreverses = NO;
                groupAnimation.removedOnCompletion = NO;
                groupAnimation.fillMode = kCAFillModeForwards;
                    [imageV.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
                }
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                imageV.hidden = YES;
                imageV_cake.hidden = NO;
                //创建基本动画(用于放缩)
                CABasicAnimation *animScale = [[CABasicAnimation alloc]init];
                //设置形变属性为放缩属性值
                animScale.keyPath = @"transform.scale";
                //设置放缩初值
                animScale.fromValue = @(0.7);
                //设置放缩终值
                animScale.toValue = @(1);
                //            animScale.autoreverses = NO;
                animScale.removedOnCompletion = NO;
                animScale.fillMode = kCAFillModeForwards;
                animScale.duration = 1;
                
                //组动画
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                groupAnimation.animations = [NSArray arrayWithObjects:animScale,nil];
                groupAnimation.duration = 1.0f;
                
                groupAnimation.removedOnCompletion = NO;
                groupAnimation.fillMode = kCAFillModeForwards;
                [imageV_cake.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
                
                [self.view bringSubviewToFront:imageV_birthday];
                LIMImageView *imageV_star_new = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) andImage:@"" andArrayName:@"cake_star_000" andArrayCount:46 andTime:0.076 andCount:1 andAfter:1 andTimerID:1];
                [self.bigGift sendSubviewToBack:imageV_star_new];
                LIMImageView *imageV_happy_new = [self imageViewWithFrame:CGRectMake(0, 240*kiphone6, kScreenW, kScreenH) andImage:@"" andArrayName:@"cake_happy_000" andArrayCount:20 andTime:0.24 andCount:1 andAfter:1 andTimerID:2];
                LIMImageView *imageV_qiqiu_new = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW , kScreenH) andImage:@"" andArrayName:@"cake_balloon_000" andArrayCount:16 andTime:0.1 andCount:1 andAfter:1 andTimerID:3];
                
                imageV_birthday.hidden = NO;
                    
                imageV_star_new.userInteractionEnabled = NO;
                imageV_happy_new.userInteractionEnabled = NO;
                imageV_qiqiu_new.userInteractionEnabled = NO;
                
                [UIView animateWithDuration:2 animations:^{
                    imageV_happy_new.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                    imageV_birthday.frame = CGRectMake((kScreenW- 257.5*kiphone6)/2.0, 270*kiphone6, 515/2.0 *kiphone6, 79/2.0 *kiphone6); // birthday
                } completion:^(BOOL finished) {
                    
                }];
                }
                
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [imageV_smoke startAnimating];//开始动画
                if (self.animationTime == giftArrModel.animationTime) {
                LIMImageView *imageV_smoke_new = [self imageViewWithFrame:CGRectMake(0, (kScreenH- 916/2.0 *kiphone6)/2.0, kScreenW , 916/2.0 *kiphone6) andImage:@"" andArrayName:@"cake_smoke_000" andArrayCount:15 andTime:0.08 andCount:1 andAfter:1 andTimerID:4];
                    imageV_smoke_new.frame = CGRectMake(0, CGRectGetMidY(imageV.frame) - (916 -393)/4.0, kScreenW, 458 *kiphone6);
//                [imageV_smoke_new mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(imageV.mas_centerY).offset(0);
//                    make.centerX.equalTo(self.bigGift).offset(0);
//                    make.width.mas_equalTo(kScreenW);
//                    make.height.mas_equalTo(916/2.0 *kiphone6);
//                }];
                }

            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                [UIView animateWithDuration:2 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                }
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                    [self cancelAnimation];
                }
            });
        }else if([giftID isEqualToString:@"15"]){  // 游艇
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            /*5s
             0-0.5 现
             1s - 2.s 交换北京
             4-5 隐
             115 138.5
             */
            UIImageView *imageV_night = [[UIImageView alloc]init]; // 背景 日
            
            imageV_night.alpha = 0;
            imageV_night.image = [UIImage imageNamed:@"boat_日"];
            CGFloat imageW = kScreenW;
            CGFloat imageH = 380 *kiphone6;
            
            
            UIImageView *imageV_morning = [[UIImageView alloc]init]; // 背景 夜
            [self.bigGift addSubview:imageV_night];
            [self.bigGift addSubview:imageV_morning];
            
            imageV_morning.alpha = 0;
            imageV_morning.image = [UIImage imageNamed:@"boat_夜"];
            [imageV_morning mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bigGift).offset(115 *kiphone6);
                make.centerX.equalTo(self.bigGift).offset(0);
                make.width.mas_equalTo(imageW);
                make.height.mas_equalTo(imageH);
            }];
            [imageV_night mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bigGift).offset(115 *kiphone6);
                make.centerX.equalTo(self.bigGift).offset(0);
                make.width.mas_equalTo(imageW);
                make.height.mas_equalTo(imageH);
            }];
            //        UIImageView *imageV_fireWork1 = [self imageViewWithFrame:CGRectMake((kScreenW -225 *kiphone6)/2.0, 132 *kiphone6, 225 *kiphone6, 225 *kiphone6) andImage:@"" andArrayName:@"boat_firework1_000" andArrayCount:15 andTime:1.2 andCount:1];
            //        imageV_fireWork1.hidden = YES;
            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [imageV_fireWork1 startAnimating];
            //            imageV_fireWork1.hidden = NO;
            //        });
//            UIImageView *imageV_fireWork2 = [self imageViewWithFrame:CGRectMake(0, 70 *kiphone6, kScreenW, 362 *kiphone6) andImage:@"" andArrayName:@"castle_light_000" andArrayCount:29 andTime:2.9 andCount:1];
//            imageV_fireWork2.hidden = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [imageV_boat startAnimating];
                LIMImageView *imageV_boat = [self imageViewWithFrame:CGRectMake(0, 138.5 *kiphone6, kScreenW, 360 *kiphone6) andImage:@"" andArrayName:@"boat_000" andArrayCount:50 andTime:0.08 andCount:1 andAfter:0 andTimerID:1];
                //                imageV_boat.hidden = NO;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [imageV_fireWork2 startAnimating];
                LIMImageView *imageV_fireWork2 = [self imageViewWithFrame:CGRectMake(0, 70 *kiphone6, kScreenW, 362 *kiphone6) andImage:@"" andArrayName:@"castle_light_000" andArrayCount:29 andTime:0.10 andCount:1 andAfter:1 andTimerID:2];
                [self.bigGift sendSubviewToBack:imageV_fireWork2];
                [self.bigGift sendSubviewToBack:imageV_morning];
                [self.bigGift sendSubviewToBack:imageV_night];
//                imageV_fireWork2.hidden = NO;
            });
            //        UIImageView *imageV_star = [self imageViewWithFrame:CGRectMake(0, 115 *kiphone6, kScreenW, 360 *kiphone6) andImage:@"" andArrayName:@"boatlight_000" andArrayCount:5 andTime:0.3 andCount:50];
            //        imageV_star.hidden = YES;
            //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [imageV_star startAnimating];
            //            imageV_star.hidden = NO;
            //        });
            
            
//            UIImageView *imageV_boat = [self imageViewWithFrame:CGRectMake(0, 138.5 *kiphone6, kScreenW, 360 *kiphone6) andImage:@"boat_00049" andArrayName:@"boat_000" andArrayCount:50 andTime:4 andCount:1];
//            imageV_boat.hidden = YES;

            
            // 渐现
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    imageV_night.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            });
            // 交换背景
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    imageV_night.alpha = 0;
                    imageV_morning.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            });
            
            
            // 渐隐
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            });
            // 移除动画
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
            
            
        }else if([giftID isEqualToString:@"16"]){  // 火炮
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            
            UIImageView *imageV_pao3 = [self imageViewWithFrame:CGRectMake(125*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8) andImage:@"cannon_00000" andArrayName:@"cannon_000" andArrayCount:2 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_pao3];
            
            UIImageView *imageV_pao2 = [self imageViewWithFrame:CGRectMake(65*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9) andImage:@"cannon_00000" andArrayName:@"cannon_000" andArrayCount:2 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_pao2];
            
            UIImageView *imageV_pao1 = [self imageViewWithFrame:CGRectMake(0, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6) andImage:@"cannon_00000" andArrayName:@"cannon_000" andArrayCount:2 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_pao1];
            
            UIImageView *imageV_paostar1 = [self imageViewWithFrame:CGRectMake(81 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6) andImage:@"" andArrayName:@"cannon_xx_000" andArrayCount:8 andTime:0.48 andCount:1];
            [self.bigGift addSubview:imageV_paostar1];
            
            UIImageView *imageV_paostar2 = [self imageViewWithFrame:CGRectMake(154.5 *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9) andImage:@"" andArrayName:@"cannon_xx_000" andArrayCount:8 andTime:0.48 andCount:1];
            [self.bigGift addSubview:imageV_paostar2];
            
            UIImageView *imageV_paostar3 = [self imageViewWithFrame:CGRectMake(200 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8) andImage:@"" andArrayName:@"cannon_xx_000" andArrayCount:8 andTime:0.48 andCount:1];
            [self.bigGift addSubview:imageV_paostar3];
            
            
            UIImageView *imageV_paolight1 = [self imageViewWithFrame:CGRectMake(240 *kiphone6, 150 *kiphone6, 243*kiphone6 , 243 *kiphone6) andImage:@"" andArrayName:@"cannon_light_000" andArrayCount:3 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_paolight1];
            
            UIImageView *imageV_paolight2 = [self imageViewWithFrame:CGRectMake(228 *kiphone6, 75 *kiphone6, 243*kiphone6 *0.9, 243 *kiphone6*0.9) andImage:@"" andArrayName:@"cannon_light_000" andArrayCount:3 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_paolight2];
            
            UIImageView *imageV_paolight3 = [self imageViewWithFrame:CGRectMake(199 *kiphone6, 140 *kiphone6, 243*kiphone6 *0.8, 243 *kiphone6*0.8) andImage:@"" andArrayName:@"cannon_light_000" andArrayCount:3 andTime:0.36 andCount:1];
            [self.bigGift addSubview:imageV_paolight3];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_pao1 startAnimating];
                [imageV_paostar1 startAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    imageV_pao1.frame = CGRectMake(-22 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                    imageV_paostar1.frame = CGRectMake(59 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                } completion:^(BOOL finished) {
                    [imageV_paolight1 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao1.frame = CGRectMake(0 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                        imageV_paostar1.frame = CGRectMake(81 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.24 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_pao2 startAnimating];
                [imageV_paostar2 startAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    imageV_pao2.frame = CGRectMake(43*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                    imageV_paostar2.frame = CGRectMake((154.5-22) *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                } completion:^(BOOL finished) {
                    [imageV_paolight2 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao2.frame = CGRectMake(65*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                        imageV_paostar2.frame = CGRectMake(154.5 *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_pao3 startAnimating];
                [imageV_paostar3 startAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    imageV_pao3.frame = CGRectMake(103*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                    imageV_paostar3.frame = CGRectMake(178 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                } completion:^(BOOL finished) {
                    [imageV_paolight3 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao3.frame = CGRectMake(125*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                        imageV_paostar3.frame = CGRectMake(200 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }];
            });
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_pao1 startAnimating];
                [imageV_paostar1 startAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    imageV_pao1.frame = CGRectMake(-22 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                    imageV_paostar1.frame = CGRectMake(59 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                } completion:^(BOOL finished) {
                    [imageV_paolight1 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao1.frame = CGRectMake(0 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                        imageV_paostar1.frame = CGRectMake(81 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imageV_pao2 startAnimating];
                    [imageV_paostar2 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao2.frame = CGRectMake(43*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                        imageV_paostar2.frame = CGRectMake((154.5-22) *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                    } completion:^(BOOL finished) {
                        [imageV_paolight2 startAnimating];
                        [UIView animateWithDuration:0.3 animations:^{
                            imageV_pao2.frame = CGRectMake(65*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                            imageV_paostar2.frame = CGRectMake(154.5 *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [imageV_pao3 startAnimating];
                        [imageV_paostar3 startAnimating];
                        [UIView animateWithDuration:0.3 animations:^{
                            imageV_pao3.frame = CGRectMake(103*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                            imageV_paostar3.frame = CGRectMake(178 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                        } completion:^(BOOL finished) {
                            [imageV_paolight3 startAnimating];
                            [UIView animateWithDuration:0.3 animations:^{
                                imageV_pao3.frame = CGRectMake(125*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                                imageV_paostar3.frame = CGRectMake(200 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                            } completion:^(BOOL finished) {
                                
                            }];
                        }];
                    });
                    
                    
                    
                });
                
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_pao1 startAnimating];
                [imageV_paostar1 startAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    imageV_pao1.frame = CGRectMake(-22 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                    imageV_paostar1.frame = CGRectMake(59 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                } completion:^(BOOL finished) {
                    [imageV_paolight1 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao1.frame = CGRectMake(0 *kiphone6, 330 *kiphone6, 119*kiphone6 , 105 *kiphone6);
                        imageV_paostar1.frame = CGRectMake(81 *kiphone6, 294 *kiphone6, 119*kiphone6 , 68.5 *kiphone6);
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imageV_pao2 startAnimating];
                    [imageV_paostar2 startAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        imageV_pao2.frame = CGRectMake(43*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                        imageV_paostar2.frame = CGRectMake((154.5-22) *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                    } completion:^(BOOL finished) {
                        [imageV_paolight2 startAnimating];
                        [UIView animateWithDuration:0.3 animations:^{
                            imageV_pao2.frame = CGRectMake(65*kiphone6, 340 *kiphone6, 119*kiphone6 *0.9 , 105 *kiphone6 *0.9);
                            imageV_paostar2.frame = CGRectMake(154.5 *kiphone6, 314 *kiphone6, 119*kiphone6*0.9 , 68.5 *kiphone6*0.9);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [imageV_pao3 startAnimating];
                        [imageV_paostar3 startAnimating];
                        [UIView animateWithDuration:0.3 animations:^{
                            imageV_pao3.frame = CGRectMake(103*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                            imageV_paostar3.frame = CGRectMake(178 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                        } completion:^(BOOL finished) {
                            [imageV_paolight3 startAnimating];
                            [UIView animateWithDuration:0.3 animations:^{
                                imageV_pao3.frame = CGRectMake(125*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8);
                                imageV_paostar3.frame = CGRectMake(200 *kiphone6, 326 *kiphone6, 119*kiphone6 *0.8, 68.5 *kiphone6*0.8);
                            } completion:^(BOOL finished) {
                                
                            }];
                        }];
                    });
                    
                    
                    
                });
                
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            });
            
            
            //        180ms
            //        111  222  一直11 60
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
            
            
        }else if([giftID isEqualToString:@"21"]){  // 飞机
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            
            
            
            UIImageView *image_BG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            image_BG.image = [UIImage imageNamed:@"plane_00054"];
            image_BG.alpha = 0;
            [self.bigGift addSubview:image_BG];
            
//            UIImageView *imageV_plane = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"" andArrayName:@"plane_000" andArrayCount:54 andTime:3.5 andCount:1];
            
            [UIView animateWithDuration:0.5 animations:^{
                image_BG.alpha = 1;
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [imageV_plane startAnimating];
                                LIMImageView *imageV_plane = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"" andArrayName:@"plane_000" andArrayCount:54 andTime:0.065 andCount:1 andAfter:1 andTimerID:1];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
            
            
        }else if([giftID isEqualToString:@"22"]){  // 城堡
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            UIImageView *image_BG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            image_BG.image = [UIImage imageNamed:@"castle_背景"];
            image_BG.alpha = 0;
            [self.bigGift addSubview:image_BG];
            
            UIImageView *imageV_star = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"" andArrayName:@"000" andArrayCount:5 andTime:0.3 andCount:20];
            UIImageView *imageV_firework = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, 362*kiphone6) andImage:@"" andArrayName:@"castle_light_000" andArrayCount:29 andTime:3 andCount:1];
            UIImageView *imageV_chengbao = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"castle_00015" andArrayName:@"castle_000" andArrayCount:16 andTime:1 andCount:1];
            UIImageView *imageV_caidai = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, 602*kiphone6) andImage:@"" andArrayName:@"castle_belt_000" andArrayCount:52 andTime:3.12 andCount:1];
            UIImageView *imageV_cloud = [self imageViewWithFrame:CGRectMake(0, kScreenH - 323*kiphone6, kScreenW, 323*kiphone6) andImage:@"" andArrayName:@"castle_cloud_000" andArrayCount:3 andTime:0.6 andCount:20];
            [imageV_star startAnimating];
            [imageV_chengbao startAnimating];
            
            imageV_cloud.alpha = 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                image_BG.alpha = 1;
                imageV_cloud.alpha = 1;
                
            }];
            
            [imageV_cloud startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_firework startAnimating];
                [imageV_caidai startAnimating];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
            
            
        }else if([giftID isEqualToString:@"23"]){  // 星空
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            UIImageView *image_BG = [[UIImageView alloc]initWithFrame:CGRectMake(0, -269 *kiphone6, kScreenW, 269 *kiphone6)];
            image_BG.image = [UIImage imageNamed:@"starry_上"];
            [self.bigGift addSubview:image_BG];
            
            UIImageView *image_BG2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 343.5 *kiphone6)];
            image_BG2.image = [UIImage imageNamed:@"starry_下"];
            [self.bigGift addSubview:image_BG2];
            
            
            UIImageView *image_beidou = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW -212 *kiphone6)/2.0, 80*kiphone6, 212 *kiphone6, 130 *kiphone6)];
            image_beidou.alpha = 0;
            image_beidou.image = [UIImage imageNamed:@"starry_北斗"];
            [self.bigGift addSubview:image_beidou];
            
            
            UIImageView *image_yueliang = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/4.0 *3 , 1110/2.0*kiphone6, 0 *kiphone6, 0 *kiphone6)];
            image_yueliang.image = [UIImage imageNamed:@"starry_月亮"];
            [self.bigGift addSubview:image_yueliang];
            
            
            
//            UIImageView *imageV_star = [self imageViewWithFrame:CGRectMake(0, kScreenH -115 *kiphone6, kScreenW, 115 *kiphone6) andImage:@"" andArrayName:@"starry_water_000" andArrayCount:5 andTime:0.5 andCount:20];
//            
//            UIImageView *imageV_liuxing = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"" andArrayName:@"starry_000" andArrayCount:6 andTime:0.24 andCount:1];
            
            [UIView animateWithDuration:1.5 animations:^{
                image_BG.frame = CGRectMake(0, 0, kScreenW, 269 *kiphone6);
                image_BG2.frame = CGRectMake(0, kScreenH - 343.5 *kiphone6, kScreenW, 343.5 *kiphone6);
            }completion:^(BOOL finished) {
//                [imageV_star startAnimating];
                LIMImageView *imageV_star = [self imageViewWithFrame:CGRectMake(0, kScreenH -115 *kiphone6, kScreenW, 115 *kiphone6) andImage:@"" andArrayName:@"starry_water_000" andArrayCount:5 andTime:0.1 andCount:20 andAfter:1 andTimerID:1];
                [UIView animateWithDuration:2 animations:^{
                    image_yueliang.frame = CGRectMake((kScreenW -140 *kiphone6)/2.0, 445*kiphone6, 140 *kiphone6, 144 *kiphone6);
                }];
                
                //            image_beidou.alpha = 1;
                for (int i = 1; i<12; i++) {
                    if (self.animationTime == giftArrModel.animationTime) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 *i* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 animations:^{
                            if (i%2 ==0) {
                                image_beidou.alpha = 1;
                            }else{
                                image_beidou.alpha = 0;
                            }
                        }];
                    });
                    
                    }
                }
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [imageV_liuxing startAnimating];
                if (self.animationTime == giftArrModel.animationTime) {
                    LIMImageView *imageV_liuxing = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"" andArrayName:@"starry_000" andArrayCount:6 andTime:0.04 andCount:1 andAfter:1 andTimerID:2];
                }
            });
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                }
            });
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.animationTime == giftArrModel.animationTime) {
                    [self cancelAnimation];
                }
            });
            
            
        }else if([giftID isEqualToString:@"26"]){  // 小岛
            [self.view addSubview:self.bigGift];
            self.isAnimation = YES;
            
            UIImageView *imageV_island = [self imageViewWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andImage:@"island_00000" andArrayName:@"island_000" andArrayCount:21 andTime:1.26*6 andCount:1];
            imageV_island.alpha = 0;
            NSMutableArray *array = [[NSMutableArray alloc]initWithArray:imageV_island.animationImages];
            for (int i = 0; i<106; i++) {
                [array addObject:[UIImage imageNamed:@"island_00020"]];
            }
            imageV_island.animationImages = array;
            
            
            
            
            
            UIImageView *imageV_dp = [self imageViewWithFrame:CGRectMake(0, 257 *kiphone6, 250 *kiphone6, 175 *kiphone6) andImage:@"" andArrayName:@"island_dolphin_000" andArrayCount:15 andTime:0.9 andCount:1];
            imageV_dp.alpha = 0;
            
            
            //        UIImageView *imageV_dp_right = [self imageViewWithFrame:CGRectMake(kScreenW- 125*kiphone6, 290 *kiphone6, 125 *kiphone6, 175 *kiphone6 *0.5) andImage:@"" andArrayName:@"island_dolphin_000" andArrayCount:15 andTime:0.9 andCount:1];
            //
            
            UIImageView *imageV_dp_right = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW- 125*kiphone6, 290 *kiphone6, 125 *kiphone6, 175 *kiphone6 *0.5)]; //
            NSMutableArray *imageArray_dp_right = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i = 0; i < 15; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d.png", @"island_dolphin_000",i];
                UIImage *image = [UIImage imageNamed:imageName];
                image = [self image:image rotation:UIImageOrientationDownMirrored];
                [imageArray_dp_right addObject:image];
            }
            imageV_dp_right.animationImages = imageArray_dp_right;  // 序列帧动画的uiimage数组
            imageV_dp_right.animationDuration = 0.9;      // 序列帧全部播放完所用时间
            imageV_dp_right.animationRepeatCount = 1;  // 序列帧动画重复次数
            imageV_dp_right.alpha = 0;
            [self.bigGift addSubview:imageV_dp_right];
            
            UIImageView *image_boat = [[UIImageView alloc]initWithFrame:CGRectMake( kScreenW - 56.5*kiphone6, 490/2.0*kiphone6, 56.5 *kiphone6, 57.5 *kiphone6)];
            image_boat.image = [UIImage imageNamed:@"island_船"];
            image_boat.alpha = 0;
            [self.bigGift addSubview:image_boat];
            
            UIImageView *imageV_left = [self imageViewWithFrame:CGRectMake(0, 200 *kiphone6, 56.5*kiphone6, 56.5*kiphone6) andImage:@"" andArrayName:@"island_right_000" andArrayCount:41 andTime:2.5 andCount:1];
            imageV_left.alpha = 0;
            
            
            UIImageView *imageV_right = [self imageViewWithFrame:CGRectMake((kScreenW -56.5*kiphone6)/1.0, 207 *kiphone6, 56.5*kiphone6, 56.5*kiphone6) andImage:@"" andArrayName:@"island_left_000" andArrayCount:42 andTime:2.5 andCount:1];
            imageV_right.alpha = 0;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                imageV_right.alpha = 1;
                imageV_left.alpha = 1;
                
                [imageV_left startAnimating];
                [imageV_right startAnimating];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                imageV_dp.alpha = 1;
                [imageV_dp startAnimating];
                
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.4* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                imageV_dp_right.alpha = 1;
                [imageV_dp_right startAnimating];
            });
            [UIView animateWithDuration:1 animations:^{
                imageV_island.alpha = 1;
                image_boat.alpha = 1;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_island startAnimating];
                [UIView animateWithDuration:5 animations:^{
                    image_boat.frame = CGRectMake( kScreenW, 490/2.0*kiphone6, 56.5 *kiphone6, 57.5 *kiphone6);
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1 animations:^{
                    self.bigGift.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelAnimation];
            });
        }
        
        
        if (giftArrModel.isFirst) {
            giftArrModel.isFirst = NO;
            [self.animationArr addObject:giftArrModel];
            
        }


        
    }
    else{  // 动画在播放， 放入数组
        
        if (giftArrModel.isFirst) {
            giftArrModel.isFirst = NO;
            [self.animationArr addObject:giftArrModel];
            
        }
        
    }
}
- (void)loadImageArray{
    NSArray *photoNameArr = @[@""
                              ,@"cucumber_000",@"drink_000",@"romantic_000",@"gift_car_000",@"microphone_000",@"fedemon",@"kiss_000"
                              ,@"棒棒糖",@"girl_light_000",@"praise_000",@"restrict_000",@"cake",@"hand_000",@"ring_000",@"boat"
                              ,@"cannon",@"animrose_000",@"motor_000",@"diamond_000",@"packet_000",@"plane_000",@"castle",@"starry"
                              ,@"啤酒",@"brick_000",@"island_",@"heart",@"fileworks_000",@"Cupid_000",@"goldcoin_000",@"gold_bri_000"
                              ,@"feichuan000"
                              ,@"cake_balloon_000",@"cake_star_000",@"cake_smoke_000",@"cake_happy_000",@"boat_000",@"castle_belt_000"
                              ,@"castle_000",@"castle_light_000",@"island_000",@"island_dolphin_000",@"island_left_000",@"island_right_000"
                              
                              ];
    //    NSArray *photoNameArr = @[@"",@"gift_car_000",@"drink_000",@"cucumber_000",@"microphone_000",@"fedemon",@"",@"kiss_000",@""];
    NSArray *photoNumArr = @[@""
                             ,@"4",@"10",@"63",@"56",@"16",@"12",@"16"
                             ,@"1",@"",@"2",@"5",@"",@"8",@"14",@""
                             ,@"",@"40",@"51",@"38",@"13",@"",@"",@""
                             ,@"1",@"32",@"",@"3",@"100",@"40",@"17",@"23"
                             ,@"26"
                             ,@"16",@"46",@"15",@"20",@"50",@"52"
                             ,@"16",@"29",@"21",@"15",@"42",@"41"
                             ];
    
    for (int i = 0; i<photoNameArr.count; i++) {
        NSString *photoName = photoNameArr[i];
        if([photoName rangeOfString:@"0"].location !=NSNotFound)//_roaldSearchText
        {
            for (int j = 0 ; j< [photoNumArr[i] intValue]; j++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d.png", photoName,j];
                NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
                UIImage *image1 = [UIImage imageWithContentsOfFile:path];
                
                
                
                [UIImage imageNamed:imageName];
            }
        }
    }
}
- (UIImageView *)imageViewWithFrame:(CGRect)frame andImage:(NSString *)imageStr andArrayName:(NSString *)arrayName andArrayCount:(NSInteger )arrgeCount andTime:(CGFloat)time andCount:(CGFloat)count{
    UIImageView *imageV_smoke = [[UIImageView alloc]initWithFrame:frame]; // 烟雾
    if (imageStr.length >0) {
        imageV_smoke.image = [UIImage imageNamed:imageStr];
    }
    NSLog(@"%@,,,%ld",arrayName,arrgeCount);
    if (arrayName.length >0) {
        NSMutableArray *imageArray_qiqiu = [[NSMutableArray alloc] initWithCapacity:2];
        for (int i = 0; i < arrgeCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d", arrayName,i];
            //
            //
//            NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//            UIImage *image = [UIImage imageWithContentsOfFile:path];
                    UIImage *image = [UIImage imageNamed:imageName];
            [imageArray_qiqiu addObject:image];
        }
        imageV_smoke.animationImages = imageArray_qiqiu;  // 序列帧动画的uiimage数组
        imageV_smoke.animationDuration = time;      // 序列帧全部播放完所用时间
        imageV_smoke.animationRepeatCount = count;  // 序列帧动画重复次数
    }
//    [self.bigGift addSubview:imageV_smoke];
    return imageV_smoke;
}

- (LIMImageView *)imageViewWithFrame:(CGRect)frame andImage:(NSString *)imageStr andArrayName:(NSString *)arrayName andArrayCount:(NSInteger )arrgeCount andTime:(CGFloat)time andCount:(CGFloat)count  andAfter:(CGFloat )after andTimerID:(NSInteger)timerID{
    
    // 开始动画
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (int j = 0; j<count; j++) {
        for (int i = 0; i < arrgeCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d", arrayName,i];
            [imageArr addObject:imageName];
        }
    }
    if ([arrayName isEqualToString:@"ring_000"]) {
        for (int i = 0; i<6; i++) {
            [imageArr addObject:@"ring_00011"];
            [imageArr addObject:@"ring_00012"];
            [imageArr addObject:@"ring_00013"];
        }
    }
    LIMImageView *imageV_smoke = [[LIMImageView alloc]initWithFrame:frame]; // 烟雾
    imageV_smoke.imageArr = imageArr;
    imageV_smoke.currIndex = 0;
    imageV_smoke.after = after;  // after = 1时。播放完毕 删除
    
    
    // 设置初始图片
    if (imageStr.length >0) {
        imageV_smoke.image = [UIImage imageNamed:imageStr];
    }
    // 判断
    if (arrayName.length >0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            switch (timerID) {
                case 1:
                {
//                    self.animation1 = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    
                    self.animation1 =  [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.animation1 forMode:NSRunLoopCommonModes];
                    [self.animation1 fire];
                }
                    break;
                case 2:
                {
//                    self.animation2 = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    self.animation2 =  [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.animation2 forMode:NSRunLoopCommonModes];
                    [self.animation2 fire];
                }
                    break;
                case 3:
                {
//                    self.animation3 = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    self.animation3 =  [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.animation3 forMode:NSRunLoopCommonModes];

                    [self.animation3 fire];
                }
                    break;
                case 4:
                {
//                    self.animation4 = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    self.animation4 =  [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.animation4 forMode:NSRunLoopCommonModes];

                    [self.animation4 fire];
                }
                    break;
                case 5:
                {
//                    self.animation5 = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    self.animation5 =  [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAnimation:) userInfo:imageV_smoke repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:self.animation5 forMode:NSRunLoopCommonModes];

                    [self.animation5 fire];
                }
                    break;
                default:
                    break;
            }
            
            
        });
    }
    [self.bigGift addSubview:imageV_smoke];
    return imageV_smoke;
}
- (void)timerAnimation:(NSTimer *)timer{
    LIMImageView *imageV = timer.userInfo;
    if (imageV.currIndex < imageV.imageArr.count) {
//        NSLog(@"%@,,%ld",imageV.imageArr,imageV.currIndex);
        NSString *imageName = imageV.imageArr[imageV.currIndex];
        imageV.currIndex += 1;
//        NSLog(@"%@,,%ld",imageName,imageV.currIndex);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            imageV.image = image;
        }
    }else{
//        NSLog(@"%g",imageV.after);
        if (imageV.after == 1.0f) {
            imageV.image = [UIImage imageNamed:@"transparent"];
        }
    }
}
- (void)removeArrModel{
    [self.animationArr removeObjectAtIndex:0];
    [self cancelAnimation];
}

- (void)bigArrPlay{
    
    // 先做动画， 后减少数量
    
    if (self.animationArr.count >0) {
        NSLog(@"%@",self.animationArr);
        LIMGiftArrModel *giftArrModel = self.animationArr[0];
        giftArrModel.count--;
        if (giftArrModel.count >0) {
            [self bigGiftAnimation:giftArrModel];
        }else{
            [self.animationArr removeObjectAtIndex:0];
        }
        
        NSLog(@"%@",self.animationArr);
        
        if (self.animationArr.count > 0) {
            LIMGiftArrModel *giftArrModel = self.animationArr[0];
            [self bigGiftAnimation:giftArrModel];
        }
    }
}
- (void)sendCountClick{
    if (self.currentGiftIndex >-1) {
        self.sendCountView.hidden = !self.sendCountView.hidden;
        
        if (self.sendCountView.hidden == YES) {
            self.turnView.clickY = kScreenH - 160*kiphone6-35*kiphone6;
            
        }else{
            self.turnView.clickY = 0;
            
        }
    }
    
}
- (void)countSelect:(UIButton *)sender{
    NSInteger index = sender.tag -850;
    NSString *count;
    switch (index) {
        case 0:
        {count = @" ×500";
            self.currentGiftCount = @"500";
            break;}
        case 1:{
            count = @"  ×100";
            self.currentGiftCount = @"100";
            break;}
        case 2:{
            count = @"   ×10";
            self.currentGiftCount = @"10";
            break;}
        case 3:{
            count = @"     ×1";
            self.currentGiftCount = @"1";
            break;
        }
        default:
            break;
    }
    self.sendCount.text = [NSString stringWithFormat:@"%@",count];
    self.sendCountView.hidden = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"webView 加载完成");
    // 设置javaScriptContext上下文
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    将tianbai对象指向自身
    
    self.jsContext[@"JS2KK"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
- (void)webShowText{
    NSLog(@"call");
    // 之后在回调JavaScript的方法Callback把内容传出去
    JSValue *Callback = self.jsContext[@"showtext"];
    //传值给web端
    [Callback callWithArguments:@[@"唤起本地OC回调完成"]];
}
- (void)rechargeScore:(NSString *)callString{
    NSLog(@"rechargeScore:%@", callString);
    // 成功回调JavaScript的方法Callback
    //    JSValue *Callback = self.jsContext[@"alerCallback"];
    //    [Callback callWithArguments:nil];
    [self showAlertWithMessage:@"web传值"];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            scaleX = -1;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(-rect.size.width, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (void)deallocAnimationTimer{
    [self.animation1 invalidate];
    self.animation1 = nil;
    
    [self.animation2 invalidate];
    self.animation2 = nil;
    
    [self.animation3 invalidate];
    self.animation3 = nil;
    
    [self.animation4 invalidate];
    self.animation4 = nil;
    
    [self.animation5 invalidate];
    self.animation5 = nil;
}
- (void)cancelAnimation{
    if (self.isAnimation == YES) {
        [self.bigGift removeFromSuperview];
        self.bigGift = nil;
        self.isAnimation = NO;
        [self bigArrPlay];
        [self deallocAnimationTimer];
    }
}
- (void)loginAnimation:(NSString *)userLevel andUserName:(NSString *)userName andUserIcon:(NSString *)iconUrl{
//                UIImageView *imageV_pao3 = [self imageViewWithFrame:CGRectMake(125*kiphone6, 350 *kiphone6, 119*kiphone6 *0.8, 105 *kiphone6 *0.8) andImage:@"cannon_00000" andArrayName:@"cannon_000" andArrayCount:2 andTime:0.36 andCount:1];
    
    NSLog(@"%@",userLevel);
    if(!self.isLogin){
        NSArray *photoNameArr = @[@""
                                  ,@"tuolaji_000",@"motuo_000",@"falali_000",@"lanbojini_000",@"bujiadi_000",@"zhishengji_000",@"kuaiting_000",@"jinlong_000"];
        //    NSArray *photoNameArr = @[@"",@"gift_car_000",@"drink_000",@"cucumber_000",@"microphone_000",@"fedemon",@"",@"kiss_000",@""];
        NSArray *photoNumArr = @[@""
                                 ,@"2",@"6",@"3",@"4",@"2",@"2",@"4",@"36"];
        self.loginGift = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.loginGift.userInteractionEnabled = NO;
        self.loginGift.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        
        NSArray *leftPaddingArr = @[@""
                                    ,@"34",@"21",@"33.5",@"33.5",@"52",@"32.5",@"0",@"6.5"];
        
        NSArray *bottomPaddingArr = @[@""
                                    ,@"18",@"21",@"29.5",@"22",@"28.5",@"12",@"17",@"0"];
        
        NSArray *textArr = @[@""
                            ,@"开着拖拉机进入",
                             @"骑着摩托车进入",
                             @"开着法拉利进入",
                             @"开着兰博基尼进入",
                             @"开着布加迪威龙进入",
                             @"开着直升机进入",
                             @"开着快艇进入",
                             @"架着金龙进入"
                             ];


        
//        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAnimation)];
//        [self.loginGift addGestureRecognizer:tapGest];
        // 组合动画  3 32 - 9 12 15 -16 21 22 23 -26   -------- 10个
        // 简单屏幕动画 4 6 - 14 -17 18 19 -25 28 29 31 --------- 10个
        if ([userLevel isEqualToString:@"1"]||[userLevel isEqualToString:@"2"]||[userLevel isEqualToString:@"3"]||[userLevel isEqualToString:@"4"]||[userLevel isEqualToString:@"5"]||[userLevel isEqualToString:@"6"]||[userLevel isEqualToString:@"7"]) {
            self.isLogin = YES;
            [self.turnView addSubview:self.loginGift];
            
            CGFloat imageX = kScreenW;
            CGFloat imageY = kScreenH - 195*kiphone6 -40;
            CGFloat imageW = 190 *kiphone6;
            CGFloat imageH = 100 *kiphone6;
            CGFloat yChange = 0;
            
            NSInteger level = [userLevel integerValue];
            // 条幅
            CGFloat bottomPadding = [bottomPaddingArr[level] integerValue] *-1;
            CGFloat leftPadding = [leftPaddingArr[level] integerValue];

            NSString *tiaofu_Name;
            
            switch (level) {
                case 1:
                {
                    imageW = 156 *kiphone6;
                    imageH = 106 *kiphone6;
                    tiaofu_Name = @"tiaofu_lan";
                }
                break;
                case 2:
                {
                    imageW = 190 *kiphone6;
                    imageH = 84 *kiphone6;
                    tiaofu_Name = @"tiaofu_lan";
                }
                    break;
                case 3:
                {
                    imageY -= 50 *kiphone6;
                    yChange = 100 *kiphone6;
                    
                    imageW = 190 *kiphone6;
                    imageH = 64 *kiphone6;
                    tiaofu_Name = @"tiaofu_zi";
                }
                   break;
                case 4:
                {
                    imageY -= 80 *kiphone6;
                    yChange = 160 *kiphone6;
                    
                    imageW = 221 *kiphone6;
                    imageH = 72 *kiphone6;
                    
                    tiaofu_Name = @"tiaofu_hong";
                }
                    break;
                case 5:
                {
                    imageY -= 106 *kiphone6;
                    yChange = 212 *kiphone6;
                    
                    imageW = 250 *kiphone6;
                    imageH = 85 *kiphone6;
                    
                    tiaofu_Name = @"tiaofu_zi";
                }
                    break;
                case 6:
                {
                    imageY -= 143 *kiphone6;
                    yChange = 286 *kiphone6;
                    
                    imageW = 250 *kiphone6;
                    imageH = 133 *kiphone6;
                    
                    tiaofu_Name = @"tiaofu_hong";
                    
                }
                    break;
                case 7:
                {
                    imageW = 303 *kiphone6;
                    imageH = 105 *kiphone6;
                    tiaofu_Name = @"tiaofu_lan";
                    
                }
                break;
                    
                default:
                    tiaofu_Name = @"tiaofu_hong";
                    break;
            }
            // 开始动画
            imageY -= imageH;
            UIImageView *imageV_pao3;
            
            if (level == 6) {
                imageV_pao3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
                imageV_pao3.frame = CGRectMake(imageX, imageY-5, imageW, imageH +10);
                
                UIImageView *imageV_zhishengji = [self loginWithFrame:CGRectMake(0, 0, imageW, imageH) andImage:@"" andArrayName:photoNameArr[level] andArrayCount:[photoNumArr[level] integerValue] andTime:[photoNumArr[level] integerValue] *0.06 andCount:100];
                [imageV_zhishengji startAnimating];
                [imageV_pao3 addSubview:imageV_zhishengji];
                
                
                [self circulateViewF:imageV_zhishengji];
                
                
            }else{
                imageV_pao3 = [self loginWithFrame:CGRectMake(imageX, imageY, imageW, imageH) andImage:@"" andArrayName:photoNameArr[level] andArrayCount:[photoNumArr[level] integerValue] andTime:[photoNumArr[level] integerValue] *0.06 andCount:100];
                
                
                [imageV_pao3 startAnimating];
            }
            [self.loginGift addSubview:imageV_pao3];
            
            
            // 条幅
            UIImageView *tiaofu_login = [[UIImageView alloc]initWithImage:[UIImage imageNamed:tiaofu_Name]];
            tiaofu_login.frame = CGRectMake(imageX + leftPadding, imageY -41.5 *kiphone6 +bottomPadding, 217.5 *kiphone6, 41.5 *kiphone6);
            [self.loginGift addSubview:tiaofu_login];
            
            UIImageView *imageV_icon = [[UIImageView alloc]initWithFrame:CGRectMake(1*kiphone6, 1.5*kiphone6, 39*kiphone6, 39*kiphone6)];
            [imageV_icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];
//            imageV_icon.backgroundColor = [UIColor whiteColor];
            imageV_icon.layer.cornerRadius = 19.5*kiphone6;
            imageV_icon.clipsToBounds = YES;
            [tiaofu_login addSubview:imageV_icon];
            
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV_icon.frame)+8*kiphone6, 8.5*kiphone6, 120*kiphone6, 10)];
            nameLabel.text = userName;
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont systemFontOfSize:10];
            [tiaofu_login addSubview:nameLabel];
            
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV_icon.frame)+8*kiphone6, CGRectGetMaxY(nameLabel.frame)+6.5*kiphone6, 120*kiphone6, 10)];
            textLabel.text = textArr[[userLevel integerValue]];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.font = [UIFont systemFontOfSize:10];
            [tiaofu_login addSubview:textLabel];
            
            
            
            
            
//            imageV_pao3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            CGFloat allX = kScreenW +imageV_pao3.frame.size.width;
            
            CGFloat first = kScreenW/2.0/allX;
            CGFloat second = kScreenW/3.0/allX;
            CGFloat third = imageW/allX +kScreenW/6.0/allX;
            
            CGFloat fistTime = 0.3;
            CGFloat sencondTime = 2;
            CGFloat thirdTime = 0.25;
            if (level == 6) {
                second = first;
                third = imageW/allX;
                fistTime = 1.5;
                sencondTime = 3;
            }
            [UIView animateKeyframesWithDuration:fistTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect frame = imageV_pao3.frame;
                frame.origin.x -= first *allX;
                frame.origin.y += yChange *first;
                NSLog(@"%g,,%g",frame.origin.x,frame.origin.y);
                imageV_pao3.frame = frame;
                
                
                // 条幅 frame
                CGRect frame_tiaofu = tiaofu_login.frame;
                frame_tiaofu.origin.x -= first *allX;
                frame_tiaofu.origin.y += yChange *first;
                tiaofu_login.frame = frame_tiaofu;

            } completion:^(BOOL finished) {
                
                [UIView animateKeyframesWithDuration:sencondTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CGRect frame = imageV_pao3.frame;
                    frame.origin.x -= second *allX;
                    frame.origin.y += yChange *second;
                    imageV_pao3.frame = frame;
                    
                    
                    CGRect frame_tiaofu = tiaofu_login.frame;
                    frame_tiaofu.origin.x -= second *allX;
                    frame_tiaofu.origin.y += yChange *second;
                    tiaofu_login.frame = frame_tiaofu;
                } completion:^(BOOL finished) {
                    [UIView animateKeyframesWithDuration:thirdTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        CGRect frame = imageV_pao3.frame;
                        frame.origin.x -= third *allX;
                        frame.origin.y += yChange *third;
                        imageV_pao3.frame = frame;
                        
                        CGRect frame_tiaofu = tiaofu_login.frame;
                        frame_tiaofu.origin.x -= third *allX;
                        frame_tiaofu.origin.y += yChange *third;
                        tiaofu_login.frame = frame_tiaofu;
                    } completion:^(BOOL finished) {
                        [self.loginGift removeFromSuperview];
                        self.loginGift = nil;
                        self.isLogin = NO;
                        [self loginArrPlay];

                    }];

                }];

                
            }];
        }else {// 金龙动画
//            CGFloat bili = 375/215.0f;
//            CGFloat imageW =
            self.isLogin = YES;
            [self.turnView addSubview:self.loginGift];
            
            
            UIImageView *imageV_dp_right = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenW/2.0, kScreenW/4.0)]; //
            NSMutableArray *imageArray_dp_right = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i = 0; i < [photoNumArr[8] integerValue]; i++) {
                NSString *imageName = [NSString stringWithFormat:@"%@%02d", photoNameArr[8],i];
                NSLog(@"%@",imageName);
                UIImage *image = [UIImage imageNamed:imageName];
                image = [self image:image rotation:UIImageOrientationDownMirrored];
                [imageArray_dp_right addObject:image];
            }
            imageV_dp_right.animationImages = imageArray_dp_right;  // 序列帧动画的uiimage数组
            imageV_dp_right.animationDuration = 2;      // 序列帧全部播放完所用时间
            imageV_dp_right.animationRepeatCount = 1;  // 序列帧动画重复次数
            [self.loginGift addSubview:imageV_dp_right];
            [imageV_dp_right startAnimating];
            
            
            CGFloat imageY = kScreenH - 195*kiphone6 -40 - kScreenW/2.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageV_dp_right stopAnimating];
            UIImageView *imageV_jinlong = [self loginWithFrame:CGRectMake(0, imageY, kScreenW, kScreenW/2.0) andImage:@"" andArrayName:photoNameArr[8] andArrayCount:[photoNumArr[8] integerValue] andTime:[photoNumArr[8] integerValue] *0.06 andCount:1];
            [imageV_jinlong startAnimating];
            [self.loginGift addSubview:imageV_jinlong];
            });
            
            
            // 条幅
            UIImageView *tiaofu_login = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tiaofu_hong"]];
            tiaofu_login.frame = CGRectMake(6.5 *kiphone6, imageY -41.5 *kiphone6, 217.5 *kiphone6, 41.5 *kiphone6);
            [self.loginGift addSubview:tiaofu_login];
            
            
            
            UIImageView *imageV_icon = [[UIImageView alloc]initWithFrame:CGRectMake(1*kiphone6, 1.5*kiphone6, 39*kiphone6, 39*kiphone6)];
            [imageV_icon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];
            //            imageV_icon.backgroundColor = [UIColor whiteColor];
            imageV_icon.layer.cornerRadius = 19.5*kiphone6;
            imageV_icon.clipsToBounds = YES;
            [tiaofu_login addSubview:imageV_icon];
            
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV_icon.frame)+8*kiphone6, 8.5*kiphone6, 120*kiphone6, 10)];
            nameLabel.text = userName;
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont systemFontOfSize:10];
            [tiaofu_login addSubview:nameLabel];
            
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV_icon.frame)+8*kiphone6, CGRectGetMaxY(nameLabel.frame)+6.5*kiphone6, 120*kiphone6, 10)];
            textLabel.text = textArr[[userLevel integerValue]];
            textLabel.textColor = [UIColor whiteColor];
            textLabel.font = [UIFont systemFontOfSize:10];
            [tiaofu_login addSubview:textLabel];

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([photoNumArr[8] integerValue] *0.06 *2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loginGift removeFromSuperview];
                self.loginGift = nil;
                self.isLogin = NO;
                [self loginArrPlay];
            });
            
            
            
        }
        
    }else if ([userLevel isEqualToString:@"8"]){ // 正在动画
        NSDictionary *dict = @{
                               @"userLevel":userLevel,
                               @"iconUrl":iconUrl,
                               @"userName":userName
                               };
        [self.loginArr addObject:dict];
    }
}
- (void)loginArrPlay{
    if (self.loginArr.count >0) {
        NSLog(@"%@",self.loginArr);
        NSLog(@"%@",self.loginArr);
        if (self.loginArr.count > 0) {
            NSDictionary *dict = self.loginArr[0];
            [self loginAnimation:dict[@"userLevel"] andUserName:dict[@"userName"] andUserIcon:dict[@"iconUrl"]];
            [self.loginArr removeObjectAtIndex:0];
        }
    }
}
- (UIImageView *)loginWithFrame:(CGRect)frame andImage:(NSString *)imageStr andArrayName:(NSString *)arrayName andArrayCount:(NSInteger )arrgeCount andTime:(CGFloat)time andCount:(CGFloat)count{
    UIImageView *imageV_smoke = [[UIImageView alloc]initWithFrame:frame]; // 烟雾
    
    NSLog(@"%@__%ld",arrayName,arrgeCount);
    
    if (imageStr.length >0) {
        imageV_smoke.image = [UIImage imageNamed:imageStr];
    }
    if (arrayName.length >0) {
        NSMutableArray *imageArray_qiqiu = [[NSMutableArray alloc] initWithCapacity:2];
        for (int i = 0; i < arrgeCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d", arrayName,i];

            
            UIImage *image = [UIImage imageNamed:imageName];
            [imageArray_qiqiu addObject:image];
        }
        imageV_smoke.animationImages = imageArray_qiqiu;  // 序列帧动画的uiimage数组
        imageV_smoke.animationDuration = time;      // 序列帧全部播放完所用时间
        imageV_smoke.animationRepeatCount = count;  // 序列帧动画重复次数
    }
    //    [self.bigGift addSubview:imageV_smoke];
    return imageV_smoke;
}
// 上下浮动
- (void)circulateViewF:(UIView *)zhishengji{

    if (zhishengji) {
    [UIView animateKeyframesWithDuration:0.24 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = zhishengji.frame;
        if (frame.origin.y == 0) {
            frame.origin.y = 5;
        }else{
            frame.origin.y = 0;
        }
        zhishengji.frame = frame;
    } completion:^(BOOL finished) {
        [self circulateViewF:zhishengji];
    }];
    }
}

//- (BarrageDescriptor *)flowerImageSpriteDescriptor
//{
//    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
//    descriptor.spriteName = NSStringFromClass([FlowerBarrageSprite class]);
//    descriptor.params[@"image"] = [[UIImage imageNamed:@"avatar"]barrageImageScaleToSize:CGSizeMake(40.0f, 40.0f)];
//    descriptor.params[@"duration"] = @(10);
//    descriptor.params[@"viewClassName"] = NSStringFromClass([UILabel class]);
//    descriptor.params[@"text"] = @"^*-*^";
//    descriptor.params[@"borderWidth"] = @(1);
//    descriptor.params[@"borderColor"] = [UIColor grayColor];
//    descriptor.params[@"scaleRatio"] = @(4);
//    descriptor.params[@"rotateRatio"] = @(100);
//    return descriptor;
//}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
