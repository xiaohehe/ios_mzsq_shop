//
//  FenLeiTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FenLeiTableViewCell.h"
@interface FenLeiTableViewCell()
@property(nonatomic,strong)UIImageView *EditIcon,*DelIcon;
@property(nonatomic,strong)UILabel *EditLabel,*DelLabel;
@end
@implementation FenLeiTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    [self addSubview:_NameLabel];
    
    _NumberLabel=[[UILabel alloc]init];
    _NumberLabel.font=DefaultFont(self.scale);
    [self addSubview:_NumberLabel];
    
    _AddIcon=[[UIImageView alloc]init];
    _AddIcon.image=[UIImage imageNamed:@"jia"];
    [self addSubview:_AddIcon];
    
    _RigthImage=[[UIImageView alloc]init];
    _RigthImage.image=[UIImage imageNamed:@"xq_right"];
    [self addSubview:_RigthImage];
    
    _topLine=[[UIImageView alloc]init];
    _topLine.backgroundColor=blackLineColore;
    [self addSubview:_topLine];
    _middleLine=[[UIImageView alloc]init];
    _middleLine.backgroundColor=blackLineColore;
    [self addSubview:_middleLine];
    _bottomLine=[[UIImageView alloc]init];
    _bottomLine.backgroundColor=blackLineColore;
    [self addSubview:_bottomLine];
    
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
}
-(void)layoutSubviews{
    _topLine.frame=CGRectMake(0, 0, self.width, .5);
    _NameLabel.frame=CGRectMake(10*self.scale, 1*self.scale, self.width/2-40*self.scale, 43*self.scale);
    _AddIcon.frame=CGRectMake(_NameLabel.right+10, _NameLabel.centerY-8*self.scale, 16*self.scale, 16*self.scale);
    _NumberLabel.frame=CGRectMake(_AddIcon.right+5*self.scale, _NameLabel.top, self.width-_AddIcon.right-30*self.scale, _NameLabel.height) ;

    _middleLine.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, self.width-20*self.scale, .5);
    
    _RigthImage.frame=CGRectMake(self.width-30*self.scale, _NameLabel.centerY-12*self.scale, 24*self.scale, 24*self.scale);
    
    _EditButton.frame=CGRectMake(self.width-120*self.scale, _middleLine.bottom, 50*self.scale, 29*self.scale);
    _EditIcon.frame=CGRectMake(0, _EditButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _EditLabel.frame=CGRectMake(_EditIcon.right+5*self.scale, _EditIcon.top, _EditButton.width-_EditIcon.right, _EditIcon.height);
    
    _DelButton.frame=CGRectMake(_EditButton.right+10, _EditButton.top, _EditButton.width, _EditButton.height);
    _DelIcon.frame=CGRectMake(0, _DelButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _DelLabel.frame=CGRectMake(_DelIcon.right+5*self.scale, _DelIcon.top, _DelButton.width-_DelIcon.right, _DelIcon.height);
    _bottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
-(void)EditButtonEvent:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(ManagerFenLeiByIndexPath:IsDel:)]) {
        [_delegate ManagerFenLeiByIndexPath:_indexPath IsDel:sender.tag==2];
    }
}
@end
