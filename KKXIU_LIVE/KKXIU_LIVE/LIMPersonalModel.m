//
//  LIMPersonalModel.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/25.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMPersonalModel.h"

@implementation LIMPersonalModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
@end
