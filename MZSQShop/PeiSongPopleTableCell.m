
//
//  PeiSongPopleTableCell.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PeiSongPopleTableCell.h"

@implementation PeiSongPopleTableCell

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
    _nameLa = [UILabel new];
    _nameLa.text = @"姓名：";
    _nameLa.font = DefaultFont(self.scale);
    [self.contentView addSubview:_nameLa];
    
    _name = [UILabel new];
    _name.font = DefaultFont(self.scale);
    [self.contentView addSubview:_name];
    
    _teleLa = [UILabel new];
    _teleLa.text = @"电话：";
    _teleLa.font = DefaultFont(self.scale);
    [self.contentView addSubview:_teleLa];
    
    _tele = [UILabel new];
    _tele.font = DefaultFont(self.scale);
    [self.contentView addSubview:_tele];
    
    _deleLa = [UIButton new];
  //  _deleLa.text = @"删除";
    [_deleLa setTitle:@"删除" forState:UIControlStateNormal];
    [_deleLa setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _deleLa.titleLabel.font = DefaultFont(self.scale);
   // _deleLa.textColor = [UIColor redColor];
    _deleLa.hidden=YES;
    [_deleLa addTarget:self action:@selector(DelegateEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleLa];
    
    _line = [UIView new];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];

}
-(void)DelegateEvent:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(DelegatePresonIndexPath:)]) {
        [_delegate DelegatePresonIndexPath:_indexPath];
    }
}
-(void)layoutSubviews{

    _nameLa.frame = CGRectMake(10*self.scale, self.height/2-25*self.scale, 50*self.scale, 20*self.scale);
    
    _name.frame = CGRectMake(_nameLa.right, _nameLa.top, 100*self.scale, _nameLa.height);
    
    _teleLa.frame = CGRectMake(_nameLa.left, self.height/2, _nameLa.width, _nameLa.height);
    
    _tele.frame = CGRectMake(_teleLa.right, _teleLa.top, 200*self.scale, _teleLa.height);

    _deleLa.frame = CGRectMake(self.width-50*self.scale, self.height/2-10*self.scale, 40*self.scale, 20*self.scale);
    _line.frame = CGRectMake(0, self.height-.5, self.width, .5);
}
@end