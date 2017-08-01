//
//  ServiceAreaTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ServiceAreaTableViewCell.h"

@implementation ServiceAreaTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}

-(void)newView{
    _blineImg=[[UIImageView alloc]init];
    _blineImg.backgroundColor=blackLineColore;
    [self.contentView addSubview:_blineImg];
    
    _rightImg=[[UIButton alloc]init];
    [_rightImg setBackgroundImage:[UIImage imageNamed:@"v1"] forState:UIControlStateNormal];
    [_rightImg setBackgroundImage:[UIImage imageNamed:@"v2"] forState:UIControlStateSelected];
    _rightImg.userInteractionEnabled=NO;
    [self.contentView addSubview:_rightImg];
    
    _contextLa = [UILabel new];
    _contextLa.font=DefaultFont(self.scale);
    _contextLa.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contextLa];
    

}

-(void)layoutSubviews{
    
    _rightImg.frame=CGRectMake(self.width-40*self.scale, self.height/2-18*self.scale, 36*self.scale, 36*self.scale);
    _contextLa.frame = CGRectMake(10*self.scale, self.contentView.height/2-10*self.scale, self.width-100*self.scale, 20*self.scale);
    
   _blineImg.frame=CGRectMake(0, self.height-.5, self.width, 0.5);
 
}
@end
