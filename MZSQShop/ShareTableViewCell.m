//
//  ShareTableViewCell.m
//  Wedding
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "DefaultPageSource.h"
@interface ShareTableViewCell()
//@property(nonatomic,strong)UIButton *ShareBtn;
@property(nonatomic,strong)UIView *BackView;
@property(nonatomic,strong)LineView *lineView;


@end
@implementation ShareTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self newView];
    }
    return self;
}
-(void)newView{
    self.backgroundColor=[UIColor clearColor];
    
    _BackView=[[UIView alloc]init];
    _BackView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_BackView];
    
    _HeaderImage=[[UIImageView alloc]init];
  //  _HeaderImage.contentMode=UIViewContentModeScaleAspectFill;
    _HeaderImage.userInteractionEnabled=YES;
    _HeaderImage.tag=49;
    [_BackView addSubview:_HeaderImage];
    
    _headBtn = [UIButton new];
    _headBtn.titleLabel.font=DefaultFont(self.scale);
    [_headBtn setTitleColor:blueTextColor forState:UIControlStateNormal];
    [_BackView addSubview:_headBtn];
    
//    _NameLabel=[[UILabel alloc]init];
//    _NameLabel.font=DefaultFont(self.scale);
//    _NameLabel.backgroundColor=[UIColor clearColor];
//    _NameLabel.textColor=blackTextColor;
//    [_BackView addSubview:_NameLabel];
    
    _ContentLabel=[[UILabel alloc]init];
    _ContentLabel.font=DefaultFont(self.scale);
    _ContentLabel.numberOfLines=0;
    [_BackView addSubview:_ContentLabel];
    
 
    _Logo1Image=[[UIImageView alloc]init];
    _Logo1Image.userInteractionEnabled=YES;
    //_Logo1Image.contentMode=UIViewContentModeScaleAspectFit;
    _Logo1Image.tag=50;
    [_BackView addSubview:_Logo1Image];
    
    _Logo2Image=[[UIImageView alloc]init];
    _Logo2Image.userInteractionEnabled=YES;
    //_Logo2Image.contentMode=UIViewContentModeScaleAspectFit;
     _Logo2Image.tag=51;
    [_BackView addSubview:_Logo2Image];
    
    _Logo3Image=[[UIImageView alloc]init];
    _Logo3Image.userInteractionEnabled=YES;
   // _Logo3Image.contentMode=UIViewContentModeScaleAspectFit;
     _Logo3Image.tag=52;
    [_BackView addSubview:_Logo3Image];
    
    _DateLabel=[[UILabel alloc]init];
    _DateLabel.font=SmallFont(self.scale);
   // _DateLabel.textAlignment=NSTextAlignmentRight;
    _DateLabel.textColor=grayTextColor;
    _DateLabel.backgroundColor=[UIColor clearColor];
    
    _lineView=[[LineView alloc]init];
    [_BackView addSubview:_lineView];
    
    [_BackView addSubview:_DateLabel];
    
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
   // UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
//[_HeaderImage addGestureRecognizer:tap4];
    [_Logo1Image  addGestureRecognizer:tap1];
      [_Logo2Image  addGestureRecognizer:tap2];
      [_Logo3Image  addGestureRecognizer:tap3];
    
    //UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ShareEvent:)];
  // [self.contentView addGestureRecognizer:longTap];
    
    
    _imgvi = [UIImageView new];
    [self.contentView addSubview:_imgvi];
    
    
    _zanvi = [UIImageView new];
    [self.contentView addSubview:_zanvi];
   
    _CaoZuoButton=[[UIButton alloc]init];
    _CaoZuoButton.hidden=YES;
    [_CaoZuoButton setImage:[UIImage imageNamed:@"gg_xin"] forState:UIControlStateNormal];
    [_CaoZuoButton addTarget:self action:@selector(CaoZuoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_CaoZuoButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView addSubview:_CaoZuoButton];
    
    _ZanButton=[[UIButton alloc]init];
    [_ZanButton setBackgroundImage: [UIImage imageNamed:@"gg_zan_b"] forState:UIControlStateNormal];
    [_ZanButton addTarget:self action:@selector(ShareEvent:) forControlEvents:UIControlEventTouchUpInside];
    _ZanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    _ZanButton.clipsToBounds=YES;
    [_ZanButton setTitleColor:whiteLineColore forState:UIControlStateNormal];
    _ZanButton.titleLabel.font=SmallFont(self.scale);
    [self.contentView addSubview:_ZanButton];
    
    _chakan = [UILabel new];
    _chakan.text=@"查看全文";
    _chakan.textColor=blueTextColor;
    _chakan.font=SmallFont(self.scale);

    [self.contentView addSubview:_chakan];
    
}
//-(void)BigImage:(UIGestureRecognizer *)G{
//  
//    NSLog(@"%d",G.view.tag);
//    
//    UIView *view=[G view];
//        if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
//            [_delegate BigImageTableViewCellWith:self.indexPath ImageIndex:view.tag-50];
//        }
//}
-(void)layoutSubviews{
    _BackView.frame=CGRectMake(0, 0, self.width, self.height);
    _HeaderImage.frame=CGRectMake(10*self.scale,10*self.scale,40*self.scale,40*self.scale);
    
    _headBtn.frame=CGRectMake(_HeaderImage.right+10*self.scale, _HeaderImage.top, 0, 25*self.scale);
    [_headBtn sizeToFit];
    _headBtn.height=25*self.scale;
    
//    _NameLabel.frame=CGRectMake(_headBtn.right+ 0*self.scale, _HeaderImage.top, _BackView.width-_headBtn.right, 25*self.scale);
    _ContentLabel.frame=CGRectMake(_headBtn.left, _headBtn.bottom, self.width-_HeaderImage.right-10*self.scale, 35*self.scale);
    if(_ContentLabel.text.length<1){
        _ContentLabel.height=0;
    }
 //   [_ContentLabel sizeToFit];
    
    float qqY = _ContentLabel.bottom;
    
    if (self.imgCount>0) {
           _imgvi.frame = CGRectMake(_ContentLabel.left,  _ContentLabel.bottom, self.contentView.width-_ContentLabel.left-10*self.scale, _imgvi.height);
        qqY=_imgvi.bottom;
    }
  
    _DateLabel.frame=CGRectMake(_ContentLabel.left,qqY+5*self.scale, 200*self.scale, 15*self.scale);
   [_DateLabel sizeToFit];
    
    
   _chakan.frame=CGRectMake(_DateLabel.right+10*self.scale, _DateLabel.top, 70*self.scale, _DateLabel.height);
    
   /* qqY=_DateLabel.bottom+5*self.scale;
    
    if (_zanvi) {
        [_zanvi removeFromSuperview];
        
        _zanvi = [UIImageView new];
        _zanvi.backgroundColor=superBackgroundColor;
        _zanvi.userInteractionEnabled=YES;
        [self.contentView addSubview:_zanvi];
        
    }
    
    
       if (_zanCount>0) {
           _zanvi.frame = CGRectMake(_ContentLabel.left, qqY+5*self.scale, self.contentView.width-_ContentLabel.left-10*self.scale, 10);

           UIImageView *xin = [[UIImageView alloc]initWithFrame:CGRectMake(5*self.scale, 3.5*self.scale, 13*self.scale, 13*self.scale)];
           xin.image =[UIImage imageNamed:@"gg_xin_3"];
           [_zanvi addSubview:xin];

        NSString *str = @"";
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(5*self.scale, 3*self.scale, _zanvi.width-10*self.scale, 10)];
        name.numberOfLines=0;
            for (NSDictionary *dic in self.zanData) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",dic[@"user_name"]]];
                }
             str = [str substringToIndex:str.length-1];
            qqY = name.bottom;
        str = [@"" stringByAppendingString:[NSString stringWithFormat:@"    %@",str]];
        name.text=str;
        name.font=SmallFont(self.scale);
        
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize size = [str boundingRectWithSize:CGSizeMake(_zanvi.width-10*self.scale, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        name.height=size.height;
        name.backgroundColor=[UIColor clearColor];
        [_zanvi addSubview:name];
        _zanvi.height=name.bottom+3*self.scale;
    
    }
    _CaoZuoButton.frame=CGRectMake(self.width-35*self.scale, _DateLabel.top+3*self.scale, 30*self.scale, 15*self.scale);
    _ZanButton.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top-5*self.scale, 0, 15*self.scale);*/

    _lineView.frame=CGRectMake(0, self.height-1, self.width, 1);
}
-(void)setImgData:(NSMutableArray *)imgData{
    if (_imgvi) {
        [_imgvi removeFromSuperview];
        _imgvi=nil;
        _imgvi = [UIImageView new];
        _imgvi.userInteractionEnabled=YES;
        [self.contentView addSubview:_imgvi];
    }
    if (self.imgCount>0) {
        
       
        
        float W=(self.contentView.width-100*self.scale)/3;
        for (int i=0; i<self.imgCount; i++) {
            
            float x = (W+10*self.scale)*(i%3);
            float y = (W-10*self.scale)*(i/3);
            
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x, y+5*self.scale, W, W*0.75)];
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds=YES;
            NSString *url=@"";
            NSString *cut =imgData[i];
            if (cut.length>0) {
                url = [cut substringToIndex:[cut length] - 4];
                
            }
            [im setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_thumb320.jpg",url]] placeholderImage:[UIImage imageNamed:@"za"]];
            
            
            im.tag=i+1;
            im.userInteractionEnabled=YES;
            [_imgvi addSubview:im];
            
            UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
            [im addGestureRecognizer:tap1];
            
              _imgvi.height=im.bottom;
          //  qqY=_imgvi.bottom;
        }
      
    }

}

-(void)BigImage:(UITapGestureRecognizer *)tap{

    if (_delegate && [_delegate respondsToSelector:@selector(BigImageTableViewCellWith:ImageIndex:)]) {
        [_delegate BigImageTableViewCellWith:_indexPath ImageIndex:tap.view.tag];
    }
}

-(void)ShareEvent:(id)sender{

    _CaoZuoButton.selected=NO;
        if (_delegate && [_delegate respondsToSelector:@selector(ShareTableViewCellWith:)]) {
            [_delegate ShareTableViewCellWith:_indexPath];
        }
}
-(void)CaoZuoButtonEvent:(UIButton *)button{
    button.selected=!button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(CanZuoTableViewCellWith:Selected:)]) {
        [_delegate CanZuoTableViewCellWith:_indexPath Selected:_CaoZuoButton.selected];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selected"]) {
        if (_CaoZuoButton.selected) {
            [UIView animateWithDuration:.3 animations:^{
                  _ZanButton.frame=CGRectMake(_CaoZuoButton.left-75*self.scale, _CaoZuoButton.top-10*self.scale, 75*self.scale, 28*self.scale);
            }];
          
        }else{
            [UIView animateWithDuration:.3 animations:^{
                _ZanButton.frame=CGRectMake(_CaoZuoButton.left, _CaoZuoButton.top-10*self.scale, 0, 28*self.scale);
            }];
        }
    }
}
-(void)dealloc{
    [_CaoZuoButton removeObserver:self forKeyPath:@"selected" context:nil];
}
@end
