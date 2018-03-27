//
//  LIMGiftRecardModel.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMGiftRecardModel.h"

@implementation LIMGiftRecardModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}

@end
