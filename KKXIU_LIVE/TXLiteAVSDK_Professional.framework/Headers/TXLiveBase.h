#import "TXLiveSDKTypeDef.h"

@protocol TXLiveBaseDelegate <NSObject>

/**
 *  SDK内部不再负责log的输出，而是通过这个函数将全部log回调给SDK使用者，由SDK使用者来决定log如何处理
 *	使用方式，具体可参看Demo中实现：
 *	1.实现TXLiveBaseDelegate，建议在一个比较早的初始化类中如AppDelegate
 *  2.在初始化中设置此回调，eg：[TXLiveBase sharedInstance].delegate = self;
 **/
@optional
-(void) onLog:(NSString*)log LogLevel:(int)level WhichModule:(NSString*)module;

@end

@interface TXLiveBase : NSObject

/*
 * 该接口已弃用，若需要启用/禁用控制台打印，请调用setConsoleEnabled方法
 */
@property (nonatomic, weak) id<TXLiveBaseDelegate> delegate;

+ (instancetype) sharedInstance;

/* setLogLevel 设置log输出级别
 *  level：参见 LOGLEVEL
 *
 */
+ (void) setLogLevel:(TX_Enum_Type_LogLevel)level;

/*
 * setConsoleEnabled 启用或禁用控制台日志打印
 *  enabled：指定是否启用
 */
+ (void) setConsoleEnabled:(BOOL)enabled;


+ (void) setAppVersion:(NSString *)verNum;
    
/**
* 获取SDK版本信息.
* 返回SDK版本信息字符串.
*/
+ (NSString *)getSDKVersionStr;
    
    @end
