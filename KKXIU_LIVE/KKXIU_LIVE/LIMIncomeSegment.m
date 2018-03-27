//
//  LIMIncomeSegment.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMIncomeSegment.h"
#import "UIColor+Extension.h"

#define lPadding (kScreenW - 130)/2.0
#define lFont [UIFont systemFontOfSize:15]
#define lFontSize 15
#define lTextColor_N [UIColor colorWithHexString:@"bebebe"]
#define lTextColor_S [UIColor colorWithHexString:@"000000"]
//#define lDivideColor_N [UIColor colorWithHexString:@"ffffff"]
#define lDivideColor_S [UIColor colorWithHexString:@"000000"]

#define lScrollContentSize CGSizeMake(256*kiphone6,0)

@interface LIMIncomeSegment()
{
    NSArray *widthArray;
    NSInteger _allButtonW;
    UIView *_divideView;
    UIView *_divideLineView;
}
@property (nonatomic, assign) NSInteger count;

@end

@implementation LIMIncomeSegment
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-0.5)];
        _scrollView.clipsToBounds = YES;
        //        _scrollView.backgroundColor = [UIColor colorWithHexString:@"ffcb00"];
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
        if (i == 2) {
            button.frame = CGRectMake(totalW -7, 0, buttonW,lFontSize +1);
        }
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
    //    [widthMutableArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%ld", [widthMutableArray[2] integerValue] -7]];
    widthArray = [widthMutableArray copy];
    
    //    widthArray // = [NSString stringWithFormat:@"%ld", [widthArray[2] integerValue] -7];
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
    if ([_delegate respondsToSelector:@selector(LIMSegment:didSelectIndex:)]) {
        [_delegate LIMSegment:self didSelectIndex:_selectedIndex];
    }
    
    //滑块
    [UIView animateWithDuration:0.1 animations:^{
        if (_selectedIndex == 2) {
            _divideView.frame = CGRectMake(totalW +_selectedIndex *lPadding -7, _divideView.frame.origin.y, selectW, _divideView.frame.size.height);
        }else{
            _divideView.frame = CGRectMake(totalW +_selectedIndex *lPadding, _divideView.frame.origin.y, selectW, _divideView.frame.size.height);
        }
    }];
    
}

- (void)didChengeToIndex:(NSInteger)index{
    
    UIButton *selectedButton = [_scrollView viewWithTag:(1000 + index)];
    [self clickSegmentButton:selectedButton];
    
}
@end

