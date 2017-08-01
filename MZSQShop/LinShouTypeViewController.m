//
//  LinShouTypeViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LinShouTypeViewController.h"
#import "ServiceAreaTableViewCell.h"
#import "AddShangJiaTypeViewController.h"
@interface LinShouTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)LinShouTypeBlock block;
@property(nonatomic,strong)UIView *HeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSMutableDictionary *ValueDic;
@end

@implementation LinShouTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self newNav];
    _dataSource=[[NSMutableArray alloc]init];
    _ValueDic=[NSMutableDictionary new];
    [self Header];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)ReshViewByAID:(NSString *)aid Name:(NSString *)name Block:(LinShouTypeBlock)block{
    _AID=aid;
    _Name=name;
   _block=block;
    [self ReshData];
    UILabel *NameLabel=(UILabel *)[self.view viewWithTag:5];
    NameLabel.text=@"选择类型";
}
-(void)ReshData{
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy ServeTypeListWithWithShop_type:_AID Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            NSArray *Arr=models;
             [_dataSource removeAllObjects];
            if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
               
                [_dataSource addObjectsFromArray:Arr];
            }
            if(_dataSource.count>0){
                [self newFooterView];
            }
            [_tableView  reloadData];
        }];
}
-(void)newView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(_HeaderView.left, _HeaderView.bottom, _HeaderView.width, self.view.height-_HeaderView.bottom)];
    self.activityVC.frame=CGRectMake(_tableView.left, 0, _tableView.width, self.view.height);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.sectionIndexTrackingBackgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    _tableView.sectionIndexColor=grayTextColor;
    _tableView.sectionIndexBackgroundColor=superBackgroundColor;
    [_tableView registerClass:[ServiceAreaTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataSource[indexPath.row];
    ServiceAreaTableViewCell *cell=(ServiceAreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.contextLa.text=[NSString stringWithFormat:@"%@",dic[@"class_name"]];
    NSString *key=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    cell.rightImg.selected=([_ValueDic objectForKey:key] !=nil);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    NSString *key=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    if ([_ValueDic objectForKey:key]) {
        [_ValueDic removeObjectForKey:key];
    }else{
        [_ValueDic setObject:dic forKey:key];
    }
    [tableView reloadData];
}
-(void)Header{
    _HeaderView=[[UIView alloc]initWithFrame:CGRectMake(80*self.scale, 0, self.view.width-80*self.scale, self.NavImg.height)];
    _HeaderView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_HeaderView];
    
    UIButton *CancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [CancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [CancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CancleBtn.titleLabel.font=Big15Font(1);
    [CancleBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:CancleBtn];
    
    UILabel *NameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CancleBtn.right+10,CancleBtn.top, _HeaderView.width-(CancleBtn.width+10)*2, CancleBtn.height)];
    NameLabel.font=self.TitleLabel.font;
    NameLabel.text=_Name;
    NameLabel.textAlignment=NSTextAlignmentCenter;
    NameLabel.tag=5;
    [_HeaderView addSubview:NameLabel];
    /*UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(_HeaderView.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=Big15Font(1);
    SaveBtn.hidden=YES;
    SaveBtn.tag=6;
    [SaveBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:SaveBtn];*/
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
    AddShangJiaTypeViewController *addVC=[[AddShangJiaTypeViewController alloc]initWithBlock:^(NSString *typeName){
        [self PopVC:nil];
    }];
    addVC.isModel=YES;
    [self presentViewController:addVC animated:NO completion:nil];
    //[self.navigationController pushViewController:addVC animated:YES];
}
-(void)tuiChuBtnClick:(id)sender{
    if([[_ValueDic allKeys] count]<1){
        [self ShowAlertWithMessage:@"请选择服务类"];
        return;
    }
    if (_block) {
        _block(_ValueDic);
        [self PopVC:nil];
    }
}
#pragma mark - 导航
-(void)newNav{
    self.NavImg.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}
-(void)PopVC:(id)sender{
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width , self.view.height);
    }];
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
