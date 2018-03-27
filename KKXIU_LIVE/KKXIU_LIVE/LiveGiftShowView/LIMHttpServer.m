//
//  LIMHttpServer.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/11/20.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMHttpServer.h"

@implementation LIMHttpServer
+ (LIMHttpServer *)defaultClient{
    static LIMHttpServer *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc]init];
        [userModel configLocalHttpServer];
    });
    return userModel;
}
- (void)askj{
    
}
#pragma mark -- 本地服务器 --
#pragma mark -服务器
#pragma mark - 搭建本地服务器 并且启动
- (void)configLocalHttpServer{
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http.tcp"];
    [_localHttpServer setPort:mLocalPort];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSLog(@"资源文件路径:%@",webPath);
    
    
    if (![fileManager fileExistsAtPath:webPath]){
        NSLog(@"File path error!");
    }else{
        NSString *webLocalPath = webPath;
        [_localHttpServer setDocumentRoot:webLocalPath];
        NSLog(@"服务器路径  :%@",_localHttpServer.documentRoot);
        [self startServer];
    }
}
- (void)startServer
{
    
    NSError *error;
    if([_localHttpServer start:&error]){
        NSLog(@"Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
        //        self.port = [NSString stringWithFormat:@"%d",[_localHttpServer listeningPort]];
    }
    else{
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}
@end
