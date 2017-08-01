//
//  GoodsDingDanTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "GoodsDingDanTableViewCell.h"

@implementation GoodsDingDanTableViewCell

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
    _HeaderImg.contentMode=UIViewContentModeScaleAspectFill;
    _HeaderImg.clipsToBounds=YES;
    [self addSubview:_HeaderImg];
    
    _NameLabel=[[UILabel alloc]init];
    _NameLabel.font=DefaultFont(self.scale);
    [self addSubview:_NameLabel];
    
    _ContentLabel=[[UILabel alloc]init];
    _ContentLabel.textColor=grayTextColor;
    _ContentLabel.font=Small10Font(self.scale);
    [self addSubview:_ContentLabel];
    
    _PriceLabel=[[UILabel alloc]init];
    _PriceLabel.textColor=_NameLabel.textColor;
    _PriceLabel.font=_NameLabel.font;
    _PriceLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:_PriceLabel];
    
    _NumLabel=[[UILabel alloc]init];
    _NumLabel.textColor=_ContentLabel.textColor;
    _NumLabel.font=_ContentLabel.font;
    _NumLabel.textAlignment=NSTextAlignmentRight;
    [self addSubview:_NumLabel];

    _bottomLine=[[UIImageView alloc]init];
    _bottomLine.backgroundColor=blackLineColore;
    [self addSubview:_bottomLine];
    
}
-(void)layoutSubviews{
    _HeaderImg.frame=CGRectMake(10*self.scale, self.height/2-(self.height-20*self.scale)*3/8, self.height-20*self.scale, (self.height-20*self.scale)*3/4);
    _NameLabel.frame=CGRectMake(_HeaderImg.right+10*self.scale, 10*self.scale, self.width-_HeaderImg.right-80*self.scale, 35*self.scale);
    _ContentLabel.frame=CGRectMake(_NameLabel.left, _NameLabel.bottom, _NameLabel.width, [self Text:_ContentLabel.text Size:CGSizeMake(_NameLabel.width, _HeaderImg.height-_NameLabel.height) Font:_ContentLabel.font].height);
    _PriceLabel.frame=CGRectMake(_NameLabel.right+5*self.scale, _NameLabel.top+10*self.scale, self.width-_NameLabel.right-15*self.scale, 15*self.scale);
    _NumLabel.frame=CGRectMake(_PriceLabel.left, _PriceLabel.bottom+5*self.scale, _PriceLabel.width, _PriceLabel.height);
    
    _bottomLine.frame=CGRectMake(0, self.height-0.5, self.width, .5);
}
@end
