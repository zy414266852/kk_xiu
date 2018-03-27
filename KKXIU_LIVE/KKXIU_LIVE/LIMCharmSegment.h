//
//  LIMCharmSegment.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/30.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LIMSegment;

@protocol LIMSegmentDelegate <NSObject>

- (void)LIMSegment:(LIMSegment*)segment didSelectIndex:(NSInteger)index;

@end

@interface LIMCharmSegment : UIControl
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,weak) id<LIMSegmentDelegate> delegate;

- (void)updateChannels:(NSArray*)array;
- (void)didChengeToIndex:(NSInteger)index;


@end
