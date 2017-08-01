//
//  FuWuSheZhiViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuSheZhiViewController.h"
#import "FuWuManagerTableViewCell.h"
#import "AddFuWuViewController.h"
@interface FuWuSheZhiViewController ()<UITableViewDataSource,UITableViewDelegate,FuWuManagerTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@end

@implementation FuWuSheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self MoreList];
}
-(void)MoreList{

    _index++;
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ServeItemListWithWithUser_ID:[Stockpile sharedStockpile].ID Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
    FuWuManagerTableViewCell *cell=(FuWuManagerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.NameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"item_name"]];
    cell.indexPath=indexPath;
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)ManagerFuWuByIndexPath:(NSIndexPath *)indexPath IsDel:(BOOL)isdel{
    if (isdel) {
        [self DelButtonEvent:indexPath];
    }else{
        NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
        [self ADdFuWu:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] Name:[NSString stringWithFormat:@"%@",[dic objectForKey:@"item_name"]]];
    }
}
-(void)DelButtonEvent:(NSIndexPath *)button{
    [self ShowAlertTitle:@"确定删除该分类？" Message:nil  Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            NSDictionary *dic=[_dataSource objectAtIndex:button.row];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelServeItemWithWithUser_ID:[Stockpile sharedStockpile].ID ServeItem_id:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimating];
                [self ShowAlertWithMessage:msg];
                if ([code isEqualToString:@"0"]) {
                    [_dataSource removeObjectAtIndex:button.row];
                    [_tableView reloadData];
                }
                
            }];
        }
    }];
}

-(void)newView{
    _dataSource=[NSMutableArray new];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MoreList)];
    [_tableView registerClass:[FuWuManagerTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}
-(void)ADdFuWu:(NSString *)ID Name:(NSString *)name{
    self.hidesBottomBarWhenPushed=YES;
    AddFuWuViewController *addfuVc=[[AddFuWuViewController alloc]initWithBlock:^{
        _index=0;
        [self MoreList];
    }];
    addfuVc.ID=ID;
    addfuVc.Name=name;
    [self.navigationController pushViewController:addfuVc animated:YES];
}
#pragma mark -----导航
-(void)newNav{
    self.TitleLabel.text=@"服务设置";
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
-(void)saveBtnEvent:(UIButton *)sender{
    [self ADdFuWu:nil Name:nil];
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
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
