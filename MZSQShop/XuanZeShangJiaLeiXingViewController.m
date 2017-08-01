//
//  XuanZeShangJiaLeiXingViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "XuanZeShangJiaLeiXingViewController.h"
#import "CellView.h"
#import "ShenQingFuWuLieShangJiaViewController.h"
#import "ShenQingShangPinLeiShangJiaViewController.h"
@interface XuanZeShangJiaLeiXingViewController ()
@property(nonatomic,assign)NSInteger SelectenTag;
@end

@implementation XuanZeShangJiaLeiXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    NSArray *Arr=@[@"商品零售类"];//,@"服务类"
      float SetY =self.NavImg.bottom;
    for(int i=0;i<Arr.count;i++){
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        Cell.titleLabel.textAlignment=NSTextAlignmentLeft;
        Cell.topline.hidden = i!=0;
        Cell.title=Arr[i];
        Cell.tag = i;
        UIImageView *Selected=[[UIImageView alloc]initWithFrame:CGRectMake(Cell.contentLabel.right-Cell.height/2, Cell.height/2-10*self.scale,20*self.scale, 20*self.scale)];
        Selected.tag=10+i;
        Selected.contentMode=UIViewContentModeScaleAspectFit;
        Selected.image=[UIImage imageNamed:@"choose_01"];
        Selected.highlightedImage=[UIImage imageNamed:@"choose_02"];
        [Cell addSubview:Selected];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapEvent:)];
        [Cell addGestureRecognizer:tap];
        [self.view addSubview:Cell];
        SetY =Cell.bottom;
    }
}
-(void)TapEvent:(UITapGestureRecognizer *)tap{
    CellView *Cell=(CellView *)[tap view];
    [self SelectedImg:Cell.tag];
    if (Cell.tag == 0) {
        ShenQingFuWuLieShangJiaViewController *fuWUVC=[[ShenQingFuWuLieShangJiaViewController alloc]init];
        fuWUVC.shop_type=@"1";
        [self.navigationController pushViewController:fuWUVC animated:YES];
    }else{
        ShenQingFuWuLieShangJiaViewController *fuWUVC=[[ShenQingFuWuLieShangJiaViewController alloc]init];
        fuWUVC.shop_type=@"2";
        [self.navigationController pushViewController:fuWUVC animated:YES];
    }
}
-(void)SelectedImg:(NSInteger)tag{
    
    if (_SelectenTag>0) {
        UIImageView *oldimg=(UIImageView *)[self.view viewWithTag:_SelectenTag];
        oldimg.highlighted=NO;
    }
    _SelectenTag = 10+tag;
    UIImageView *img=(UIImageView *)[self.view viewWithTag:_SelectenTag];
    img.highlighted=YES;
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"选择商家类型";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
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
