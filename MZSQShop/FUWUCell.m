//
//  FUWUCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FUWUCell.h"

#import "DefaultPageSource.h"
#import "LineView.h"
@interface FUWUCell()
@property(nonatomic,assign) float scale;
@property(nonatomic,strong)LineView *blineImg;
@end
@implementation FUWUCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        self.backgroundColor=[UIColor whiteColor];
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, self.height/2-10*self.scale, 70*self.scale, 20*self.scale)];
        _titleLabel.font=DefaultFont(self.scale);
        // _titleLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:_titleLabel];
        _contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top, self.width - _titleLabel.right-20*self.scale, _titleLabel.height)];
        _contentLabel.font=DefaultFont(self.scale);
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        _RightImg=[[UIImageView alloc]init];
        _RightImg.image=[UIImage imageNamed:@"xq_right"];
        _RightImg.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:_RightImg];
        
        _blineImg=[[LineView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _blineImg.hidden=YES;
        [self addSubview:_blineImg];
        
        _topline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _topline.hidden=YES;
        _topline.backgroundColor=blackLineColore;
        [self addSubview:_topline];
        
        _bottomline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        //_bottomline.hidden=YES;
        _bottomline.backgroundColor=blackLineColore;
        [self addSubview:_bottomline];
           [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _titleLabel.text =title;
}

-(void)setContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:_contentLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize cellsize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, 10000*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (cellsize.height<=20) {
        cellsize.height =20;
    }
    _contentLabel.frame=CGRectMake(_titleLabel.right, _titleLabel.top, _contentLabel.width, cellsize.height);
    _contentLabel.numberOfLines=0;
    _contentLabel.text = content;
    self.size=CGSizeMake(self.width, cellsize.height+ _titleLabel.top*2);
}
-(void)layoutSubviews{
    _blineImg.frame=CGRectMake(0, self.height-1, self.width, 1);
    _topline.frame=CGRectMake(0, 0, self.width, 0.5);
    if (_shotLine) {
        _bottomline.frame=CGRectMake(10*self.scale, self.height-0.5, self.width-20*self.scale, 0.5);
    }else{
        _bottomline.frame=CGRectMake(0, self.height-0.5, self.width, 0.5);
    }
    
}
-(void)setHiddenLine:(BOOL)hidden{
    
    _blineImg.hidden = hidden;
}
-(void)ShowRight:(BOOL)show{
    _RightImg.hidden =!show;
    _RightImg.frame=CGRectMake(self.width-30*self.scale,self.height/2-12*self.scale, 24*self.scale, 24*self.scale);
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object) {
        if ([keyPath isEqualToString:@"frame"]) {
            _titleLabel.frame =CGRectMake(10*self.scale, self.height/2-10*self.scale, 65*self.scale, 20*self.scale);
            float SetY=_titleLabel.height;
            _contentLabel.frame=CGRectMake(_titleLabel.right, _titleLabel.top, self.width - _titleLabel.right-20*self.scale, SetY);
        }
    }
}
-(void)dealloc{
   [self removeObserver:self  forKeyPath:@"frame"];
}


@end
