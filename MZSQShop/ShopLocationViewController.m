
//
//  ShopLocationViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopLocationViewController.h"

@interface ShopLocationViewController ()<UITextFieldDelegate>

@end

@implementation ShopLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    [self sreachVi];
    
    
}

#pragma mark---店铺坐标
-(void)sreachVi{
    UIView *heardView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, self.view.height-self.NavImg.bottom+10*self.scale)];
    heardView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:heardView];
    
    UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10, self.view.width-20*self.scale, 32*self.scale)];
    SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
    SearchBG.userInteractionEnabled=YES;
    [heardView addSubview:SearchBG];
    
    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(SearchBG.width-SearchBG.height, 0, SearchBG.height, SearchBG.height)];
    IconImage.image=[UIImage imageNamed:@"search"];
    [SearchBG addSubview:IconImage];
    UITextField *searchText=[[UITextField alloc]initWithFrame:CGRectMake(8*self.scale, 0, SearchBG.width-IconImage.height-5*self.scale , SearchBG.height)];
    searchText.font=DefaultFont(self.scale);
    searchText.placeholder=@"请输您的送餐地址";
    searchText.delegate=self;
    [SearchBG addSubview:searchText];
}
#pragma mark----地图---- 
-(void)mapView{
    

}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺坐标";
    
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
