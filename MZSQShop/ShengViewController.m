//
//  ShengViewController.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShengViewController.h"
#import "ChineseToPinyin.h"
#import "CityCell.h"

#import "ShiViewController.h"
@interface ShengViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)ShengBlock block;
@property(nonatomic,strong)UIView *HeaderView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray *existTitles;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)ShiViewController *shiVC;
@end

@implementation ShengViewController
-(id)initWithBlock:(ShengBlock)block{
    self=[super init];
    if (self) {
        _block=block;
    }
    return self;
}
-(void)ReshViewWithName:(NSString *)name Block:(ShengBlock)block{
    if (name && name.length>0) {
        UILabel *NameLabel=(UILabel *)[self.view viewWithTag:5];
        NameLabel.text=name;
    }
    self.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    if (_isMenu) {
        self.view.backgroundColor=[UIColor clearColor];
    }
     _block=block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self allocNSArray];
    [self Header];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self ReshProData];
}
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
            [_tableView reloadData];
        }
        UIButton *btn=(UIButton *)[self.view viewWithTag:6];
        btn.hidden=(_dataSource.count>0);
      
    }];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(_HeaderView.left, _HeaderView.bottom, _HeaderView.width, self.view.height-_HeaderView.bottom)];
     self.activityVC.frame=CGRectMake(_tableView.left, 0, _tableView.width, self.view.height);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.sectionIndexTrackingBackgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    _tableView.sectionIndexColor=grayTextColor;
    _tableView.sectionIndexBackgroundColor=superBackgroundColor;
    [_tableView registerClass:[CityCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    _shiVC=[[ShiViewController alloc]init];
    _shiVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    _shiVC.isAdress=_isAdress;
    _shiVC.isMenu=_isMenu;
    [self.view addSubview:_shiVC.view];
}
#pragma mark - TableView
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
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
    _indexPath=indexPath;
    if (_isMenu) {
        if (_block ) {
           NSDictionary *dic  = _dataSource[_indexPath.section][_indexPath.row];
            _block(dic,nil,nil,nil);
            [self PopVC:nil];
        }
        return;
    }
     NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    [_shiVC ReshViewByPID:[NSString stringWithFormat:@"%@",dic[@"id"]] Name:[NSString stringWithFormat:@"%@",dic[@"name"]] Block:^(NSDictionary *Shi, NSDictionary *Xian, NSDictionary *Zhen) {
        _block(dic,Shi,Xian,Zhen);
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width , self.view.height);
    }];
    _shiVC.isAdress=_isAdress;
    [UIView animateWithDuration:.3 animations:^{
        _shiVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
    }];
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
 /*   [_existTitles removeAllObjects];
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
-(void)Header{
    _HeaderView=[[UIView alloc]initWithFrame:CGRectMake(80*self.scale, 0, self.view.width-80*self.scale, self.NavImg.height)];
    _HeaderView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_HeaderView];
    
    UIButton *CancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [CancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [CancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CancleBtn.titleLabel.font=Big15Font(1);
    [CancleBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:CancleBtn];
    
    UILabel *NameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CancleBtn.right+10,CancleBtn.top, _HeaderView.width-(CancleBtn.width+10)*2, CancleBtn.height)];
    NameLabel.font=self.TitleLabel.font;
    NameLabel.textAlignment=NSTextAlignmentCenter;
    NameLabel.tag=5;
    NameLabel.text=@"选择省份";
    [_HeaderView addSubview:NameLabel];
    
    UIButton *SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(_HeaderView.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=Big15Font(1);
    SaveBtn.hidden=YES;
    SaveBtn.tag=6;
    [SaveBtn addTarget:self action:@selector(SaveBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [_HeaderView addSubview:SaveBtn];
}
-(void)SaveBtnVC:(id)sender{
    if (_block) {
         // NSDictionary *dic  = _dataSource[_indexPath.section][_indexPath.row];
        _block(nil,nil,nil,nil);
          [self PopVC:nil];
    }
}
#pragma mark - 导航
-(void)newNav{
    self.NavImg.hidden=YES;
}
-(void)PopVC:(id)sender{
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = CGRectMake(self.view.width, 0, self.view.width , self.view.height);
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
