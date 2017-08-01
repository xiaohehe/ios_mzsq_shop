//
//  PresonDingDanTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PresonDingDanTableViewCell.h"

@implementation PresonDingDanTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
    _HeaderImg=[[UIImageView alloc]init];
    _HeaderImg.layer.masksToBounds=YES;
    [self addSubview:_HeaderImg];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    [self addSubview:_NameLabel];
    
    _MsgButton=[[UIButton alloc]init];
    [_MsgButton setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
    [_MsgButton addTarget:self action:@selector(MsgButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_MsgButton];
    
    _RigthImg=[[UIImageView alloc]init];
    _RigthImg.image=[UIImage imageNamed:@"xq_right"];
    [self addSubview:_RigthImg];
    
    _SHRLabel=[[UILabel alloc]init];
    _SHRLabel.textColor=grayTextColor;
    _SHRLabel.font=Small10Font(self.scale);
    [self addSubview:_SHRLabel];
    
    _ADLabel=[[UILabel alloc]init];
    _ADLabel.textColor=_SHRLabel.textColor;
    _ADLabel.font=_SHRLabel.font;
    [self addSubview:_ADLabel];
    
    _TimeLabel=[[UILabel alloc]init];
    _TimeLabel.textColor=_SHRLabel.textColor;
    _TimeLabel.font=_SHRLabel.font;
    [self addSubview:_TimeLabel];
    
    _MarkLabel=[[UILabel alloc]init];
    _MarkLabel.textColor=_SHRLabel.textColor;
    _MarkLabel.font=_SHRLabel.font;
    [self addSubview:_MarkLabel];
    
    _bottomLine=[[UIImageView alloc]init];
    _bottomLine.backgroundColor=blackLineColore;
    [self addSubview:_bottomLine];
    
}
-(void)layoutSubviews{
    _HeaderImg.frame=CGRectMake(10*self.scale, 5*self.scale, 35*self.scale, 35*self.scale);
    _HeaderImg.layer.cornerRadius=_HeaderImg.height/2;
    
    _NameLabel.frame=CGRectMake(_HeaderImg.right+10*self.scale, _HeaderImg.top, [self Text:_NameLabel.text Size:CGSizeMake(self.width/2, _HeaderImg.height) Font:_NameLabel.font].width, _HeaderImg.height);
    _MsgButton.frame=CGRectMake(_NameLabel.right+5*self.scale, _NameLabel.centerY-12*self.scale, 24*self.scale, 24*self.scale);
    _RigthImg.frame=CGRectMake(_MsgButton.right+10*self.scale, _MsgButton.top, _MsgButton.width, _MsgButton.height);
    _SHRLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, self.width-_NameLabel.left-10*self.scale, 15*self.scale);
    _ADLabel.frame=CGRectMake(_SHRLabel.left, _SHRLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _TimeLabel.frame=CGRectMake(_SHRLabel.left, _ADLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _MarkLabel.frame=CGRectMake(_SHRLabel.left, _TimeLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _bottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
-(void)MsgButtonEvent:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(FindPresonSendMsg:)]) {
        [_delegate FindPresonSendMsg:_inexPath];
    }
}
@end
