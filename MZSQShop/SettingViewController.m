//
//  SettingViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "HelpTableViewCell.h"
#import "WebViewController.h"
#import "AddFanKuiViewController.h"
#import "HelpViewController.h"
#import "CacheManager.h"
#import "JPUSHService.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
}
-(void)newView{
    _dataSource=@[@"帮助",@"意见反馈",@"消息推送提醒",@"清除缓存",@"当前版本"];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    if ([Stockpile sharedStockpile].isLogin) {
        [self newFooter];
  }
}
- (void)newFooter{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60*self.scale)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView setTableFooterView:footerView];
    UIButton *tiJiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tiJiaoBtn.frame = CGRectMake(12*self.scale, 10*self.scale, self.view.width - 24*self.scale, 31*self.scale);
    [tiJiaoBtn setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    tiJiaoBtn.titleLabel.font=BigFont(self.scale);
    [tiJiaoBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [tiJiaoBtn addTarget:self action:@selector(tuiChuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:tiJiaoBtn];
}
-(void)tuiChuBtnClick{
    
  [self ShowAlertTitle:@"提示" Message:@"是否退出登录" Delegate:self Block:^(NSInteger index) {
      if(index == 1){
            [self.appdelegate OutLogin];
      }
 }];
  
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
//设置cell 内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*self.scale , 0, self.view.width/2, 44*self.scale)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = _dataSource[indexPath.row];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = DefaultFont(self.scale);
    [cell addSubview:titleLab];
    
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:{
            
            UISwitch * kaiGuan = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.width - 60, 7*self.scale, 49, 31*self.scale)];
            kaiGuan.onTintColor = blueTextColor;
            kaiGuan.on=[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
            [cell addSubview:kaiGuan];
            [kaiGuan addTarget:self action:@selector(CloseANVNotifacation:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"------%@",kaiGuan);
        }
            break;
        case 3:
        {
            UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100*self.scale , 0, 90*self.scale, 44*self.scale)];
            valueLab.backgroundColor = [UIColor clearColor];
          //  SDImageCache*imagecache=[SDImageCache sharedImageCache];
            CacheManager *cachemanager=[CacheManager defaultCacheManager];
           double cachesize=[cachemanager GetCacheSize];
            valueLab.text=[NSString stringWithFormat:@"%.2fM",cachesize];
            valueLab.textColor = grayTextColor;
            valueLab.textAlignment=NSTextAlignmentRight;
            valueLab.font = DefaultFont(self.scale);
            [cell addSubview:valueLab];
        }
            break;
        case 4:{
            UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100*self.scale , 0, 85*self.scale, 44*self.scale)];
            valueLab.backgroundColor = [UIColor clearColor];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
              NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            valueLab.text=[NSString stringWithFormat:@"V%@",appVersion];
            valueLab.textColor = [UIColor grayColor];
            valueLab.textAlignment=NSTextAlignmentRight;
            valueLab.font = DefaultFont(self.scale);
            [cell addSubview:valueLab];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
    
    if (indexPath.row == 0) {
        UIImageView *hxImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.width, .5)];
        hxImg.backgroundColor  = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
        [cell addSubview:hxImg];
    }
    UIImageView *hxImg  = [[UIImageView alloc] initWithFrame:CGRectMake(0,44*self.scale - .5, self.view.width, .5)];
    hxImg.backgroundColor  = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    [cell addSubview:hxImg];
    return cell;
}
-(void)CloseANVNotifacation:(UISwitch *)kg{
    BOOL open = kg.isOn;
    if (open) {
          [[UIApplication sharedApplication] registerForRemoteNotifications];
          [self.appdelegate ZhuCeJPush];
      
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    switch (indexPath.row) {
        case 0:{
            HelpViewController *helpVC=[[HelpViewController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
            }
            break;
        case 1:{
            AddFanKuiViewController *fanKuiVC=[[AddFanKuiViewController alloc]init];
            [self.navigationController pushViewController:fanKuiVC animated:YES];
        }
            break;
        case 3:
        {
            [self ShowAlertTitle:@"是否确定清理缓存" Message:nil Delegate:self Block:^(NSInteger index) {
                if (index == 1) {
                    CacheManager * cachemanager=[CacheManager defaultCacheManager];
                    [cachemanager clearCache:^(BOOL success) {
                          [_tableView reloadData];
                    }];
                   
                }
            }];
            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"设置";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
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
