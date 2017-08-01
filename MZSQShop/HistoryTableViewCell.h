//
//  HistoryTableViewCell.h
//  AdultStore
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperTableViewCell.h"
@interface HistoryTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *topline;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *StateLabel;
@property(nonatomic,strong)UILabel *TimeLabel;
@end
