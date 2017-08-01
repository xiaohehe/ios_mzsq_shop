//
//  BusinessInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "CellView.h"

@interface BusinessInfoViewController : SuperViewController
@property(nonatomic,strong)UIScrollView *topImg;
@property(nonatomic,strong)UIScrollView *bigScroll;
@property(nonatomic,strong)UIView *shopBigVi,*start;
@property(nonatomic,strong)CellView *gongGaoCell,*jieShaoCell,*pingJiaCell;
@property(nonatomic,strong)UILabel *nameLa;
@property(nonatomic,strong)NSString *shop_id;
@property(nonatomic,strong)UILabel *phoneLa;
@end
