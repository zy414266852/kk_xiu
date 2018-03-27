//
//  LiveGiftShowModel.h
//  LiveSendGift
//
//  Created by Jonhory on 2016/11/11.
//  Copyright © 2016年 com.wujh. All rights reserved.
//  包含用户信息和礼物信息

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LivePrizeListModel.h"
#import "LiveUserModel.h"

@interface LivePrizeShowModel : NSObject

@property (nonatomic ,strong) LivePrizeListModel * giftModel;

@property (nonatomic ,strong) LiveUserModel * user;

@property (nonatomic, assign) NSUInteger currentNumber;/** 当前送礼数量 */


/**
 *  0  = 大奖 -有图片
 *  1  = 大奖 -没有图片
 *  2  = 特大奖 -有图片
 *  3  = 特大奖 -没有图片
*/
@property (nonatomic, assign) NSInteger type;

// 连续动画时使用
@property (nonatomic, assign) NSUInteger toNumber;/** 连续增加的数量 */
@property (nonatomic, assign) CGFloat interval;/** 连续增加时动画间隔 */
@property (nonatomic, strong) dispatch_source_t animatedTimer;

+ (instancetype)giftModel:(LivePrizeListModel *)giftModel userModel:(LiveUserModel *)userModel;

@end
