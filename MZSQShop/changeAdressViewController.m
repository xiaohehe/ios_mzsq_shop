//
//  changeAdressViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "changeAdressViewController.h"
#import "HuoQuDiTuZuoBiaoViewController.h"
#import "GetBaiDuMapViewController.h"
@interface changeAdressViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSDictionary *AdressDic;
@end

@implementation changeAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    
    UIView *bigVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, self.view.width, 44.0f)];
    bigVi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigVi];
    
    UITextField *lable = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-40*self.scale,bigVi.height)];
    lable.font = DefaultFont(self.scale);
    lable.placeholder = @"请输入店铺地址";
    lable.tag=10;
    [lable setMaxLength:AddLength];
    lable.text=_Adress;
    lable.delegate=self;
    [bigVi addSubview:lable];
    [self.view addSubview:self.activityVC];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(bigVi.width-36*self.scale, bigVi.height/2-14*self.scale, 28*self.scale, 28*self.scale)];
    [button setImage:[UIImage imageNamed:@"xq_dibiao"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(HuoQuAddressEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bigVi addSubview:button];
    
    /*监听TextField的变化*/
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)HuoQuAddressEvent:(id)sender{
    GetBaiDuMapViewController *huoQuVC=[[GetBaiDuMapViewController alloc]init];
    [huoQuVC getZuoBiaoBlock:^(NSDictionary *dic) {
        UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
        _AdressDic=[dic mutableCopy];
        NameText.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]] EmptyStringByWhitespace];
    }];
    [self.navigationController pushViewController:huoQuVC animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if (name.length>40) {
        name=[name substringToIndex:40];
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
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺地址";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(changeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
-(void)changeBtnEvent:(UIButton *)sender{

    [self.view endEditing:YES];
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if ([name length]<1) {
        [self ShowAlertWithMessage:@"请输入店铺地址"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyShopAddressWithUser_ID:[Stockpile sharedStockpile].ID Address:name Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
      
        if ([code isEqualToString:@"0"]) {
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:name forKey:@"address"];
         //   if (_AdressDic) {
              //  [self.activityVC startAnimating];
               // [analy ModifyShopCoordinateWithUser_ID:[Stockpile sharedStockpile].ID Lng:[_AdressDic objectForKey:@"longitude"] Lat:[_AdressDic objectForKey:@"latitude"] Block:^(id models, NSString *code, NSString *msg) {
                 //    [self.activityVC stopAnimating];
                 //     [self ShowAlertWithMessage:msg];
                  //  [Info setObject:[_AdressDic objectForKey:@"longitude"] forKey:@"longitude"];
                 //   [Info setObject:[_AdressDic objectForKey:@"latitude"] forKey:@"latitude"];
               //     [model setObject:Info forKey:@"shop_info"];
                //    [[Stockpile  sharedStockpile]setModel:model];
                 //   dispatch_async(dispatch_get_main_queue(), ^{
                        //  [self PopVC:nil];
                 //   });
                  
             //   }];
         //   }else{
                  [self ShowAlertWithMessage:msg];
                [model setObject:Info forKey:@"shop_info"];
                [[Stockpile  sharedStockpile]setModel:model];
                 [self PopVC:nil];
         //   }
        }else{
              [self ShowAlertWithMessage:msg];
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
