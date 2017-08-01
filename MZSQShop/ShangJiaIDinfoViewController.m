//
//  ShangJiaIDinfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShangJiaIDinfoViewController.h"
//#import "ShangJiaIDinfoTableViewCell.h"
#import "ChangeLianXiPopleViewController.h"
#import "XiuGiPassWordViewController.h"
#import "ChangeTeleViewController.h"
#import "HelpTableViewCell.h"
@interface ShangJiaIDinfoViewController ()
@property(nonatomic,strong)UITableView *table;
@end

@implementation ShangJiaIDinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    // Do any additional setup after loading the view.
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) style:UITableViewStylePlain];
    _table.dataSource=self;
    _table.delegate=self;
    _table.rowHeight=44*self.scale;
    _table.separatorStyle = UITableViewCellAccessoryNone;
    [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
}
-(void)viewWillAppear:(BOOL)animated{
    [_table reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model=[Stockpile sharedStockpile].model;
    NSArray *arr = @[@"联系人",@"手机号码",@"修改密码"];
    NSArray *ValueArr=@[@"",@"",@""];
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[[NSString stringWithFormat:@"%@",[dic objectForKey:@"contact_name"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"contact_mobile"]],[NSString stringWithFormat:@""]];
    }
    HelpTableViewCell *cell =(HelpTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = arr[indexPath.row];
    cell.nameLabel.text=ValueArr[indexPath.row];
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    if (indexPath.row == 1) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.rigthImg.hidden=YES;
    }else{
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        cell.rigthImg.hidden=NO;
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary *model=[Stockpile sharedStockpile].model;
    NSArray *ValueArr=@[@"",@"",@""];
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[[NSString stringWithFormat:@"%@",[dic objectForKey:@"contact_name"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"contact_mobile"]],[NSString stringWithFormat:@""]];
    }

    if (indexPath.row==0) {
        ChangeLianXiPopleViewController *change = [ChangeLianXiPopleViewController new];
        change.Name=[ValueArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:change animated:YES];
    }
    
    if (indexPath.row==1) {
        //ChangeTeleViewController *change = [ChangeTeleViewController new];
       // change.Tel=[ValueArr objectAtIndex:indexPath.row];
       // [self.navigationController pushViewController:change animated:YES];
    }
    
    if (indexPath.row==2) {
        XiuGiPassWordViewController *password = [XiuGiPassWordViewController new];
        [self.navigationController pushViewController:password animated:YES];
    }
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺账号信息";
    
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
