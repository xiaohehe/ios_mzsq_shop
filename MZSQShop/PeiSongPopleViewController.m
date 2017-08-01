//
//  PeiSongPopleViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PeiSongPopleViewController.h"
#import "PeiSongPopleTableCell.h"
#import "AddPopleViewController.h"

@interface PeiSongPopleViewController ()<UITableViewDelegate,UITableViewDataSource,PeiSongPopleTableCellDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)PeiSongBlock block;
@end

@implementation PeiSongPopleViewController
-(id)initWithBlock:(PeiSongBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self BigTableVi];
    [self returnVi];
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
    [analy StaffListWithUser_id:[Stockpile sharedStockpile].ID Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_table.footer endRefreshing];
        NSArray *Arr=models;
        if (_index==1) {
            _table.footer.hidden=NO;
            [_dataSource removeAllObjects];
        }
        if([code isEqualToString:@"0"] &&Arr){
            [_dataSource addObjectsFromArray:Arr];
        }
        if (!Arr || Arr.count<FenYe || !models || [code isEqualToString:@"1"]) {
            _table.footer.hidden=YES;
        }
        [_table reloadData];
    }];
}
-(void)BigTableVi{
    _dataSource=[[NSMutableArray alloc]init];
    _table =[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.rowHeight = 70.0f;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.backgroundColor=superBackgroundColor;
    [_table registerClass:[PeiSongPopleTableCell class] forCellReuseIdentifier:@"cell"];
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MoreList)];
    [self.view addSubview:_table];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
    PeiSongPopleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.tele.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mobile"]];
    cell.indexPath=indexPath;
    //cell.delegate=self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
    if (_block) {
        _block(dic);
        [self PopVC:nil];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShowAlertTitle:@"提示" Message:@"是否确定要删除该配送人员" Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            [self.activityVC startAnimating];
             NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelStaffWithUser_id:[Stockpile sharedStockpile].ID Staff_ID: [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimating];
                [self ShowAlertWithMessage:msg];
                if ([code isEqualToString:@"0"]) {
                    _index=0;
                     [self MoreList];
                }
               
            }];
        }
    }];
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"配送人员设置";
    
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
    AddPopleViewController *add = [[AddPopleViewController alloc]initWithBlock:^{
        _index=0;
        [self MoreList];
    }];
    [self.navigationController pushViewController:add animated:YES];
    
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
