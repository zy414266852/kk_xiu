//
//  LIMChatSelectViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/17.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMChatSelectViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LIMPushLiveViewController.h"
#import "LIMPushLiveModel.h"
#import <MJExtension.h>

#import "ImSDK/ImSDK.h"
#import "ImSDK/TIMManager.h"
#import "ImSDK/IMSdkInt.h"
#import "TLSSDK/TLSHelper.h"
#import "IMGroupExt/IMGroupExt.h"

#import "TXLiteAVSDK_Professional/TXLivePush.h"
#import "TXLiteAVSDK_Professional/TXLivePushConfig.h"
#import "TXLiteAVSDK_Professional//TXLiveBase.h"
#import "HttpClient.h"
#import "CcUserModel.h"
#import <CoreLocation/CoreLocation.h>
#import "LIMGameCollectionViewCell.h"
#import <UIImageView+WebCache.h>


#define mTest @"no"
@interface LIMChatSelectViewController ()<AVCaptureFileOutputRecordingDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{//添加代理协议 CLLocationManagerDelegate
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder * _geocoder;//初始化地理编码器
}

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;

@property (strong, nonatomic)  UIButton *captureButton;
@property (strong, nonatomic)  UISegmentedControl *modeControl;


@property (nonatomic, strong) UIImageView *showV;
@property (nonatomic, strong) UIView *displayView;

@property (nonatomic, strong) NSArray *shareIconArray_N;
@property (nonatomic, strong) NSArray *shareIconArray_S;
@property (nonatomic, strong) NSArray *shareTitleArray;

@property (nonatomic, strong) TXLivePush *txLivePush;
@property (nonatomic, strong) NSString *groupID;

@property (nonatomic, strong) UITextField *titleF;
@property (nonatomic, strong) UILabel *titleP;

@property (nonatomic, strong) UIView  *botttomView;

@property (nonatomic, assign) CGFloat beautyDepth;
@property (nonatomic, assign) CGFloat whiteningDepth;
@property (nonatomic, assign) CGFloat eyeScaleLevel;
@property (nonatomic, assign) CGFloat faceScaleLevel;
@property (nonatomic, strong) UIView *sliderV;
@property (nonatomic, strong) UIView *btnBkgView;
@property (nonatomic, assign) BOOL turnFront;


@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectDataSource;

@property (nonatomic, assign) NSInteger gameID;

@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation LIMChatSelectViewController
- (NSMutableArray *)collectDataSource{
    if (_collectDataSource == nil) {
        _collectDataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _collectDataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameID = 0;
//    [self starCapture];
    [self createIMGroup];
    self.view.backgroundColor = [UIColor whiteColor];
    _showV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"livepage"]];
    _showV.userInteractionEnabled = YES;
    [self.view addSubview:_showV];
    
    
    [_showV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    _displayView = [[UIView alloc]init];
    _displayView.backgroundColor = [UIColor clearColor];
    _displayView.userInteractionEnabled = YES;
    [self.view addSubview:_displayView];
    
    [_displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];

    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(offKeyBoard)];
    tapGest.delegate = self;
    [self.view addGestureRecognizer:tapGest];
    
    [self setUI];
    
    
    self.navigationController.navigationBar.hidden = YES;
    TXLivePushConfig* _config = [[TXLivePushConfig alloc] init];
    _config = [[TXLivePushConfig alloc] init];
    _txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    [_txLivePush startPreview:_showV];  //_playView用来承载我们的渲染控件
    _turnFront = YES;
    [_txLivePush setFocusPosition:CGPointMake(0, 0)];
    
    CcUserModel *userInfo = [CcUserModel defaultClient];
    _beautyDepth = [userInfo.beautyDepth floatValue];
    _whiteningDepth = [userInfo.whiteningDepth floatValue];
    _eyeScaleLevel = [userInfo.eyeScaleLevel floatValue];
    _faceScaleLevel = [userInfo.faceScaleLevel floatValue];
    [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
    [_txLivePush setEyeScaleLevel:_eyeScaleLevel];
    [_txLivePush setFaceScaleLevel:_faceScaleLevel];
    
    [self createBottomView];

    
    

}

- (void)setUI{
    UIButton *offBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [offBtn setImage:[UIImage imageNamed:@"pushpage_10"] forState:UIControlStateNormal];
    [offBtn addTarget:self action:@selector(offThisView) forControlEvents:UIControlEventTouchUpInside];
    [offBtn sizeToFit];
    
    [_displayView addSubview:offBtn];
    [offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_displayView).offset(-13.5);
        make.top.equalTo(_displayView).offset(21.5);
    }];
    // 位置
    UIImageView *location = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_6"]];
    [location sizeToFit];
    [_displayView addSubview:location];
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_displayView).offset(26.5);
        make.left.equalTo(_displayView).offset(12.5);
        
    }];
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSString *locationStr;
    if (userModel.city.length >0) {
        locationStr = userModel.city;
    }else{
        locationStr = @"火星市";
    }
    CGFloat buttonW = [locationStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTitle:locationStr forState:UIControlStateNormal];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.frame = CGRectMake(0, 0, buttonW, 12);
    [_displayView addSubview:locationBtn];
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(location.mas_centerY);
        make.left.equalTo(location.mas_right).offset(4);
//        make.size.mas_equalTo(CGSizeMake(buttonW, 12));
    }];
    
    self.locationBtn = locationBtn;
    
    // 翻转
    self.turnFront = YES;
    UIImageView *turnDevice = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"startpush_9"]];
    [turnDevice sizeToFit];
    [_displayView addSubview:turnDevice];
    [turnDevice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationBtn.mas_centerY).offset(0);
        make.left.equalTo(locationBtn.mas_right).offset(14);
        
    }];
    CGFloat buttonW2 = [@"翻转" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width +0.5;
    UIButton *turnDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [turnDeviceBtn setTitle:@"翻转" forState:UIControlStateNormal];
    turnDeviceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [turnDeviceBtn addTarget:self action:@selector(turnFont) forControlEvents:UIControlEventTouchUpInside];
    [_displayView addSubview:turnDeviceBtn];
    
    [turnDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(location.mas_centerY);
        make.left.equalTo(turnDevice.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(buttonW2, 12));
    }];
    
//    UIButton *turnClickFrame = [UIButton buttonWithType:UIButtonTypeCustom];
////    turnClickFrame.backgroundColor = [UIColor redColor];
//    [turnClickFrame addTarget:self action:@selector(turnFont) forControlEvents:UIControlEventTouchUpInside];
//    [_displayView addSubview:turnClickFrame];
//    
//    [turnClickFrame mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(turnDeviceBtn);
//        make.size.mas_equalTo(CGSizeMake(buttonW2 +20, 30));
//    }];

    
    // 直播标题
    UITextField *titleTF = [[UITextField alloc]init];
    titleTF.textColor = [UIColor whiteColor];
    titleTF.font = [UIFont systemFontOfSize:20];
    titleTF.textAlignment = NSTextAlignmentCenter;
//    titleTF.text = @"给直播写个标题吧";
    titleTF.delegate = self;
    [_displayView addSubview:titleTF];
    [titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_displayView).offset(-110);
        make.left.equalTo(_displayView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(20);
    }];
    // 直播标题提示
    UILabel *titlePlace= [[UILabel alloc]init];
    titlePlace.text = @"给直播写个标题吧";
    titlePlace.textColor = [UIColor whiteColor];
    titlePlace.textAlignment = NSTextAlignmentCenter;
    titlePlace.font = [UIFont systemFontOfSize:20];
    [_displayView addSubview:titlePlace];
    [titlePlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleTF).offset(0);
        make.left.equalTo(_displayView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(20);
    }];

    
    // 标题提示
    UILabel *titleLabel= [[UILabel alloc]init];
    titleLabel.text = @"—— 会显示在开播推送消息中 ——";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [_displayView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTF.mas_bottom).offset(13);
        make.left.equalTo(_displayView).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(14);
    }];
    if(!self.isChat){
        [self createGame];
    }
    
    // 美颜
    UIButton *beatifulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [beatifulBtn setImage:[UIImage imageNamed:@"startpush_图层-0"] forState:UIControlStateNormal];
    [beatifulBtn addTarget:self action:@selector(showBottonView) forControlEvents:UIControlEventTouchUpInside];
//    [beatifulBtn sizeToFit];r
    
    [_displayView addSubview:beatifulBtn];
    [beatifulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_displayView).offset(29.5 *kiphone6);
        make.bottom.equalTo(_displayView).offset(-74.5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    // 开始直播
    UIButton *starLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [starLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [starLiveBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    starLiveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    starLiveBtn.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
    [starLiveBtn addTarget:self action:@selector(starTolive) forControlEvents:UIControlEventTouchUpInside];
    starLiveBtn.layer.cornerRadius = 19;
    starLiveBtn.clipsToBounds = YES;
    [_displayView addSubview:starLiveBtn];
    [starLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beatifulBtn.mas_right).offset(14 *kiphone6);
        make.centerY.equalTo(beatifulBtn.mas_centerY).offset(0);
        make.right.equalTo(_displayView).offset(-29.5 *kiphone6);
        make.height.mas_equalTo(38);
    }];

    
    // 分享按钮。16 17.5
    CGFloat proportionNum = (kScreenW - 16*4)/7.9;
    NSArray *iconArray = @[@"startpush_3",@"startpush_4",@"startpush_2",@"startpush_5"];
    self.shareTitleArray = @[@"微信分享已开",@"朋友圈分享已开",@"QQ分享已开",@"QQ空间分享已开"];
    self.shareIconArray_N = iconArray;
//    self.shareIconArray_S = @[@"startpush_3",@"startpush_4",@"startpush_2",@"startpush_5"];
    for (int i = 0; i < 4; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
        iconBtn.alpha = 0.5;
        iconBtn.tag = 100 +i;
        [iconBtn sizeToFit];
        
        [_displayView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_displayView).offset(proportionNum *2.45  + i*(proportionNum +16));
            make.bottom.equalTo(starLiveBtn.mas_top).offset(-18.5);
        }];
        
        UILabel *shareLabel = [[UILabel alloc]init];
        shareLabel.backgroundColor = [UIColor colorWithHexString:@"9c69d4"];
        shareLabel.text = self.shareTitleArray[i];
        shareLabel.textColor = [UIColor whiteColor];
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.layer.cornerRadius = 4;
        shareLabel.clipsToBounds = YES;
        shareLabel.hidden = YES;
        shareLabel.tag = 200 +i;
        [_displayView addSubview:shareLabel];
        
//        多边形-2
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"多边形-2"]];
        [imageV sizeToFit];
        imageV.hidden = YES;
        imageV.tag = 300 +i;
        
        
        CGFloat buttonW = [self.shareTitleArray[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width + 20;
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(iconBtn.mas_centerX).offset(0);
            make.bottom.equalTo(iconBtn.mas_top).offset(-17.5);
            make.size.mas_equalTo(CGSizeMake(buttonW, 30));
        }];
        
        [_displayView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareLabel.mas_centerX).offset(0);
            make.top.equalTo(shareLabel.mas_bottom).offset(0);
//            make.size.mas_equalTo(CGSizeMake(buttonW, 30));
        }];

    }
    self.titleF = titleTF;
    self.titleP = titlePlace;
    
}
- (void)turnC{
    AVCaptureDevice *videoDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
}
- (void)starCapture{
    self.captureSession = [[AVCaptureSession alloc] init];
    //Optional: self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    AVCaptureDevice *videoDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
    //    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *stillImageOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:stillImageOutputSettings];
    
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    // Setup capture session for taking pictures
    [self.captureSession addInput:self.videoInput];
    [self.captureSession addOutput:self.stillImageOutput];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    UIView *aView = self.view;
    previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [aView.layer addSublayer:previewLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) captureStillImage
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput.connections objectAtIndex:0];
    if ([stillImageConnection isVideoOrientationSupported])
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (imageDataSampleBuffer != NULL)
         {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             [library writeImageToSavedPhotosAlbum:[image CGImage]
                                       orientation:(ALAssetOrientation)[image imageOrientation]
                                   completionBlock:^(NSURL *assetURL, NSError *error)
              {
                  UIAlertView *alert;
                  if (!error)
                  {
                      alert = [[UIAlertView alloc] initWithTitle:@"Photo Saved"
                                                         message:@"The photo was successfully saved to you photos library"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
                  }
                  else
                  {
                      alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Photo"
                                                         message:@"The photo was not saved to you photos library"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
                  }
                  
                  [alert show];
              }
              ];
         }
         else
             NSLog(@"Error capturing still image: %@", error);
     }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.captureSession stopRunning];
//    [self.txLivePush stopPreview];
    
    CcUserModel *userInfo = [CcUserModel defaultClient];
    userInfo.beautyDepth = [NSString stringWithFormat:@"%g",_beautyDepth];
    userInfo.whiteningDepth = [NSString stringWithFormat:@"%g",_whiteningDepth];
    userInfo.faceScaleLevel = [NSString stringWithFormat:@"%g",_faceScaleLevel];
    userInfo.eyeScaleLevel = [NSString stringWithFormat:@"%g",_eyeScaleLevel];
    [userInfo saveAllInfo];
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    BOOL recordedSuccessfully = YES;
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
            recordedSuccessfully = [value boolValue];
        // Logging the problem anyway:
        NSLog(@"A problem occurred while recording: %@", error);
    }
    if (recordedSuccessfully) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                    completionBlock:^(NSURL *assetURL, NSError *error)
         {
             UIAlertView *alert;
             if (!error)
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Video Saved"
                                                    message:@"The movie was successfully saved to you photos library"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
             }
             else
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Video"
                                                    message:@"The movie was not saved to you photos library"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
             }
             
             [alert show];
         }
         ];
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
- (void)offThisView{
    
    NSLog(@"老子不播了");
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)shareType:(UIButton *)sender{
    if (sender.alpha == 1) {
        sender.alpha = 0.5;
        
        UILabel *shareLabel = [_displayView viewWithTag:100 +sender.tag];
        shareLabel.hidden = YES;
        
        UIImageView *imageV = [_displayView viewWithTag:200 +sender.tag];
        imageV.hidden = YES;
        return;
    }
    
    for (int i = 0; i<4; i++) {
        UIButton *allBtn = [_displayView viewWithTag:100+i];
        allBtn.alpha = 0.5;
        UILabel *shareLabel = [_displayView viewWithTag:200 +i];
        shareLabel.hidden = YES;
        UIImageView *imageV = [_displayView viewWithTag:300 +i];
        imageV.hidden = YES;
    }
    UILabel *shareLabel = [_displayView viewWithTag:100 +sender.tag];
    shareLabel.hidden = NO;
    sender.alpha = 1;
    UIImageView *imageV = [_displayView viewWithTag:200 +sender.tag];
    imageV.hidden = NO;
    
}
- (void)starTolive{
    [self httpForPushInfo];

}

- (void)httpForPushInfo{
    if (self.gameID <1 || self.gameID >5) {
        if(!self.isChat){
            [self showAlertWithMessage:@"请选择正确的游戏"];
            return;
        }
    }
    if ([mTest isEqualToString:@"yes"]) {
        LIMPushLiveViewController* pushLiveVC = [[LIMPushLiveViewController alloc]init];
        [self presentViewController:pushLiveVC animated:YES completion:^{
        }];
    }else{
    if (self.groupID.length<=0) {
        [self showAlertWithMessage:@"群聊创建失败"];
        [self createIMGroup];
    }else{
        
        NSString *haveGame = @"0";
        if(!self.isChat){
            haveGame = @"2";
        }

    CcUserModel *userModel = [CcUserModel defaultClient];
        NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
        [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"livetitle":self.titleF.text ,@"roomid":self.groupID,@"gameid":[NSString stringWithFormat:@"%ld",self.gameID]}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];

    
    [[HttpClient defaultClient] requestWithPath:mStar_Live method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            
            NSDictionary *dict = responseObject[@"result"][@"compereinfo"];
            LIMPushLiveModel *pushModel = [LIMPushLiveModel mj_objectWithKeyValues:dict];
            NSLog(@"%@",pushModel.cover);
            LIMPushLiveViewController* pushLiveVC = [[LIMPushLiveViewController alloc]init];
            pushLiveVC.turnFront = self.turnFront;
            pushLiveVC.rtmpUrl = self.pushvideourl;
            pushLiveVC.groupID = self.groupID;
            pushLiveVC.livePushModel = pushModel;
            pushLiveVC.gameID = self.gameID;
            [self.txLivePush stopPreview];
            
            [self presentViewController:pushLiveVC animated:YES completion:^{
//                [self.txLivePush stopPreview];
//                if(self.txLivePush != nil)
//                {
//                    self.txLivePush.delegate = nil;
//                    [self.txLivePush stopPreview];
//#ifdef  UGC_ACTIVITY
//                    [[TXUGCRecord shareInstance] stopCameraPreview];
//#endif
//                }
                
            }];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    }
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
- (void)createIMGroup{
    [[TIMGroupManager sharedInstance] createGroup:@"AVChatRoom" groupId:@"" groupName:@"wechat" succ:^(NSString *groupId) {
        self.groupID = groupId;
    } fail:^(int code, NSString *msg) {
        NSLog(@"---------------------------%@",msg);
    }];
}
- (void)createBottomView
{
    
    // 美颜整体视图
    _botttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH)];
    _botttomView.hidden = YES;
    [self.showV addSubview:_botttomView];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_botttomView addGestureRecognizer:singleTap];
    UIView * btnBkgView = [[UIView alloc] init ];//WithFrame:CGRectMake(0, size.height - btnBkgViewHeight, size.width, btnBkgViewHeight)];
    btnBkgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    btnBkgView.userInteractionEnabled = YES;
    [_botttomView addSubview:btnBkgView];
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [btnBkgView addGestureRecognizer:singleTap2];
    
    [btnBkgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_botttomView).offset(0);
        make.left.equalTo(_botttomView).offset(0);
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
    [_botttomView addSubview:sliderV];
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
    [_botttomView addGestureRecognizer:singleTap];
    
}
- (void)showBottonView{
    _displayView.hidden  = YES;
    _botttomView.hidden = NO;
    [_showV bringSubviewToFront:_botttomView];
    [UIView animateWithDuration:0.5 animations:^{
        _botttomView.frame =  CGRectMake(0, 0, kScreenW, kScreenH);
    }];
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (_botttomView) {
        _botttomView.hidden = YES;
        _botttomView.frame = CGRectMake(0, kScreenH, kScreenW, kScreenH);
        _displayView.hidden = NO;
        CcUserModel *userInfo = [CcUserModel defaultClient];
        userInfo.beautyDepth = [NSString stringWithFormat:@"%g",_beautyDepth];
        userInfo.whiteningDepth = [NSString stringWithFormat:@"%g",_whiteningDepth];
        userInfo.eyeScaleLevel = [NSString stringWithFormat:@"%g",_eyeScaleLevel];
        userInfo.faceScaleLevel = [NSString stringWithFormat:@"%g",_faceScaleLevel];
        [userInfo saveAllInfo];

    }
}
-(void)sliderValueChanged:(UISlider *)paramSender{
//    _beautyDepth = 4.5;
//    _whiteningDepth = 4.5;
//    _eyeScaleLevel = 4.5;
//    _faceScaleLevel = 4.5;
//    [_txLivePush setBeautyFilterDepth:_beautyDepth setWhiteningFilterDepth:_whiteningDepth];
//    [_txLivePush setEyeScaleLevel:_eyeScaleLevel];
//    [_txLivePush setFaceScaleLevel:_faceScaleLevel];


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
}
- (void)offKeyBoard{
    [_titleF resignFirstResponder];
}
// textF
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"123");
    self.titleP.hidden = YES;
    self.titleP.alpha = 0;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.titleP.hidden = NO;
        self.titleP.alpha = 1;
    }
}
- (void)emptyClick{
}
- (void)locationClick{
    
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
//            // 位置名
//            　　NSLog(@"name,%@",placemark.name);
//            　　// 街道
//            　　NSLog(@"thoroughfare,%@",placemark.thoroughfare);
//            　　// 子街道
//            　　NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
//            　　// 市
//            　　NSLog(@"locality,%@",placemark.locality);
//            　　// 区
//            　　NSLog(@"subLocality,%@",placemark.subLocality);
//            　　// 国家
//            　　NSLog(@"country,%@",placemark.country);
            
            
//            CGFloat buttonW = [placemark.locality boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
            [self.locationBtn setTitle:placemark.locality forState:UIControlStateNormal];

        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //    [manager stopUpdatingLocation];不用的时候关闭更新位置服务
}
- (void)createGame{
    
    CGFloat interSpace = 17;
    CGFloat iconW = (kScreenW - 17*5)/4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 17;
    // 2.设置行间距
    layout.minimumLineSpacing = 2;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(iconW, iconW +20);
    //    // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    //    layout.estimatedItemSize = CGSizeMake(320, 60);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    // 6.设置头视图尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(50, 50);
    //    // 7.设置尾视图尺寸大小
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    // 8.设置分区(组)的EdgeInset（四边距）
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    layout.headerReferenceSize = CGSizeMake(0, 0);
    //    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    //    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    //    layout.sectionFootersPinToVisibleBounds = YES;
    //    layout.sectionHeadersPinToVisibleBounds = YES;
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSArray *gameArray = userModel.gameconflist;
//    for (int i = 0; i<gameArray.count ; i++) {
//        NSDictionary *dict = gameArray[i];
//        [self.collectDataSource addObject:dict[@"gamename"]];
//    }
    
    [self.collectDataSource addObjectsFromArray:@[@"抓娃娃",@"蔬菜精灵",@"车行",@"武林争霸",@"海盗船长"]];
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -49) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    UINib *collectNib = [UINib nibWithNibName:NSStringFromClass([LIMGameCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:collectNib forCellWithReuseIdentifier:@"LIMGameCollectionViewCell"];
    [self.displayView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(28.5);
        make.left.equalTo(_displayView).offset(17);
        make.width.mas_equalTo(kScreenW -34);
        make.height.mas_equalTo(150);
    }];
}
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectDataSource.count;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LIMGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LIMGameCollectionViewCell" forIndexPath:indexPath];
    cell.money.text = self.collectDataSource[indexPath.row];
    cell.giftIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"gameS_%ld",indexPath.row+1]];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.gameID = indexPath.row +1;
    for (int i = 0; i<self.collectDataSource.count; i++) {
        NSIndexPath *allPath = [NSIndexPath indexPathForRow:i inSection:0];
        LIMGameCollectionViewCell *presentCell = (LIMGameCollectionViewCell *)[collectionView cellForItemAtIndexPath:allPath];
        presentCell.coverImage.hidden = YES;
    }
    LIMGameCollectionViewCell *presentCell = (LIMGameCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    presentCell.coverImage.hidden = NO;
    NSLog(@"selectCell = %ld",indexPath.row);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
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
