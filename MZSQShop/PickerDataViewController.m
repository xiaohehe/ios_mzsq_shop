//
//  PickerDataViewController.m
//  MeiYanShop
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "PickerDataViewController.h"

@interface PickerDataViewController ()//<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIDatePicker *datePicker;

@property (nonatomic,strong)PickerDataBlock block;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation PickerDataViewController
- (void)getPickerDate:(NSArray *)data Block:(PickerDataBlock)block{
    _dataSource=[NSMutableArray new];
   // [_dataSource addObjectsFromArray:data];
    _block = block;
 //  [_datePicker reloadAllComponents];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavImg.alpha = 0;
    
    [self newPickerV];
    
    [self newBtn];
}
- (void)newBtn{
    
  /*  UILabel *qingChuL = [[UILabel     alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    qingChuL.text = @"清除已选";
    qingChuL.textColor = [UIColor grayColor];
    qingChuL.backgroundColor = [UIColor clearColor];
    qingChuL.textAlignment = 1;
    qingChuL.font = [UIFont systemFontOfSize:12*self.scale];
    
    [self.view addSubview:qingChuL];*/
    
    UIButton *quXiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quXiaoBtn.frame = CGRectMake(0,0  , 60*self.scale, 44*self.scale);
    [quXiaoBtn setTitle:@"取消" forState:0];
    [quXiaoBtn setTitleColor:grayTextColor forState:0];
    quXiaoBtn.tag = 1;
    [quXiaoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    quXiaoBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    [self.view addSubview:quXiaoBtn];
    
    UIButton *queDingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queDingBtn.frame = CGRectMake(self.view.width - 60*self.scale,0, 60*self.scale, 44*self.scale);
    [queDingBtn setTitle:@"确定" forState:0];
    [queDingBtn setTitleColor:blueTextColor forState:0];
    queDingBtn.tag = 2;
    [queDingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    queDingBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13*self.scale];
    [self.view addSubview:queDingBtn];
    
    
    UIImageView *hxImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.width, .5)];
    hxImg.backgroundColor  = blackLineColore;
    [self.view addSubview:hxImg];
    
    UIImageView *hxImg1  = [[UIImageView alloc] initWithFrame:CGRectMake(0,queDingBtn.bottom - .5, self.view.width, .5)];
    hxImg1.backgroundColor  = blackLineColore;
    [self.view addSubview:hxImg1];
    
}
- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 1) {
        _block(@"");
    }else{
          NSLog(@"%@",_datePicker.date);
        
        NSDate *selected = _datePicker.date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *destDateString = [dateFormatter stringFromDate:selected];
     
    /*-   NSMutableArray *Arr=[[NSMutableArray alloc]init];
        NSString *RT=@"";
        for (int i=0; i<_dataSource.count; i++)
        {
            NSArray *resultArr=[_dataSource objectAtIndex:i];
         NSString *result=[resultArr objectAtIndex:[_datePicker selectedRowInComponent:i]];
           RT=[NSString stringWithFormat:@"%@:%@",RT,result];
            [Arr addObject:result];
        }
        if (RT.length>0) {
            RT=[RT substringFromIndex:1];
        }*/
       _block(destDateString);
    }
    
}
- (void)newPickerV{
    
   _datePicker=[[ UIDatePicker alloc] initWithFrame:CGRectMake(0, 44*self.scale, self.view.width, 437*self.scale/2.25)];
    _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [self.view addSubview:_datePicker];
    
  /* _datePicker=[[ UIPickerView alloc] initWithFrame:CGRectMake(0, 44*self.scale, self.view.width, 437*self.scale/2.25)];
      _datePicker.delegate = self;
   _datePicker.dataSource = self;
    [self.view addSubview:_datePicker];*/
}
#pragma mark PickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [_dataSource count] ;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[_dataSource objectAtIndex:component] count];
}
/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 70*self.scale, 70*self.scale);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:Big17Font(self.scale)];
    }
    pickerLabel.text =[NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:component] objectAtIndex:row]];
    return pickerLabel;
}*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%@",[[_dataSource objectAtIndex:component] objectAtIndex:row]];
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
