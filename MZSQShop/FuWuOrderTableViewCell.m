//
//  FuWuOrderTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuOrderTableViewCell.h"
@interface FuWuOrderTableViewCell()
@property(nonatomic,strong)UILabel *ConentLabel;
@end;
@implementation FuWuOrderTableViewCell

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
    

    
    _SHRLabel=[[FUWUCell alloc]init];
    _SHRLabel.titleLabel.textColor=grayTextColor;
    _SHRLabel.titleLabel.text=@"收货人：";
    _SHRLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _SHRLabel.bottomline.hidden=YES;
    _SHRLabel.titleLabel.font=SmallFont(self.scale);
    _SHRLabel.contentLabel.textColor=_SHRLabel.titleLabel.textColor;
    _SHRLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_SHRLabel];
    
    _TelLabel=[[FUWUCell alloc]init];
    _TelLabel.titleLabel.textColor=grayTextColor;
    _TelLabel.titleLabel.text=@"手机号码：";
    _TelLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _TelLabel.bottomline.hidden=YES;
    _TelLabel.titleLabel.font=SmallFont(self.scale);
    _TelLabel.contentLabel.textColor=_SHRLabel.titleLabel.textColor;
    _TelLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_TelLabel];
    
    _ADLabel=[[FUWUCell alloc]init];
    _ADLabel.titleLabel.text=@"收货地址：";
    _ADLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _ADLabel.bottomline.hidden=YES;
    _ADLabel.titleLabel.textColor=grayTextColor;
    _ADLabel.titleLabel.font=SmallFont(self.scale);
    _ADLabel.contentLabel.textColor=_SHRLabel.titleLabel.textColor;
    _ADLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_ADLabel];
    
    _FuWuItemLabel=[[FUWUCell alloc]init];
      _FuWuItemLabel.frame=CGRectMake(0, 0, self.width,20*self.scale);
    _FuWuItemLabel.titleLabel.text=@"服务项目：";
    _FuWuItemLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _FuWuItemLabel.bottomline.hidden=YES;
    _FuWuItemLabel.titleLabel.textColor=grayTextColor;
    _FuWuItemLabel.titleLabel.font=SmallFont(self.scale);
    _FuWuItemLabel.contentLabel.textColor=blueTextColor;
    _ConentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_FuWuItemLabel.titleLabel.right, _FuWuItemLabel.top, _FuWuItemLabel.contentLabel.width, _FuWuItemLabel.titleLabel.height)];
    _ConentLabel.font=_FuWuItemLabel.titleLabel.font;
    _ConentLabel.textColor=blueTextColor;
    [_FuWuItemLabel addSubview:_ConentLabel];
    _FuWuItemLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_FuWuItemLabel];
    
    _TimeLabel=[[FUWUCell alloc]init];
    _TimeLabel.titleLabel.text=@"配送时间：";
    _TimeLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _TimeLabel.bottomline.hidden=YES;
    _TimeLabel.titleLabel.textColor=grayTextColor;
    _TimeLabel.titleLabel.font=SmallFont(self.scale);
    _TimeLabel.contentLabel.textColor=_SHRLabel.titleLabel.textColor;
    _TimeLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_TimeLabel];

    _MarkLabel=[[FUWUCell alloc]init];
    _MarkLabel.titleLabel.text=@"买家备注：";
    _MarkLabel.titleLabel.textAlignment=NSTextAlignmentLeft;
    _MarkLabel.bottomline.hidden=YES;
    _MarkLabel.titleLabel.textColor=grayTextColor;
    _MarkLabel.titleLabel.font=SmallFont(self.scale);
    _MarkLabel.contentLabel.textColor=_SHRLabel.titleLabel.textColor;
    _MarkLabel.contentLabel.font=_SHRLabel.titleLabel.font;
    [self addSubview:_MarkLabel];
    
    
    _middleLine=[[UIImageView alloc]init];
    _middleLine.backgroundColor=blackLineColore;
    [self addSubview:_middleLine];
    
    _bottomLine=[[UIImageView alloc]init];
    _bottomLine.backgroundColor=blackLineColore;
    [self addSubview:_bottomLine];
    
    NSLog(@"*******  %.2f",self.width);
    
}
-(void)setItems:(NSString *)Items{
    _ConentLabel.size=CGSizeMake(_ConentLabel.width, [self Text:Items Size:CGSizeMake(_ConentLabel.width, 100000) Font:_ConentLabel.font].height);
    _ConentLabel.numberOfLines=0;
    _ConentLabel.text=Items;
    _FuWuItemLabel.height=_ConentLabel.bottom;
}
-(void)layoutSubviews{
    _HeaderImg.frame=CGRectMake(10*self.scale, 5*self.scale, 35*self.scale, 35*self.scale);
    _HeaderImg.layer.cornerRadius=_HeaderImg.height/2;
    _NameLabel.frame=CGRectMake(_HeaderImg.right+10*self.scale, _HeaderImg.top, [self Text:_NameLabel.text Size:CGSizeMake(self.width/2, _HeaderImg.height) Font:_NameLabel.font].width, _HeaderImg.height);
    _MsgButton.frame=CGRectMake(_NameLabel.right+5*self.scale, _NameLabel.centerY-12*self.scale, 24*self.scale, 24*self.scale);
    _RigthImg.frame=CGRectMake(_MsgButton.right+10*self.scale, _MsgButton.top, _MsgButton.width, _MsgButton.height);
    _middleLine.frame=CGRectMake(10*self.scale, _HeaderImg.bottom+5*self.scale, self.width-20*self.scale, .5);
    _SHRLabel.frame=CGRectMake(0, _middleLine.bottom, self.width, 20*self.scale);
    _TelLabel.frame=CGRectMake(_SHRLabel.left, _SHRLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _ADLabel.frame=CGRectMake(_SHRLabel.left, _TelLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _FuWuItemLabel.origin=CGPointMake(_SHRLabel.left, _ADLabel.bottom);
    _TimeLabel.frame=CGRectMake(_SHRLabel.left, _FuWuItemLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _MarkLabel.frame=CGRectMake(_SHRLabel.left, _TimeLabel.bottom, _SHRLabel.width, _SHRLabel.height);
    _bottomLine.frame=CGRectMake(0, self.height-.5, self.width, .5);
}
-(void)MsgButtonEvent:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(FindFuWuOrderPresonSendMsg:)]) {
        [_delegate FindFuWuOrderPresonSendMsg:_inexPath];
    }
}


@end
