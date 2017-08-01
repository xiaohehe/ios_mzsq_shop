//
//  BigImageViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BigImageViewController.h"

@interface BigImageViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)BigImageBlock block;
@end

@implementation BigImageViewController
-(id)initWithBlock:(BigImageBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
      _index=_indexPage;
    [self ReshView];
  
}
-(void)newView{
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    _mainScrollView.pagingEnabled=YES;
    _mainScrollView.delegate=self;
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    [self.view insertSubview:_mainScrollView belowSubview:self.NavImg];
  }
-(void)ReshView{
    [_mainScrollView removeFromSuperview];
    _mainScrollView=nil;
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    _mainScrollView.pagingEnabled=YES;
    _mainScrollView.delegate=self;
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    [self.view insertSubview:_mainScrollView belowSubview:self.NavImg];
    
    
    for (int i=0; i<_ImageArr.count; i++)
    {
        UIImageView *Image=[[UIImageView alloc]initWithFrame:CGRectMake(i*_mainScrollView.width, 0, _mainScrollView.width, _mainScrollView.height)];
        Image.contentMode=UIViewContentModeScaleAspectFit;
        Image.backgroundColor=[UIColor clearColor];
        Image.tag = 10+i;
        
        Image.userInteractionEnabled=YES;
       // __block UIImageView *blockImg=Image;
        id img=[_ImageArr objectAtIndex:i];
        if ([img isKindOfClass:[UIImage class]]) {
            Image.image=img;
        }else if ([img isKindOfClass:[NSString class]]){
             [Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_ImageArr objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"not_1"]];
//            [Image setImageWithURLRequest:  [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_ImageArr objectAtIndex:i]]]] placeholderImage:[UIImage imageNamed:@"not_1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                if (_ImageArr.count>i) {
//                    [_ImageArr replaceObjectAtIndex:i withObject:image];
//                    blockImg.image=image;
//                }
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                
//            }];
        }
        [_mainScrollView addSubview:Image];
        _mainScrollView.contentSize=CGSizeMake(Image.right, Image.height);
    }
    CGRect frame = _mainScrollView.frame;
    if ((1+_index)>_ImageArr.count) {
        _index--;
    }
    frame.origin.x = frame.size.width *_index;
    frame.origin.y = 0;
    [_mainScrollView scrollRectToVisible:frame animated:NO];
     self.TitleLabel.text=[NSString stringWithFormat:@"%ld/%lu",(long)(_index+1),(unsigned long)_ImageArr.count];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point=[scrollView contentOffset];
    int n=(int)point.x/(scrollView.width);
    _index = n;
     self.TitleLabel.text=[NSString stringWithFormat:@"%ld/%lu",(long)(_index+1),(unsigned long)_ImageArr.count];
}

-(void)HiddenBigImage{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)newNav{
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];

    UIButton *Delete=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [Delete setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    Delete.titleLabel.font = BigFont(self.scale);
    [Delete addTarget:self action:@selector(DeleteBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:Delete];
    
}
-(void)DeleteBtnEvent:(id)sender{
    if (_index< _ImageArr.count && _index>=0) {
        id img = [_ImageArr objectAtIndex:_index];
        [_ImageArr removeObjectAtIndex:_index];
        /*if (_index<_webImgArr.count) {
            [_webImgArr removeObjectAtIndex:_index];
        }*/
        
    if ( _webImgArr.count>0) {
            NSInteger ind = [_webImgArr indexOfObject:img];
            if ([[_webImgArr objectAtIndex:ind] isKindOfClass:[NSString class]] ) {
                 [_webImgArr replaceObjectAtIndex:ind withObject:@"-1"];
            }
        }
        [self ReshView];
    }
    if (_ImageArr.count<1) {
        [self PopVC:nil];
    }
}
- (void)PopVC:(id)sender{
    if (_block) {
        _block();
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
