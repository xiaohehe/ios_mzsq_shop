//
//  FuWuManagerTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuManagerTableViewCell.h"
@interface FuWuManagerTableViewCell()
@property(nonatomic,strong)UIImageView *EditIcon,*DelIcon;
@property(nonatomic,strong)UILabel *EditLabel,*DelLabel;
@end
@implementation FuWuManagerTableViewCell
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
    _EditButton.hidden=YES;
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
    _NameLabel.frame=CGRectMake(10*self.scale, self.height/2-15*self.scale, self.width/2, 30*self.scale);
    _EditButton.frame=CGRectMake(self.width-120*self.scale, self.height/2-14*self.scale, 50*self.scale, 28*self.scale);
    _EditIcon.frame=CGRectMake(0, _EditButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _EditLabel.frame=CGRectMake(_EditIcon.right+5*self.scale, _EditIcon.top, _EditButton.width-_EditIcon.right, _EditIcon.height);
    _DelButton.frame=CGRectMake(_EditButton.right+10, _EditButton.top, _EditButton.width, _EditButton.height);
    _DelIcon.frame=CGRectMake(0, _DelButton.height/2-7*self.scale, 14*self.scale, 14*self.scale);
    _DelLabel.frame=CGRectMake(_DelIcon.right+5*self.scale, _DelIcon.top, _DelButton.width-_DelIcon.right, _DelIcon.height);
    _bottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
-(void)EditButtonEvent:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(ManagerFuWuByIndexPath:IsDel:)]) {
        [_delegate ManagerFuWuByIndexPath:_indexPath IsDel:sender.tag==2];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
