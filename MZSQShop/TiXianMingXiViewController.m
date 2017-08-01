//
//  TiXianMingXiViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TiXianMingXiViewController.h"
#import "PickerViewController.h"
#import "HistoryTableViewCell.h"
#import "CellView.h"
@interface TiXianMingXiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)CellView *chacun;
@property(nonatomic,strong)UIControl *bigcon;
@property(nonatomic,strong)UIView *timeVi;
@property(nonatomic,strong)PickerViewController *pickerVc;
@property(nonatomic,strong)UIButton *timeOne,*timeTwo;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString *StartTime,*EndTime;
@end

@implementation TiXianMingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self returnVi];
    [self chaXunVC];
    [self infocellVC];
    _dataSource=[NSMutableArray new];
   [self newDatePick];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)newDatePick{
    
    _pickerVc = [[PickerViewController alloc] init];
    _pickerVc.view.frame = CGRectMake(0, self.view.height , self.view.width, (437/2.25+44)*self.scale);
    [self.view addSubview:_pickerVc.view];
}
-(void)ShowPick{
    [self.view endEditing:YES];
    [UIView animateWithDuration:.3 animations:^{
        _pickerVc.view.frame = CGRectMake(0, self.view.height - (437/2.25+44)*self.scale, self.view.width, (437/2.25+44)*self.scale);
    }];
}
-(void)HiddenPick{
    [UIView animateWithDuration:.3 animations:^{
        _pickerVc.view.frame = CGRectMake(0, self.view.height , self.view.width, (437/2.25+44)*self.scale);
    }];
}
#pragma mark----查询
-(void)chaXunVC{
    
    _chacun = [[CellView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 44)];
    _chacun.titleLabel.text=@"查询日期";
    _chacun.titleLabel.width=60*self.scale;
    _chacun.userInteractionEnabled=YES;
    [self.view addSubview:_chacun];
    
    UIButton *chaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chaBtn.backgroundColor = blueTextColor;
    [chaBtn setTitle:@"查询" forState:UIControlStateNormal];
    chaBtn.frame = CGRectMake(self.view.width-50*self.scale, _chacun.titleLabel.top, 40*self.scale, 20*self.scale);
    chaBtn.titleLabel.font = BoldSmallFont(self.scale);
    [chaBtn addTarget:self action:@selector(ChaXunEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_chacun addSubview:chaBtn];
    NSDate *date=[NSDate new];
    
    _timeOne = [[UIButton alloc]initWithFrame:CGRectMake(_chacun.titleLabel.right, chaBtn.top, 70*self.scale, 20*self.scale )];
    [_timeOne setTitle:[NSString stringFromDate:date] forState:UIControlStateNormal];
    [_timeOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _timeOne.tag=1;
    [_timeOne addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    _timeOne.titleLabel.font=SmallFont(self.scale);
    [_chacun addSubview:_timeOne];
    UIView *bline1 = [[UIView alloc]initWithFrame:CGRectMake(-5, _timeOne.height+5, _timeOne.width+10, .5)];
    bline1.backgroundColor=blackLineColore;
    [_timeOne addSubview:bline1];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(_timeOne.right+10, _chacun.height/2-.25, 20*self.scale, .5*self.scale )];
    line.backgroundColor=blackLineColore;
    [_chacun addSubview:line];
    _timeTwo = [[UIButton alloc]initWithFrame:CGRectMake(line.right+10, _timeOne.top, _timeOne.width, _timeOne.height)];
    [_timeTwo setTitle:[NSString stringFromDate:date] forState:UIControlStateNormal];
    [_timeTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _timeTwo.tag=2;
    [_timeTwo addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    _timeTwo.titleLabel.font=SmallFont(self.scale);
    [_chacun addSubview:_timeTwo];
    _StartTime=[NSString stringFromDate:date];
    _EndTime=[NSString stringFromDate:date];
    UIView *bline2 = [[UIView alloc]initWithFrame:CGRectMake(-5, _timeTwo.height+5, _timeTwo.width+10, .5)];
    bline2.backgroundColor=blackLineColore;
    [_timeTwo addSubview:bline2];
}
-(void)selectTime:(UIButton *)sender{
  [self ShowPick];
    [_pickerVc   getPickerDateBlock:^(NSString *str) {
        if (sender.tag==1) {
            _StartTime=str;
        }else{
            _EndTime=str;
        }
        [sender setTitle:str forState:UIControlStateNormal];
        [self HiddenPick];
    }];
    
}
-(void)ChaXunEvent:(id)sender{
    if (_StartTime.length<1 || _EndTime.length<1) {
        [self ShowAlertWithMessage:@"选择查询时间"];
        return;
    }
    
    _index=0;
    [self ReshData];
}
-(void)ReshData{
    if([[_StartTime dateFromString] compare:[_EndTime dateFromString]]>0){
        [self ShowAlertWithMessage:@"开始时间应晚于结束时间"];
        return;
    }
    _index++;
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy WithDrawListWithUser_ID:[Stockpile sharedStockpile].ID Start_time:_StartTime End_time:_EndTime Pindex:[NSNumber numberWithInteger:_index] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.footer endRefreshing];
        NSArray *Arr=models;
        if(_index==1){
            [_dataSource removeAllObjects];
            _tableView.footer.hidden=NO;
        }
        if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
            [_dataSource addObjectsFromArray:Arr];
        }
        if (!Arr || Arr.count<FenYe || !models || [code isEqualToString:@"1"]) {
            _tableView.footer.hidden=YES;
        }
        [_tableView  reloadData];
    }];
}
-(void)infocellVC{
    
    CellView *infoCell = [[CellView alloc]initWithFrame:CGRectMake(0, _chacun.bottom+10*self.scale, self.view.width, 44)];
    infoCell.title = @"提现日期";
    [self.view addSubview:infoCell];
    
    UILabel *numberLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2-20*self.scale, infoCell.titleLabel.top, 60*self.scale, 20*self.scale)];
    numberLa.font=DefaultFont(self.scale);
    numberLa.text = @"";
    [infoCell addSubview:numberLa];
    
    UILabel *jineLa = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, infoCell.titleLabel.top, 60*self.scale, 20*self.scale)];
    jineLa.font=DefaultFont(self.scale);
    jineLa.textAlignment=NSTextAlignmentRight;
    jineLa.text = @"提现金额";
    [infoCell addSubview:jineLa];
    
    float setY = infoCell.bottom+10*self.scale;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, self.view.height-setY)];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"TXCell"];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(ReshData)];
    [self.view addSubview:_tableView];
}
#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
   //  return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    HistoryTableViewCell *cell=(HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TXCell" forIndexPath:indexPath];
    cell.topline.hidden = indexPath.row!=0;
    cell.NameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"create_time"]];
    cell.TimeLabel.text=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"amount"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"提现明细";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
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
