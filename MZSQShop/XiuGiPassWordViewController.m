


//
//  XiuGiPassWordViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "XiuGiPassWordViewController.h"
#import "CellView.h"
@interface XiuGiPassWordViewController ()<UITextFieldDelegate>

@end

@implementation XiuGiPassWordViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+15*self.scale, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.view addSubview:topLine];
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, topLine.bottom+132*self.scale, self.view.width, 0.5)];
    bottomLine.backgroundColor=blackLineColore;
    [self.view addSubview:bottomLine];
    NSArray *Arr=@[@"当前密码",@"新密码",@"确认新密码"];
    for (int i=0; i<Arr.count; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, topLine.bottom+44*self.scale*i, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        Cell.titleLabel.text=Arr[i];
        Cell.titleLabel.font=DefaultFont(self.scale);
        // Cell.titleLabel.size=CGSizeMake(50*self.scale, Cell.titleLabel.height);
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( Cell.titleLabel.right+10*self.scale, 5*self.scale, Cell.width- Cell.titleLabel.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=Arr[i];
        textF.secureTextEntry=YES;
        textF.tag=10+i;
        textF.delegate=self;
        [Cell setHiddenLine:i==[Arr count]-1];
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
    }
    
    /*UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
     [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"center_btn"] forState:UIControlStateNormal];
     [LoginBtn setTitle:@"修改" forState:UIControlStateNormal];
     [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     LoginBtn.titleLabel.font=BigFont(self.scale);
     [LoginBtn addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:LoginBtn];*/
}
-(void)NextButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    UITextField *NPwdText=(UITextField *)[self.view viewWithTag:11];
    UITextField *RPwdText=(UITextField *)[self.view viewWithTag:12];
    NSString *ypwd=[YPwdText.text trimString];
    NSString *npwd=[NPwdText.text trimString];
    NSString *rpwd=[RPwdText.text trimString];
    if (![ypwd isValidatePassword] && ![ypwd isEqualToString:[Stockpile sharedStockpile].password]) {
        [self ShowAlertWithMessage:@"原密码错误"];
        return;
    }
    if (![npwd isValidatePassword]) {
        [self ShowAlertWithMessage:@"密码为6~12位的字母或数字组成"];
        return;
    }
    if(![rpwd isEqualToString:npwd]) {
        [self ShowAlertWithMessage:@"两次密码不一致"];
        return;
    }
       [self.activityVC startAnimating];
      AnalyzeObject *anali=[[AnalyzeObject alloc]init];
    [anali ModifyLoginPassWithUser_ID:[Stockpile sharedStockpile].ID Old_login_pass:ypwd Passwrod:npwd Block:^(id models, NSString *code, NSString *msg) {
        [self ShowAlertWithMessage:msg];
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
            [[Stockpile sharedStockpile]setPassword:npwd];
        }
        

    }];
    //    [anali si_yi_changePwdWithID:[Stockpile sharedStockpile].ID NewPwd:npwd OldPwd:ypwd Role:[Stockpile sharedStockpile].Role  Block:^(id models, NSString *code, NSString *msg) {
    //        [self ShowAlertWithMessage:msg];
    //        [self.activityVC stopAnimate];
    //        if ([code isEqualToString:@"1"]) {
    //            [self PopVC:nil];
    //            [[Stockpile sharedStockpile]setPassword:npwd];
    //        }
    //
    //    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"修改密码";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *SaveButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveButton setTitle:@"保存" forState:UIControlStateNormal];
    SaveButton.titleLabel.font=DefaultFont(self.scale);
    [SaveButton addTarget:self action:@selector(NextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveButton];
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
