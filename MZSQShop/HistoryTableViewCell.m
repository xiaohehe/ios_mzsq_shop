//
//  HistoryTableViewCell.m
//  AdultStore
//
//  Created by apple on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "HistoryTableViewCell.h"
@interface HistoryTableViewCell()
@property(nonatomic,strong)UIImageView *blineImg;
@property(nonatomic,strong)UIImageView *contImg;
@end
@implementation HistoryTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
        _NameLabel=[[UILabel alloc]init];
        _NameLabel.font=DefaultFont(self.scale);
        _NameLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_NameLabel];
        
        _StateLabel=[[UILabel alloc]init];
        _StateLabel.font=_NameLabel.font;
        _StateLabel.backgroundColor=_NameLabel.backgroundColor;
        _StateLabel.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_StateLabel];
        
        _TimeLabel=[[UILabel alloc]init];
        _TimeLabel.font=_NameLabel.font;
         _TimeLabel.textAlignment=NSTextAlignmentRight;
        _TimeLabel.backgroundColor=_NameLabel.backgroundColor;
        [self.contentView addSubview:_TimeLabel];
        
        _blineImg=[[UIImageView alloc]init];
        _blineImg.backgroundColor=blackLineColore;
        [self.contentView addSubview:_blineImg];
        
        _topline=[[UIImageView alloc]init];
        _topline.backgroundColor=blackLineColore;
        [self.contentView addSubview:_topline];
    }
    return self;
}
-(void)layoutSubviews{
    float W = (self.width-40*self.scale)/3;
    _NameLabel.frame=CGRectMake(10*self.scale, 0, W, self.height);
    _StateLabel.frame=CGRectMake(_NameLabel.right+10*self.scale, _NameLabel.top, W, _NameLabel.height);
    _TimeLabel.frame=CGRectMake(_StateLabel.right+10*self.scale, _StateLabel.top, _StateLabel.width, _StateLabel.height);
    _blineImg.frame=CGRectMake(0, self.height-.5, self.width, .5);
    _topline.frame=CGRectMake(0, 0, self.width, .5);
}
@end
