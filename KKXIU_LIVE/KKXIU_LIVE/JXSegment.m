//
//  JXSegment.m
//  JXChannelSegment
//
//  Created by JackXu on 16/9/16.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "JXSegment.h"
#import "UIColor+Extension.h"

#define lPadding (256*kiphone6 - 173.5)/3.0
#define lFont [UIFont boldSystemFontOfSize:17]
#define lFontSize 17
#define lTextColor_N [UIColor colorWithHexString:@"fefefe"]
#define lTextColor_S kBlackColor_Default
#define lDivideColor_N [UIColor colorWithHexString:@"ffffff"]
#define lDivideColor_S kBlackColor_Default
#define lScrollContentSize CGSizeMake(256*kiphone6,0)

@interface JXSegment(){
    NSArray *widthArray;
    NSInteger _allButtonW;
    UIView *_divideView;
    UIView *_divideLineView;
}
@property (nonatomic, assign) NSInteger count;
@end

@implementation JXSegment

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-0.5)];
        _scrollView.clipsToBounds = YES;
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _divideLineView = [[UIView alloc] init];
        _divideLineView.backgroundColor = [UIColor clearColor];//[UIColor groupTableViewBackgroundColor];
        [_scrollView addSubview:_divideLineView];
        
        _divideView  = [[UIView alloc] init];
        _divideView.backgroundColor = lDivideColor_S;
        [_scrollView addSubview:_divideView];
        
        UIImageView *divideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
        divideImageView.image = [UIImage imageNamed:@"home_schedule_divider"];
        [self addSubview:divideImageView];
        
    }
    
    return self;
}

-(UIFont*)textFont{
    return _textFont?:[UIFont systemFontOfSize:14];
}


- (void)updateChannels:(NSArray*)array{
    for (int i = 0; i<self.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:1000+i];
        [btn removeFromSuperview];
    }
    
    NSMutableArray *widthMutableArray = [NSMutableArray array];
    CGFloat totalW = 0;
    for (int i = 0; i < array.count; i++) {
        
        NSString *string = [array objectAtIndex:i];
        CGFloat buttonW = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lFont} context:nil].size.width;
        [widthMutableArray addObject:@(buttonW)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalW, 0, buttonW,lFontSize +1)];
        button.tag = 1000 + i;
        [button.titleLabel setFont:lFont];
        [button setTitleColor:lTextColor_N forState:UIControlStateNormal];
        [button setTitleColor:lTextColor_S forState:UIControlStateSelected];
        [button setTitle:string forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        totalW = buttonW +totalW +lPadding;
        
        if (i == 0) {
            [button setSelected:YES];
            _divideView.frame = CGRectMake(0, _scrollView.bounds.size.height-2, buttonW, 2);
            _selectedIndex = 0;
        }
        
    }
    _allButtonW = totalW;
//    _scrollView.contentSize = CGSizeMake(totalW,0);
    _scrollView.contentSize = lScrollContentSize;
    widthArray = [widthMutableArray copy];
    _divideLineView.frame = CGRectMake(0, _scrollView.frame.size.height-1, totalW, 2);
    self.count = array.count;
}

- (void)clickSegmentButton:(UIButton*)selectedButton{
    UIButton *oldSelectButton = (UIButton*)[_scrollView viewWithTag:(1000 + _selectedIndex)];
    [oldSelectButton setSelected:NO];
    [selectedButton setSelected:YES];
    _selectedIndex = selectedButton.tag - 1000;
    NSInteger totalW = 0;
    for (int i=0; i<_selectedIndex; i++) {
        totalW += [[widthArray objectAtIndex:i] integerValue];
    }
    //处理边界
    CGFloat selectW = [[widthArray objectAtIndex:_selectedIndex] integerValue];
    CGFloat offset = totalW + (selectW - self.bounds.size.width) *0.5 ;
    offset = MIN(_allButtonW - self.bounds.size.width, MAX(0, offset));
//    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    if ([_delegate respondsToSelector:@selector(JXSegment:didSelectIndex:)]) {
        [_delegate JXSegment:self didSelectIndex:_selectedIndex];
    }
    //滑块
    [UIView animateWithDuration:0.1 animations:^{
        _divideView.frame = CGRectMake(totalW +_selectedIndex *lPadding, _divideView.frame.origin.y, selectW, _divideView.frame.size.height);
    }];
}

- (void)didChengeToIndex:(NSInteger)index{
    UIButton *selectedButton = [_scrollView viewWithTag:(1000 + index)];
    [self clickSegmentButton:selectedButton];
}

@end
