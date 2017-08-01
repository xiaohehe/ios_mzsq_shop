//
//  AddPopleViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddPopleViewController.h"
#import "CellView.h"

@interface AddPopleViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)AddReshBlock block;
@end

@implementation AddPopleViewController
-(id)initWithBlock:(AddReshBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the
    [self returnVi];
    NSArray *arr = @[@"请输入新员工姓名",@"请输入新员工联系方式"];
    float setY = self.NavImg.bottom+10*self.scale;
    for (int i=0; i<2; i++) {
        CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44*self.scale)];
        nameCell.backgroundColor = [UIColor whiteColor];
        nameCell.topline.hidden = i!=0;
        [self.view addSubview:nameCell];
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, nameCell.width, nameCell.height)];
        tf.placeholder=arr[i];
        tf.font=DefaultFont(self.scale);
        tf.tag=10+i;
        if (i==0) {
            [tf setMaxLength:Lenth10];
        }
        tf.delegate=self;
        [nameCell addSubview:tf];
        
        setY = nameCell.bottom;
    }
    [self.view addSubview:self.activityVC];
    /*监听TextField的变化*/
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if (name.length>10) {
        name=[name substringToIndex:10];
    }
    NameText.text=name;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==11) {
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    return YES;
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
    
    self.TitleLabel.text=@"添加新员工";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"添加" forState:UIControlStateNormal];
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
    
    [self.view endEditing:YES];
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    UITextField *TelText=(UITextField *)[self.view viewWithTag:11];
    NSString *name=[NameText.text trimString];
    NSString *tel=[TelText.text trimString];
    
    if ([name isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入新员工姓名"];
        return;
    }
    if ([tel isEmptyString] || ![tel isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入新员工联系方式"];
        return;
    }

    [self.activityVC startAnimating];
    AnalyzeObject *anali=[[AnalyzeObject alloc]init];
    [anali AddStaffWithUser_id:[Stockpile sharedStockpile].ID Staff_name:name Staff_mobile:tel Block:^(id models, NSString *code, NSString *msg) {
        [self ShowAlertWithMessage:msg];
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            if (_block) {
                _block();
            }
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
