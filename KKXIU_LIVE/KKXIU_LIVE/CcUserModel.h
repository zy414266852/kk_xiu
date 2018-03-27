//
//  CcUserModel.h
//  KuangWanTV
//
//  Created by 张洋 on 15/12/2.
//  Copyright © 2015年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>

@interface CcUserModel : NSObject


// 通用接口参数
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *phonetype;
@property (nonatomic, strong) NSString *imei;
@property (nonatomic, strong) NSString *jwd;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *os;
@property (nonatomic, strong) NSString *ver;
@property (nonatomic, strong) NSString *encry;

// info
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *avatar;
//@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *authstate;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *personsign;
@property (nonatomic, strong) NSString *star;
@property (nonatomic, strong) NSString *timid;
@property (nonatomic, strong) NSString *timsig;

// 个人
@property (nonatomic, strong) NSString *iscompere;
@property (nonatomic, strong) NSString *userlevel;
@property (nonatomic, strong) NSString *cumoney;
@property (nonatomic, strong) NSString *score;

@property (nonatomic, strong) NSString *noNight;


// 主播美颜
@property (nonatomic, strong) NSString *beautyDepth;
@property (nonatomic, strong) NSString *whiteningDepth;
@property (nonatomic, strong) NSString *eyeScaleLevel;
@property (nonatomic, strong) NSString *faceScaleLevel;




@property (nonatomic, strong) NSString *provider_uid;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *telephoneNum;

@property (nonatomic,strong) NSArray *userCollectionArr;
@property (nonatomic,strong) NSArray *userAttentionArr;
@property (nonatomic,strong) UIImage *imageAfterChoose;

@property (nonatomic,strong) NSArray *gameconflist;




//@property (nonatomic, strong) CLLocation *loation;

+ (CcUserModel *)defaultClient;
- (void)saveAllInfo;
- (void)setUserModelInfo;
- (void)removeUserInfo;

- (NSDictionary *)httpParaDictUnSecret;
//- (NSDictionary *)httpParaDictSecret;
- (NSDictionary *)httpParaDictSecret:(NSDictionary *)para;

@end
