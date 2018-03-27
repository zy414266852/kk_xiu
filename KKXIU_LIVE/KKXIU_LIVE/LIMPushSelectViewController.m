//
//  LIMPushSelectViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/17.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPushSelectViewController.h"

@interface LIMPushSelectViewController ()
@property (nonatomic, strong) UIView  *botttomView;


@end

@implementation LIMPushSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initBottomView
{
    _botttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _botttomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    //        _botttomView.alpha = 0.80;
    _botttomView.hidden = YES;
    [self.view addSubview:_botttomView];
    CGSize size = _botttomView.frame.size;
    /////////////////////////////////////////////底部/////////////////////////////////////////////////////
    int btnBkgViewHeight = 229.5;
    UIView * btnBkgView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - btnBkgViewHeight, size.width, btnBkgViewHeight)];
    btnBkgView.backgroundColor = [UIColor whiteColor];
    btnBkgView.userInteractionEnabled = YES;
    [_botttomView addSubview:btnBkgView];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //        [btnBkgView addGestureRecognizer:singleTap];
    
    
    
    
    // 关闭
    UIImageView * imageHidden = [[UIImageView alloc] init];
    imageHidden.image = [UIImage imageNamed:@"startpush_图层-3"];
    imageHidden.center = CGPointMake(kScreenH / 2, btnBkgViewHeight / 2);
    imageHidden.userInteractionEnabled = YES;
    
    [imageHidden sizeToFit];
    [btnBkgView addSubview:imageHidden];
    [imageHidden mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnBkgView).offset(-2);
        make.centerX.equalTo(btnBkgView);
    }];
    
    
    // 聊天直播
    UIView *chatView = [[UIView alloc]init];
    //        chatView.backgroundColor = [UIColor cyanColor];
    [btnBkgView addSubview:chatView];
    UITapGestureRecognizer* tapGoChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChatLive)];
    [chatView addGestureRecognizer:tapGoChat];
    
    
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnBkgView).offset(-108);
        make.left.equalTo(btnBkgView).offset(66);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *chatLabel = [[UILabel alloc]init];
    chatLabel.text = @"聊天直播";
    chatLabel.textColor = [UIColor colorWithHexString:@"585352"];
    chatLabel.font = [UIFont systemFontOfSize:13];
    chatLabel.textAlignment = NSTextAlignmentCenter;
    
    [chatView addSubview:chatLabel];
    [chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chatView).offset(0);
        make.left.equalTo(chatView).offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(13);
    }];
    
    
    
    UIImageView *chatImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_图层-2"]];
    [chatImage sizeToFit];
    [chatView addSubview:chatImage];
    
    [chatImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chatLabel.mas_top).offset(-14.5);
        make.centerX.equalTo(chatView).offset(0);
    }];
    
    // 游戏直播
    
    UIView *gameView = [[UIView alloc]init];
    //        gameView.backgroundColor = [UIColor cyanColor];
    [btnBkgView addSubview:gameView];
    UITapGestureRecognizer* tapGoGame = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goGameLive)];
    [gameView addGestureRecognizer:tapGoGame];
    
    
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnBkgView).offset(-108);
        make.right.equalTo(btnBkgView).offset(-66);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(80);
    }];
    
    
    UILabel *gameLabel = [[UILabel alloc]init];
    gameLabel.text = @"聊天直播";
    gameLabel.textColor = [UIColor colorWithHexString:@"585352"];
    gameLabel.font = [UIFont systemFontOfSize:13];
    gameLabel.textAlignment = NSTextAlignmentCenter;
    
    [gameView addSubview:gameLabel];
    [gameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(gameView).offset(0);
        make.left.equalTo(gameView).offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(13);
    }];
    
    
    
    UIImageView *gameImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_图层-1"]];
    [gameImage sizeToFit];
    [gameView addSubview:gameImage];
    
    [gameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(gameLabel.mas_top).offset(-14.5);
        make.centerX.equalTo(gameView).offset(0);
    }];
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    [imageHidden addGestureRecognizer:singleTap];
    [_botttomView addGestureRecognizer:singleTap];
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (_botttomView) {
        _botttomView.hidden = YES;
    }
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
