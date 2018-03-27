//
//  LIMPersonalModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/25.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMPersonalModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSArray *coverlist;
@property (nonatomic, copy) NSArray *consumelist;

@property (nonatomic, copy) NSString *followcount;
@property (nonatomic, copy) NSString *fanscount;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *personsign;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *cumoney;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *userlevel;
@property (nonatomic, copy) NSString *iscompere;
@property (nonatomic, copy) NSString *authstate;

@property (nonatomic, copy) NSString *isfollow;
@end
