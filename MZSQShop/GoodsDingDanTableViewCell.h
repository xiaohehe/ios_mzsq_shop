//
//  GoodsDingDanTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface GoodsDingDanTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *ContentLabel;
@property(nonatomic,strong)UILabel *PriceLabel;
@property(nonatomic,strong)UILabel *NumLabel;
@property(nonatomic,strong)NSIndexPath *inexPath;
@property(nonatomic,strong)UIImageView *bottomLine;

@end
