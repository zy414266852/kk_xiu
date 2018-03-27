//
//  LIMGameHomeModel.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2018/1/9.
//  Copyright © 2018年 张洋. All rights reserved.
//

#import "LIMGameHomeModel.h"

@implementation LIMGameHomeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}

@end
