//
//  ShangJiaJieShaoViewController.m
//  MZSQShop
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ShangJiaJieShaoViewController.h"
#import "CellView.h"
@interface ShangJiaJieShaoViewController ()<UITextViewDelegate>

@end

@implementation ShangJiaJieShaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy SummaryWithUser_ID:[Stockpile sharedStockpile].ID Summary:@"" Type:@"2" Block:^(id models, NSString *code, NSString *msg) {
          [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"] && models) {
             UITextView *Advise=(UITextView *)[self.view viewWithTag:1];
            Advise.text=[[[NSString stringWithFormat:@"%@",[models objectForKey:@"summary"]] EmptyStringByWhitespace] trimString];
      
                UILabel *label=(UILabel *)[self.view viewWithTag:12];
                label.hidden= Advise.text.length>0;
            if (Advise.text.length>140) {
                Advise.text=[Advise.text substringToIndex:140];
            }
            UILabel *zi =(UILabel *)[self.view viewWithTag:20];
            zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)Advise.text.length];
     
        }
    }];
}
-(void)newView{
    
    CellView *TextBg=[[CellView alloc]initWithFrame:CGRectMake(0,self.NavImg.bottom+ 10, self.view.width, 160*self.scale)];
    TextBg.backgroundColor=[UIColor whiteColor];
    TextBg.topline.hidden=NO;
    TextBg.bottomline.hidden=NO;
    [self.view addSubview:TextBg];
    
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, TextBg.width-30, 20)];
    placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    placeLabel.text=@"请输入商家简介";//最多输入140个字符
    placeLabel.tag=12;
    placeLabel.numberOfLines=0;
    placeLabel.font=DefaultFont(self.scale);
    [TextBg addSubview:placeLabel];
    
    UITextView *contentText=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, TextBg.width-20, TextBg.height-10)];
    contentText.backgroundColor=[UIColor clearColor];
    contentText.tag=1;
    contentText.delegate=self;
    contentText.font=DefaultFont(self.scale);
    [TextBg addSubview:contentText];
    
    UILabel *ZiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, TextBg.bottom, self.view.width-20*self.scale, 20*self.scale)];
    ZiLabel.font=[UIFont systemFontOfSize:12*self.scale];
    ZiLabel.text=@"您最多还可以输入140个字";
    ZiLabel.textAlignment=NSTextAlignmentRight;
    ZiLabel.textColor=[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    ZiLabel.tag = 20;
    [self.view addSubview:ZiLabel];
    //[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, bottomLine.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
 /*   UIButton *tiJiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tiJiaoBtn.frame = CGRectMake(18*self.scale, ZiLabel.bottom+10*self.scale, self.view.width - 36*self.scale, 35*self.scale);
    [tiJiaoBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
    [tiJiaoBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    tiJiaoBtn.titleLabel.font=BigFont(self.scale);
    [tiJiaoBtn setTitle:@"确认" forState:UIControlStateNormal];
    [tiJiaoBtn addTarget:self action:@selector(FaBiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tiJiaoBtn];*/
    
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
    if (textView.text.length>140) {
        textView.text=[textView.text substringToIndex:140];
    }
    UILabel *zi =(UILabel *)[self.view viewWithTag:20];
    zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)textView.text.length];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)FaBiaoBtnClick:(id)sender{
    [self.view endEditing:YES];
    UITextView *Advise=(UITextView *)[self.view viewWithTag:1];
    NSString *content=[Advise.text trimString];
    if (!content || content.length<1) {
        [self ShowAlertWithMessage:@"请输入商家简介"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy SummaryWithUser_ID:[Stockpile sharedStockpile].ID Summary:content Type:@"1" Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];
}

#pragma mark - 
-(void)newNav{
    self.TitleLabel.text=@"商家简介";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(FaBiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
}
-(void)PopVC:(UIButton *)sender{
     [self.view endEditing:YES];
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
