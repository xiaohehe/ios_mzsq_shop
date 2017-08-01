//
//  MenuViewController.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MenuViewController.h"
#import "HelpTableViewCell.h"

#import "ShengViewController.h"
#import "ShiViewController.h"
#import "XianViewController.h"
#import "ZhenViewController.h"
@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MenuBlock block;
@property(nonatomic,strong)UIView *HeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *valueSource;
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,strong) ShengViewController *shengVC;
@property(nonatomic,strong) ShiViewController *shiVC;
@property(nonatomic,strong) XianViewController *xianVC;
@property(nonatomic,strong) ZhenViewController *zhenVC;
@end
@implementation MenuViewController
-(id)initWithBlock:(MenuBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
-(void)SelectedNum:(NSInteger)num Block:(MenuBlock)block{
    _num=num;
     _block=block;
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self Header];
    [self ReshValue];
    [self newView];
    [self ShengShiXianZhen];
}
-(void)ShengShiXianZhen{
    //省
    _shengVC=[[ShengViewController alloc]init];
    _shengVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    _shengVC.isMenu=YES;
    [self.view addSubview:_shengVC.view];
    //市
    _shiVC=[[ShiViewController alloc]init];
    _shiVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    _shiVC.isMenu=YES;
    [self.view addSubview:_shiVC.view];
    //县
    _xianVC=[[XianViewController alloc]init];
    _xianVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    _xianVC.isMenu=YES;
    [self.view addSubview:_xianVC.view];
    //镇
    _zhenVC=[[ZhenViewController alloc]init];
    _zhenVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    _zhenVC.isMenu=YES;
    [self.view addSubview:_zhenVC.view];
}
-(void)ReshValue{
    NSString *sheng=@"";
    NSString *shi=@"";
    NSString *xian=@"";
    NSString *zhen=@"";
    if (_Sheng) {
        sheng=[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"name"]];
    }
    if (_Shi) {
        shi=[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"name"]];
    }
    if (_Xian) {
        xian=[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"name"]];
    }
    if (_Zhen) {
        zhen=[NSString stringWithFormat:@"%@",[_Zhen objectForKey:@"name"]];
    }
     _valueSource=@[sheng,shi,xian,zhen];
    UIButton *btn=(UIButton *)[self.view viewWithTag:6];
    btn.hidden=YES;
    if (xian.length>0) {
        btn.hidden=NO;
    }
    [_tableView reloadData];
}
-(void)newView{
    _dataSource=@[@"省份",@"城市",@"区县",@"社区"];
   
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(_HeaderView.left, _HeaderView.bottom, _HeaderView.width, self.view.height-_HeaderView.bottom)];
    self.activityVC.frame=CGRectMake(_tableView.left, 0, _tableView.width, self.view.height);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.sectionIndexTrackingBackgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    _tableView.sectionIndexColor=grayTextColor;
    _tableView.sectionIndexBackgroundColor=superBackgroundColor;
    [_tableView registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self newRooter];
}
-(void)newRooter{
    UIView *RooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, 45*self.scale)];
    UILabel *TiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, RooterView.width-20*self.scale, 45*self.scale)];
    TiLabel.font=Small10Font(self.scale);
    TiLabel.text=@"社区只能选择已经开通的，如您想服务的社区还未开通拇指社区，请申请开通新社区或访问www.mzsq.com，联系客服人员";
    TiLabel.textColor=[UIColor redColor];
    TiLabel.numberOfLines=0;
    [RooterView addSubview:TiLabel];
    _tableView.tableFooterView = RooterView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_num<[_dataSource count] && _num!=0) {
        return _num;
    }
    return [_dataSource count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HelpTableViewCell *cell=(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.title=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.HeaderImg.hidden=YES;
    cell.nameLabel.text=_valueSource[indexPath.row];
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    cell.bottomline.hidden=NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [_shengVC ReshViewWithName:@"选择省份" Block:^(NSDictionary *Sheng, NSDictionary *Shi, NSDictionary *Xian, NSDictionary *Zhen) {
            _Sheng=[Sheng mutableCopy];
            _Shi=nil;
            _Xian=nil;
            _Zhen=nil;
              [self ReshValue];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _shengVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }else if (indexPath.row == 1){
        if (!_Sheng) {
            [self ShowAlertWithMessage:@"选择省份"];
            return;
        }
        [_shiVC ReshViewByPID:[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"id"]] Name:@"选择城市" Block:^(NSDictionary *Shi, NSDictionary *Xian, NSDictionary *Zhen) {
            _Shi=[Shi mutableCopy];
            _Xian=nil;
            _Zhen=nil;
              [self ReshValue];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _shiVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }else if (indexPath.row == 2){
        if (!_Shi) {
            [self ShowAlertWithMessage:@"选择城市"];
            return;
        }
        [_xianVC ReshViewByCID:[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"id"]] Name:@"选择区县" Block:^(NSDictionary *Xian, NSDictionary *Zhen) {
            _Xian=[Xian mutableCopy];
            _Zhen=nil;
              [self ReshValue];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _xianVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }else if (indexPath.row == 3){
        if (!_Xian) {
            [self ShowAlertWithMessage:@"选择区县"];
            return;
        }
        [_zhenVC selectedZhenByAreaID:[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"id"]] PID:[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"id"]] CID:[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"id"]] Name:@"选择想要认证的小区" Block:^(NSDictionary *Zhen) {
            _Zhen=[Zhen mutableCopy];
            [self ReshValue];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _zhenVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }
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
    NameLabel.textAlignment=NSTextAlignmentCenter;
    NameLabel.text=@"选择城市";
    [_HeaderView addSubview:NameLabel];
    
    UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(_HeaderView.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=Big15Font(1);
    SaveBtn.tag=6;
    [SaveBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:SaveBtn];
}
-(void)SaveBtnVC:(id)sender{
    if (_block) {
        _block(_Sheng,_Shi,_Xian,_Zhen);
        [self PopVC:nil];
    }
}
#pragma mark - 导航
-(void)newNav{
    self.NavImg.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
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
