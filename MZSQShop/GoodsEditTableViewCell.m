//
//  GoodsEditTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsEditTableViewCell.h"
@interface GoodsEditTableViewCell()
@property(nonatomic,strong)UIImageView *EditIcon,*DelIcon;
@property(nonatomic,strong)UILabel *EditLabel,*DelLabel;
@end
@implementation GoodsEditTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }

    return self;
}
-(void)newView{
    _yuanImg = [UIButton new];
    [_yuanImg setImage:[UIImage imageNamed:@"choose_01_img"] forState:UIControlStateNormal];
    [_yuanImg setImage:[UIImage imageNamed:@"choose_02_img"] forState:UIControlStateSelected];
    [_yuanImg addTarget:self action:@selector(SelectedEvent:) forControlEvents:UIControlEventTouchUpInside];
    _yuanImg.selected=NO;
    [self addSubview:_yuanImg];
    
    _headImg = [UIImageView new];
    _headImg.contentMode=UIViewContentModeScaleAspectFill;
    _headImg.clipsToBounds = YES;
    [self addSubview:_headImg];
    
    _nameLa = [UILabel new];
    _nameLa.font=DefaultFont(self.scale);
    [self addSubview:_nameLa];
    
    _sales = [UILabel new];
    _sales.font = SmallFont(self.scale);
    _sales.textColor=grayTextColor;
    [self addSubview:_sales];
    
    _timeLa = [UILabel new];
    _timeLa.font=_sales.font;
    _timeLa.textColor=grayTextColor;
    [self addSubview:_timeLa];
    
    _EditButton=[[UIButton alloc]init];
    _EditIcon=[UIImageView new];
    _EditIcon.image=[UIImage imageNamed:@"leibie"];
    [_EditButton addSubview:_EditIcon];
    _EditLabel=[UILabel new];
    _EditLabel.text=@"编辑";
    _EditLabel.font=SmallFont(self.scale);
    [_EditButton addTarget:self action:@selector(EditButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    _EditButton.tag=1;
    [_EditButton addSubview:_EditLabel];
    [self addSubview:_EditButton];
    
    _DelButton=[[UIButton alloc]init];
    _DelIcon=[UIImageView new];
    _DelIcon.image=[UIImage imageNamed:@"delect"];
    [_DelButton addSubview:_DelIcon];
    _DelLabel=[UILabel new];
    _DelLabel.text=@"删除";
    _DelLabel.font=SmallFont(self.scale);
    [_DelButton addSubview:_DelLabel];
    [_DelButton addTarget:self action:@selector(EditButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    _DelButton.tag=2;
    [self addSubview:_DelButton];
    
    _numberLa = [UILabel new];
    _numberLa.font = DefaultFont(self.scale);
    _numberLa.textAlignment=NSTextAlignmentRight;
    _numberLa.textColor=[UIColor redColor];
    [self addSubview:_numberLa];

    _line = [UIView new];
    _line.backgroundColor = blackLineColore;
    [self addSubview:_line];
}
-(void)layoutSubviews{
    _yuanImg.frame = CGRectMake(5*self.scale, self.height/2-18*self.scale, 36*self.scale, 36*self.scale);
    _headImg.frame = CGRectMake(_yuanImg.right+5*self.scale ,10*self.scale, 70*self.scale, 52*self.scale);
    _nameLa.frame = CGRectMake(_headImg.right+10*self.scale, _headImg.top, 100*self.scale, 20*self.scale);
    _sales.frame = CGRectMake(_nameLa.left, _nameLa.bottom+5*self.scale, self.width-_headImg.right-15*self.scale, 15*self.scale);
    _timeLa.frame = CGRectMake(_sales.left, _sales.bottom+5*self.scale, self.width-_headImg.right, 15*self.scale);
    _numberLa.frame = CGRectMake(self.width-100*self.scale, 10*self.scale, 90*self.scale, 20*self.scale);
    _line.frame = CGRectMake(0, self.height-.5, self.width, .5) ;
    _EditButton.frame=CGRectMake(self.width-120*self.scale, _line.top-18*self.scale, 50*self.scale, 16*self.scale);
    _EditIcon.frame=CGRectMake(0, _EditButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _EditLabel.frame=CGRectMake(_EditIcon.right+5*self.scale, _EditIcon.top, _EditButton.width-_EditIcon.right, _EditIcon.height);
    _DelButton.frame=CGRectMake(_EditButton.right+10, _EditButton.top, _EditButton.width, _EditButton.height);
    _DelIcon.frame=CGRectMake(0, _DelButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _DelLabel.frame=CGRectMake(_DelIcon.right+5*self.scale, _DelIcon.top, _DelButton.width-_DelIcon.right, _DelIcon.height);

   // _bigbtn.frame = CGRectMake(_headImg.left, 0, self.contentView.width-_headImg.left, _headImg.bottom);
}
-(void)SelectedEvent:(UIButton *)button{
    button.selected = ! button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(SelectedGoodsTableViewCellSelected:ForIndexPath:)]) {
        [_delegate SelectedGoodsTableViewCellSelected:button.selected ForIndexPath:_indexPath];
    }
}
-(void)EditButtonEvent:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(ManagerGoodsTableViewCellIsEdit:ForIndexPath:)]) {
        [_delegate ManagerGoodsTableViewCellIsEdit:sender.tag==1 ForIndexPath:_indexPath];
    }
}
@end
