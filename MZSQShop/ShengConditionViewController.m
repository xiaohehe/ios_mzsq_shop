//
//  ShengConditionViewController.m
//  Wedding
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShengConditionViewController.h"
#import "ChineseToPinyin.h"
#import "CityCell.h"
@interface ShengConditionViewController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *proTableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray *existTitles;
@property(nonatomic,strong)CityBlock pickblock;
@end
@implementation ShengConditionViewController
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    for (NSDictionary *dic in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinYinFromChinaString:dic[@"name"]];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:dic];
    }
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinYinFromChinaString:obj1[@"name"]];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            NSString *firstLetter2 = [ChineseToPinyin pinYinFromChinaString:obj2[@"name"]];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    return sortedArray;
}
-(void)allocNSArray
{
    _dataSource=[[NSMutableArray alloc]init];
    _contactsSource=[[NSMutableArray alloc]init];
    _sectionTitles =[[NSMutableArray alloc]init];
    _existTitles = [NSMutableArray array];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self allocNSArray];
    [self newNav];
    [self newProTable];
    [self.view addSubview:self.activityVC];
      [self ReshProData];
}
#pragma mark -
-(void)ReshProData{
    
    [self.activityVC startAnimating];
  AnalyzeObject *anale=[[AnalyzeObject alloc]init];
    [anale GetProvinceListWithBlock:^(id models, NSString *code, NSString *msg) {
        NSArray *Arr=models;
         [self.activityVC stopAnimating];
        if (models && [code isEqualToString:@"0"])
        {
            [_contactsSource addObjectsFromArray:Arr];
            [_dataSource addObjectsFromArray:[self sortDataArray:_contactsSource]];
            [_proTableView reloadData];
        }
       
    }];
}
-(void)Header{
    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50*self.scale)];
    header.backgroundColor=[UIColor clearColor];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20*self.scale)];
    title.backgroundColor=[UIColor clearColor];
    title.text=@"  当前所在";
    title.font=[UIFont systemFontOfSize:12*self.scale];
    [header addSubview:title];
    UIImageView *IMG=[[UIImageView alloc]initWithFrame:CGRectMake(0, title.bottom, self.view.width, header.height-title.bottom)];
    IMG.backgroundColor=superBackgroundColor;
    IMG.userInteractionEnabled=YES;
    [header addSubview:IMG];
    UITextField *text=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, title.width-20, IMG.height)];
    //text.enabled = NO;
    text.backgroundColor=[UIColor clearColor];
    text.font=title.font;
    text.delegate=self;
    text.tag = 500;
    text.placeholder=@"请选择一个城市";
    text.textColor=[UIColor redColor];
    text.text=[NSString stringWithFormat:@"%@",_Sheng];
    [IMG addSubview:text];
    _proTableView.tableHeaderView=header;
   // [self.view addSubview:header];
}
-(void)newProTable{
    _proTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _proTableView.delegate=self;
    _proTableView.dataSource=self;
    _proTableView.tag = 1;
    //设置索引的属性
    _proTableView.sectionIndexTrackingBackgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    _proTableView.sectionIndexColor=grayTextColor;
    _proTableView.sectionIndexBackgroundColor=[UIColor clearColor];
    [_proTableView registerClass:[CityCell class] forCellReuseIdentifier:@"Cell"];
    _proTableView.tableFooterView=[UIView new];
    [_proTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_proTableView];
  //  [self Header];
}
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return _dataSource.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataSource[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    CityCell *cell=(CityCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1) {
        NSDictionary *dic  = _dataSource[indexPath.section][indexPath.row];
        if (_pickblock) {
            _pickblock(dic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.text.length>0) {
        for (NSDictionary *dic in _contactsSource) {
            if (_pickblock &&  [ [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] rangeOfString:textField.text].location != NSNotFound) {
                _pickblock(dic);
                 [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    }
    return NO;
}
#pragma mark - 设置Section
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2 || [_dataSource[section] count]<1) {
        return  nil;
    }
    UILabel *header=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 15*self.scale)];
    header.backgroundColor=blackLineColore;
    header.font=[UIFont systemFontOfSize:12*self.scale];
    NSString *string=[NSString stringWithFormat:@"  %@",_sectionTitles[section]];
    header.text =string;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2 || [_dataSource[section] count]<1) {
        return 0;
    }
    return  15*self.scale;
}
#pragma mark - 设置索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 2) {
        return nil;
    }
  /*  [_existTitles removeAllObjects];
    if (self.view.height>480) {
        [_existTitles addObject:@""];
        for (int i = 0; i < _sectionTitles.count; i++) {
            if ([_dataSource[i] count]>0) {
                [_existTitles addObject:[self.sectionTitles objectAtIndex:i]];
                [_existTitles addObject:@""];
            }
        }
        [_existTitles addObject:@""];
    }else
    {
        [_existTitles addObject:@""];
        for (int i = 0; i < _sectionTitles.count; i++) {
            if ([_dataSource[i] count]>0) {
                [_existTitles addObject:[self.sectionTitles objectAtIndex:i]];
            }
        }
        [_existTitles addObject:@""];
    }*/
   return _sectionTitles;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [self.sectionTitles indexOfObject:title];
}


#pragma mark -
-(void)selectedCity:(CityBlock)cityblock{
    if (cityblock) {
        self.pickblock = cityblock;
    }
}
#pragma mark -
-(void)newNav{
    self.TitleLabel.text = @"选择省份";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
