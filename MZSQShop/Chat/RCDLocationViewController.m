//
//  RCDLocationViewController.m
//  AdultStore
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RCDLocationViewController.h"

@implementation RCDLocationViewController

-(void)viewWillAppear:(BOOL)animated{
  
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)newNav{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
       backBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -15, 0, 15);
/*    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_img"]];
    backImg.contentMode=UIViewContentModeScaleAspectFit;
    backImg.frame = CGRectMake(-10, 8, 28, 28);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 11, 65, 22)];
    backText.text = @"返回";
    backText.font = BigFont(1);
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:pinkTextColor];
    [backBtn addSubview:backText];*/
    [backBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 6, 44, 44)];
    [SaveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [SaveBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:SaveBtn];
   [self.navigationItem setRightBarButtonItem:rightButton];
}
- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
  [super leftBarButtonItemPressed:sender];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonItemPressed:(id)sender{
   [super rightBarButtonItemPressed:sender];
    
}
@end
