//
//  ShangjiaSettingTableViewCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShangjiaSettingTableViewCell.h"

@implementation ShangjiaSettingTableViewCell

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

    _rightImg=[[UIImageView alloc]init];
    _rightImg.image=[UIImage imageNamed:@"xq_right"];
    [self.contentView addSubview:_rightImg];

    _contextLa = [UILabel new];
    _contextLa.font = DefaultFont(self.scale);
    _contextLa.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_contextLa];
    
}

-(void)layoutSubviews{

    _rightImg.frame=CGRectMake(self.width-30*self.scale, self.height/2-12*self.scale, 24*self.scale, 24*self.scale);

    _blineImg.frame=CGRectMake(10*self.scale, self.height-.5, self.width-20*self.scale, 0.5);
    
    _contextLa.frame = CGRectMake(10*self.scale, self.contentView.height/2-10*self.scale, self.contentView.width-100*self.scale, 20*self.scale);
    

}
@end
