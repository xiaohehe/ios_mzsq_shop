//
//  ShopTypeManagerViewController.m
//  MZSQShop
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopTypeManagerViewController.h"
#import "ServiceAreaTableViewCell.h"
#import "AddShangJiaTypeViewController.h"
@interface ShopTypeManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableDictionary *SelectedType;
@property(nonatomic,strong)ShopTypeBlock block;
@end

@implementation ShopTypeManagerViewController
-(id)initWithBlock:(ShopTypeBlock)block{
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
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ShopUsermyServeTypeList2WithShop_type:_shop_type Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        NSArray *Arr=models;
        [_dataSource removeAllObjects];
        if (Arr && Arr.count>0) {
            [_dataSource addObjectsFromArray:Arr];
        }
        [self SelectedDic:_dataSource];
        if (_dataSource.count>0) {
            [self newFooterView];
        }
        [_tableView reloadData];
        
    }];
}
-(void)SelectedDic:(NSArray *)Arr{
    if (_SelectedTypeDic) {
    NSString *key =[NSString stringWithFormat:@"%@",[_SelectedTypeDic objectForKey:@"id"]];
       [_SelectedType setObject:_SelectedTypeDic forKey:key];
    }
   /* for (NSDictionary *dic in Arr) {
        NSString *key =[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        if ([[dic objectForKey:@"selected"] integerValue] == 1) {
            [_SelectedType setObject:dic forKey:key];
        }
    }*/
}
-(void)newView{
    _dataSource=[[NSMutableArray alloc]init];
    _SelectedType=[NSMutableDictionary new];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) ];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ServiceAreaTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =[_dataSource objectAtIndex:indexPath.row];
    NSString *key =[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    ServiceAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contextLa.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]];
    cell.rightImg.selected=([_SelectedType objectForKey:key]!=nil);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =[_dataSource objectAtIndex:indexPath.row];
    NSString *key =[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    if ([_SelectedType objectForKey:key]) {
        [_SelectedType removeObjectForKey:key];
    }else{
        [_SelectedType removeAllObjects];
        [_SelectedType setObject:dic forKey:key];
    }
    [_tableView reloadData];
}

-(void)newFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_tableView.width, 80*self.scale)];
    footerView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:footerView];
    UIButton *tiJiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tiJiaoBtn.frame = CGRectMake(12*self.scale, 10*self.scale, footerView.width - 24*self.scale, 31*self.scale);
    [tiJiaoBtn setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    tiJiaoBtn.titleLabel.font=BigFont(self.scale);
    [tiJiaoBtn setTitle:@"确定提交" forState:UIControlStateNormal];
    [tiJiaoBtn addTarget:self action:@selector(tuiChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:tiJiaoBtn];
    
    WPHotspotLabel *TishiLabel=[[WPHotspotLabel alloc]initWithFrame:CGRectMake(tiJiaoBtn.left+10*self.scale, tiJiaoBtn.bottom+10*self.scale, tiJiaoBtn.width-20*self.scale, 35*self.scale)];
    TishiLabel.textAlignment=NSTextAlignmentRight;
    TishiLabel.numberOfLines=0;
    TishiLabel.attributedText=[@"如果以上没有你选择的类型,<help>点击申请</help>" attributedStringWithStyleBook:[self ActionType]];
    [footerView addSubview:TishiLabel];
}
-(NSDictionary *)ActionType{
    NSDictionary *style=@{
                          @"body":[UIFont systemFontOfSize:12*self.scale],
                          @"help":@[[UIColor redColor],[WPAttributedStyleAction styledActionWithAction:^{
                              NSLog(@"Help action");
                              [self nextView];
                          }]]
                          };
    return style;
    
}
-(void)nextView{
    
    AddShangJiaTypeViewController *addVC=[[AddShangJiaTypeViewController alloc]initWithBlock:^(NSString *typeName) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [self.navigationController pushViewController:addVC animated:YES];
}
-(void)tuiChuBtnClick:(id)sender{
        if([[_SelectedType allKeys] count]<1){
       [self ShowAlertWithMessage:@"请选择商铺类别"];
           return;
       }
    if (_block) {
        NSDictionary *dic =[[_SelectedType allValues] firstObject];
        _block(dic);
        [self PopVC:nil];
    }
   /* NSString *types=@"";
    for (NSString *key in [_SelectedType allKeys]) {
        types=[NSString stringWithFormat:@"%@,%@",types,key];
    }
    if (types.length>0) {
        types=[types substringFromIndex:1];
    }
    
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyServeTypeWithUser_ID:[Stockpile sharedStockpile].ID Serve_type:types Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];*/
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"商铺类别管理";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
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
