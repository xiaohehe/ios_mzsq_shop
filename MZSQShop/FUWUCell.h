//
//  FUWUCell.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUWUCell : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *RightImg;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL shotLine;
@property(nonatomic,strong)UIImageView *topline;
@property(nonatomic,strong)UIImageView *bottomline;
-(void)ShowRight:(BOOL)show;
-(void)setHiddenLine:(BOOL)hidden;
@end
