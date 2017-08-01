//
//  GoodsEditTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"

@protocol GoodsEditTableViewCellDelegate <NSObject>
@optional
-(void)SelectedGoodsTableViewCellSelected:(BOOL)selected ForIndexPath:(NSIndexPath *)indexPath;
-(void)ManagerGoodsTableViewCellIsEdit:(BOOL)isEdit ForIndexPath:(NSIndexPath *)indexPath;
@end
@interface GoodsEditTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic,strong)UILabel *nameLa,*sales,*timeLa,*numberLa;
@property(nonatomic,strong)UIButton *yuanImg;
@property(nonatomic,strong)UIButton *EditButton;
@property(nonatomic,strong)UIButton *DelButton;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<GoodsEditTableViewCellDelegate>delegate;
@end
