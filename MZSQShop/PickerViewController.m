//
//  PickerViewController.m
//  LeLeFangChan
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@property (nonatomic,strong)UIDatePicker *datePicker;

@property (nonatomic,strong)PickerBlock block;
@end

@implementation PickerViewController

- (void)getPickerDateBlock:(PickerBlock)block{

    _block = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavImg.alpha = 0;
    
    
    [self newPickerV];

    [self newBtn];

}
- (void)newBtn{

    UILabel *qingChuL = [[UILabel     alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    qingChuL.text = @"清除已选";
    qingChuL.textColor = [UIColor grayColor];
    qingChuL.backgroundColor = [UIColor clearColor];
    qingChuL.textAlignment = 1;
    qingChuL.font = [UIFont systemFontOfSize:12*self.scale];
    
    [self.view addSubview:qingChuL];
    
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
    hxImg.backgroundColor  = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self.view addSubview:hxImg];
    
    UIImageView *hxImg1  = [[UIImageView alloc] initWithFrame:CGRectMake(0,queDingBtn.bottom - .5, self.view.width, .5)];
    hxImg1.backgroundColor  = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [self.view addSubview:hxImg1];
    
    

}
- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 1) {
        _block(@"");
    }else{
        NSLog(@"%@",_datePicker.date);
        
        NSString *dateStr =[NSString stringWithFormat:@"%@",_datePicker.date];
        dateStr = [dateStr componentsSeparatedByString:@" "][0];
        
        _block(dateStr);
    }

}
- (void)newPickerV{
     _datePicker=[[ UIDatePicker alloc] initWithFrame:CGRectMake(0, 44*self.scale, self.view.width, 437*self.scale/2.25)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:_datePicker];
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
