//
//  OnSellGoodsViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OnSellGoodsViewController.h"
#import "GoodsEditTableViewCell.h"
//#import "ChangeGoodsViewController.h"
//#import "GoodsXiangQingViewController.h"
#import "AddGoodsInfoViewController.h"
#include "CellView.h"
@interface OnSellGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GoodsEditTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)CellView *ToolView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableDictionary *GoodsDic;
@property(nonatomic,strong)NSString *Key;
@property(nonatomic,strong)UIView *bigVi;
@end

@implementation OnSellGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
      [self serachVi];
    [self BigTableVi];
    [self bottomVi];
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
    [analy ProdListWithUser_ID:[Stockpile sharedStockpile].ID Class_id:@"" Status:@"1" Keyword:_Key Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.footer endRefreshing];
        NSArray *Arr=models;
        if (_index==1) {
            _tableView.footer.hidden=NO;
            [_dataSource removeAllObjects];
            UIButton *Btn=(UIButton *)[self.view viewWithTag:100];
            Btn.selected=NO;
        }
        if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
            [_dataSource addObjectsFromArray:Arr];
        }
        if (!Arr || Arr.count<FenYe || !models || [code isEqualToString:@"1"]) {
            _tableView.footer.hidden=YES;
        }
           _bigVi.hidden=_dataSource.count<1;
        [_tableView  reloadData];
    }];
}
-(void)BigTableVi{
    _dataSource = [[NSMutableArray alloc]init];
    _GoodsDic=[NSMutableDictionary new];
    _Key=@"";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.ToolView.bottom, self.view.width, self.view.height-self.ToolView.bottom-35*self.scale) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.rowHeight = 95.0f*self.scale;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=superBackgroundColor;
      [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(MoreList)];
    [_tableView registerClass:[GoodsEditTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
    GoodsEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSArray *Arr=[dic objectForKey:@"imgs"];
    NSString *Img=@"";
    if (Arr.count>0) {
        Img=[[NSString stringWithFormat:@"%@",Arr.firstObject] trimString];
        
    }
    [cell.headImg setImageWithURL:[NSURL URLWithString:Img] placeholderImage:[UIImage imageNamed:@"not_1"]];
    
    cell.yuanImg.selected=([_GoodsDic objectForKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]!=nil);
    cell.nameLa.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prod_name"]];
    cell.sales.text = [NSString stringWithFormat:@"销量:%@    库存:%@",[dic objectForKey:@"sales"],[dic objectForKey:@"inventory"]];
    cell.timeLa.text = [NSString stringWithFormat:@"时间:%@",[dic objectForKey:@"create_time"]];
    cell.numberLa.text =  [[NSString stringWithFormat:@"￥%@/%@",[dic objectForKey:@"price"],[dic objectForKey:@"unit"]] EmptyStringByWhitespace];
    cell.indexPath = indexPath;
    cell.delegate=self;
    return cell;
    
}
#pragma mark - GoodsEditTableViewCellDelegate
-(void)SelectedGoodsTableViewCellSelected:(BOOL)selected ForIndexPath:(NSIndexPath *)indexPath{
    
     NSDictionary *dic=[_dataSource objectAtIndex:indexPath.row];
    if (selected) {
        [_GoodsDic setObject:dic forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }else{
        [_GoodsDic removeObjectForKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
    }
    NSArray *AllKey=[_GoodsDic allKeys];
    UIButton *Btn=(UIButton *)[self.view viewWithTag:100];
    Btn.selected=(AllKey.count==_dataSource.count);
}
-(void)ManagerGoodsTableViewCellIsEdit:(BOOL)isEdit ForIndexPath:(NSIndexPath *)indexPath{
    if (isEdit) {
        [self EditButtonEvent:indexPath];
    }else{
        [self DelButtonEvent:indexPath];
    }
}
-(void)EditButtonEvent:(NSIndexPath *)sender{
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary *dic=[_dataSource objectAtIndex:sender.row];
    AddGoodsInfoViewController *AddGoodsVc=[[AddGoodsInfoViewController alloc]initWithBlock:^{
        _index=0;
        [self MoreList];
    }];
    NSArray *Arr=[dic objectForKey:@"imgs"];
    AddGoodsVc.name=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"prod_name"]] EmptyStringByWhitespace];
    AddGoodsVc.price=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]] EmptyStringByWhitespace];
    AddGoodsVc.inventory=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"inventory"]] EmptyStringByWhitespace];
    AddGoodsVc.desc=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]] EmptyStringByWhitespace];
    AddGoodsVc.ID=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] EmptyStringByWhitespace];
    AddGoodsVc.class_id=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_id"]] EmptyStringByWhitespace];
      AddGoodsVc.class_Name=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]] EmptyStringByWhitespace];
    AddGoodsVc.unit=[[[NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]] EmptyStringByWhitespace] EmptyStringByWhitespace];
    AddGoodsVc.origin_price =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"origin_price"]] EmptyStringByWhitespace];
    AddGoodsVc.inventroty_alarm =[[NSString stringWithFormat:@"%@",[dic objectForKey:@"inventroty_alarm"]] EmptyStringByWhitespace];
    AddGoodsVc.imgArr=[Arr mutableCopy];
    [self.navigationController pushViewController:AddGoodsVc animated:YES];
}
-(void)DelButtonEvent:(NSIndexPath *)button{
    [self ShowAlertTitle:@"确定删除该产品？" Message:nil  Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            NSDictionary *dic=[_dataSource objectAtIndex:button.row];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelProdWithUser_ID:[Stockpile sharedStockpile].ID Prod_id:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
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
#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _Key=[textField.text trimString];
    _index=0;
    [self MoreList];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
      [self.view endEditing:YES];
}

-(void)toGoodsXiangQingVC{
    self.hidesBottomBarWhenPushed=YES;
    //GoodsXiangQingViewController *goods = [GoodsXiangQingViewController new];
   // [self.navigationController pushViewController:goods animated:YES];
}

-(void)chooseEvent:(UIButton *)sender{
    sender.selected =!sender.selected;
    if (sender.selected) {
        for (NSDictionary *dic in _dataSource) {
             [_GoodsDic setObject:dic forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
        }
    }else{
        [_GoodsDic removeAllObjects];
    }
       [_tableView reloadData];
}

-(void)serachVi{
        _ToolView=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 50*self.scale)];
        _ToolView.backgroundColor=superBackgroundColor;
        [self.view addSubview:_ToolView];
        
        UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10, self.view.width-20*self.scale, 32*self.scale)];
        SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
        SearchBG.userInteractionEnabled=YES;
        [_ToolView addSubview:SearchBG];
        
    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(SearchBG.width-SearchBG.height, 0, SearchBG.height, SearchBG.height)];
    IconImage.image=[UIImage imageNamed:@"search"];
    [SearchBG addSubview:IconImage];
    UITextField *searchText=[[UITextField alloc]initWithFrame:CGRectMake(8*self.scale, 0, SearchBG.width-IconImage.height-5*self.scale , SearchBG.height)];
        searchText.font=DefaultFont(self.scale);
        searchText.placeholder=@"请输入店名/商品";
        searchText.delegate=self;
        [SearchBG addSubview:searchText];

}
#pragma mark----底部面板，， 全选，  删除按钮
-(void)bottomVi{
    _bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.bottom, self.view.width, 35*self.scale)];
    _bigVi.backgroundColor = [UIColor whiteColor];
    _bigVi.userInteractionEnabled=YES;
    [self.view addSubview:_bigVi];
    
    
    UIButton *yuanImg = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, _bigVi.height/2-8*self.scale, 45*self.scale, 16*self.scale)];
    [yuanImg setImage:[UIImage imageNamed:@"choose_01"] forState:UIControlStateNormal];
    [yuanImg setImage:[UIImage imageNamed:@"choose_02"] forState:UIControlStateSelected];
   // yuanImg.backgroundColor=[UIColor redColor];
    yuanImg.imageEdgeInsets=UIEdgeInsetsMake(0, -14*self.scale, 0, 14*self.scale);
    yuanImg.selected=NO;
    [yuanImg addTarget:self action:@selector(chooseEvent:) forControlEvents:UIControlEventTouchUpInside];
    yuanImg.tag = 100;
    [_bigVi addSubview:yuanImg];
    UILabel *quanXuanLa = [[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 0, 30*self.scale, yuanImg.height)];
    quanXuanLa.text=@"全选";
    quanXuanLa.font=SmallFont(self.scale);
    [yuanImg addSubview:quanXuanLa];
    
    UIButton *xiaJiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiaJiaBtn.backgroundColor = blueTextColor;
    xiaJiaBtn.frame = CGRectMake(self.view.width-120*self.scale, _bigVi.height/2-10*self.scale, 50*self.scale, 20*self.scale);
    xiaJiaBtn.layer.cornerRadius=3.0f;
    [xiaJiaBtn setTitle:@"下架" forState:UIControlStateNormal];
    xiaJiaBtn.titleLabel.font = BoldSmallFont(self.scale);
    [xiaJiaBtn addTarget:self action:@selector(ShangJiaButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigVi addSubview:xiaJiaBtn];
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.backgroundColor = [UIColor redColor];
    deleBtn.frame = CGRectMake(xiaJiaBtn.right+10*self.scale, _bigVi.height/2-10*self.scale, 50*self.scale, 20*self.scale);
    deleBtn.layer.cornerRadius=3.0f;
    [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleBtn.titleLabel.font = BoldSmallFont(self.scale);
    [deleBtn addTarget:self action:@selector(DeleBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_bigVi addSubview:deleBtn];
    
}
-(void)ShangJiaButtonEvent:(id)sender{
    NSArray *AllKey=[_GoodsDic allKeys];
    if (AllKey.count<1) {
        [self ShowAlertWithMessage:@"请选择商品"];
        return;
    }
    [self ShowAlertTitle:@"提示" Message:@"是否要下架选中的商品" Delegate:self Block:^(NSInteger index) {
        if (index==1) {
            NSString *IDS=@"";
            for (id key in AllKey) {
                IDS=[NSString stringWithFormat:@"%@,%@",IDS,key];
            }
            IDS=[IDS substringFromIndex:1];
            [self.activityVC startAnimating];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy OnOffShelveProdWithUser_ID:[Stockpile sharedStockpile].ID Prod_id:IDS State:@"2" Block:^(id models, NSString *code, NSString *msg) {
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
-(void)DeleBtnEvent:(UIButton *)sender{
    
    NSArray *AllKey=[_GoodsDic allKeys];
    if (AllKey.count<1) {
        [self ShowAlertWithMessage:@"请选择商品"];
        return;
    }
    NSString *IDS=@"";
    for (id key in AllKey) {
        IDS=[NSString stringWithFormat:@"%@,%@",IDS,key];
    }
    IDS=[IDS substringFromIndex:1];
    
    [self ShowAlertTitle:@"确定删除选中的商品？" Message:nil  Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
          
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelProdWithUser_ID:[Stockpile sharedStockpile].ID Prod_id:IDS Block:^(id models, NSString *code, NSString *msg) {
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
    
    self.TitleLabel.text=@"在售商品列表";
    
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
