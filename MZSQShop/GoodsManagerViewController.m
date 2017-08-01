//
//  GoodsManagerViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GoodsManagerViewController.h"
#import "CellView.h"
#import "GoodsFenLeiManagerViewController.h"
#import "OnSellGoodsViewController.h"
#import "UnOnSellGoodsViewController.h"
#import "AddGoodsInfoViewController.h"
@interface GoodsManagerViewController ()

@end

@implementation GoodsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    
    NSArray *arr = @[@"商品分类管理",@"在售商品管理",@"下架商品管理",@"添加商品"];
    float setY = self.NavImg.bottom+10*self.scale;
    for (int i=0; i<arr.count; i++) {
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        nameCell.backgroundColor = [UIColor whiteColor];
        nameCell.topline.hidden=i!=0;
        nameCell.titleLabel.text=arr[i];
        nameCell.titleLabel.size=CGSizeMake(100*self.scale, nameCell.titleLabel.height);
        [nameCell ShowRight:YES];
        nameCell.tag=1+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(managerBtn:)];
        [nameCell addGestureRecognizer:tap];
        [self.view addSubview:nameCell];
        setY = nameCell.bottom;
    }
}

-(void)managerBtn:(UITapGestureRecognizer *)sender{
    self.hidesBottomBarWhenPushed=YES;
    switch ([[sender view] tag]) {
        case 1:
        {
            GoodsFenLeiManagerViewController *fenlei = [GoodsFenLeiManagerViewController new];
            [self.navigationController pushViewController:fenlei animated:YES];
        
        }
            break;
            
        case 2:
        {
            OnSellGoodsViewController *setVC=[[OnSellGoodsViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
            
        case 3:
        {
            UnOnSellGoodsViewController *setVC=[[UnOnSellGoodsViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
        case 4:
        {
      
            AddGoodsInfoViewController *AddGoodsVc=[[AddGoodsInfoViewController alloc]initWithBlock:^{
               
             
            }];
            [self.navigationController pushViewController:AddGoodsVc animated:YES];
            
        }
            break;
            
        default:
            break;
    }



}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"商品管理";
    
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
