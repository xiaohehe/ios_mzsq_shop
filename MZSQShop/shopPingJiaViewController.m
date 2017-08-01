//
//  shopPingJiaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "shopPingJiaViewController.h"
#import "shopPingJiaTableViewCell.h"

@interface shopPingJiaViewController ()<shopDelegect,UIScrollViewDelegate>
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)UIView *wei;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UIPageControl *page;
@end

@implementation shopPingJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_wei removeFromSuperview];
    _index=0;
    _data=[NSMutableArray new];
    [self BigTable];

   // [self ReshData];
    [self returnVi];
    [self.view addSubview:self.activityVC];

    
 //图片放大
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _scroll.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    _scroll.hidden=YES;
    _scroll.delegate=self;
    _scroll.pagingEnabled=YES;
    [self.view addSubview:_scroll];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.height-20*self.scale, self.view.width, 20*self.scale)];
    _page.pageIndicatorTintColor=[UIColor whiteColor];
    _page.hidden=YES;
    _page.currentPage=1;
    _page.currentPageIndicatorTintColor=[UIColor whiteColor];
    _page.pageIndicatorTintColor=[UIColor grayColor];
    [self.view addSubview:_page];
}
-(void)setScrollhident:(BOOL)bol{

    _scroll.hidden=bol;
    _page.hidden=bol;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _index=0;
    [self ReshData];

}
#pragma mark - 数据块

-(void)ReshData
{
    _index++;
        [self.activityVC startAnimating];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze CommentListWithShop_id:_shop_id PIndex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_bigTable.header endRefreshing];
        [_bigTable.footer endRefreshing];
        if (_index==1) {
            _bigTable.footer.hidden=NO;
            [_data removeAllObjects];
        }
        NSArray *Arr=models;
        if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
            [_data addObjectsFromArray:Arr];
            [_bigTable reloadData];
        }else{
            _bigTable.footer.hidden=YES;
        }
    }];
    
    [self ReshView];
}
-(void)ReshView{
    
}
#pragma mark---大表格
-(void)BigTable{
    if (_bigTable) {
        [_bigTable removeFromSuperview];
    }
    _bigTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    _bigTable.delegate=self;
    _bigTable.dataSource=self;
    _bigTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bigTable registerClass:[shopPingJiaTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_bigTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footEvent)];
    [_bigTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headEvent)];
    [self.view addSubview:_bigTable];

}
-(void)footEvent{
    [self ReshData];
}
-(void)headEvent{
    _index=0;
    [self ReshData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [[NSString stringWithFormat:@"%@",_data[indexPath.row][@"content"]] boundingRectWithSize:CGSizeMake(self.view.width-70*self.scale, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat height =size.height;

    NSMutableArray *ar = [NSMutableArray new];

    for (int i=1; i<10; i++) {
        NSString *im = _data[indexPath.row][[NSString stringWithFormat:@"img%d",i]];
        if (![im isEqualToString:@""]) {
            [ar addObject:im];
        }
    }
    
    float imgH = 0;
    if (ar.count<=0) {
        imgH = 0;
    }
    
    if (ar.count<4 && ar.count>0) {
        imgH = 70*self.scale;
    }else if (ar.count<7 && ar.count>0){
        imgH=130*self.scale;
    }else if (ar.count<10 && ar.count>0){
        imgH=190*self.scale;
    }
    return height+imgH+70*self.scale;
//三张图片以内的+110;
//没图片的+60
//六张图片+170
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    shopPingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath=indexPath;
    [cell.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    //cell.headImg.image=[UIImage imageNamed:@"center_img"];
    cell.name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_name"]];
    cell.context.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];

    NSMutableArray *ar = [NSMutableArray new];
    
    for (int i=1; i<10; i++) {
     
       NSString *im =    [NSString stringWithFormat:@"%@", dic[[NSString stringWithFormat:@"img%d",i]]];
        if (![im isEmptyString]) {
            [ar addObject:[im trimString]];
        }
    }

    cell.imgCount=ar.count;
    cell.data=_data;
    cell.delegect=self;
    cell.time.text =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"create_time"]];
    cell.line.backgroundColor=blackLineColore;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text=@"店铺评价";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    [UIView animateWithDuration:.3 animations:^{
        _scroll.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self setScrollhident:YES];
    }];
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)imageChange:(NSIndexPath *)indexPath imgCount:(NSInteger)index Selected:(NSInteger)sindex{
    for (UIView *vi in _scroll.subviews) {
        [vi removeFromSuperview];
    }
    _page.numberOfPages=index;
    NSLog(@"%ld",(long)index);
    [self setScrollhident:NO];
    _scroll.backgroundColor=[UIColor blackColor];

    _page.currentPage = sindex;
    _scroll.bouncesZoom=YES;
    float setY=0;
    for (int i=0; i<index; i++) {
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(setY, 0, self.view.width, self.view.height)];
        [im setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_data[indexPath.row][[NSString stringWithFormat:@"img%d",i+1]]]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        im.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change)];
        [im addGestureRecognizer:tap];
        im.contentMode=UIViewContentModeScaleAspectFit;
        setY=im.right;
        [_scroll addSubview:im];
        _scroll.contentSize = CGSizeMake(im.right, self.view.height);
    }
    CGRect frame = _scroll.frame;
    frame.origin.x = frame.size.width *_page.currentPage;
    frame.origin.y = 0;
       [_scroll scrollRectToVisible:frame animated:NO];
}
-(void)change{

    [UIView animateWithDuration:.3 animations:^{
        _scroll.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
         [self setScrollhident:YES];
        
    } completion:^(BOOL finished) {
       
        
    }];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   int q = scrollView.contentOffset.x/self.view.width;
    _page.currentPage=q;

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
