
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HTTPServer.h"
#import "LIMHttpServer.h"
@interface YYTabBarController : UITabBarController<UIApplicationDelegate>
//@property (nonatomic,strong) HTTPServer *localHttpServer;
@property (nonatomic,strong) LIMHttpServer *myServer;

//
////切换滑块位置
//- (void)selectTabbarIndex:(NSInteger)index;
//
//- (void)createViewAboveTabbarView;
////移除消息
//- (void)removeAllNotiMsg;

@end
