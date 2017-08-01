//
//  ServiceAreaTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol ServiceAreaTableViewCellDelegate <NSObject>
@optional
-(void)ServiceAreaTableViewCellSelected:(BOOL)selected IndexPath:(NSIndexPath *)indexPath;
@end
@interface ServiceAreaTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *blineImg;
@property(nonatomic,strong)UILabel *contextLa;
@property(nonatomic,strong)UIButton *rightImg;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)id<ServiceAreaTableViewCellDelegate>delegate;
@end
