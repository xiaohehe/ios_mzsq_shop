//
//  AddShangJiaTypeViewController.m
//  MZSQShop
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AddShangJiaTypeViewController.h"
#import "CellView.h"
@interface AddShangJiaTypeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) AddShangJiaType_Block tblock;
@end

@implementation AddShangJiaTypeViewController
-(id)initWithBlock:(AddShangJiaType_Block)block{
    self=[super init];
    if (self) {
        _tblock=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    CellView *bigVi = [[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 44*self.scale)];
    bigVi.backgroundColor = [UIColor whiteColor];
    bigVi.topline.hidden=NO;
    [self.view addSubview:bigVi];
    
    UITextField *lable = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale,bigVi.height)];
    lable.font = DefaultFont(self.scale);
    lable.placeholder = @"请输入申请商铺类别的名称";
    lable.tag=10;
    [lable setMaxLength:Lenth20];
    lable.delegate=self;
    [bigVi addSubview:lable];
    /*监听TextField的变化*/
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if (name.length>20) {
        name=[name substringToIndex:20];
    }
    NameText.text=name;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"申请商铺类别";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top,70*self.scale, self.TitleLabel.height)];
    [saveBtn setTitle:@"申请类别" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(1);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
}
-(void)saveBtnEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if ([name length]<1) {
        [self ShowAlertWithMessage:@"请输入申请商铺类别的名称"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ApplyServeTypeWithUser_ID:[Stockpile sharedStockpile].ID Serve_type_name:name Block:^(id models, NSString *code, NSString *msg) {
        
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_isModel) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }else{
                       [self.navigationController popViewControllerAnimated:NO];
                }
             
                if (_tblock) {
                    _tblock(name);
                }
            });
            
        }
    }];
}
-(void)PopVC:(UIButton *)sender{
    if (_isModel) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else
    {
         [self.navigationController popViewControllerAnimated:YES];
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
