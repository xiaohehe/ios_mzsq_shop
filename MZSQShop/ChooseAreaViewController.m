//
//  ChooseAreaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChooseAreaViewController.h"
#import "ChooseAreaTableViewCell.h"
//#import "QueDingAreaViewController.h"
#import "HelpTableViewCell.h"
#import "ShengConditionViewController.h"
#import "ShiConditionViewController.h"
#import "XianConditionViewController.h"
#import "ZhenConditionViewController.h"
#import "ChineseToPinyin.h"
@interface ChooseAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *ValueArr;
@property(nonatomic,strong)NSDictionary *Sheng,*Shi,*Xian,*Com;
@property(nonatomic,strong)NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray *existTitles;
@end

@implementation ChooseAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self BigTableVi];
    [self.view addSubview:self.activityVC];
}


-(void)BigTableVi{
    
    _ValueArr=@[@"",@"",@"",@""];
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.rowHeight=44*self.scale;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"省份",@"城市",@"区域",@"社区"];
    HelpTableViewCell *cell = (HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = arr[indexPath.row];
    cell.nameLabel.text = _ValueArr[indexPath.row];
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    [self newHead];


    return cell;
}
-(void)newHead{
    UIView *bigVi =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200*self.scale)];
    _table.tableFooterView=bigVi;
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 70*self.scale)];
    la.text = @"社区只能选择已经开通的，如您想服务的社区还未开通拇指社区，请申请开通新社区或访问www.mzsq.com，联系客服人员";//bigVi
    la.numberOfLines=0;
    la.font = DefaultFont(self.scale);
    [bigVi addSubview:la];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10*self.scale,la.bottom+10*self.scale,self.view.width-20*self.scale,30*self.scale);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = BigFont(self.scale);
    btn.layer.cornerRadius=4.0f;
    [btn addTarget:self action:@selector(queDing:) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:btn];


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ShengConditionViewController *shengVC=[[ShengConditionViewController alloc]init];
            shengVC.titlename=@"选择省份";
            [shengVC selectedCity:^(NSDictionary *FirstObject) {
                _Sheng=[FirstObject mutableCopy];
                _Shi=nil;
                _Xian=nil;
                _Com=nil;
                _ValueArr=@[[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"name"]],@"",@"",@""];
                [_table reloadData];
            }];
            [self.navigationController pushViewController:shengVC animated:YES];
        }
            break;
            
        case 1:
        {
            if (!_Sheng) {
                [self ShowAlertWithMessage:@"选择省份"];
                return;
            }
            ShiConditionViewController *shiVC=[[ShiConditionViewController alloc]init];
            shiVC.titlename=@"选择城市";
            [shiVC selectedCityByShengID:[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"id"]] Block:^(NSDictionary *ShiObj) {
                _Shi=[ShiObj mutableCopy];
                _Xian=nil;
                _Com=nil;
                _ValueArr=@[[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"name"]],@"",@""];
                 [_table reloadData];
            }];
            [self.navigationController pushViewController:shiVC animated:YES];
        }
            break;
            
        case 2:
        {
            if (!_Shi) {
                [self ShowAlertWithMessage:@"选择城市"];
                return;
            }
            XianConditionViewController *xianVC=[[XianConditionViewController alloc]init];
            [xianVC selectedAreaByCityID:[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"id"]] Block:^(NSDictionary *Xian) {
                _Xian=[Xian mutableCopy];
                _Com=nil;
                _ValueArr=@[[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"name"]],@""];
                [_table reloadData];
            }];
            [self.navigationController pushViewController:xianVC animated:YES];
        }
            break;
            
        case 3:
        {
            if (!_Xian) {
                [self ShowAlertWithMessage:@"选择区县"];
                return;
            }
            ZhenConditionViewController *zhenVc=[[ZhenConditionViewController alloc]init];
            zhenVc.MaxNum=_MaxNum;
            zhenVc.nowNum=_nowNum;
            zhenVc.nowComArr=[_nowComArr mutableCopy];
            [zhenVc selectedZhenByAreaID:[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"id"]] PID:[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"id"]] CID:[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"id"]] Block:^(NSDictionary *Zhen, BOOL pop) {
                if (Zhen) {
                    NSString *ID=@"";
                    NSString *Name=@"";
                    for (id key  in [Zhen allKeys]) {
                        ID = [NSString stringWithFormat:@"%@,%@",ID,key];
                        Name = [NSString stringWithFormat:@"%@,%@",Name,[[Zhen objectForKey:key] objectForKey:@"name"]];
                    }
                    if (ID.length>0) {
                        ID=[ID substringFromIndex:1];
                        Name=[Name substringFromIndex:1];
                    }
                    
                    _Com=@{@"id":ID,@"name":Name};
                    _ValueArr=@[[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_Com objectForKey:@"name"]]];
                    [_table reloadData];
                }else{
                     [self.navigationController popViewControllerAnimated:NO];
                }
            }];
             [self.navigationController pushViewController:zhenVc animated:YES];
        }
            break;
            
        default:
            break;
    }


}

-(void)queDing:(UIButton *)sender{
    
    if(!_Com){
        [self ShowAlertWithMessage:@"选择想要认证的社区"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    
    [analy AddServeCommunityWithWithUser_ID:[Stockpile sharedStockpile].ID Community_id:[NSString stringWithFormat:@"%@",[_Com objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];

}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"选择想要认证的小区";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];

    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
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
