//
//  ServiceAreaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ServiceAreaViewController.h"
#import "ServiceAreaTableViewCell.h"
#import "ChooseAreaViewController.h"

@interface ServiceAreaViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)NSInteger maxNumber;
@end

@implementation ServiceAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self BigTableVi];
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
   [analy ServeCommunityListWithWithUser_ID:[Stockpile sharedStockpile].ID Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.footer endRefreshing];
       if (models) {
           NSArray *Arr=[models objectForKey:@"selected_community"];
           _maxNumber=[[models objectForKey:@"serve_comm_max_num"] integerValue];
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

       }
        [_tableView  reloadData];
    }];
}
-(void)BigTableVi{

    _dataSource=[[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ServiceAreaTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
   [self newRooter];
}
-(void)newRooter{
    UIView *RooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 35*self.scale)];
    UILabel *TiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, 35*self.scale)];
    TiLabel.font=Small10Font(self.scale);
    TiLabel.text=@"如果想要删除服务社区或添加更多的服务社区，请访问www.mzsq.com，查找所属服务站并联系管理人员";
    TiLabel.textColor=[UIColor redColor];
    TiLabel.numberOfLines=0;
    [RooterView addSubview:TiLabel];
    _tableView.tableFooterView = RooterView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =[_dataSource objectAtIndex:indexPath.row];
    ServiceAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contextLa.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    cell.rightImg.selected=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"selected"]] isEqualToString:@"1"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dic =[_dataSource objectAtIndex:indexPath.row];
    BOOL Sd=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"selected"]] isEqualToString:@"1"];
    NSString *ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    if (!Sd) {
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy AddServeCommunityWithWithUser_ID:[Stockpile sharedStockpile].ID Community_id:ID Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                _index=0;
                [self MoreList];
            }
        }];
    }else{
      /*  [self ShowAlertTitle:@"是否取消在该社区的服务？" Message:nil Delegate:self Block:^(NSInteger index) {
            if (index == 1) {
                [self.activityVC startAnimating];
                AnalyzeObject *analy=[[AnalyzeObject alloc]init];
                [analy DelServeCommunityWithWithUser_ID:[Stockpile sharedStockpile].ID Community_id:ID Block:^(id models, NSString *code, NSString *msg) {
                    [self.activityVC stopAnimating];
                    [self ShowAlertWithMessage:msg];
                    if ([code isEqualToString:@"0"]) {
                        _index=0;
                        [self MoreList];
                    }
                }];
            }
        }];*/
    }
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"已认证小区";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"新增" forState:UIControlStateNormal];
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
    
 if(_dataSource.count>=_maxNumber && _maxNumber>0){
        [self ShowAlertWithMessage:@"您所服务社区的数量已达上限，请联系我们服务更多社区！"];
        return;
    }
    self.hidesBottomBarWhenPushed=YES;
    ChooseAreaViewController *area = [ChooseAreaViewController new];
    area.MaxNum=_maxNumber;
    area.nowNum = _dataSource.count;
    area.nowComArr=[_dataSource mutableCopy];
    [self.navigationController pushViewController:area animated:YES];
    
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
