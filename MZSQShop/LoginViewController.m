//
//  LoginViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "CellView.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "JPUSHService.h"
#import "XuanZeShangJiaLeiXingViewController.h"
@interface LoginViewController()<UITextFieldDelegate>
@property(nonatomic,strong)LoginBlock block;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end
@implementation LoginViewController
-(id)initWithBlock:(LoginBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    if (_block && [Stockpile sharedStockpile].isLogin) {
        _block();
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    /*监听TextField的变化*/
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, rect.origin.y-self.NavImg.bottom);
    }];
}
-(void)newView{
    
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
     _mainScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseKeyBoard)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    
    UIView *TopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150*self.scale)];
    TopView.backgroundColor=[UIColor clearColor];
    [_mainScrollView addSubview:TopView];
    UIImageView *HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width/2-45*self.scale, TopView.height/2-45*self.scale,90*self.scale, 90*self.scale)];
    HeaderImg.image=[UIImage imageNamed:@"dl_img"];
    HeaderImg.layer.masksToBounds=YES;
    HeaderImg.layer.cornerRadius=HeaderImg.height/2;
    HeaderImg.contentMode=UIViewContentModeScaleAspectFit;
    [TopView addSubview:HeaderImg];
    
    UIImageView *topLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, TopView.bottom, self.view.width, 0.5)];
    topLine.backgroundColor=blackLineColore;
    [_mainScrollView addSubview:topLine];
    UIImageView *bottomLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, topLine.bottom+88*self.scale, self.view.width, 0.5)];
    bottomLine.backgroundColor=blackLineColore;
    [_mainScrollView addSubview:bottomLine];
    
    for (int i=0; i<2; i++)
    {
        CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, topLine.bottom+44*self.scale*i, self.view.width, 44*self.scale)];
        Cell.backgroundColor=[UIColor whiteColor];
        UIImageView *Img=[[UIImageView alloc]initWithFrame:CGRectMake(15*self.scale, Cell.height/2-11*self.scale, 22*self.scale, 22*self.scale)];
        Img.image = i==0?[UIImage imageNamed:@"dl_icon01"]:[UIImage imageNamed:@"dl_icon02"];
        [Cell addSubview:Img];
        
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(Img.right+10*self.scale, 5*self.scale, Cell.width-Img.right-40*self.scale, Cell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
        textF.placeholder=i==0?@"请输入手机号":@"请输入登录密码";
        textF.text = i==0?[Stockpile sharedStockpile].userName:@"";
        textF.secureTextEntry=(i==1);
        textF.tag=10+i;
        textF.delegate=self;
        [Cell setHiddenLine:i==1];
        [Cell addSubview:textF];
        [_mainScrollView addSubview:Cell];
    }
    
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    LoginBtn.tag = 7;
    LoginBtn.enabled=NO;
    [LoginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:LoginBtn];
    
    UIButton *forgotBtn=[[UIButton alloc]initWithFrame:CGRectMake(LoginBtn.left, LoginBtn.bottom+5*self.scale, 60*self.scale, 20*self.scale)];
    [forgotBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgotBtn setTitleColor:grayTextColor forState:UIControlStateNormal];
    forgotBtn.titleLabel.font=SmallFont(self.scale);
    [forgotBtn addTarget:self action:@selector(ForgotButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:forgotBtn];
    
    UIButton *RegisterBtn=[[UIButton alloc]initWithFrame:CGRectMake(LoginBtn.right-60*self.scale, LoginBtn.bottom+5*self.scale, 60*self.scale, 20*self.scale)];
    [RegisterBtn setTitle:@"免费注册" forState:UIControlStateNormal];
    [RegisterBtn setTitleColor:grayTextColor forState:UIControlStateNormal];
    [RegisterBtn addTarget:self action:@selector(RegisterButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    RegisterBtn.titleLabel.font=SmallFont(self.scale);
    [_mainScrollView addSubview:RegisterBtn];
    
    _mainScrollView.contentSize=CGSizeMake(self.view.width, RegisterBtn.bottom+20*self.scale);
    
}
-(void)CloseKeyBoard{
     [self.view endEditing:YES];
}
#pragma mark - 按钮事件
/*登录*/
-(void)LoginButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
    UITextField *TextPwd=(UITextField *)[self.view viewWithTag:11];
    NSString *tel=[TextFf.text trimString];
    if (tel.length<1 || ![tel isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入您的手机号码"];
        return;
    }
    NSString *Pwd=[TextPwd.text trimString];
    if (Pwd.length<1 || ![Pwd isValidatePassword]) {
        [self ShowAlertWithMessage:@"请输入您的登录密码"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ShopUsergetComuunityTelWithMobile:tel Block:^(id models, NSString *code, NSString *msg) {
        NSString *CTel=@"";
        if ([code isEqualToString:@"0"]) {
            CTel=[[NSString stringWithFormat:@"%@",models] EmptyStringByWhitespace];
        }
    [analy UserLoginWithMobile:tel Password:Pwd Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"UserLoginWithMobile==%@",models);
        if([code isEqualToString:@"0"]){
            [[Stockpile sharedStockpile]setUserName:tel];
            [[Stockpile sharedStockpile]setPassword:Pwd];
            [[Stockpile sharedStockpile] setUsertoken:[models objectForKey:@"usertoken"]];
           
     [[Stockpile sharedStockpile]setID:[NSString stringWithFormat:@"%@",[models objectForKey:@"id"]]];
            NSString *ytpe=[[[NSString stringWithFormat:@"%@",[[models objectForKey:@"shop_info"] objectForKey:@"apply_result"]] trimString] EmptyStringByWhitespace];
            if ([ytpe isEqualToString:@"3"] || [ytpe isEqualToString:@"4"]) {
                [self.activityVC stopAnimating];
                NSLog(@"***** %@",ytpe);
                if ([ytpe isEqualToString:@"3"]) {
                    [self ShowAlertWithMessage:@"未通过审核，请重新申请！"];
                }
                XuanZeShangJiaLeiXingViewController *xuanZeVc=[[XuanZeShangJiaLeiXingViewController alloc]init];
                [self.navigationController pushViewController:xuanZeVc animated:YES];
                return ;
            }else if([ytpe isEqualToString:@"2"]){
                [[Stockpile sharedStockpile]setNickName:[NSString stringWithFormat:@"%@",[models objectForKey:@"nick_name"]]];
                [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",[models objectForKey:@"avatar"]]];
                [[Stockpile sharedStockpile]setModel:[models mutableCopy]];
                [ [Stockpile sharedStockpile]setRole:[NSString stringWithFormat:@"%@",[[models objectForKey:@"shop_info"] objectForKey:@"shop_type"]]];
                [[Stockpile sharedStockpile]setToken:[NSString stringWithFormat:@"%@",[models objectForKey:@"token"]]];
                // [[Stockpile sharedStockpile]setIsLogin:YES];
                // NSLog(@"********** %@",[Stockpile sharedStockpile].token);
                [[RCIM sharedRCIM] connectWithToken:[Stockpile sharedStockpile].token success:^(NSString *userId) {
                    NSLog(@"rongyun==%@====%@",[Stockpile sharedStockpile].token,userId);
                    NSString *ShopName=@"";
                    if (models && [models objectForKey:@"shop_info"]) {
                        ShopName=[[[NSString stringWithFormat:@"%@",[[models objectForKey:@"shop_info"] objectForKey:@"shop_name"]] trimString] EmptyStringByWhitespace];
                    }
                    RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:ShopName portrait:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].logo]];
                    [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
                    NSString *tag =[NSString stringWithFormat:@"mzsq_%@",[Stockpile sharedStockpile].ID];
                    [JPUSHService setAlias:tag callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                    [[Stockpile sharedStockpile]setIsLogin:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.activityVC stopAnimating];
                        [self PopVC:nil];
                        if (_block) {
                            _block();
                        }
                    });
                } error:^(RCConnectErrorCode status) {
                    [self.activityVC stopAnimating];
                } tokenIncorrect:^{
                    [self.activityVC stopAnimating];
                }];
            }else{
                [self.activityVC stopAnimating];
                /*UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的信息正在审核中，请耐心等待！如有疑问,请联系我们" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAct=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                 UIAlertAction *TelAct=[UIAlertAction actionWithTitle:@"联系" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSString *telUrl = [NSString stringWithFormat:@"telprompt:40088686867"];
                         NSURL *url = [[NSURL alloc] initWithString:telUrl];
                         [[UIApplication sharedApplication] openURL:url];
                     });
                     
                 }];
                [alertCon addAction:TelAct];
                [alertCon addAction:cancelAct];
                [self presentViewController:alertCon animated:YES completion:nil];*/
                [self ShowAlertTitle:@"温馨提示" Message:@"您的信息正在审核中，请耐心等待！如有疑问,请联系我们" Delegate:self Block:^(NSInteger index) {
                    if (index == 1) {
                        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",CTel];
                        NSURL *url = [[NSURL alloc] initWithString:telUrl];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
            }
        }else{
             [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
        }
        
    }];
    }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
/* 忘记密码*/
-(void)ForgotButtonEvent:(id)sender{
    ForgetPasswordViewController *forgetVC=[[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
/*注册*/
-(void)RegisterButtonEvent:(id)sender{
    
    RegisterViewController *registerVC=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
#pragma mark - TextField
-(void)TextFieldChange{
    
    UITextField *TextFf=(UITextField *)[self.view viewWithTag:10];
    UITextField *TextPwd=(UITextField *)[self.view viewWithTag:11];
    NSString *tel=[TextFf.text trimString];
    UIButton *LoginBtn=(UIButton *)[self.view viewWithTag:7];
    if (TextFf.text.length>0 && TextPwd.text.length>0 && [tel isValidateMobile]) {
        LoginBtn.enabled=YES;
    }else{
        LoginBtn.enabled=NO;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    return YES;
}
#pragma mark - 导航
- (void)newNav{
    self.TitleLabel.text = @"登录";
}
-(void)PopVC:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
