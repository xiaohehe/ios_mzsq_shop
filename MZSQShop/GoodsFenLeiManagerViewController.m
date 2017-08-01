//
//  GoodsFenLeiManagerViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsFenLeiManagerViewController.h"
#import "CellView.h"
#import "AddFenLeiViewController.h"
//#import "GoodsEditViewController.h"
#import "FenLeiTableViewCell.h"
#import "LeiBieGoodsListViewController.h"
@interface GoodsFenLeiManagerViewController ()<UITableViewDataSource,UITableViewDelegate,FenLeiTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;

@end

@implementation GoodsFenLeiManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self BigScrollVi];
    [self.view addSubview:self.activityVC];
   
}
-(void)viewWillAppear:(BOOL)animated{
    _index=0;
     [self MoreList];
}
-(void)MoreList{
    _index++;
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ProdClassListWithUser_id:[Stockpile sharedStockpile].ID Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.footer endRefreshing];
        NSArray *Arr=models;
        if (_index==1) {
            _tableView.footer.hidden=NO;
            [_dataSource removeAllObjects];
        }
        if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
            [_dataSource addObjectsFromArray:Arr];
        }
        if (!Arr || Arr.count<FenYe || !models || [code isEqualToString:@"1"]) {
            _tableView.footer.hidden=YES;
        }
        [_tableView  reloadData];
    }];
}
-(void)BigScrollVi{
    _dataSource=[NSMutableArray new];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
      [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MoreList)];
    [_tableView registerClass:[FenLeiTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.section];
    FenLeiTableViewCell *cell=(FenLeiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.NameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]];
    cell.NumberLabel.text=[NSString stringWithFormat:@"%@种商品",[dic objectForKey:@"prod_count"]];
    cell.indexPath=indexPath;
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *new=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    new.backgroundColor=superBackgroundColor;
    return new;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.section];
    LeiBieGoodsListViewController *lieBiaoVC=[[LeiBieGoodsListViewController alloc]init];
    lieBiaoVC.Name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]];
    lieBiaoVC.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:lieBiaoVC animated:YES];
    
    
}
-(void)ManagerFenLeiByIndexPath:(NSIndexPath *)indexPath IsDel:(BOOL)isdel{
    if (isdel) {
        [self DelButtonEvent:indexPath];
    }else{
        [self EditButtonEvent:indexPath];
    }
}
-(void)EditButtonEvent:(NSIndexPath *)sender{
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary *dic=[_dataSource objectAtIndex:sender.section];
    AddFenLeiViewController *AddVC=[[AddFenLeiViewController alloc]initWithBlock:^{
        _index=0;
        [self MoreList];
    }];
    AddVC.Name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]];
    AddVC.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self.navigationController pushViewController:AddVC animated:YES];
}
-(void)DelButtonEvent:(NSIndexPath *)button{
    [self ShowAlertTitle:@"确定删除该分类？" Message:@"删除后，该分类下所有商品将会被删除"  Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
             NSDictionary *dic=[_dataSource objectAtIndex:button.section];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelProdClassWithUser_id:[Stockpile sharedStockpile].ID Class_id:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimating];
                [self ShowAlertWithMessage:msg];
                if ([code isEqualToString:@"0"]) {
                    [_dataSource removeObjectAtIndex:button.section];
                    [_tableView reloadData];
                }
                
            }];
        }
    }];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"商品分类管理";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"添加" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    AddFenLeiViewController *fenlei = [[AddFenLeiViewController alloc]init];
    [self.navigationController pushViewController:fenlei animated:YES];
    
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
