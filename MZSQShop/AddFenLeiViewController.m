//
//  AddFenLeiViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddFenLeiViewController.h"
#import "CellView.h"
//#import "GoodsEditViewController.h"

@interface AddFenLeiViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)AddFenLeiBlock block;
@end

@implementation AddFenLeiViewController
-(id)initWithBlock:(AddFenLeiBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    
    CellView *nameCell = [[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 44*self.scale)];
    nameCell.topline.hidden=NO;
    [self.view addSubview:nameCell];
    UITextField *nameLa=[[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, nameCell.width, nameCell.height-10*self.scale)];
    nameLa.placeholder=@"请输入分类名称";
    nameLa.font = DefaultFont(self.scale);
    nameLa.tag=10;
    [nameLa setMaxLength:Lenth10];
    nameLa.delegate=self;
    nameLa.text=_Name;
    [nameCell addSubview:nameLa];
    
   /* CellView *NumberCell = [[CellView alloc]initWithFrame:CGRectMake(0, nameCell.bottom, self.view.width, 44.0f)];
    [self.view addSubview:NumberCell];
    UITextField *numberLa=[[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, NumberCell.width, NumberCell.height)];
    numberLa.placeholder=@"请输入分类名称";
    numberLa.font = DefaultFont(self.scale);
    [NumberCell addSubview:numberLa];*/
    [self.view addSubview:self.activityVC];
      //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];
    if (ypwd.length>10) {
        ypwd=[ypwd substringToIndex:10];
        YPwdText.text=ypwd;
    }
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"添加分类";
    
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
    [self.view endEditing:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
      [self.view endEditing:YES];
    
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];
    if (!ypwd || [ypwd isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入分类名称"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    if(_ID && _ID.length>0){
        [analy ModifyProdClassWithUser_id:[Stockpile sharedStockpile].ID Class_id:_ID Class_name:ypwd Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                if(_block){
                    _block();
                }
                [self PopVC:nil];
            }
        }];
    }else{
        [analy AddProdClassWithUser_id:[Stockpile sharedStockpile].ID Class_name:ypwd Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                if(_block){
                    _block();
                }
                [self PopVC:nil];
            }

        }];
    }
    
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
