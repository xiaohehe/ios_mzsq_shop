//
//  PeiSongPriceViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PeiSongPriceViewController.h"
#import "SetPriceViewController.h"
#import "HelpTableViewCell.h"
@interface PeiSongPriceViewController ()
@property(nonatomic,strong)UITableView *table;
@end

@implementation PeiSongPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    // Do any additional setup after loading the view.
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _table.dataSource=self;
    _table.delegate=self;
    _table.backgroundColor = superBackgroundColor;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.rowHeight=50.0f;
    [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_table];
}
-(void)viewWillAppear:(BOOL)animated{
    [_table reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *textArr = @[@"配送费",@"满多少元免配送费"];
    NSArray *ValueArr = @[@"",@""];
    NSDictionary *model=[Stockpile sharedStockpile].model;
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[[NSString stringWithFormat:@"%.0f",[[dic objectForKey:@"delivery_fee"] floatValue]],[NSString stringWithFormat:@"%.0f",[[dic objectForKey:@"free_delivery_amount"]floatValue]]];
    }

    HelpTableViewCell *cell = (HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = textArr[indexPath.row];
    cell.nameLabel.text = ValueArr[indexPath.row];
    cell.nameLabel.textColor=grayTextColor;
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    NSArray *ValueArr = @[@"",@""];
    NSDictionary *model=[Stockpile sharedStockpile].model;
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[[NSString stringWithFormat:@"%.0f",[[dic objectForKey:@"delivery_fee"] floatValue]],[NSString stringWithFormat:@"%.0f",[[dic objectForKey:@"free_delivery_amount"]floatValue]]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SetPriceViewController *prictVc=[[SetPriceViewController alloc]init];
    prictVc.isPeiSong=indexPath.row==0;
    prictVc.Fee=ValueArr[indexPath.row];
    [self.navigationController pushViewController:prictVc animated:YES];

}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"配送费设置";
    
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
