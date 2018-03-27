//
//  LIMHotTableViewCell.h
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/10.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIMLiveListModel.h"
@interface LIMHotTableViewCell : UITableViewCell
- (void)setDataSource:(LIMLiveListModel *)liveModel;
@end
