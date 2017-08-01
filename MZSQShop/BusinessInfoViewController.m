//
//  BusinessInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BusinessInfoViewController.h"
#import "CellView.h"
#import "shopPingJiaViewController.h"

@interface BusinessInfoViewController ()<NSXMLParserDelegate>
@property(nonatomic,strong)UIImageView *startImg;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)CellView *nameCell;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSMutableString *soapResults;
@property(nonatomic,strong)UIScrollView *scoll;
@property(nonatomic,strong)NSMutableArray *arr;
@end

@implementation BusinessInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableDictionary new];
    [self returnVi];
    [self BigScrollView];
    [self.view addSubview:self.activityVC];
    [self ReshData];

    
}
#pragma mark - 数据块
-(void)ReshData
{
    [self.activityVC startAnimating];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze ShopDetailWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            [_data addEntriesFromDictionary:models];
            [self topImageVi];
        }
    }];
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"商家详情";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)BigScrollView{
    _bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _bigScroll.contentSize = CGSizeMake(self.view.width, 1000);
    [self.view addSubview:_bigScroll];
}

#pragma mark ------顶部图片
-(void)topImageVi{

    NSLog(@"%@",_data);
    _topImg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*3/4.0)];
  //  [_topImg setImageWithURL:[NSURL URLWithString:[_data objectForKey:@"shop_zhaopai"]] placeholderImage:[UIImage imageNamed:@"za"]];
    _topImg.pagingEnabled=YES;
    [_bigScroll addSubview:_topImg];
    
    NSArray *Arr=[_data objectForKey:@"shop_zhaopai_arr"];
    [self newZhaoPai:Arr];
    [self BusinessNameAndAdress];
}
-(void)newZhaoPai:(NSArray *)Arr{
    
    if (![Arr isKindOfClass:[NSArray class]] || !Arr || Arr.count<1) {
         NSString *img=@"";
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _topImg.width, _topImg.height)];
        [Img setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"za"]];
        [_topImg addSubview:Img];
        _topImg.contentSize=CGSizeMake(Img.right, Img.bottom);
    }else{
        for (int i=0; i<Arr.count; i++)
        {
            NSString *img=[[[NSString stringWithFormat:@"%@",[Arr objectAtIndex:i]] EmptyStringByWhitespace] trimString];
            UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(i*_topImg.width, 0, _topImg.width, _topImg.height)];
            [Img setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"za"]];
            [_topImg addSubview:Img];
            _topImg.contentSize=CGSizeMake(Img.right, Img.bottom);
        }
    }
    
}
#pragma mark ------图片下边两个cell，名字和地址；
-(void)BusinessNameAndAdress{
    _shopBigVi = [[UIView alloc]initWithFrame:CGRectMake(0, _topImg.bottom, self.view.width,100*self.scale)];
    [_bigScroll addSubview:_shopBigVi];
//名字的cell
    
    _nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50*self.scale)];
    [_shopBigVi addSubview:_nameCell];

    _nameLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 200*self.scale, 20*self.scale)];
    _nameLa.text = [_data objectForKey:@"shop_name"];
    _nameLa.font = DefaultFont(self.scale);
    [_nameCell addSubview:_nameLa];
    
    
    UILabel *startLa = [[UILabel alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom, 100*self.scale, 15*self.scale)];
    startLa.backgroundColor = [UIColor clearColor];
    [_nameCell addSubview:startLa];

    [self setStartNumber:[_data objectForKey:@"rating"]];

    
    
    CellView *adressCell = [[CellView alloc]initWithFrame:CGRectMake(0, _nameCell.bottom, self.view.width, 50*self.scale)];
    [_shopBigVi addSubview:adressCell];
    
    UIImageView *adressImg = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLa.left, 25/2*self.scale, 25*self.scale, 25*self.scale)];
    adressImg.image = [UIImage imageNamed:@"xq_dibiao"];
    [adressCell addSubview:adressImg];
    
    
    UILabel *adressLa = [[UILabel alloc]initWithFrame:CGRectMake(adressImg.right+5*self.scale, adressImg.top, 180*self.scale, 30*self.scale)];
    adressLa.numberOfLines=0;
    adressLa.font = SmallFont(self.scale);
    adressLa.text = [_data objectForKey:@"address"];
    [adressCell addSubview:adressLa];
    [self shopGongGao];
    
}

#pragma mark--店铺公告
-(void)shopGongGao{
    _gongGaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _shopBigVi.bottom+10*self.scale, self.view.width, 100*self.scale)];
    _gongGaoCell.topline.hidden=NO;
    [_bigScroll addSubview:_gongGaoCell];
    
    UILabel *gonggaoLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    gonggaoLa.textAlignment = NSTextAlignmentLeft;
    gonggaoLa.text = @"店铺公告";
    gonggaoLa.font=DefaultFont(self.scale);
    [_gongGaoCell addSubview:gonggaoLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(gonggaoLa.left, gonggaoLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_gongGaoCell addSubview:line];
    NSString *str = [NSString stringWithFormat:@"%@",[_data objectForKey:@"notice"]];
    str=[str EmptyStringByWhitespace];
    UILabel *contextLa = [[UILabel alloc]initWithFrame:CGRectMake(gonggaoLa.left, line.bottom+10*self.scale, line.width, 0)];
    contextLa.numberOfLines = 0;
    contextLa.font=DefaultFont(self.scale);
    contextLa.text =str;
    contextLa.textAlignment = NSTextAlignmentLeft;
    [contextLa sizeToFit];
    contextLa.textColor = grayTextColor;
    _gongGaoCell.clipsToBounds=YES;
    [_gongGaoCell addSubview:contextLa];
    if (contextLa.height>10) {
        _gongGaoCell.height=contextLa.bottom+10*self.scale;
    }else{
        _gongGaoCell.height=line.top;
    }
    
    [self shopJieShao];
}

#pragma mark-----店铺介绍
-(void)shopJieShao{

    _jieShaoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _gongGaoCell.bottom+10*self.scale, self.view.width, 100*self.scale)];
    _jieShaoCell.topline.hidden=NO;
    [_bigScroll addSubview:_jieShaoCell];
    
    UILabel *jieShaoLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    jieShaoLa.textAlignment = NSTextAlignmentLeft;
    jieShaoLa.text = @"商家简介";
    jieShaoLa.font=DefaultFont(self.scale);
    [_jieShaoCell addSubview:jieShaoLa];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(jieShaoLa.left, jieShaoLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [_jieShaoCell addSubview:line];
    
    UILabel *ContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(jieShaoLa.left, line.bottom+10*self.scale,self.view.width-20*self.scale, 0)];
    ContentLabel.font=DefaultFont(self.scale);
    ContentLabel.numberOfLines=0;
    ContentLabel.textColor=grayTextColor;
    ContentLabel.text=[[NSString stringWithFormat:@"%@",[_data objectForKey:@"summary"]] EmptyStringByWhitespace];
   [ContentLabel sizeToFit];
  //  ContentLabel.size=CGSizeMake(self.view.width-20*self.scale, ContentLabel.height);
    [_jieShaoCell addSubview:ContentLabel];
      _jieShaoCell.clipsToBounds=YES;
    if (ContentLabel.height>10) {
        _jieShaoCell.height=ContentLabel.bottom+10*self.scale;
    }else{
        _jieShaoCell.height=line.top;
    }
       [self shopPingJia];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height= webViewHeight;
    webView.frame= newFrame;
    _jieShaoCell.height=webView.bottom;
}
#pragma mark--店铺评价
-(void)shopPingJia{
    _pingJiaCell = [[CellView alloc]initWithFrame:CGRectMake(0, _jieShaoCell.bottom+10*self.scale, self.view.width, 44*self.scale)];
    _pingJiaCell.topline.hidden=NO;
    [_bigScroll addSubview:_pingJiaCell];
    
    UILabel *pingJiaLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    pingJiaLa.textAlignment = NSTextAlignmentLeft;
    pingJiaLa.text = @"店铺评价";
    pingJiaLa.font = DefaultFont(self.scale);
    [_pingJiaCell addSubview:pingJiaLa];
    UIImageView *jianTouImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*self.scale, 8*self.scale, 30*self.scale, 30*self.scale)];
    jianTouImg.image = [UIImage imageNamed:@"xq_right"];
    [_pingJiaCell addSubview:jianTouImg];
    UIButton *pingjiaBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pingjiaBt.frame = CGRectMake(0, 0, self.view.width, _pingJiaCell.height);
    [pingjiaBt addTarget:self action:@selector(pingJiaEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_pingJiaCell addSubview:pingjiaBt];
    [self shopXiangQing];
}
-(void)pingJiaEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    shopPingJiaViewController *shopPingJia = [shopPingJiaViewController new];
    shopPingJia.shop_id=self.shop_id;
    [self.navigationController pushViewController:shopPingJia animated:YES];
}
#pragma mark-----店铺详情
-(void)shopXiangQing{

    CellView *xiangQingCell = [[CellView alloc]init];
    xiangQingCell.frame = CGRectMake(0, _pingJiaCell.bottom+10*self.scale, self.view.width,0);
    xiangQingCell.topline.hidden=NO;
    xiangQingCell.clipsToBounds=YES;
    [_bigScroll addSubview:xiangQingCell];

    UILabel *xiangQingLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    xiangQingLa.textAlignment = NSTextAlignmentLeft;
    xiangQingLa.text = @"店铺详情";
    xiangQingLa.font = DefaultFont(self.scale);
    [xiangQingCell addSubview:xiangQingLa];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(xiangQingLa.left, xiangQingLa.bottom+10*self.scale, self.view.width-20*self.scale, .5)];
    line.backgroundColor = blackLineColore;
    [xiangQingCell addSubview:line];
 
    UILabel *ContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(xiangQingLa.left, line.bottom+10*self.scale,self.view.width-20*self.scale, 0)];
    ContentLabel.font=DefaultFont(self.scale);
    ContentLabel.numberOfLines=0;
    ContentLabel.textColor=grayTextColor;
    ContentLabel.text=[[NSString stringWithFormat:@"%@",[_data objectForKey:@"detail"]] EmptyStringByWhitespace];
    [ContentLabel sizeToFit];
    //  ContentLabel.size=CGSizeMake(self.view.width-20*self.scale, ContentLabel.height);
    [xiangQingCell addSubview:ContentLabel];
    
    
    NSLog(@"%@",_data);
    _arr = [_data objectForKey:@"imgs"];
    
    float scrollBottomY = ContentLabel.bottom;
    float W=(self.view.width-40*self.scale)/3;
    for (int i=0; i<_arr.count; i++) {
        float x = (W+10*self.scale)*(i%3);
        float y = (W-10*self.scale)*(i/3);
        NSString *im1 = [NSString stringWithFormat:@"%@",[_arr objectAtIndex:i]];
        NSLog(@"%@",im1);
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y+ContentLabel.bottom+10*self.scale, W, W*0.75)];
        [im setImageWithURL:[NSURL URLWithString:im1] placeholderImage:[UIImage imageNamed:@"not_1"]];
        im.tag=i+1;
        im.userInteractionEnabled=YES;
        im.contentMode=UIViewContentModeScaleAspectFill;
         im.clipsToBounds = YES;
        [xiangQingCell addSubview:im];
        
        scrollBottomY = im.bottom;
        
        UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImage:)];
        [im addGestureRecognizer:tap1];
        
    }

    if (scrollBottomY>0) {
           xiangQingCell.height=scrollBottomY+10*self.scale;
    }else{
        xiangQingCell.height=line.top;
    }
    _bigScroll.contentSize = CGSizeMake(self.view.width, xiangQingCell.bottom+10*self.scale);
}

-(void)BigImage:(UITapGestureRecognizer *)tap{
    _scoll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scoll.backgroundColor=[UIColor blackColor];
    _scoll.contentSize = CGSizeMake(self.view.width*_arr.count, self.view.height);
    _scoll.pagingEnabled=YES;
    [self.view addSubview:_scoll];
    UIImageView *tapImg=(UIImageView *)[tap view];
    float setY=0;
    for (int i=0; i<_arr.count; i++) {
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(setY, 0, self.view.width, self.view.height)];
        im.contentMode=UIViewContentModeScaleAspectFit;
           NSString *im1 = [NSString stringWithFormat:@"%@",[_arr objectAtIndex:i]];
        [im setImageWithURL:[NSURL URLWithString:im1] placeholderImage:[UIImage imageNamed:@"not_2"]];
        im.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change)];
        [im addGestureRecognizer:tap];
        [_scoll addSubview:im];
        setY=im.right;
    }
    CGRect frame = _scoll.frame;
    frame.origin.x = _scoll.width *(tapImg.tag-1);
    frame.origin.y = 0;
    [_scoll scrollRectToVisible:frame animated:NO];

}
-(void)change{
    
    [UIView animateWithDuration:.3 animations:^{
        _scoll.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [_scoll removeFromSuperview];
    } completion:^(BOOL finished) {
        
        
    }];
    
}

-(void)setStartNumber:(NSString *)StartNumber
{
    float star=[StartNumber floatValue];
    if (star>5) {
        star=5;
    }
    if (_start) {
        [_start removeFromSuperview];
        _start=nil;
    }
    _start=[[UIView alloc]initWithFrame:CGRectMake(_nameLa.left, _nameLa.bottom+5*self.scale, 70*self.scale, 15*self.scale)];
    [_nameCell addSubview:_start];
    
    UILabel *fen = [[UILabel alloc]initWithFrame:CGRectMake(_start.right, _start.top-2*self.scale, 50*self.scale, 15*self.scale)];
    if (StartNumber==nil || [StartNumber isEqualToString:@""]) {
        StartNumber=@"0";
    }
    
    fen.text=[NSString stringWithFormat:@"%@分",StartNumber];
    fen.textColor = [UIColor redColor];
    fen.font=SmallFont(self.scale);
    [_nameCell addSubview:fen];
    
    int num=(int)star;
    float setX = 0;
    for (int i=0; i<num; i++)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star01"];
        setX = starImg.right +3*self.scale;
        [_start addSubview:starImg];
    }
    if (star>num)
    {
        UIImageView *starImg=[[UIImageView alloc]initWithFrame:CGRectMake(setX, 0, 10*self.scale, 10*self.scale)];
        starImg.image=[UIImage imageNamed:@"xq_star02"];
        [_start addSubview:starImg];
    }
// self.scoreLa.text=[NSString stringWithFormat:@"%@分",StartNumber];
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
