//
//  LIMPushLiveViewController.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMPushLiveModel.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSObjcDelegate <JSExport>
//tianbai对象调用的JavaScript方法，必须声明！！！
- (void)rechargeScore;
- (void)rechargeScore:(NSString *)callString;

@end

@interface LIMPushLiveViewController : UIViewController
@property (nonatomic, strong)NSString *rtmpUrl;

//@property (nonatomic, strong)NSString *turnFront;
@property (nonatomic, strong)NSString *groupID;
@property (nonatomic, assign)BOOL turnFront;
@property (nonatomic, strong)LIMPushLiveModel *livePushModel;

@property (nonatomic, assign)NSInteger gameID;

@end
