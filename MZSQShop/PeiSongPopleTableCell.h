//
//  PeiSongPopleTableCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol PeiSongPopleTableCellDelegate <NSObject>
@optional
-(void)DelegatePresonIndexPath:(NSIndexPath *)indexPath;
@end
@interface PeiSongPopleTableCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *nameLa,*name,*teleLa,*tele;
@property(nonatomic,strong)UIButton *deleLa;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIView *line;
@property(nonatomic,assign)id<PeiSongPopleTableCellDelegate>delegate;
@end
