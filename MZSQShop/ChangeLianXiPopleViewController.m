//
//  ChangeLianXiPopleViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChangeLianXiPopleViewController.h"

@interface ChangeLianXiPopleViewController ()<UITextFieldDelegate>

@end

@implementation ChangeLianXiPopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self returnVi];
    UIView *bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 44.0f)];
    bigVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigVi];
    
    
    UITextField *lable = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width,bigVi.height)];
    lable.font = DefaultFont(self.scale);
    lable.placeholder = @"请输入联系人姓名";
    lable.text=_Name;
    lable.delegate=self;
    lable.tag=10;
    [bigVi addSubview:lable];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"修改联系人";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if ([name length]<1) {
        [self ShowAlertWithMessage:@"请输入联系人姓名"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyContactNameWithUser_ID:[Stockpile sharedStockpile].ID Contact_name:name Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:name forKey:@"contact_name"];
            [model setObject:Info forKey:@"shop_info"];
            [[Stockpile  sharedStockpile]setModel:model];
            
            [self PopVC:nil];
        }
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
