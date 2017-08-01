//
//  FenLeiTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol FenLeiTableViewCellDelegate <NSObject>
@optional
-(void)ManagerFenLeiByIndexPath:(NSIndexPath *)indexPath IsDel:(BOOL)isdel;
@end
@interface FenLeiTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *NumberLabel;
@property(nonatomic,strong)UIButton *EditButton;
@property(nonatomic,strong)UIButton *DelButton;
@property(nonatomic,strong)UIImageView *AddIcon;
@property(nonatomic,strong)UIImageView *RigthImage;
@property(nonatomic,strong)UIImageView *topLine;
@property(nonatomic,strong)UIImageView *middleLine;
@property(nonatomic,strong)UIImageView *bottomLine;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<FenLeiTableViewCellDelegate>delegate;
@end
