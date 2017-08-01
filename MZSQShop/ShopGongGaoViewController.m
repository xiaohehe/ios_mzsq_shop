//
//  ShopGongGaoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopGongGaoViewController.h"

@interface ShopGongGaoViewController ()<UITextViewDelegate>

@end

@implementation ShopGongGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    
    NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
    NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
    
    UIView *TextBg=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,self.NavImg.bottom+ 10*self.scale, self.view.width-20*self.scale, 160*self.scale)];
    TextBg.backgroundColor=[UIColor whiteColor];
    TextBg.layer.borderColor=blackLineColore.CGColor;
    TextBg.layer.borderWidth = .5;
    [self.view addSubview:TextBg];
    
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, TextBg.width-30, 20)];
    placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    placeLabel.text=@"请输入店铺公告";//最多输入140个字
    placeLabel.tag=12;
    placeLabel.numberOfLines=0;
    placeLabel.font=DefaultFont(self.scale);
    [TextBg addSubview:placeLabel];
    
    UITextView *contentText=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, TextBg.width-20, TextBg.height-10)];
    contentText.backgroundColor=[UIColor clearColor];
    contentText.tag=1;
    contentText.text=[[NSString stringWithFormat:@"%@",[Info objectForKey:@"notice"]] EmptyStringByWhitespace];
    if (![contentText.text isEmptyString]) {
        placeLabel.hidden=YES;
    }
    contentText.delegate=self;
    contentText.font=DefaultFont(self.scale);
    [TextBg addSubview:contentText];
    
    [self.view addSubview:self.activityVC];
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
    NSString * name =[textView.text trimString];
 if (name.length>100) {
        textView.text=[name substringToIndex:100];
    }
   // UILabel *zi =(UILabel *)[self.view viewWithTag:20];
   // zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)textView.text.length];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺公告";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"发布" forState:UIControlStateNormal];
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
    UITextView *Advise=(UITextView *)[self.view viewWithTag:1];
    NSString *content=[Advise.text trimString];
    if (!content || content.length<1) {
        [self ShowAlertWithMessage:@"请输入有效的建议内容"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyShopNoticeWithUser_ID:[Stockpile sharedStockpile].ID Notice:content Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:content forKey:@"notice"];
            [model setObject:Info forKey:@"shop_info"];
            [[Stockpile  sharedStockpile]setModel:model];
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
