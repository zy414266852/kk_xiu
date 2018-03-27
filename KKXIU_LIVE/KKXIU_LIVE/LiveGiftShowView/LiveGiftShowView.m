//
//  LiveGiftShowView.m
//  LiveSendGift
//
//  Created by Jonhory on 2016/11/11.
//  Copyright © 2016年 com.wujh. All rights reserved.
//

#import "LiveGiftShowView.h"
#import "LiveGiftListModel.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

static CGFloat const kNameLabelFont = 12.0;//送礼者
#define kNameLabelTextColor [UIColor whiteColor]//送礼者颜色

static CGFloat const kGiftLabelFont = 10.0;//送出礼物寄语  字体大小
#define kGiftLabelTextColor [UIColor orangeColor]//礼物寄语 字体颜色

static CGFloat const kGiftNumberWidth = 15.0;

@interface LiveGiftShowView ()

@property (nonatomic ,weak) UIImageView * backIV;/**< 背景图 */
@property (nonatomic ,weak) UIImageView * iconIV;/**< 头像 */
@property (nonatomic ,weak) UILabel * nameLabel;/**< 名称 */
@property (nonatomic ,weak) UILabel * sendLabel;/**< 送出 */
@property (nonatomic ,weak) UIImageView * giftIV;/**< 礼物图片 */

@property (nonatomic ,strong) NSTimer * liveTimer;/**< 定时器控制自身移除 */
@property (nonatomic ,assign) NSInteger liveTimerForSecond;

@property (nonatomic ,assign) BOOL isSetNumber;

@end

@implementation LiveGiftShowView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kViewWidth, kViewHeight)];
    if (self) {
        self.liveTimerForSecond = 0;
        [self setupContentContraints];
        self.creatDate = [NSDate date];
        self.kTimeOut = 3;
        self.kRemoveAnimationTime = 0.5;
        self.kNumberAnimationTime = 0.25;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.liveTimerForSecond = 0;
        [self setupContentContraints];
    }
    return self;
}

- (void)setModel:(LiveGiftShowModel *)model{
    if (!model) {
        return;
    }
    _model = model;
    
    self.nameLabel.text = model.user.name;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.user.iconUrl] placeholderImage:[UIImage imageNamed:@"LiveDefaultIcon"]];
    
    self.sendLabel.text = model.giftModel.rewardMsg;
    
    
    NSArray *photoNameArr = @[@""
                              ,@"cucumber_000",@"drink_000",@"romantic",@"gift_car_000",@"microphone_000",@"fedemon",@"kiss_000"
                              ,@"棒棒糖",@"girl_light_000",@"praise_000",@"restrict_000",@"cake",@"hand_000",@"ring_000",@"boat"
                              ,@"cannon",@"animrose_000",@"motor_000",@"diamond_000",@"packet_000",@"plane_000",@"castle",@"starry"
                              ,@"啤酒",@"brick_000",@"island_",@"heart_000",@"fileworks_000",@"Cupid_000",@"goldcoin_000",@"gold_bri_000"
                              ,@"feichuang"];
    NSArray *photoNumArr = @[@""
                             ,@"4",@"10",@"",@"56",@"16",@"12",@"16"
                             ,@"1",@"",@"2",@"5",@"",@"8",@"14",@""
                             ,@"",@"40",@"51",@"38",@"13",@"",@"",@""
                             ,@"1",@"32",@"",@"3",@"100",@"40",@"17",@"23"
                             ,@""
                             ];

    NSLog(@"______________________________%@",model.giftModel.type );
    if([model.giftModel.type isEqualToString:@"1"]
       ||[model.giftModel.type isEqualToString:@"2"]
       ||[model.giftModel.type isEqualToString:@"5"]
       ||[model.giftModel.type isEqualToString:@"7"]
       ||[model.giftModel.type isEqualToString:@"10"]
       ||[model.giftModel.type isEqualToString:@"11"]
       ||[model.giftModel.type isEqualToString:@"13"]
       ||[model.giftModel.type isEqualToString:@"20"]
       ||[model.giftModel.type isEqualToString:@"27"]
       ||[model.giftModel.type isEqualToString:@"30"]){
        
        
        CGFloat imageW = kScreenW;
        CGFloat imageH = kScreenH;
        CGFloat time = 0.3;
        CGFloat count = 1;
        CGFloat addRepeat = 1;
        CGFloat addImageCount = 0;
        if ([model.giftModel.type isEqualToString:@"1"]){   // 黄瓜
            imageW = kScreenW;
            imageH = 350 *kiphone6;
            addRepeat = 2;
            addImageCount = 15;
            count = 1000;
            time = 0.24 + 0.24 +0.9;

        }else if ([model.giftModel.type isEqualToString:@"2"]){ // 红酒
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            addImageCount = 15;
            count = 1000;
            time = 0.6 +0.9;
        }
        else if ([model.giftModel.type isEqualToString:@"5"]){ // 金话筒
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 1000;
            time = 16*0.06;
        }
        else if ([model.giftModel.type isEqualToString:@"7"]){ // 吻
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 1000;
            addImageCount = 15;
            time = 16*0.06 + 0.9;
        }
        else if ([model.giftModel.type isEqualToString:@"10"]){ // 赞
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 10000;
            time = 2*0.1;
        }
        else if ([model.giftModel.type isEqualToString:@"11"]){ // 约
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            addImageCount = 15;
            count = 1000;
            time = 5*0.06 +0.3;
        }
        else if ([model.giftModel.type isEqualToString:@"13"]){ // 鼓掌
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 10000;
            time = 8*0.06;
            
            [self.giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.nameLabel.mas_right).offset(5).priority(750);
                make.width.equalTo(@35.2);
                make.height.equalTo(@35.2);
            }];
        }
        else if ([model.giftModel.type isEqualToString:@"20"]){ // 红包
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 1000;
            addImageCount = 15;
            time = 13*0.06 + 0.9;
            
            [self.giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.nameLabel.mas_right).offset(5).priority(750);
                make.width.equalTo(@50);
                make.height.equalTo(@50);
            }];

        }
        else if ([model.giftModel.type isEqualToString:@"27"]){ // 心跳
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 10000;
            time = 25*0.04;
        }
        else if ([model.giftModel.type isEqualToString:@"30"]){ // 金币
            imageW = 250 *kiphone6;
            imageH = 270 *kiphone6;
            count = 10000;
            time = 17*0.06;
            
            
            
            UIImageView * iv_bg = [[UIImageView alloc]init];
            iv_bg.image = [UIImage imageNamed:@"goldcoin_图层-1"];
            [self addSubview:iv_bg];
            //            [self sendSubviewToBack:iv_bg];
            [iv_bg mas_makeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.nameLabel.mas_right).offset(5).priority(750);
                make.right.equalTo(self.mas_right).offset(-kGiftNumberWidth);
                make.width.equalTo(@44).priority(750);
                make.height.equalTo(@44).priority(750);
                make.centerY.equalTo(self);
            }];
            
            UIImageView * iv = [[UIImageView alloc]init];
            iv.image = [UIImage imageNamed:@"goldcoin_图层-0"];
            [self addSubview:iv];
//            [self sendSubviewToBack:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                //        make.left.equalTo(self.nameLabel.mas_right).offset(5).priority(750);
                make.right.equalTo(self.mas_right).offset(-kGiftNumberWidth);
                make.width.equalTo(@44).priority(750);
                make.height.equalTo(@44).priority(750);
                make.centerY.equalTo(self);
            }];
            
            [self bringSubviewToFront:self.giftIV];
            
            
     
            //旋转动画
            CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            anima3.toValue = [NSNumber numberWithFloat:M_PI*2000];
            //组动画
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            groupAnimation.animations = [NSArray arrayWithObjects:anima3, nil];
            groupAnimation.duration = 3000.0f;
            [iv_bg.layer addAnimation:groupAnimation forKey:@"groupAnimation"];

        }

        
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        
        NSLog(@"%@",model.giftModel.type);
        
        if ([model.giftModel.type isEqualToString:@"27"]) {
            NSString *imageName1 = [NSString stringWithFormat:@"heart_00000"];
            UIImage *image1 = [UIImage imageNamed:imageName1];
            
            NSString *imageName2 = [NSString stringWithFormat:@"heart_00001"];
            UIImage *image2 = [UIImage imageNamed:imageName2];
            
            NSString *imageName3 = [NSString stringWithFormat:@"heartBG"];
            UIImage *image3 = [UIImage imageNamed:imageName3];
            
            NSString *imageName4 = [NSString stringWithFormat:@"heart_00002"];
            UIImage *image4 = [UIImage imageNamed:imageName4];

            
            CGSize size = CGSizeMake(44, 44);
        
            UIGraphicsBeginImageContext(size);
            
            [image3 drawInRect:CGRectMake(0, 0, size.width, size.height)];
            
            [image2 drawInRect:CGRectMake(0, 0, size.width , size.height)];
            
            UIImage *image5 =UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            [imageArray addObject:image1];
            [imageArray addObject:image2];
            [imageArray addObject:image5];
            [imageArray addObject:image5];
            [imageArray addObject:image2];
            [imageArray addObject:image4];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            
            [imageArray addObject:image1];
            [imageArray addObject:image2];
            [imageArray addObject:image5];
            [imageArray addObject:image5];
            [imageArray addObject:image2];
            [imageArray addObject:image4];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            
            

            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            [imageArray addObject:image1];
            
            

        }else{
        for (int i = 0; i <addRepeat; i++) {
        for (int i = 0; i < [photoNumArr[[model.giftModel.type integerValue]] integerValue]; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d.png", photoNameArr[[model.giftModel.type integerValue]],i];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageArray addObject:image];
        }
        }
        }
        for (int i = 0; i<addImageCount; i++) {
            int num = [photoNumArr[[model.giftModel.type intValue]] intValue] -1;
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%02d.png", photoNameArr[[model.giftModel.type integerValue]],num]]];
        }
        self.giftIV.animationImages = imageArray;// 序列帧动画的uiimage数组
        self.giftIV.animationDuration = time;// 序列帧全部播放完所用时间
        self.giftIV.animationRepeatCount = count;// 序列帧动画重复次数
        [self.giftIV startAnimating];//开始动画
        int num = [photoNumArr[[model.giftModel.type intValue]] intValue] -1;
        self.giftIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%02d.png", photoNameArr[[model.giftModel.type integerValue]],num]];
    }else{
        [self.giftIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.giftModel.picUrl]] placeholderImage:nil];
    }
    
}

/**
 重置定时器和计数
 
 @param number 计数
 */
- (void)resetTimeAndNumberFrom:(NSInteger)number{
    self.numberView.number = number;
    [self addGiftNumberFrom:number];
}

/**
 获取用户名

 @return 获取用户名
 */
- (NSString *)getUserName{
    return self.nameLabel.text;
}

/**
 礼物数量自增1使用该方法

 @param number 从多少开始计数
 */
- (void)addGiftNumberFrom:(NSInteger)number{
    if (!self.isSetNumber) {
        self.numberView.number = number;
        self.isSetNumber = YES;
    }
    //每调用一次self.numberView.number get方法 自增1
    NSInteger num = self.numberView.number;
    [self.numberView changeNumber:num];
    [self handleNumber:num];
    self.model.currentNumber = num;
    self.creatDate = [NSDate date];
}


/**
 设置任意数字时使用该方法

 @param number 任意数字 >9999 则显示9999
 */
- (void)changeGiftNumber:(NSInteger)number{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.numberView changeNumber:number];
        [self handleNumber:number];
    });
}

#pragma mark - Private
/**
 处理显示数字 开启定时器

 @param number 显示数字的值
 */
- (void)handleNumber:(NSInteger )number{
    self.liveTimerForSecond = 0;
    //根据数字修改self.giftIV的约束 比如 1 占 10 的宽度，10 占 20的宽度
    NSString * numStr = [NSString stringWithFormat:@"%zi",number];
    CGFloat giftRight = numStr.length * kGiftNumberWidth + kGiftNumberWidth;
    
//    [self.giftIV mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-kGiftNumberWidth - giftRight);
//    }];
    
//    if (numStr.length >= 4) {
//        [self.giftIV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-kGiftNumberWidth * 6);
//        }];
//    }
    
    
    if (!CGAffineTransformIsIdentity(self.numberView.transform)) {
        [self.numberView.layer removeAllAnimations];
    }
    self.numberView.transform = CGAffineTransformIdentity;
//    self.numberView.backgroundColor = [UIColor redColor];
    
    [UIView animateWithDuration:self.kNumberAnimationTime animations:^{
        self.numberView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        if (finished) {
            self.numberView.transform = CGAffineTransformIdentity;
        }
    }];
    

    
    [self.liveTimer setFireDate:[NSDate date]];
}

- (void)liveTimerRunning{
    self.liveTimerForSecond += 1;
    if (self.liveTimerForSecond > self.kTimeOut) {
        if (self.isAnimation == YES) {
            self.isAnimation = NO;
            return;
        }
        self.isAnimation = YES;
        self.isLeavingAnimation = YES;
        CGFloat xChanged = [UIScreen mainScreen].bounds.size.width;
        
        switch (self.hiddenModel) {
            case LiveGiftHiddenModeLeft:
                xChanged = -xChanged;
                break;
            default:
                break;
        }
        if (self.hiddenModel == LiveGiftHiddenModeNone) {
            self.isLeavingAnimation = NO;
            if (self.liveGiftShowViewTimeOut) {
                self.liveGiftShowViewTimeOut(self);
            }
            [self removeFromSuperview];
        } else {
            [UIView animateWithDuration:self.kRemoveAnimationTime delay:self.kNumberAnimationTime options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.transform = CGAffineTransformTranslate(self.transform, xChanged, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isLeavingAnimation = NO;
                    if (self.liveGiftShowViewTimeOut) {
                        self.liveGiftShowViewTimeOut(self);
                    }
                    [self removeFromSuperview];
                }
            }];
        }
        
        [self stopTimer];
    }
    
}


- (void)setupContentContraints{
    [self.backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@6);
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(9);
        make.left.equalTo(self.iconIV.mas_right).offset(6);
        make.width.equalTo(@86);
    }];
    
    [self.sendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-9);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.giftIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel.mas_right).offset(5).priority(750);
        make.right.equalTo(self.mas_right).offset(-kGiftNumberWidth);
        make.width.equalTo(@44).priority(750);
        make.height.equalTo(@44).priority(750);
        make.centerY.equalTo(self);
    }];
    
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(5).priority(750);
        make.centerY.height.equalTo(self);
    }];
}

- (UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [self creatIV];
        _backIV.image = [UIImage imageNamed:@"w_liveGiftBack"];
    }
    return _backIV;
}

- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [self creatIV];
        _iconIV.image = [UIImage imageNamed:@"LiveDefaultIcon"];
        _iconIV.layer.cornerRadius = 15;
        _iconIV.layer.masksToBounds = YES;
    }
    return _iconIV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [self creatLabel];
        _nameLabel.textColor = kNameLabelTextColor;
        _nameLabel.font = [UIFont systemFontOfSize:kNameLabelFont];
    }
    return _nameLabel;
}

- (UILabel *)sendLabel{
    if (!_sendLabel) {
        _sendLabel = [self creatLabel];
        _sendLabel.font = [UIFont systemFontOfSize:kGiftLabelFont];
        _sendLabel.textColor = kGiftLabelTextColor;
    }
    return _sendLabel;
}


- (UIImageView *)giftIV{
    if (!_giftIV) {
        _giftIV = [self creatIV];
    }
    return _giftIV;
}

- (LiveGiftShowNumberView *)numberView{
    if (!_numberView) {
        LiveGiftShowNumberView * nv = [[LiveGiftShowNumberView alloc]init];
        [self addSubview:nv];
        _numberView = nv;
    }
    return _numberView;
}

- (UIImageView *)creatIV{
    UIImageView * iv = [[UIImageView alloc]init];
    [self addSubview:iv];
    return iv;
}

- (UILabel * )creatLabel{
    UILabel * label = [[UILabel alloc]init];
    [self addSubview:label];
    return label;
}


- (NSTimer *)liveTimer{
    if (!_liveTimer) {
        _liveTimer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(liveTimerRunning) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_liveTimer forMode:NSRunLoopCommonModes];
    }
    return _liveTimer;
}

- (void)stopTimer{
    if (_liveTimer) {
        [_liveTimer invalidate];
        _liveTimer = nil;
    }
}

@end
