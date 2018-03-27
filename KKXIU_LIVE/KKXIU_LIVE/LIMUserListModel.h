//
//  LIMUserListModel.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/28.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIMUserListModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *personsign;
@property (nonatomic, copy) NSString *iscompere;

//@property (nonatomic, copy) NSString *score;
@end
