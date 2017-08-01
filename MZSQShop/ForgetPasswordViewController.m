//
//  ForgetPasswordViewController.m
//  MZSQShop
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CellView.h"
@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *Tel;
@end

@implementation ForgetPasswordViewController

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
    [RegisterBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    RegisterBtn.tag=7;
    RegisterBtn.enabled=NO;
    [RegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegisterBtn.titleLabel.font=BigFont(self.scale);
    [RegisterBtn addTarget:self action:@selector(RegisterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegisterBtn];

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
    [self.view endEditing:YES];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy UserGetVerifyCodeWithMobile:tel Type:@"2" Block:^(id models, NSString *code, NSString *msg) {
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
    [self.view endEditing:YES];
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
    [analy ForgetLoginPassWithMobile:tel Login_pass:pwd User_type:@"2" Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];
}

#pragma mark - TextField
-(void)TextFieldChange{
    
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
    UITextField *TextCode=(UITextField *)[self.view viewWithTag:11];
    UITextField *TextPwd=(UITextField *)[self.view viewWithTag:12];
    NSString *tel=[TextFf.text trimString];
    UIButton *LoginBtn=(UIButton *)[self.view viewWithTag:7];
    if (TextFf.text.length>0 && TextPwd.text.length>0 && [tel isValidateMobile] && TextCode.text.length>0) {
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
    self.TitleLabel.text=@"忘记密码";
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
