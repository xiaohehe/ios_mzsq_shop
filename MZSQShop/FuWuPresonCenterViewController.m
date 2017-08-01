//
//  FuWuPresonCenterViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuPresonCenterViewController.h"
#import "CenterCell.h"
#import "LoginViewController.h"
#import "FuWuSheZhiViewController.h"
#import "ShangJiaSettingViewController.h"
#import "FuWuShopSettingViewController.h"
#import "SettingViewController.h"
#import "OnSellGoodsViewController.h"
#import "FuWuOrderListViewController.h"
#import "TongJijViewController.h"
#import "WoDeGongGaoViewController.h"
#import "TiXianViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatListViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface FuWuPresonCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RCIMReceiveMessageDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)UIView *LoginView;
@property(nonatomic,strong)UIImageView *HeaderImg;
@end

@implementation FuWuPresonCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    if ([Stockpile sharedStockpile].isLogin && [Stockpile sharedStockpile].ID.length>0) {
        [self newMeView];
    }else{
        [self newLogin];
    }
         [RCIM sharedRCIM].receiveMessageDelegate=self;
}
-(void)newLogin{
    if (_LoginView) {
        [_LoginView removeFromSuperview];
    }
    _LoginView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, _HeaderImg.width, _HeaderImg.height)];
    UIButton *Image=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, 10*self.scale, 80*self.scale, 80*self.scale)];
    Image.layer.masksToBounds=YES;
    Image.layer.cornerRadius=Image.height/2;
    //Image.image=[UIImage imageNamed:@"center_img"];
    [Image setImage:[UIImage imageNamed:@"center_img"] forState:UIControlStateNormal];
    [Image addTarget:self action:@selector(goZhangHu) forControlEvents:UIControlEventTouchUpInside];
    [_LoginView addSubview:Image];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-49*self.scale, Image.bottom+5*self.scale, 90*self.scale, 25*self.scale)];
    [button setBackgroundImage:[UIImage setImgNameBianShen:@"center_index_btn"] forState:UIControlStateNormal];
    [button setTitle:@"登录/注册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LoginViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=DefaultFont(self.scale);
    [_LoginView addSubview:button];
    
    [_HeaderImg addSubview:_LoginView];
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ReshMessage];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //AudioServicesPlaySystemSound(1007);
    });
    
}
-(void)ReshMessage{
    int unreadMsgCount =[self.appdelegate ReshData];
    UILabel *CarNum=(UILabel *)[self.view viewWithTag:66];
    if (unreadMsgCount>0) {
        CarNum.hidden=NO;
        CarNum.text=[NSString stringWithFormat:@"%d",unreadMsgCount];
        if (unreadMsgCount>99) {
            CarNum.text=[NSString stringWithFormat:@"99+"];
        }
    }else{
        CarNum.hidden=YES;
    }
}
-(void)newMeView{
    if (_LoginView) {
        [_LoginView removeFromSuperview];
    }
    _LoginView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, _HeaderImg.width, _HeaderImg.height)];
    _LoginView.userInteractionEnabled=YES;
       [self ReshMessage];
    UIButton *Image=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-40*self.scale, 5*self.scale, 80*self.scale, 80*self.scale)];
    Image.layer.masksToBounds=YES;
    Image.layer.cornerRadius=Image.height/2;
    //Image.image=[UIImage imageNamed:@"center_img"];
    //  [Image setImage:[UIImage imageNamed:@"center_img"] forState:UIControlStateNormal];
    [Image setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[Stockpile sharedStockpile].logo] placeholderImage:[UIImage imageNamed:@"center_img"]];
    [Image addTarget:self action:@selector(goZhangHu) forControlEvents:UIControlEventTouchUpInside];
    [_LoginView addSubview:Image];
    
    NSDictionary *model=[Stockpile sharedStockpile].model;
    NSString *ShopName=@"";
    NSInteger is_auth=0;
    if (model && [model objectForKey:@"shop_info"]) {
        ShopName=[NSString stringWithFormat:@"%@",model[@"shop_info"][@"shop_name"]];
        is_auth = [[[model objectForKey:@"shop_info"] objectForKey:@"is_auth"] integerValue];
        
        NSLog(@"*** %@",model);
    }
    UILabel *Name=[[UILabel alloc]initWithFrame:CGRectMake(40*self.scale, Image.bottom+10*self.scale, self.view.width-80*self.scale, 20*self.scale)];
    Name.textAlignment=NSTextAlignmentCenter;
    Name.textColor=[UIColor whiteColor];
    Name.font=DefaultFont(self.scale);
    Name.text=ShopName;
    [_LoginView addSubview:Name];
    if (is_auth>1) {
        float textW=[self Text:Name.text Size:Name.size Font:Name.font].width;
        Name.frame=CGRectMake(self.view.width/2-textW/2-11*self.scale, Name.top, textW, Name.height);
        UIImageView *IconImg=[[UIImageView alloc]initWithFrame:CGRectMake(Name.right+2*self.scale, Name.top,20*self.scale, 20*self.scale  )];
        IconImg.image=[UIImage imageNamed:@"jinpanrenzheng"];
        [_LoginView addSubview:IconImg];
    }
    [_HeaderImg addSubview:_LoginView];
    
    RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:[Stockpile sharedStockpile].ID name:ShopName portrait:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].logo]];
    [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
}

-(void)goZhangHu{
    /*self.hidesBottomBarWhenPushed=YES;
     ZhangHuGuanLiViewController *zhanghu = [ZhangHuGuanLiViewController new];
     [self.navigationController pushViewController:zhanghu animated:YES];
     self.hidesBottomBarWhenPushed=NO;*/
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册中获取" otherButtonTitles:@"拍照", nil];
    [action showInView:self.view];
}
#pragma mark - 拍照片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"相册");
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (buttonIndex == 1) {
        NSLog(@"拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
        
    }
}
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    if (image.size.width<newSize.width) {
        return image;
    }
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(400, 400)];
    NSData *imgData=UIImageJPEGRepresentation(newImg, 0.5);
    NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    [self UpDateLogo:base64img];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)UpDateLogo:(NSString *)logo{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyLogoWithUser_ID:[Stockpile sharedStockpile].ID Logo:logo Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if([code isEqualToString:@"0"] && models){
            [[Stockpile sharedStockpile]setLogo:[NSString stringWithFormat:@"%@",[models objectForKey:@"avatar"]]];
            [self newMeView];
        }
    }];
}

-(void)headView{
    UIView *HeaderView=[[UIView alloc]init];
    HeaderView.backgroundColor=[UIColor whiteColor];
    _HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 130*self.scale)];
    _HeaderImg.backgroundColor=blueTextColor;
    [HeaderView addSubview:_HeaderImg];
    _HeaderImg.userInteractionEnabled = YES;
    
    HeaderView.frame=CGRectMake(0, 0, self.view.width, _HeaderImg.bottom);
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, HeaderView.height-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    [HeaderView addSubview:line];
    _tableView.tableHeaderView =HeaderView;
}

-(void)newView{
    //,@"收入提现"
    _dataSource=@[@[@"商家设置",@"服务设置",@"订单管理",@"我的公告",@"统计",@"收入提现"],@[@"设置"]];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) ];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[CenterCell class] forCellReuseIdentifier:@"CenterCell"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self headView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataSource count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_dataSource objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imgArr=@[@[@"mai_center_ico_01",@"center_index_ico_05",@"center_index_ico_04",@"center_index_ico_03",@"mai_center_ico_02",@"mai_center_ico_03"],@[@"center_index_ico_10"]];
    CenterCell *Cell=(CenterCell *)[tableView dequeueReusableCellWithIdentifier:@"CenterCell" forIndexPath:indexPath];
    Cell.titleLabel.text = _dataSource[indexPath.section][indexPath.row];
    Cell.headImage.image=[UIImage imageNamed:imgArr[indexPath.section][indexPath.row]];
    Cell.indexPath = indexPath;
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*self.scale;
}
#pragma mark----退出登录；
-(void)exitLogin{
    
    
    UIView *bigVi = [[UIView alloc]init];
    bigVi.frame=CGRectMake(0, 0, self.view.width, 45*self.scale);
    _tableView.tableFooterView=bigVi;
    
}
-(void)exiteEvent:(UIButton *)sender{
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10*self.scale)];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, view.height-.5, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    view.backgroundColor=superBackgroundColor;
    [view addSubview:line];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    if (![Stockpile sharedStockpile].isLogin ) {
        [self LoginViewEvent:nil];
        self.hidesBottomBarWhenPushed=NO;
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            if (indexPath.section==1) {
                SettingViewController *setVC=[[SettingViewController alloc]init];
                [self.navigationController pushViewController:setVC animated:YES];
            }else{
                FuWuShopSettingViewController *setVC=[[FuWuShopSettingViewController alloc]init];
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }
            break;
            
        case 1:
        {
            FuWuSheZhiViewController *setVC=[[FuWuSheZhiViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
            
        case 2:
        {
            FuWuOrderListViewController *setVC=[[FuWuOrderListViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
            
        case 3:
        {
            WoDeGongGaoViewController *gongGaoVc=[[WoDeGongGaoViewController alloc]init];
            [self.navigationController pushViewController:gongGaoVc animated:YES];
            
        }
            break;
            
        case 4:
        {
            TongJijViewController *setVC=[[TongJijViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
            
        case 5:{
            TiXianViewController *setVC=[[TiXianViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    self.hidesBottomBarWhenPushed=NO;
}

-(void)LoginViewEvent:(UIButton *)button{
    
    UINavigationController *navView=[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]initWithBlock:^{
        [self newMeView];
    }] ];
    [self presentViewController:navView animated:YES completion:nil];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"个人中心";
    UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
    [talkImg setImage:[UIImage imageNamed:@"index_xiaoxi"] forState:UIControlStateNormal];
    [talkImg setImage:[UIImage imageNamed:@"dian_ico_01"] forState:UIControlStateHighlighted];
    talkImg.frame=CGRectMake(self.view.width-self.TitleLabel.height, self.TitleLabel.top, self.TitleLabel.height,self.TitleLabel.height);
    [talkImg addTarget:self action:@selector(ChatBtnVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:talkImg];
    
    UILabel *CarNum=[[UILabel alloc]initWithFrame:CGRectMake(talkImg.width-20, 2, 18, 18)];
    CarNum.backgroundColor=[UIColor redColor];
    CarNum.layer.cornerRadius=CarNum.width/2;
    CarNum.layer.masksToBounds=YES;
    CarNum.textAlignment=NSTextAlignmentCenter;
    CarNum.font=SmallFont(1);
    CarNum.tag=66;
    CarNum.textColor=[UIColor whiteColor];
    CarNum.hidden=YES;
    [talkImg addSubview:CarNum];
}
-(void)ChatBtnVC:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    RCDChatListViewController *hisVC=[[RCDChatListViewController alloc]init];
    [self.navigationController pushViewController:hisVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
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
