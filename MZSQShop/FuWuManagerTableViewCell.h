//
//  FuWuManagerTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol FuWuManagerTableViewCellDelegate <NSObject>
@optional
-(void)ManagerFuWuByIndexPath:(NSIndexPath *)indexPath IsDel:(BOOL)isdel;
@end
@interface FuWuManagerTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UIButton *EditButton;
@property(nonatomic,strong)UIButton *DelButton;
@property(nonatomic,strong)UIImageView *bottomLine;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<FuWuManagerTableViewCellDelegate>delegate;
@end
