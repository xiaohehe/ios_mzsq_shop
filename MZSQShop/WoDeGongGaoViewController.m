//
//  WoDeGongGaoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WoDeGongGaoViewController.h"
#import "FaBuGongGaoViewController.h"
#import "GongGaoInfoViewController.h"
#import "LiuYanTableViewCell.h"
#import "ShareTableViewCell.h"
#import "IntroControll.h"
@interface WoDeGongGaoViewController ()<UITableViewDataSource,UITableViewDelegate,ShareTableViewCellDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UILabel *la;
@property(nonatomic,strong)IntroControll *IntroV;
@end

@implementation WoDeGongGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    _dataSource = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
  
    //[self reshData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self headr];
}
-(void)reshData{
    [_la removeFromSuperview];
    _index++;
    AnalyzeObject *anle = [AnalyzeObject new];
  [self.activityVC startAnimating];
    NSDictionary *dic = @{@"user_id":[Stockpile sharedStockpile].ID,@"notice_type":@"2",@"pindex":[NSNumber numberWithInteger:_index]};
    [anle getNoticeListwithDic:dic WithBlock:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_index==1) {
            [_dataSource removeAllObjects];
            _tableView.footer.hidden=NO;
        }
        if ([code isEqualToString:@"0"]) {
                [_dataSource addObjectsFromArray:models];
        }
            [_tableView reloadData];
        if (_dataSource.count<=0) {
            _la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
            _la.text=@"暂无公告信息！";
            _la.textAlignment=NSTextAlignmentCenter;
            [self.view addSubview:_la];
            _tableView.footer.hidden=YES;
        }

        
    }];
}
-(void)newView{
    _tableView=[[UITableView  alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[ShareTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footr)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headr)];

    [self.view addSubview:_tableView];
}

-(void)footr{
    [self reshData];
}

-(void)headr{
    _index=0;
    [self reshData];
}


#pragma mark - 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.activityVC];
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.activityVC startAnimating];
        AnalyzeObject *anle = [AnalyzeObject new];
       

    NSDictionary *dic = @{@"user_id":[Stockpile sharedStockpile].ID,@"notice_id":_dataSource[indexPath.row][@"id"]};
        [anle delNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            if ([code isEqualToString:@"0"]) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                _index=0;
                [self reshData];
            }
            [self.activityVC stopAnimating];
        }];
    }




}

-(void)bianij:(UIButton *)btn{
    //NSMutableArray *data = [NSMutableArray new];
    self.hidesBottomBarWhenPushed=YES;
    FaBuGongGaoViewController *fabu = [FaBuGongGaoViewController new];
    fabu.conteent = _dataSource[btn.tag-1][@"content"];
    fabu.titlee = _dataSource[btn.tag-1][@"title"];

    fabu.gongid = _dataSource[btn.tag-1][@"id"];
    fabu.bian=YES;
  //  fabu.imgData=data;
    [self.navigationController pushViewController:fabu animated:YES];
    
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic =  [_dataSource objectAtIndex:indexPath.row];
    
    ShareTableViewCell *cell=(ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.HeaderImage.tag=indexPath.row;
   [cell.HeaderImage setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].nickName] forState:UIControlStateNormal];
    NSDictionary *model=[Stockpile sharedStockpile].model;
    NSString *ShopName=@"";
    if (model && [model objectForKey:@"shop_info"]) {
        ShopName=[NSString stringWithFormat:@"%@",model[@"shop_info"][@"shop_name"]];
    }
       [cell.headBtn setTitle:[NSString stringWithFormat:@"%@",[ShopName EmptyStringByWhitespace] ] forState:UIControlStateNormal];
    
    NSMutableArray *a = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = [dic objectForKey:str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    cell.ContentLabel.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"] ]EmptyStringByWhitespace];
 
    cell.imgCount=a.count;
    cell.imgData=a;
    cell.DateLabel.text =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"create_time"] ]EmptyStringByWhitespace];
    cell.delegate=self;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dic =  [_dataSource objectAtIndex:indexPath.row];
    NSMutableArray *ar = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = [dic objectForKey:str];
        if (![na isEqualToString:@""]) {
            [ar addObject:na];
        }
    }
    float imgH = 0;
    if (ar.count<=0) {
        imgH = 0;
    }
    float W=(self.view.width-100*self.scale)/3;
    if (ar.count<4 && ar.count>0) {
        imgH = W*0.75+5*self.scale;
    }else if (ar.count<7 && ar.count>0){
         imgH = W*0.75+(W-5*self.scale);
    }else if (ar.count<10 && ar.count>0){
          imgH = W*0.75+(W-5*self.scale)*2;
    }
    NSString *content = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"] ]EmptyStringByWhitespace];
    if (content.length>0) {
            return imgH+100*self.scale;
    }
    
    return imgH+65*self.scale;

   // return 64*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//去编辑公告
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
  GongGaoInfoViewController *gonggao = [GongGaoInfoViewController new];
    gonggao.type=@"2";
    gonggao.gongID = _dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:gonggao animated:YES];
}
#pragma mark - 大图
-(void)BigImageTableViewCellWith:(NSIndexPath *)indexPath ImageIndex:(NSInteger)index{
    NSMutableArray *a = [NSMutableArray new];
    
   NSDictionary *dic =  [_dataSource objectAtIndex:indexPath.row];
    
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"img%d",i+1];
        NSString *na = [dic objectForKey:str];
        if (![na isEqualToString:@""]) {
            [a addObject:na];
        }
    }
    
    NSLog(@"******* %@",a);
    NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i <a.count; i ++) {
        
        IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",a[i]]];
        [pagesArr addObject:model1];
    }
    
    _IntroV = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
  //  _IntroV.delegate=self;
    [_IntroV index:index-1];
    
    [self.appdelegate.window addSubview:_IntroV];
    
}


#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"我的公告";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.NavImg.height, self.TitleLabel.top, self.NavImg.height, self.TitleLabel.height)];
    [SaveButton setTitle:@"发公告" forState:UIControlStateNormal];
    SaveButton.titleLabel.font=DefaultFont(self.scale);
    [SaveButton addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveButton];
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)NextButtonEvent:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    FaBuGongGaoViewController *fabuVC=[[FaBuGongGaoViewController alloc]init];
    fabuVC.bian=NO;
    [self.navigationController pushViewController:fabuVC animated:YES];
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
