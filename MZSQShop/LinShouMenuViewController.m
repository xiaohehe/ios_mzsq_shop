//
//  LingShouMenuViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LinShouMenuViewController.h"
#import "HelpTableViewCell.h"
#import "LinShouTypeViewController.h"



@interface LinShouMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)LingShouMenuBlock block;
@property(nonatomic,strong)UIView *HeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSArray *valueSource;
@property(nonatomic,strong) LinShouTypeViewController *shengVC;
@end

@implementation LinShouMenuViewController

-(void)SelectedShopType:(NSString *)shopType Block:(LingShouMenuBlock)block{
   _block=block;
    _StopType=shopType;
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
    _shengVC=[[LinShouTypeViewController alloc]init];
    _shengVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [self.view addSubview:_shengVC.view];

}
-(void)ReshValue{
    NSString *sheng=@"";
    NSString *shi=@"";
    NSString *xian=@"";
    NSString *zhen=@"";
    _valueSource=@[sheng,shi,xian,zhen];
    [_tableView reloadData];
}
-(void)newView{
    _dataSource=@[@"电商",@"实体"];
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
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataSource count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HelpTableViewCell *cell=(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.title=[NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    cell.HeaderImg.hidden=YES;
    cell.nameLabel.text=_valueSource[indexPath.row];
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    cell.rigthImg.hidden=YES;
    cell.bottomline.hidden=NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
      _block([NSDictionary dictionaryWithObjectsAndKeys:_StopType,@"shopType",@(indexPath.row+1),@"weishang",[_dataSource objectAtIndex:indexPath.row],@"name", nil],nil);
     self.view.frame = CGRectMake(self.view.width, 0, self.view.width , self.view.height);
 /*  [_shengVC ReshViewByAID:_StopType Name:@"选择类型" Block:^(NSDictionary *Zhen) {
        _block([NSDictionary dictionaryWithObjectsAndKeys:_StopType,@"shopType",@(indexPath.row+1),@"weishang", nil],Zhen);
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width , self.view.height);
    }];
    [UIView animateWithDuration:.3 animations:^{
        _shengVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
    }];*/
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
    NameLabel.text=@"选择类型";
    [_HeaderView addSubview:NameLabel];
    
   /* UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(_HeaderView.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=Big15Font(1);
    SaveBtn.tag=6;
    [SaveBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:SaveBtn];*/
}
-(void)SaveBtnVC:(id)sender{
    /*if (_block) {
        _block(_Sheng,_Shi,_Xian,_Zhen);
        [self PopVC:nil];
    }*/
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
