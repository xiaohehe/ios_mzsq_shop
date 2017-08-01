//
//  ShopTimeSetViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopTimeSetViewController.h"
#import "CellView.h"
#import "PickerDataViewController.h"
@interface ShopTimeSetViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)NSDictionary *InfoDic;
@property(nonatomic,strong)PickerDataViewController *pickerVC;
@end

@implementation ShopTimeSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    [self newView];
    [self newDatePick];
    [self.view addSubview:self.activityVC];
    [self ReshData];
  /*  */
}
-(void)newDatePick{
    
    _pickerVC = [[PickerDataViewController alloc] init];
    _pickerVC.view.frame = CGRectMake(0, self.view.height , self.view.width, (437/2.25+44)*self.scale);
    [self.view addSubview:_pickerVC.view];
}
-(void)ShowPick{
    [self.view endEditing:YES];
    [UIView animateWithDuration:.3 animations:^{
        _pickerVC.view.frame = CGRectMake(0, self.view.height - (437/2.25+44)*self.scale, self.view.width, (437/2.25+44)*self.scale);
    }];
}
-(void)HiddenPick{
    [UIView animateWithDuration:.3 animations:^{
        _pickerVC.view.frame = CGRectMake(0, self.view.height , self.view.width, (437/2.25+44)*self.scale);
    }];
}

-(void)newDetail{
    float setY=10*self.scale;
    float setX=0;
    //NSArray *Arr=[_InfoDic objectForKey:@"hour_params"];
    NSArray *SelectArr=[[NSString stringWithFormat:@"%@",[_InfoDic objectForKey:@"business_hour"]] componentsSeparatedByString:@","];
    for (int i=0; i<3; i++) {
        //NSDictionary *IDic = [Arr objectAtIndex:i];
        NSString *StartTimekey=[NSString stringWithFormat:@"business_start_hour%d",i+1];
        NSString *EndTimekey=[NSString stringWithFormat:@"business_end_hour%d",i+1];
        CellView *time1Cell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 45*self.scale)];
        time1Cell.backgroundColor = [UIColor whiteColor];
        time1Cell.topline.hidden=i!=0;
        [_mainScrollView addSubview:time1Cell];
        UIButton *btnImg1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImg1.frame = CGRectMake(5*self.scale, time1Cell.height/2-20*self.scale, 40*self.scale, 40*self.scale);
        [btnImg1 setBackgroundImage:[UIImage imageNamed:@"v1"] forState:UIControlStateNormal];
        [btnImg1 setBackgroundImage:[UIImage imageNamed:@"v2"] forState:UIControlStateSelected];
        btnImg1.tag=1+i;
        btnImg1.selected=NO;
        for (id Va in SelectArr )
        {
            if ([Va integerValue] ==i+1) {
                btnImg1.selected=YES;
            }
        }
        [btnImg1 addTarget:self action:@selector(btnSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
        [time1Cell addSubview:btnImg1];
        
        UITextField *TextF=[[UITextField alloc]initWithFrame:CGRectMake(btnImg1.right+10*self.scale, 0, 90*self.scale, time1Cell.height)];
        TextF.tag=100+i*2+1;
        TextF.delegate=self;
        TextF.text=[NSString stringWithFormat:@"%@",[_InfoDic objectForKey:StartTimekey]];
        TextF.font = DefaultFont(self.scale);
        TextF.textAlignment=NSTextAlignmentRight;
        [time1Cell addSubview:TextF];
        time1Cell.contentLabel.frame=CGRectMake(TextF.right+5*self.scale, time1Cell.contentLabel.top,15*self.scale, time1Cell.contentLabel.height);
        time1Cell.contentLabel.font=DefaultFont(self.scale);
        time1Cell.contentLabel.textAlignment=NSTextAlignmentCenter;
        time1Cell.contentLabel.text=[NSString stringWithFormat:@"至"];
        UITextField *TextFS=[[UITextField alloc]initWithFrame:CGRectMake(time1Cell.contentLabel.right+5*self.scale, 0, 90*self.scale, time1Cell.height)];
        TextFS.tag=100+i*2+2;
        TextFS.delegate=self;
        TextFS.text=[NSString stringWithFormat:@"%@",[_InfoDic objectForKey:EndTimekey]];
        TextFS.font = DefaultFont(self.scale);
        [time1Cell addSubview:TextFS];
        setY = time1Cell.bottom;
    }
    setY+=10*self.scale;
    for (int i=0; i<2; i++) {
        CellView *time1Cell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 45*self.scale)];
        time1Cell.backgroundColor = [UIColor whiteColor];
        time1Cell.topline.hidden=i!=0;
        [_mainScrollView addSubview:time1Cell];
        UIButton *btnImg1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImg1.frame = CGRectMake(5*self.scale, time1Cell.height/2-20*self.scale, 40*self.scale, 40*self.scale);
        [btnImg1 setBackgroundImage:[UIImage imageNamed:@"v1"] forState:UIControlStateNormal];
        [btnImg1 setBackgroundImage:[UIImage imageNamed:@"v2"] forState:UIControlStateSelected];
         btnImg1.tag=4+i;
        btnImg1.userInteractionEnabled=NO;
        btnImg1.selected=NO;
        btnImg1.selected = i==0?([[_InfoDic objectForKey:@"off_on_saturday"] integerValue]==2):([[_InfoDic objectForKey:@"off_on_sunday"] integerValue]==2);
     //   [btnImg1 addTarget:self action:@selector(btnSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
        [time1Cell addSubview:btnImg1];
        setX=btnImg1.right+10*self.scale;
        time1Cell.contentLabel.frame=CGRectMake(btnImg1.right+10*self.scale, time1Cell.contentLabel.top, time1Cell.width-btnImg1.right-60.*self.scale, time1Cell.contentLabel.height);
        time1Cell.contentLabel.textAlignment=NSTextAlignmentCenter;
        time1Cell.contentLabel.font=DefaultFont(self.scale);
        time1Cell.contentLabel.text=i==0?@"周六休息":@"周日休息";
        time1Cell.tag=i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapTimeEvent:)];
        [time1Cell addGestureRecognizer:tap];
        setY = time1Cell.bottom;
    }
    
        CellView *xiuxiCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY+10*self.scale, self.view.width, 45*self.scale)];
        xiuxiCell.topline.hidden=NO;
        xiuxiCell.contentLabel.frame=CGRectMake(setX, xiuxiCell.height/2-10*self.scale, 200*self.scale, 20*self.scale);
        xiuxiCell.contentLabel.text=@"歇业";
        [_mainScrollView addSubview:xiuxiCell];
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.width-59*self.scale,xiuxiCell.height/2-11*self.scale, 49*self.scale, 22*self.scale);
        [btn setBackgroundImage:[UIImage imageNamed:@"v4"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"v3"] forState:UIControlStateSelected];
        btn.selected=([[_InfoDic objectForKey:@"status"] integerValue]==3);
        btn.tag = 10;
        [btn addTarget:self action:@selector(XYbtnSelectEvent:) forControlEvents:UIControlEventTouchUpInside];
        [xiuxiCell addSubview:btn];
        setY = xiuxiCell.bottom;
    _mainScrollView.contentSize=CGSizeMake(self.view.width, setY+15*self.scale);
}
-(void)XYbtnSelectEvent:(UIButton *)button{
     button.selected=!button.selected;
    [self.activityVC startAnimating];
    NSString *status=button.selected?@"2":@"1";
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy CloseOrOpenShopWithWithUser_ID:[Stockpile sharedStockpile].ID Status:status Block:^(id models, NSString *code, NSString *msg) {
         [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if (![code isEqualToString:@"0"]) {
            button.selected=!button.selected;
        }
    }];
}
-(void)TapTimeEvent:(UITapGestureRecognizer *)tap{
    CellView *cell=(CellView *)[tap view];
    NSInteger tag = cell.tag+4;
    UIButton *sender=(UIButton *)[self.view viewWithTag:tag];
    sender.selected = !sender.selected;
    if (tag == 4) {
        NSString *status=sender.selected?@"2":@"1";
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy OffOnSaturdayWithWithUser_ID:[Stockpile sharedStockpile].ID Status:status Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if (![code isEqualToString:@"0"]) {
                sender.selected=!sender.selected;
            }
        }];

    }else if (tag == 5){
        NSString *status=sender.selected?@"2":@"1";
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy OffOnSundayWithWithUser_ID:[Stockpile sharedStockpile].ID Status:status Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if (![code isEqualToString:@"0"]) {
                sender.selected=!sender.selected;
            }
        }];

    }

}

-(void)newView{
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 /*   NSMutableArray *HArr=[[NSMutableArray alloc]init];
    for (int i=0; i<24; i++) {
        [HArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    NSMutableArray *MArr=[[NSMutableArray alloc]init];
    for (int i=0; i<60; i++) {
        [MArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
  
    NSArray *Arr=@[HArr,MArr];*/
    [self ShowPick];
    [_pickerVC getPickerDate:nil Block:^(NSString *pickerstr) {
        if (pickerstr.length>0) {
             textField.text = pickerstr;
        }
        [self HiddenPick];
        [self textUpDateTime:(textField.tag-100)];
    }];
    return NO;
}
-(void)textUpDateTime:(NSInteger)tag{
    UITextField *Time1=(UITextField *)[self.view viewWithTag:101];
    UITextField *Time2=(UITextField *)[self.view viewWithTag:102];
    if (Time1.text.length>0 && Time2.text.length>0 && tag<3) {
        UIButton *btnImg1=(UIButton *)[self.view viewWithTag:1];
        
        [self UpDataTimeStime:Time1.text Type:@"1" EndTime:Time2.text Selected:btnImg1.selected?@"2":@"1"];
    }
    UITextField *Time3=(UITextField *)[self.view viewWithTag:103];
    UITextField *Time4=(UITextField *)[self.view viewWithTag:104];
    if (Time3.text.length>0 && Time4.text.length>0 && tag<5 && tag>2) {
        UIButton *btnImg1=(UIButton *)[self.view viewWithTag:2];
         [self UpDataTimeStime:Time3.text Type:@"2" EndTime:Time4.text Selected:btnImg1.selected?@"2":@"1"];
    }
    UITextField *Time5=(UITextField *)[self.view viewWithTag:105];
    UITextField *Time6=(UITextField *)[self.view viewWithTag:106];
    if (Time5.text.length>0 && Time6.text.length>0 && tag>4) {
        UIButton *btnImg1=(UIButton *)[self.view viewWithTag:3];
         [self UpDataTimeStime:Time5.text Type:@"3" EndTime:Time6.text Selected:btnImg1.selected?@"2":@"1"];
    }
}
-(void)UpDataTimeStime:(NSString *)Stime Type:(NSString *)type EndTime:(NSString *)endtime Selected:(NSString *)selected{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyServeHourWithWithUser_ID:[Stockpile sharedStockpile].ID Hour_type:type Is_check:selected Business_start_hour:Stime Business_end_hour:endtime Block:^(id models, NSString *code, NSString *msg){
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if (![code isEqualToString:@"0"]) {
            UIButton *sender=(UIButton *)[self.view viewWithTag:[type integerValue]];
            sender.selected=!sender.selected;
        }

        
    }];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy GetServeHourWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if (models && [code isEqualToString:@"0"]) {
            _InfoDic=[models mutableCopy];
            if (_InfoDic) {
                [self newDetail];
            }
            
        }
    }];
}
-(void)btnSelectEvent:(UIButton *)sender{
    sender.selected=!sender.selected;
        switch (sender.tag) {
            case 1:
            {
                 [self textUpDateTime:1];
            }
                break;
            case 2:
            {
                 [self textUpDateTime:3];
            }
                break;
            case 3:
            {
                [self textUpDateTime:5];
            }
                break;
            case 4:
            {
                NSString *status=sender.selected?@"2":@"1";
                [self.activityVC startAnimating];
                AnalyzeObject *analy=[[AnalyzeObject alloc]init];
                [analy OffOnSaturdayWithWithUser_ID:[Stockpile sharedStockpile].ID Status:status Block:^(id models, NSString *code, NSString *msg) {
                     [self.activityVC stopAnimating];
                    [self ShowAlertWithMessage:msg];
                    if (![code isEqualToString:@"0"]) {
                        sender.selected=!sender.selected;
                    }
                }];
            }
                break;
            case 5:
            {
                NSString *status=sender.selected?@"2":@"1";
                [self.activityVC startAnimating];
                AnalyzeObject *analy=[[AnalyzeObject alloc]init];
                [analy OffOnSundayWithWithUser_ID:[Stockpile sharedStockpile].ID Status:status Block:^(id models, NSString *code, NSString *msg) {
                    [self.activityVC stopAnimating];
                     [self ShowAlertWithMessage:msg];
                    if (![code isEqualToString:@"0"]) {
                         sender.selected=!sender.selected;
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"营业时间设置";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    /*UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];*/
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
    
    
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
