//
//  RegisterViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "CellView.h"
#import "XuanZeShangJiaLeiXingViewController.h"
#import "WebXieYiViewController.h"
@interface RegisterViewController()<UITextFieldDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *Tel;
@end
@implementation RegisterViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    /*监听TextField的变化*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)newView{
    NSArray *ImgArr=@[@"dl_icon01",@"zhuce_icon01",@"dl_icon02"];
    NSArray *PlaceArr=@[@"请输入手机号码",@"请输入验证码",@"请设置登录密码"];
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10*self.scale+self.NavImg.bottom, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [self.view addSubview:topLine];
    float setY=topLine.bottom;
    for (int i=0; i<PlaceArr.count; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        Img.image = [UIImage imageNamed:ImgArr[i]];
        [Cell addSubview:Img];
        
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(Img.right+10*self.scale, 5*self.scale, Cell.width-Img.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=PlaceArr[i];
        textF.secureTextEntry=(i==2);
        textF.delegate=self;
        textF.tag=10+i;
        [Cell setHiddenLine:i==PlaceArr.count-1];
        [Cell addSubview:textF];
        [self.view addSubview:Cell];
        if(i==1)
        {
            UIButton *MSMBtn=[[UIButton alloc]initWithFrame:CGRectMake(Cell.width-110*self.scale, 8*self.scale, 100*self.scale, Cell.height-16*self.scale)];
            [MSMBtn setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            MSMBtn.titleLabel.font=DefaultFont(self.scale);
            [MSMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [MSMBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            MSMBtn.tag=5;
            [MSMBtn addTarget:self action:@selector(MSMButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [Cell addSubview:MSMBtn];
            
            textF.frame=CGRectMake(Img.right+10*self.scale, 5*self.scale, MSMBtn.left-Img.right-25*self.scale, Cell.height-10*self.scale);
        }
        setY=Cell.bottom;
    }
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 0.5)];
    bottomLine.backgroundColor=blackLineColore;
    [self.view addSubview:bottomLine];
    
    UIButton *RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [RegisterBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
     [RegisterBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [RegisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    RegisterBtn.tag=7;
    RegisterBtn.enabled=NO;
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.titleLabel.font=BigFont(self.scale);
    [RegisterBtn addTarget:self action:@selector(RegisterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegisterBtn];
    
    RegisterBtn.enabled=YES;

    UIButton *XYButton=[[UIButton alloc]initWithFrame:CGRectMake(RegisterBtn.left+30*self.scale, RegisterBtn.bottom+15*self.scale, 150*self.scale, 20*self.scale)];
    [XYButton setTitleColor:blueTextColor forState:UIControlStateNormal];
    [XYButton setTitle:@"《拇指社区用户使用协议》" forState:UIControlStateNormal];
    [XYButton addTarget:self action:@selector(XYButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    XYButton.titleLabel.font=SmallFont(self.scale);
    [self.view addSubview:XYButton];
    UIButton *OKXY=[[UIButton alloc]initWithFrame:CGRectMake(XYButton.left-30*self.scale, XYButton.top-4*self.scale, 28*self.scale, 28*self.scale)];
    [OKXY setImage:[UIImage imageNamed:@"choose_01_img"] forState:UIControlStateNormal];
    [OKXY setImage:[UIImage imageNamed:@"choose_02_img"] forState:UIControlStateSelected];
    OKXY.tag=1;
    OKXY.selected=YES;
    [OKXY addTarget:self action:@selector(OKXYEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKXY];
    
    
    CellView *TiCell=[[CellView alloc]initWithFrame:CGRectMake(0, OKXY.bottom+5*self.scale, self.view.width, 25*self.scale)];
    TiCell.backgroundColor=[UIColor clearColor];
    TiCell.contentLabel.frame=CGRectMake(10*self.scale, TiCell.titleLabel.top, self.view.width-20*self.scale, TiCell.titleLabel.height);
    TiCell.contentLabel.textColor=[UIColor redColor];
    TiCell.contentLabel.text=@"注册和设置指南，请访问www.mzsq.com,查看帮助中心";// attributedStringWithStyleBook:[self Style]];
    TiCell.contentLabel.font=SmallFont(self.scale);
    [TiCell.contentLabel sizeToFit];
    TiCell.contentLabel.centerY=TiCell.height/2;
    if (TiCell.height<TiCell.contentLabel.bottom+TiCell.contentLabel.top) {
        TiCell.height=TiCell.contentLabel.bottom+TiCell.contentLabel.top;
    }
    TiCell.bottomline.hidden=YES;
    [self.view addSubview:TiCell];
}
#pragma mark - 按钮事件
/*获取验证码*/
-(void)MSMButtonEvent:(id)sender{
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if ( ![tel isValidateMobile])
    {
        [self ShowAlertWithMessage:@"请输入有效的手机号码"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy UserGetVerifyCodeWithMobile:tel Type:@"1" Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if (![code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:msg];
        }else{
             _code=[NSString stringWithFormat:@"%@",[models objectForKey:@"verify_code"]];
            _Tel=tel;
            NSLog(@"***********%@",_code);
            _time=120;
            _timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeji) userInfo:nil repeats:YES];
        }
    }];
}
-(void)timeji
{
    UIButton *btn=(UIButton *)[self.view viewWithTag:5];
    if (_time == 0) {
        [_timer invalidate];
        _timer = nil;
        btn.enabled=YES;
        [btn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _time = 120;
    }else
    {
        [btn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
        btn.enabled=NO;
        _time--;
    }
}
/*注册事件*/
-(void)RegisterButtonEvent:(id)sender{
//    XuanZeShangJiaLeiXingViewController *xuanZeVc=[[XuanZeShangJiaLeiXingViewController alloc]init];
//    [self.navigationController pushViewController:xuanZeVc animated:YES];
//    return;
   UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if ( ![tel isValidateMobile])
    {
        [self ShowAlertWithMessage:@"请输入有效的手机号码"];
        return;
    }
    if (![tel isEqualToString:_Tel]) {
        [self ShowAlertWithMessage:@"请输入此手机号码无效"];
        return;
    }
    UITextField *codeText=(UITextField *)[self.view viewWithTag:11];
    NSString *telcode=[codeText.text trimString];
    if (![telcode isEqualToString:_code] || telcode.length<1) {
        [self ShowAlertWithMessage:@"验证码有误，请输入正确的验证码"];
        return;
    }
    UITextField *pwdText=(UITextField *)[self.view viewWithTag:12];
    NSString *pwd=[pwdText.text trimString];
    if (pwd.length<1 || ![pwd isValidatePassword]) {
        [self ShowAlertWithMessage:@"密码为6~12位的字母或数字组成"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy UserRegisterWithMobile:tel Password:pwd Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:@"请继续完成店铺设置，然后提交审核"];
         //   [[Stockpile sharedStockpile]setIsLogin:YES];
            [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models objectForKey:@"id"]]];
            [[Stockpile sharedStockpile]setToken:[NSString stringWithFormat:@"%@",[models objectForKey:@"token"]]];
            XuanZeShangJiaLeiXingViewController *xuanZeVc=[[XuanZeShangJiaLeiXingViewController alloc]init];
            [self.navigationController pushViewController:xuanZeVc animated:YES];
            
           // [self PopVC:nil];
        }else{
            [self ShowAlertWithMessage:msg];
        }
    }];
}
/*是否同意协议*/
-(void)OKXYEvent:(UIButton *)button{
    button.selected=!button.selected;
    [self TextFieldChange];
}
/*协议*/
-(void)XYButtonEvent:(id)sneder{
    self.hidesBottomBarWhenPushed=YES;
    WebXieYiViewController *webXYVC=[[WebXieYiViewController alloc]init];
    [self.navigationController pushViewController:webXYVC animated:YES];
}
#pragma mark - TextField
-(void)TextFieldChange{
    
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
    UITextField *TextCode=(UITextField *)[self.view viewWithTag:11];
    UITextField *TextPwd=(UITextField *)[self.view viewWithTag:12];
    UIButton *Btn=(UIButton *)[self.view viewWithTag:1];
    NSString *tel=[TextFf.text trimString];
    UIButton *LoginBtn=(UIButton *)[self.view viewWithTag:7];
    if (TextFf.text.length>0 && TextPwd.text.length>0 && [tel isValidateMobile] && TextCode.text.length>0 && Btn.selected) {
        LoginBtn.enabled=YES;
    }else{
        LoginBtn.enabled=NO;
    }
    
}


#pragma mark - TextField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 13) {
        [self.view endEditing:YES];
        return NO;
    }else if (textField.tag == 10){
        textField.keyboardType=UIKeyboardTypePhonePad;
    }else if (textField.tag == 11){
        textField.keyboardType=UIKeyboardTypeNumberPad;
    }
    return YES;
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
    self.TitleLabel.text=@"注册";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
@end
