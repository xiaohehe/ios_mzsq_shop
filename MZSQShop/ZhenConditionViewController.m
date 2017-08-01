//
//  ZhenConditionViewController.m
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ZhenConditionViewController.h"
#import "CityCell.h"
#import "ServiceAreaTableViewCell.h"
#import "AddSeverAreaViewController.h"
#import "ChineseToPinyin.h"
@interface ZhenConditionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)ZhenBlock block;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSMutableDictionary *Dic;
@property(nonatomic,strong)NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property(nonatomic,strong)NSMutableArray *existTitles;
@end

@implementation ZhenConditionViewController
-(id)initWithBlock:(ZhenBlock)block{
    self=[super init];
    if (self) {
        _block=block;
        _Dic=[NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self allocNSArray];
    _Dic=[NSMutableDictionary new];
    [self newView];
    [self.view addSubview:self.activityVC];
   // [self ReshData];
}
-(void)allocNSArray
{
    _dataSource=[[NSMutableArray alloc]init];
    _contactsSource=[[NSMutableArray alloc]init];
    _sectionTitles =[[NSMutableArray alloc]init];
    _existTitles = [NSMutableArray array];
}
-(void)selectedZhenByAreaID:(NSString *)AID PID:(NSString *)PID CID:(NSString *)CID   Block:(ZhenBlock)cityblock{
    _AID=AID;
    _PID=PID;
    _CID=CID;
    _block=cityblock;

}
-(void)viewWillAppear:(BOOL)animated{
    [self ReshData];
}
-(void)ReshData{
    [_dataSource removeAllObjects];
    [_Dic removeAllObjects];
    [self.activityVC startAnimating];
    AnalyzeObject *analt=[[AnalyzeObject alloc]init];
    [analt GetCommunityListWithDistrict_id:_AID Block:^(id models, NSString *code, NSString *msg) {
        NSArray *Arr=models;
        [self.activityVC stopAnimating];
        [_contactsSource removeAllObjects];
        [_dataSource removeAllObjects];
        if ([code isEqualToString:@"0"] && Arr) {
            for (NSDictionary *dic in Arr) {
                if (![self ChackCom:dic]) {
                    [_contactsSource addObject:dic];
                }
            }
          //  [_contactsSource addObjectsFromArray:Arr];
            [_dataSource addObjectsFromArray:[self sortDataArray:_contactsSource]];
            
         ///   [_dataSource addObjectsFromArray:Arr];
        }
        [_tableView reloadData];
        if (_dataSource.count>0) {
              [self newFooterView];
        }
      
    }];
}
-(BOOL)ChackCom:(NSDictionary *)dic{
    BOOL key = NO;
    for (NSDictionary *sdin in _nowComArr) {
        if ([[dic objectForKey:@"id"] integerValue] == [[sdin objectForKey:@"id"] integerValue]) {
            key=YES;
            break;
        }
    }
    return key;
}
-(void)newFooterView{
    UIView *View=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 65*self.scale)];
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, 15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"dian_btn"] forState:UIControlStateHighlighted];
    [LoginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [LoginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [View addSubview:LoginBtn];
    
    _tableView.tableFooterView = View;
}
-(void)LoginButtonEvent:(id)sender{
    if(_block){
        _block(_Dic,NO);
        [self PopVC:nil];
    }
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.sectionIndexTrackingBackgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    _tableView.sectionIndexColor=grayTextColor;
    _tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    [_tableView registerClass:[ServiceAreaTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
   // [self newRooter];
}
-(void)newRooter{
    UIView *RooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 35*self.scale)];
    UILabel *TiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 0, self.view.width-20*self.scale, 35*self.scale)];
    TiLabel.font=Small10Font(self.scale);
    TiLabel.text=@"社区只能选择已经开通的，如您想服务的社区还未开通拇指社区，请申请开通新社区或访问www.mzsq.com，联系客服人员";
    TiLabel.textColor=[UIColor redColor];
    TiLabel.numberOfLines=0;
    [RooterView addSubview:TiLabel];
    _tableView.tableFooterView = RooterView;
}
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    ServiceAreaTableViewCell *cell=(ServiceAreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.contextLa.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
    cell.rightImg.selected =([_Dic objectForKey:[dic objectForKey:@"id"]]!=nil);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath=indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSDictionary *dic = _dataSource[indexPath.section][indexPath.row];
    id key  = [dic objectForKey:@"id"];
    if ([_Dic objectForKey:key]) {
        [_Dic removeObjectForKey:key];
    }else{
        if (_MaxNum> _nowNum + [_Dic allKeys].count) {
              [_Dic setObject:dic forKey:key];
           
        }else{
            [self ShowAlertWithMessage:@"您所服务的社区的数量已达上限，请联系我们服务更多社区！"];
        }
      
    }
    [tableView reloadData];
    
  /*  NSDictionary *dic = _dataSource[indexPath.row];
    if (_block ) {
        _block(dic,NO);
        [self PopVC:nil];
    }*/
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
   /* [_existTitles removeAllObjects];
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
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text = @"选择想要认证的小区";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, self.TitleLabel.top, 70*self.scale, self.TitleLabel.height)];
    [saveBtn setTitle:@"申请新社区" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(1);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
}
-(void)saveBtnEvent:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    AddSeverAreaViewController *addAreaVC=[[AddSeverAreaViewController alloc]initWithBlock:^{
        if (_block) {
             [self.navigationController popViewControllerAnimated:NO];
            _block(nil,YES);
        }
    }];
    addAreaVC.ShengID=_PID;
    addAreaVC.ShiID=_CID;
    addAreaVC.XianID=_AID;
    [self.navigationController pushViewController:addAreaVC animated:YES];
}
-(void)PopVC:(id)sender
{
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
