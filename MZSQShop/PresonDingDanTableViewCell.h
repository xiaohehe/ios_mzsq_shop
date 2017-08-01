//
//  PresonDingDanTableViewCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol PresonDingDanTableViewCellDelegate <NSObject>
@optional
-(void)FindPresonSendMsg:(NSIndexPath *)indexPath;
@end
@interface PresonDingDanTableViewCell : SuperTableViewCell
@property(nonatomic,strong)UIImageView *HeaderImg;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UIButton *MsgButton;
@property(nonatomic,strong)UIImageView *RigthImg;
@property(nonatomic,strong)UILabel *SHRLabel;
@property(nonatomic,strong)UILabel *ADLabel;
@property(nonatomic,strong)UILabel *TimeLabel;
@property(nonatomic,strong)UILabel *MarkLabel;
@property(nonatomic,strong)NSIndexPath *inexPath;
@property(nonatomic,strong)UIImageView *bottomLine;
@property(nonatomic,assign)id<PresonDingDanTableViewCellDelegate>delegate;
@end
