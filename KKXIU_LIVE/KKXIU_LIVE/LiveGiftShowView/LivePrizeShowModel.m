//
//  LiveGiftShowModel.m
//  LiveSendGift
//
//  Created by Jonhory on 2016/11/11.
//  Copyright © 2016年 com.wujh. All rights reserved.
//

#import "LivePrizeShowModel.h"

@implementation LivePrizeShowModel

+ (instancetype)giftModel:(LivePrizeListModel *)giftModel userModel:(LiveUserModel *)userModel{
    LivePrizeShowModel * model = [[LivePrizeShowModel alloc]init];
    model.giftModel = giftModel;
    model.user = userModel;
    model.interval = 0.35;
    model.toNumber = 1;
    return model;
}


@end
