//
//  ShareTableViewCell.h
//  Wedding
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "CenterCell.h"

@protocol ShareTableViewCellDelegate <NSObject>
@optional
-(void)ShareTableViewCellWith:(NSIndexPath *)indexPath;
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index;
-(void)CanZuoTableViewCellWith:(NSIndexPath *)indexPath Selected:(BOOL)selected;
@end
@interface ShareTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImage, *xin;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,assign)NSInteger zanCount;
@property(nonatomic,strong)UILabel *ContentLabel,*chakan;
@property(nonatomic,strong)UIImageView *Logo1Image;
@property(nonatomic,strong)UIImageView *Logo2Image;
@property(nonatomic,strong)UIImageView *Logo3Image;
@property(nonatomic,strong)UILabel *DateLabel;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UIButton *CaoZuoButton;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<ShareTableViewCellDelegate>delegate;

@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,assign)NSInteger imgCount;
@property(nonatomic,strong)NSMutableArray *imgData;

@property(nonatomic,strong)UIImageView *imgvi,*zanvi;
@property(nonatomic,strong)UIButton *ZanButton;

@property(nonatomic,strong)NSMutableArray *zanData;

@end
