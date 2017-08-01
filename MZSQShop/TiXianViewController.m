//
//  TiXianViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TiXianViewController.h"
#import "CellView.h"
#import "TiXianMingXiViewController.h"

@interface TiXianViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)CellView *zhifuType;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)NSString *Count;
@property(nonatomic,strong)NSString *Least_amount;

@property(nonatomic,strong)NSString *withdraw_rate;

@property(nonatomic,assign)BOOL isHasPoint;
@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Count=@"0.00";
    [self returnVi];
    [self cellVi];
    [self.view addSubview:self.activityVC];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ShopDetailWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
          if ( models) {
                _withdraw_rate=[NSString stringWithFormat:@"%@",[models objectForKey:@"withdraw_rate"]];
        }
    [analy ShopUserInfoWithWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"] && models) {
            _Count=[NSString stringWithFormat:@"%@",[models objectForKey:@"account"]];
            _Least_amount=[NSString stringWithFormat:@"%@",[models objectForKey:@"least_amount"]];
            [self newDetail];
        }
    }];
        
    }];
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
-(void)cellVi{

    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    _mainScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseKeyBoard)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    
}
-(void)newDetail{
    UIView *bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 300)];;
    [_mainScrollView addSubview:bigVi];
    
    //手机号
    CellView *teleCell = [[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    teleCell.titleLabel.text=@"手机号";
    teleCell.titleLabel.textColor=grayTextColor;
    [bigVi addSubview:teleCell];
    
    UITextField *teleTF = [[UITextField alloc]initWithFrame:CGRectMake(teleCell.titleLabel.right, teleCell.height/2-10*self.scale, self.view.width-teleCell.titleLabel.right-20*self.scale, 20*self.scale)];
    teleTF.font=teleCell.titleLabel.font;
    teleTF.text=[Stockpile sharedStockpile].userName;
    teleTF.textColor=grayTextColor;
    teleTF.tag=10;
    teleTF.userInteractionEnabled=NO;
    [teleCell addSubview:teleTF];
    //验证码
    CellView *yanZhengMa = [[CellView alloc]initWithFrame:CGRectMake(0, teleCell.bottom, self.view.width, 44)];
    yanZhengMa.titleLabel.text = @"验证码";
    yanZhengMa.titleLabel.textColor=grayTextColor;
    [bigVi addSubview:yanZhengMa];
    
    UITextField *yanzhengmaTF = [[UITextField alloc]initWithFrame:CGRectMake(yanZhengMa.titleLabel.right, yanZhengMa.height/2-10*self.scale, 100,20*self.scale)];
    yanzhengmaTF.font=yanZhengMa.titleLabel.font;
    yanzhengmaTF.keyboardType=UIKeyboardTypeNumberPad;
    yanzhengmaTF.tag=11;
    yanzhengmaTF.delegate=self;
    yanzhengmaTF.placeholder=@"获取验证码";
    [yanZhengMa addSubview:yanzhengmaTF];
    
    UIButton *huoQu = [UIButton buttonWithType:UIButtonTypeCustom];
    huoQu.frame=CGRectMake(self.view.width-80*self.scale, yanZhengMa.height/2-12.5*self.scale, 70*self.scale, 25*self.scale);
    // huoQu.backgroundColor = blueTextColor;
    [huoQu setBackgroundImage:[UIImage ImageForColor:blueTextColor] forState:UIControlStateNormal];
    huoQu.titleLabel.font=BoldSmallFont(self.scale);
    [huoQu setTitle:@"获取验证码" forState:UIControlStateNormal];
    huoQu.tag=5;
    [huoQu addTarget:self action:@selector(huoquBtn)forControlEvents:UIControlEventTouchUpInside];
    [yanZhengMa addSubview:huoQu];
    //账号
    
    
    CellView *zhangCell = [[CellView alloc]initWithFrame:CGRectMake(0, yanZhengMa.bottom, self.view.width, 44)];
    zhangCell.titleLabel.text=@"账号";
    zhangCell.titleLabel.textColor=grayTextColor;
    [bigVi addSubview:zhangCell];
    
    UITextField *zhangTF = [[UITextField alloc]initWithFrame:CGRectMake(zhangCell.titleLabel.right, zhangCell.height/2-10*self.scale, self.view.width-zhangCell.titleLabel.right-20*self.scale, 20*self.scale)];
    zhangTF.font=zhangCell.titleLabel.font;
    zhangTF.tag=12;
    zhangTF.delegate=self;
    zhangTF.keyboardType=UIKeyboardTypeASCIICapable;
    zhangTF.placeholder=@"请输入账号";
    [zhangCell addSubview:zhangTF];
    
    //支付方式
    _zhifuType = [[CellView alloc]initWithFrame:CGRectMake(0, zhangCell.bottom, self.view.width, 44)];
    [bigVi addSubview:_zhifuType];
    
    float setX=60*self.scale;
    float setY = 0;
    for (int i=0; i<2; i++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame= CGRectMake(setX, _zhifuType.height/2-7.5*self.scale, 15*self.scale, 15*self.scale);
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"choose_01"] forState:UIControlStateNormal];
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"choose_02"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectEvent:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag=i+1;
        if (i==0) {
            _selectedBtn=selectBtn;
            _selectedBtn.selected=YES;
        }
        [_zhifuType addSubview:selectBtn];
        
        UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(selectBtn.right+5*self.scale, 0, 70*self.scale, zhangCell.height)];
        type.text =i==0? @"微信账号":@"支付宝账号";
        type.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectedType:)];
        [type addGestureRecognizer:tap];
        type.tag=31+i;
        type.font=DefaultFont(self.scale);
        type.textColor=grayTextColor;
        [_zhifuType addSubview:type];
        
        setX = type.right+30*self.scale;
        setY = _zhifuType.bottom;
    }
    
    
    CellView *tixianJinE = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44)];
    UITextField *tiXianJETF = [[UITextField alloc]initWithFrame:CGRectMake(tixianJinE.titleLabel.left, tixianJinE.height/2-15*self.scale, 120*self.scale, 30*self.scale)];
    tiXianJETF.font=tixianJinE.titleLabel.font;
    tiXianJETF.tag=13;
    tiXianJETF.delegate=self;
    tiXianJETF.keyboardType=UIKeyboardTypeDecimalPad;
    tiXianJETF.placeholder=@"请输入提现金额";
    [tixianJinE addSubview:tiXianJETF];
    
    tixianJinE.titleLabel.width=100*self.scale;
    tixianJinE.contentLabel.text = [NSString stringWithFormat:@"可提现余额%@",_Count];
    tixianJinE.titleLabel.textColor=grayTextColor;
    tixianJinE.contentLabel.textAlignment=NSTextAlignmentRight;
    [bigVi addSubview:tixianJinE];
    
    UIButton *tiXian = [[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, tixianJinE.bottom+20*self.scale, self.view.width-20*self.scale, 40*self.scale)];
    tiXian.backgroundColor = [UIColor redColor];
    [tiXian setTitle:@"提交申请" forState:UIControlStateNormal];
    tiXian.titleLabel.font = BigFont(self.scale);
    tiXian.layer.cornerRadius=4.0f;
    [tiXian addTarget:self action:@selector(tixianEvent) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:tiXian];
    
    UILabel *TishiLabel=[[UILabel alloc]initWithFrame:CGRectMake(tiXian.left, tiXian.bottom+20*self.scale, tiXian.width, 13*self.scale)];
    if ([_withdraw_rate doubleValue]>0) {
         TishiLabel.text=[NSString stringWithFormat:@"1.您的提现费率为：%@%%",_withdraw_rate];
    }
    TishiLabel.font=SmallFont(self.scale);
    TishiLabel.textColor=grayTextColor;
    TishiLabel.numberOfLines=0;
    [TishiLabel sizeToFit];
    [bigVi addSubview:TishiLabel];
    bigVi.height=TishiLabel.bottom;
    
    _mainScrollView.contentSize=CGSizeMake(self.view.width, bigVi.bottom+20*self.scale);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)CloseKeyBoard{
     [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 13){
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            _isHasPoint = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!_isHasPoint)//text中还没有小数点
                    {
                        _isHasPoint = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHasPoint) {//存在小数点
                          NSRange ran = [textField.text rangeOfString:@"."];
                        //判断小数点的位数
                        //NSRange ran = [textField.text rangeOfString:@"."];
                        if ((range.location - ran.location <= 2) || ran.location<Lenth8) {
                           
                            return YES;
                        }else{
                            
                            return NO;
                        }
                    }else{
                        if (range.location<Lenth8) {
                            return YES;
                        }
                          return NO;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [self.view endEditing:YES];
    return YES;
}
-(void)huoquBtn{
    UITextField *telText=(UITextField *)[self.view viewWithTag:10];
    NSString *tel=[telText.text trimString];
    if ( ![tel isValidateMobile])
    {
        [self ShowAlertWithMessage:@"请输入有效的手机号码"];
        return;
    }
    [self CloseKeyBoard];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy UserGetVerifyCodeWithMobile:tel Type:@"3" Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if (![code isEqualToString:@"0"]) {
            [self ShowAlertWithMessage:msg];
        }else{
            _code=[NSString stringWithFormat:@"%@",[models objectForKey:@"verify_code"]];
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
-(void)selectEvent:(UIButton *)sedner{
      [self.view endEditing:YES];
    _selectedBtn.selected=NO;
    _selectedBtn=sedner;
    _selectedBtn.selected=YES;
}
-(void)SelectedType:(UITapGestureRecognizer *)tap{
      [self.view endEditing:YES];
    UILabel *L=(UILabel *)[tap view];
    UIButton *Bnt=(UIButton *)[self.view viewWithTag:L.tag-30];
    [self selectEvent:Bnt];
}
#pragma mark-----提现方法
-(void)tixianEvent{
      [self CloseKeyBoard];
    UITextField *CodeText=(UITextField *)[self.view viewWithTag:11];
    NSString *code=[CodeText.text trimString];
    if ([code isEmptyString] || ![code isEqualToString:_code]) {
        [self ShowAlertWithMessage:@"请输入正确的验证码"];
        return;
    }
    UITextField *ZhangHaoText=(UITextField *)[self.view viewWithTag:12];
    NSString *zhanghao=[ZhangHaoText.text trimString];
    if ([zhanghao isEmptyString] || zhanghao.length<1) {
        [self ShowAlertWithMessage:@"请输入您的账号"];
        return;
    }
    UITextField *jinEText=(UITextField *)[self.view viewWithTag:13];
    NSString *jinE=[jinEText.text trimString];
    if ([jinE floatValue]<=0 || [jinE componentsSeparatedByString:@"."].count>2) {
        [self ShowAlertWithMessage:@"请输入提现金额"];
        return;
    }
    if ([jinE floatValue]<[_Least_amount floatValue]) {
        [self ShowAlertWithMessage:[NSString stringWithFormat:@"提现最低限额为%@",_Least_amount]];
        return;
    }
    if ([jinE floatValue]>[_Count floatValue]) {
        [self ShowAlertWithMessage:@"您的账号余额不足"];
        return;
    }
  
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ApplyWithDrawWithUser_ID:[Stockpile sharedStockpile].ID Account_type:[NSString stringWithFormat:@"%ld",(long)_selectedBtn.tag] Account:zhanghao Amout:jinE Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
      
        if ([code isEqualToString:@"0"]) {
             _code=nil;
              jinEText.text=@"";
            [self saveBtnEvent:nil];
        }
       
    }];
}

#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"申请提现";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-75*self.scale, self.TitleLabel.top, 75*self.scale, self.TitleLabel.height)];
    [saveBtn setTitle:@"提现明细" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    TiXianMingXiViewController *tixianmingxi = [TiXianMingXiViewController new];
    [self.navigationController pushViewController:tixianmingxi animated:YES];
    
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
