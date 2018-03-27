#ifndef TXUGCRecordTypeDef_H
#define TXUGCRecordTypeDef_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 * CameraRecord 录制视频质量类型
 */
typedef NS_ENUM(NSInteger, TXVideoQuality)
{
    VIDEO_QUALITY_LOW                               = 0,            //resolution  360×640     fps 20   bitrate 600
    VIDEO_QUALITY_MEDIUM                            = 1,            //resolution  540×960     fps 20   bitrate 1200
    VIDEO_QUALITY_HIGH                              = 2,            //resolution  720×1280    fps 20   bitrate 2400
};

/*
 * CameraRecord 录制分辨率类型定义
 */
typedef NS_ENUM(NSInteger, TXVideoResolution)
{
    VIDEO_RESOLUTION_360_640                  = 0,
    VIDEO_RESOLUTION_540_960                  = 1,
    VIDEO_RESOLUTION_720_1280                 = 2,
};

/*
 * 横竖屏录制类型定义
 */
typedef NS_ENUM(NSInteger, TXVideoHomeOrientation) {
    VIDOE_HOME_ORIENTATION_RIGHT  = 0,        // home在右边横屏录制
    VIDEO_HOME_ORIENTATION_DOWN,              // home在下面竖屏录制
    VIDEO_HOME_ORIENTATION_LEFT,              // home在左边横屏录制
    VIDOE_HOME_ORIENTATION_UP,                // home在上面竖屏录制
};

/*
 * 录制参数定义
 */

@interface TXUGCSimpleConfig : NSObject
@property (nonatomic, assign) TXVideoQuality        videoQuality;        //录制视频质量
@property (nonatomic, retain) UIImage *             watermark;           //设置水印图片. 设为nil等同于关闭水印
@property (nonatomic, assign) CGPoint               watermarkPos;        //设置水印图片位置
@property (nonatomic, assign) BOOL                  frontCamera;         //是否是前置摄像头
@end

@interface TXUGCCustomConfig : NSObject
@property (nonatomic, assign) TXVideoResolution     videoResolution;     //自定义分辨率
@property (nonatomic, assign) int                   videoFPS;            //自定义fps   15~30
@property (nonatomic, assign) int                   videoBitratePIN;     //自定义码率   600~2400
@property (nonatomic, retain) UIImage *             watermark;           //设置水印图片. 设为nil等同于关闭水印
@property (nonatomic, assign) CGPoint               watermarkPos;        //设置水印图片位置
@property (nonatomic, assign) BOOL                  frontCamera;         //是否是前置摄像头
@end


/*
 * 录制结果错误码定义
 */
typedef NS_ENUM(NSInteger, TXUGCRecordResultCode)
{
    UGC_RECORD_RESULT_OK                                = 0,    //录制成功（业务层主动结束录制）
    UGC_RECORD_RESULT_OK_INTERRUPT                      = 1,    //录制成功（sdk自动结束录制）
    UGC_RECORD_RESULT_FAILED                            = 1001, //录制失败
};


/*
 * 录制结果
 */
@interface TXUGCRecordResult : NSObject
@property (nonatomic, assign) TXUGCRecordResultCode retCode;        //错误码
@property (nonatomic, strong) NSString*             descMsg;        //错误描述信息
@property (nonatomic, strong) NSString*             videoPath;      //视频文件path
@property (nonatomic, strong) UIImage*              coverImage;     //视频封面
@end

#endif
