//
//  FuWuShopSettingViewController.m
//  MZSQShop
//
//  Created by apple on 2017/2/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FuWuShopSettingViewController.h"
#import "ShangjiaSettingTableViewCell.h"
#import "ShangPuLeiBieManagerViewController.h"
#import "PeiSongPriceViewController.h"
#import "ShopInfoManageViewController.h"
#import "ShopGongGaoViewController.h"
#import "ServiceAreaViewController.h"
#import "ShopTimeSetViewController.h"
#import "JieShouOrderSetViewController.h"
#import "PeiSongPopleViewController.h"
@interface FuWuShopSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *textArr;
@end

@implementation FuWuShopSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bigTableVi];
    [self returnVi];
}
#pragma mark---表格；
-(void)bigTableVi{
    _textArr=@[@"店铺基本信息设置",@"店铺公告",@"配送员工设置",@"配送费设置",@"营业时间设置",@"接单信息设置"];
    //_textArr=@[@"店铺基本信息设置",@"店铺公告",@"商铺类别管理",@"配送员工设置",@"配送费设置",@"营业时间设置",@"接单信息设置"];

    if (![[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
        _textArr=@[@"店铺基本信息设置",@"店铺公告",@"配送员工设置",@"营业时间设置",@"接单信息设置"];
        //_textArr=@[@"店铺基本信息设置",@"店铺公告",@"商铺类别管理",@"配送员工设置",@"营业时间设置",@"接单信息设置"];

    }
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.backgroundColor = superBackgroundColor;
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_table registerClass:[ShangjiaSettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    [self newRooter];
}
-(void)newRooter{
    UIView *RooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _table.width, 45*self.scale)];
    UILabel *TiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, RooterView.width-20*self.scale, 45*self.scale)];
    TiLabel.font=Small10Font(self.scale);
    TiLabel.text=@"店铺设置指南请访问www.mzsq.com,查看帮助中心";
    TiLabel.textColor=[UIColor redColor];
    TiLabel.numberOfLines=0;
    [RooterView addSubview:TiLabel];
    _table.tableFooterView = RooterView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShangjiaSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contextLa.text = _textArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
        switch (indexPath.row) {
            case 0:{
                
                ShopInfoManageViewController *info = [ShopInfoManageViewController new];
                [self.navigationController pushViewController:info animated:YES];
            }
                
                break;
                
            case 1:
            {
                ShopGongGaoViewController *gongGao = [ShopGongGaoViewController new];
                [self.navigationController pushViewController:gongGao animated:YES];
            }
                break;
                
            case 11:
            {
                ServiceAreaViewController *gongGao = [ServiceAreaViewController new];
                [self.navigationController pushViewController:gongGao animated:YES];
            }
                break;
                
            case 2:
            {
                ShangPuLeiBieManagerViewController *shangPuVc=[[ShangPuLeiBieManagerViewController alloc]init];
                [self.navigationController pushViewController:shangPuVc animated:YES];
            }
                break;
                
            case 3:
            {
                PeiSongPopleViewController *peisong = [PeiSongPopleViewController new];
                [self.navigationController pushViewController:peisong animated:YES];
                
            }
                break;
                
            case 4:
            {
                ShopTimeSetViewController *shoptimt = [ShopTimeSetViewController new];
                [self.navigationController pushViewController:shoptimt animated:YES];
                
                
            }
                break;
                
            case 5:
            {
                JieShouOrderSetViewController *order = [JieShouOrderSetViewController new];
                [self.navigationController pushViewController:order animated:YES];
                
                
            }
                break;
                
            default:
                break;
        }
        
        return;
    }
    
    switch (indexPath.row) {
        case 0:{
            
            ShopInfoManageViewController *info = [ShopInfoManageViewController new];
            [self.navigationController pushViewController:info animated:YES];
        }
            
            break;
            
        case 1:
        {
            ShopGongGaoViewController *gongGao = [ShopGongGaoViewController new];
            [self.navigationController pushViewController:gongGao animated:YES];
        }
            break;
            
        case 11:
        {
            ServiceAreaViewController *gongGao = [ServiceAreaViewController new];
            [self.navigationController pushViewController:gongGao animated:YES];
        }
            break;
            
        case 2:
        {
            ShangPuLeiBieManagerViewController *shangPuVc=[[ShangPuLeiBieManagerViewController alloc]init];
            [self.navigationController pushViewController:shangPuVc animated:YES];
        }
            break;
            
        case 3:
        {
            PeiSongPopleViewController *peisong = [PeiSongPopleViewController new];
            [self.navigationController pushViewController:peisong animated:YES];
            
        }
            break;
            
        case 4:{
            
            
            PeiSongPriceViewController *peiSong = [PeiSongPriceViewController new];
            [self.navigationController pushViewController:peiSong animated:YES];
        }
            
            break;
            
        case 5:
        {
            ShopTimeSetViewController *shoptimt = [ShopTimeSetViewController new];
            [self.navigationController pushViewController:shoptimt animated:YES];
            
            
        }
            break;
            
        case 6:
        {
            JieShouOrderSetViewController *order = [JieShouOrderSetViewController new];
            [self.navigationController pushViewController:order animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"商家设置";
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
