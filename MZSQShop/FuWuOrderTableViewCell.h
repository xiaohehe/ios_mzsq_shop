//
//  FuWuOrderTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
#import "FUWUCell.h"
@protocol FuWuOrderTableViewCellDelegate <NSObject>
@optional
-(void)FindFuWuOrderPresonSendMsg:(NSIndexPath *)indexPath;
@end
@interface FuWuOrderTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UIButton *MsgButton;
@property(nonatomic,strong)UIImageView *RigthImg;
@property(nonatomic,strong)UIImageView *middleLine;
@property(nonatomic,strong)FUWUCell *SHRLabel;
@property(nonatomic,strong)FUWUCell *TelLabel;
@property(nonatomic,strong)FUWUCell *ADLabel;
@property(nonatomic,strong)FUWUCell *FuWuItemLabel;
@property(nonatomic,strong)FUWUCell *TimeLabel;
@property(nonatomic,strong)FUWUCell *MarkLabel;
@property(nonatomic,strong)NSString *Items;
@property(nonatomic,strong)NSIndexPath *inexPath;
@property(nonatomic,strong)UIImageView *bottomLine;
@property(nonatomic,assign)id<FuWuOrderTableViewCellDelegate>delegate;
@end
