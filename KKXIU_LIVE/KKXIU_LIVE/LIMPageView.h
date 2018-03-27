//
//  LIMPageView.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/29.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LIMPageView;

@protocol LIMPageViewDataSource <NSObject>

- (NSInteger)numberOfItemInLIMPageView:(LIMPageView*)pageView;
- (UIView*)pageView:(LIMPageView*)pageView viewAtIndex:(NSInteger)index;

@end

@protocol LIMPageViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end

@interface LIMPageView : UIView
@property(nonatomic,strong) UIScrollView *scrollview;
@property(nonatomic,assign) NSInteger numberOfItems;
@property(nonatomic,assign) BOOL scrollAnimation;
@property(nonatomic,weak) id<LIMPageViewDataSource> datasource;
@property(nonatomic,weak) id<LIMPageViewDelegate> delegate;

- (void)reloadData;
- (void)changeToItemAtIndex:(NSInteger)index;

@end

