//
//  LIMHttpServer.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/20.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"

@interface LIMHttpServer : NSObject
@property (nonatomic,strong) HTTPServer *localHttpServer;

+ (LIMHttpServer *)defaultClient;

- (void)configLocalHttpServer;

@end
