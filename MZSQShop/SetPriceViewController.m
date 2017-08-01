//
//  SetPriceViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SetPriceViewController.h"
#import "CellView.h"
@interface SetPriceViewController ()<UITextFieldDelegate>
@property(nonatomic,assign)BOOL isHasPoint ;
@end

@implementation SetPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    
    NSString *Name=@"满多少元免配送费";
    if(_isPeiSong){
        Name=@"配送费";
    }
    CellView *Cell=[[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+15*self.scale, self.view.width, 44*self.scale)];
    Cell.backgroundColor=[UIColor whiteColor];
    Cell.titleLabel.text=Name;
    Cell.topline.hidden=NO;
    Cell.titleLabel.font=DefaultFont(self.scale);
    [Cell.titleLabel sizeToFit];
    UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( Cell.titleLabel.right+10*self.scale, 5*self.scale, Cell.width- Cell.titleLabel.right-40*self.scale, Cell.height-10*self.scale)];
    textF.font=DefaultFont(self.scale);
    textF.placeholder=Name;
    textF.text=_Fee;
    textF.delegate=self;
    textF.textAlignment=NSTextAlignmentRight;
    textF.keyboardType=UIKeyboardTypeNumberPad;
    textF.tag=10;
    [Cell addSubview:textF];
    [self.view addSubview:Cell];
}
-(void)NextButtonEvent:(id)sender{
    [self.view endEditing:YES];
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];
    if ([ypwd floatValue]<0 || [ypwd componentsSeparatedByString:@"."].count>1|| [ypwd isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入恰当的配送费用"];
        return;
    }
    ypwd=[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[ypwd integerValue]]];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    if (_isPeiSong) {
        [analy ModifyDeleverFeeWithUser_ID:[Stockpile sharedStockpile].ID Amount:ypwd Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
                NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
                [Info setObject:ypwd forKey:@"delivery_fee"];
                [model setObject:Info forKey:@"shop_info"];
                [[Stockpile  sharedStockpile]setModel:model];
                [self PopVC:nil];
            }
        }];
    }else{
        [analy ModifyFreeAmountWithUser_ID:[Stockpile sharedStockpile].ID Amount:ypwd Block:^(id models, NSString *code, NSString *msg) {
             [self.activityVC stopAnimating];
              [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
                NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
                [Info setObject:ypwd forKey:@"free_delivery_amount"];
                [model setObject:Info forKey:@"shop_info"];
                [[Stockpile  sharedStockpile]setModel:model];
                   [self PopVC:nil];
            }
        }];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 10){
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
                        return YES;
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


#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"配送费设置";
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
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
