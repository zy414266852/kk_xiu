//
//  LIMLiveShareView.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMLiveShareView.h"
#import <UIImageView+WebCache.h>
#import "CcUserModel.h"
#import "HttpClient.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface LIMLiveShareView()
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIImageView *shareImage;

@end
@implementation LIMLiveShareView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self addGestureRecognizer:singleTap];
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.windowLevel       = UIWindowLevelStatusBar;
        _actionWindow.backgroundColor   = [UIColor clearColor];
        _actionWindow.hidden = NO;
        [self.actionWindow addSubview:self];
                [self setUI];
    }
    return self;
}
- (void)setUI{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    bigView.layer.cornerRadius = 5;
    bigView.clipsToBounds = YES;
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(119);
    }];
    
    UILabel *shareTitle = [[UILabel alloc]init];
    shareTitle.text = @"分享至";
    shareTitle.textColor = [UIColor colorWithHexString:@"7f7f7f"];
    shareTitle.font = [UIFont systemFontOfSize:15];
    [bigView addSubview:shareTitle];
    [shareTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(10.5);
        make.top.equalTo(bigView).offset(6.5);
        make.size.mas_equalTo(CGSizeMake(70, 16));
    }];
    
    
    // 分享按钮。16 17.5
    CGFloat proportionNum = (kScreenW - 45*4)/4;
    NSArray *iconArray = @[@"share_图层-80",@"share_图层-81",@"share_图层-78",@"share_图层-79"];
    for (int i = 0; i < 4; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
//        iconBtn.alpha = 0.5;
        iconBtn.tag = 100 +i;
//        [iconBtn sizeToFit];
        
        [bigView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bigView).offset(proportionNum/2.0 + i*(proportionNum +45));
            make.bottom.equalTo(bigView).offset(-42.5);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(0);
        make.bottom.equalTo(bigView).offset(-9);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 14));
    }];
    
    [self createShareDetailView];

    
}
- (void)setShareUI{
    
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.centerY.equalTo(self).offset(-20);
        make.width.mas_equalTo(280 *kiphone6);
        make.height.mas_equalTo(420 *kiphone6);
    }];
    
    //
    //
    //    //
    UIImageView *upImage = [[UIImageView alloc]init];
    [upImage sd_setImageWithURL:[NSURL URLWithString:self.coverUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];
    //    [upImage sd_setImageWithURL:[NSURL URLWithString:self.simpleInfoModel.cover]];
    upImage.userInteractionEnabled = YES;
    [bigView addSubview:upImage];
    [upImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bigView).offset(0);
        make.top.equalTo(bigView).offset(0);
        make.width.equalTo(bigView.mas_width);
        make.height.mas_equalTo(320 *kiphone6);
    }];
    UITapGestureRecognizer* emptyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [upImage addGestureRecognizer:emptyTap];
    
    
    self.shareImage = upImage;
    
    UIView *blackView =[[UIView alloc]init];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [upImage addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.bottom.left.right.equalTo(upImage).offset(0);
    }];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:[self qrImageForString:self.ewmshareurl imageSize:120 logoImageSize:30]];
    codeImage.userInteractionEnabled = YES;
    [blackView addSubview:codeImage];
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(blackView).offset(0);
        make.left.equalTo(blackView).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    
    UILabel *describeTitle = [[UILabel alloc]init];
    describeTitle.text = @"马上扫码，陪我一起玩";
    //    describeTitle.text = self.simpleInfoModel.personsign;
    describeTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    describeTitle.textAlignment = NSTextAlignmentLeft;
    describeTitle.font = [UIFont systemFontOfSize:13];
    [blackView addSubview:describeTitle];
    [describeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImage.mas_right).offset(10);
        make.top.equalTo(codeImage).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(13);
    }];
    
    
    //    UIImageView *tempImage = [[UIImageView alloc]initWithImage:[self makeImageWithView:upImage withSize:CGSizeMake(280, 320)]];
    //    [bigView addSubview:tempImage];
    //
    //    [tempImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(bigView).offset(10);
    //        make.top.equalTo(upImage.mas_bottom).offset(0);
    //        make.bottom.equalTo(bigView).offset(0);
    //        make.width.mas_equalTo(50);
    //    }];
    
    NSString *nameStr = @"分享至";
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.text = nameStr;
    nameTitle.textColor = [UIColor colorWithHexString:@"c7c7c7"];
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.font = [UIFont systemFontOfSize:15];
    [bigView addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(10);
        make.top.equalTo(upImage.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(50);
    }];//
    
    UIView *shareBtnView = [[UIView alloc]init];
    shareBtnView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [bigView addSubview:shareBtnView];
    [shareBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(0);
        make.top.equalTo(nameTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.equalTo(bigView.mas_width).offset(0);
    }];//
    
    
    // 分享按钮。16 17.5
    CGFloat proportionNum = (280* kiphone6 - 16*4)/5;
    NSArray *iconArray = @[@"startpush_3",@"startpush_4",@"startpush_2",@"startpush_5"];
    for (int i = 0; i < 4; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
        iconBtn.alpha = 0.5;
        iconBtn.tag = 100 +i;
        [iconBtn sizeToFit];
        
        [shareBtnView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shareBtnView).offset(proportionNum + i*(proportionNum +16));
            make.bottom.equalTo(shareBtnView).offset(-18.5);
        }];
        
    }
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_10"]];
    [imageV sizeToFit];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigView.mas_bottom).offset(25.5 *kiphone6);
        make.centerX.equalTo(self).offset(0);
    }];
    [self createShareDetailView];
}
- (void)createShareDetailView{
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    [self addSubview:bigView];
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.centerY.equalTo(self).offset(5200);
        make.width.mas_equalTo(276);
        make.height.mas_equalTo(467);
    }];
    
    //
    //
    //    //
    UIImageView *upImage = [[UIImageView alloc]init];
    [upImage sd_setImageWithURL:[NSURL URLWithString:self.coverUrl] placeholderImage:[UIImage imageNamed:@"place_icon"]];
    //    [upImage sd_setImageWithURL:[NSURL URLWithString:self.simpleInfoModel.cover]];
    upImage.userInteractionEnabled = YES;
    [bigView addSubview:upImage];
    [upImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bigView).offset(0);
        make.top.equalTo(bigView).offset(0);
        make.width.equalTo(bigView.mas_width);
        make.height.mas_equalTo(392.5);
    }];
    UITapGestureRecognizer* emptyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClick)];
    [upImage addGestureRecognizer:emptyTap];
    
    
    self.shareImage = upImage;
    
    UIView *blackView =[[UIView alloc]init];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [upImage addSubview:blackView];
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(107.5);
        make.bottom.left.right.equalTo(upImage).offset(0);
    }];
    
    UIImageView *codeImage = [[UIImageView alloc]initWithImage:[self qrImageForString:self.ewmshareurl imageSize:120 logoImageSize:30]];
    codeImage.userInteractionEnabled = YES;
    [blackView addSubview:codeImage];
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(blackView).offset(0);
        make.left.equalTo(blackView).offset(11.5);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(95);
    }];
    
    
    UILabel *describeTitle = [[UILabel alloc]init];
    describeTitle.text = @"马上扫码，陪我一起玩";
    //    describeTitle.text = self.simpleInfoModel.personsign;
    describeTitle.textColor = [UIColor colorWithHexString:@"ffffff"];
    describeTitle.textAlignment = NSTextAlignmentLeft;
    describeTitle.font = [UIFont systemFontOfSize:13];
    [blackView addSubview:describeTitle];
    [describeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImage.mas_right).offset(11.5);
        make.top.equalTo(codeImage).offset(19);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(13);
    }];
    
    UIImage *iconImage = [UIImage imageNamed:@"share_娱乐-交友-一切尽在-拷贝"];
    UIImageView *iconImageV = [[UIImageView alloc]initWithImage:iconImage];
    [iconImageV sizeToFit];
    [blackView addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImage.mas_right).offset(11.5);
        make.top.equalTo(describeTitle.mas_bottom).offset(23);
        
    }];
    
    
    //    UIImageView *tempImage = [[UIImageView alloc]initWithImage:[self makeImageWithView:upImage withSize:CGSizeMake(280, 320)]];
    //    [bigView addSubview:tempImage];
    //
    //    [tempImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(bigView).offset(10);
    //        make.top.equalTo(upImage.mas_bottom).offset(0);
    //        make.bottom.equalTo(bigView).offset(0);
    //        make.width.mas_equalTo(50);
    //    }];
    
    NSString *nameStr = @"分享至";
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.text = nameStr;
    nameTitle.textColor = [UIColor colorWithHexString:@"000000"];
    nameTitle.textAlignment = NSTextAlignmentLeft;
    nameTitle.font = [UIFont systemFontOfSize:13];
    [bigView addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(6.5);
        make.top.equalTo(upImage.mas_bottom).offset(7.5);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(50);
    }];//
    
    UIView *shareBtnView = [[UIView alloc]init];
    //    shareBtnView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [bigView addSubview:shareBtnView];
    [shareBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigView).offset(0);
        make.bottom.equalTo(bigView).offset(0);
        make.height.mas_equalTo(54.5);
        make.width.equalTo(bigView.mas_width).offset(0);
    }];//
    
    
    // 分享按钮。16 17.5
    CGFloat proportionNum = (276 - 30*4)/4;
    NSArray *iconArray = @[@"share_图层-80",@"share_图层-81",@"share_图层-78",@"share_图层-79"];
    for (int i = 0; i < 4; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconBtn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
        //        iconBtn.alpha = 0.5;
        iconBtn.tag = 100 +i;
        //        [iconBtn sizeToFit];
        
        [shareBtnView addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shareBtnView).offset(proportionNum/2.0 + i*(proportionNum +30));
            //            make.bottom.equalTo(shareBtnView).offset(-18.5);
            make.centerY.equalTo(shareBtnView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            
        }];
        
    }
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pushpage_10"]];
    [imageV sizeToFit];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigView.mas_bottom).offset(25.5 *kiphone6);
        make.centerX.equalTo(self).offset(0);
    }];

}
- (void)dismiss:(UITapGestureRecognizer *)tap {
    NSLog(@"123123");
    [UIView animateWithDuration:0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self setAlpha:0];
                         [self setUserInteractionEnabled:NO];
                         
                         //                         CGRect frame = _mainView.frame;
                         //                         frame.origin.y += frame.size.height;
                         //                         [_mainView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _actionWindow.hidden = YES;
                         [self removeFromSuperview];
                         //                         self.isShow = NO;
                     }];
}
- (void)followUser{
    NSLog(@"关注");
    if ([_followBtn.currentTitle isEqualToString:@"关注"]) {
        //        [self followOther:self.simpleInfoModel.uid];
    }
}
- (void)pushOtherView:(UIButton *)sender{
    if (sender.tag == 200) {
        [self dismiss:nil];
        self.backClick(@"otherinfo");
    }else{
        self.backClick(@"private");
    }
    NSLog(@"push push  push");
}
- (void)emptyClick{
    
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
            [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            //            [self showAlertWithMessage:resmsg];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"place_icon"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}



- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (void)shareType:(UIButton *)sender{
    NSArray* imageArray = @[[self makeImageWithView:self.shareImage withSize:CGSizeMake(276, 392.5)]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray //传入要分享的图片
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeImage];
        
        NSInteger index = sender.tag -100;
        switch (index) {
            case 0:
            {
                //进行分享
                [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                 }];
                
                break;
            }
            case 1:
            {
                //进行分享
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                 }];
                
                break;
            }
            case 2:
            {
                //进行分享
                [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                 }];
                
                break;
            }
            case 3:
            {
                //进行分享
                [ShareSDK share:SSDKPlatformSubTypeQZone //传入分享的平台类型
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
                 }];
                
                break;
            }
            default:
                break;
        }
        
    }
}

@end
