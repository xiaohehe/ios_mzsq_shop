//
//  ShopInfoManageViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopInfoManageViewController.h"
#import "VPImageCropperViewController.h"
#import "ShangJiaIDinfoViewController.h"
#import "changeAdressViewController.h"
#import "ShopLocationViewController.h"
#import "ReXianTeleViewController.h"
#import "ShopNameViewController.h"
#import "ShopXiangQingViewController.h"
#import "HelpTableViewCell.h"
#import "HuoQuDiTuZuoBiaoViewController.h"
#import "ShangJiaJieShaoViewController.h"
#import "BusinessInfoViewController.h"
#import "ShopZhaoPaiViewController.h"

#import "GetBaiDuMapViewController.h"
@interface ShopInfoManageViewController ()<VPImageCropperDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)NSInteger tagImg;
@end

@implementation ShopInfoManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _table.dataSource=self;
    _table.delegate=self;
    _table.backgroundColor = superBackgroundColor;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"cell"];
     [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"ImgCell"];
    [_table registerClass:[HelpTableViewCell class] forCellReuseIdentifier:@"LImgCell"];
    [self.view addSubview:_table];
    
    [self.view addSubview:self.activityVC];
}
-(void)viewWillAppear:(BOOL)animated{
    [_table reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 3) {
        return 60*self.scale;
    }
    return 44*self.scale;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *textArr = @[@"店铺账号信息",@"店铺logo",@"店铺名称",@"店铺招牌",@"店铺地址",@"店铺坐标",@"热线电话",@"商家简介",@"店铺详情",@"预览"];
    NSArray *ValueArr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
     NSDictionary *model=[Stockpile sharedStockpile].model;
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[@"",[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_name"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_zhaopai"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]],[NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"hotline"]],@"",@"",@""];
    }
    if (indexPath.row == 1) {
         HelpTableViewCell *cell =(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImgCell" forIndexPath:indexPath];
        cell.titleLabel.text = textArr[indexPath.row];
        [cell.HeaderImg setImageWithURL:[NSURL URLWithString:ValueArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        //cell.rigthImg.hidden=YES;
        return cell;
    }
    if (indexPath.row == 3) {
        HelpTableViewCell *cell =(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LImgCell" forIndexPath:indexPath];
        cell.titleLabel.text = textArr[indexPath.row];
        [cell.HeaderImg setImageWithURL:[NSURL URLWithString:ValueArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        //cell.rigthImg.hidden=YES;
        return cell;
    }
    
    HelpTableViewCell *cell =(HelpTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = textArr[indexPath.row];
    cell.nameLabel.text=ValueArr[indexPath.row];
    cell.nameLabel.textAlignment=NSTextAlignmentRight;
    cell.nameLabel.textColor=grayTextColor;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    NSArray *ValueArr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSDictionary *model=[Stockpile sharedStockpile].model;
    if (model && [model objectForKey:@"shop_info"]) {
        NSDictionary *dic = [model objectForKey:@"shop_info"];
        ValueArr=@[@"",[NSString stringWithFormat:@"%@",[dic objectForKey:@"logo"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_name"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"shop_zhaopai"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]],@"",[NSString stringWithFormat:@"%@",[dic objectForKey:@"hotline"]],@"",@"",@""];
    }
    switch (indexPath.row) {
        case 0:
        {
            ShangJiaIDinfoViewController *shangjiaID = [ShangJiaIDinfoViewController new];
            [self.navigationController pushViewController:shangjiaID animated:YES];
        
        }
            break;
            
        case 1:
        {
            UIActionSheet *_action = [[UIActionSheet alloc]initWithTitle:@"店铺logo" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
            _action.tag=1;
            _tagImg=1;
            [_action showInView:self.view];
            
        }
            break;
        case 2:
        {
            ShopNameViewController *action = [ShopNameViewController new];
            action.Name=[ValueArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:action animated:YES];
            
        }
            break;
            
        case 3:{
        
            ShopZhaoPaiViewController *zhaoPaiVc=[[ShopZhaoPaiViewController alloc]init];
            [self.navigationController pushViewController:zhaoPaiVc animated:YES];
//           UIActionSheet *_action1 = [[UIActionSheet alloc]initWithTitle:@"店铺logo" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
//            _action1.tag=2;
//              _tagImg=2;
//            [_action1 showInView:self.view];
            break;
        }
            
        case 4:
        {
            changeAdressViewController *action = [changeAdressViewController new];
            action.Adress=[ValueArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:action animated:YES];
            
        }
            break;
        case 5:
        {
           // ShopLocationViewController *action = [ShopLocationViewController new];
           // [self.navigationController pushViewController:action animated:YES];
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
             NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
          GetBaiDuMapViewController *zuoBiaoVc=[[GetBaiDuMapViewController alloc]init];
            [zuoBiaoVc getZuoBiaoBlock:^(NSDictionary *dic) {
                [self.activityVC startAnimating];
                AnalyzeObject *analy=[[AnalyzeObject alloc]init];
                [analy ModifyShopCoordinateWithUser_ID:[Stockpile sharedStockpile].ID Lng:[dic objectForKey:@"longitude"] Lat:[dic objectForKey:@"latitude"] Block:^(id models, NSString *code, NSString *msg) {
                    [self.activityVC stopAnimating];
                    [self ShowAlertWithMessage:msg];
                    if([code isEqualToString:@"0"]){
                       // NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
                        [Info setObject:[dic objectForKey:@"longitude"] forKey:@"longitude"];
                        [Info setObject:[dic objectForKey:@"latitude"] forKey:@"latitude"];
                        [model setObject:Info forKey:@"shop_info"];
                        [[Stockpile  sharedStockpile]setModel:model];
                         [_table reloadData];
                    }
                }];
            }];
            
            [self.navigationController pushViewController:zuoBiaoVc animated:YES];
            //GetBaiDuMapViewController *baiDuVC=[[GetBaiDuMapViewController alloc]init];
            //[self.navigationController pushViewController:baiDuVC animated:YES];
        }
            break;
            
        case 6:
        {
            ReXianTeleViewController *action = [ReXianTeleViewController new];
            action.Tel=[ValueArr objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:action animated:YES];
            
        }
            break;
        case 7:
        {
            ShangJiaJieShaoViewController *jianJieVc=[[ShangJiaJieShaoViewController alloc]init];
            [self.navigationController pushViewController:jianJieVc animated:YES];
            
        }
            break;
        case 8:
        {
            ShopXiangQingViewController *action = [ShopXiangQingViewController new];
            [self.navigationController pushViewController:action animated:YES];
            
        }
            break;
        case 9:
        {
            NSDictionary *model=[Stockpile sharedStockpile].model;
            if (model && [model objectForKey:@"shop_info"]) {
                NSDictionary *dic = [model objectForKey:@"shop_info"];
                BusinessInfoViewController *action = [BusinessInfoViewController new];
                action.shop_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                [self.navigationController pushViewController:action animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NSLog(@"拍照");
            UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {  
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
        }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
            break;
        case 1:{
           
                NSLog(@"从相册选择");
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        }
            break;
        default:
            break;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  
//  if (_tagImg==1) {
//        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
//        NSData *imgData=UIImageJPEGRepresentation(newImg, 0.5);
//        NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
//
//          [self dismissViewControllerAnimated:YES completion:nil];
//    }else{
           UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self dismissViewControllerAnimated:YES completion:^{
            float H = self.view.width*3/4.0;
            VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, self.view.height/2-H/2, self.view.frame.size.width, H) limitScaleRatio:3.0];
            imgCropperVC.delegate = self;
            [self presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }];
  //  }
  
}
-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    NSData *imgData=UIImageJPEGRepresentation(editedImage, 0.5);
    NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    if (_tagImg == 1) {
          [self UpDateLogo:base64img];
    }else{
          [self UpDateZhaoPai:base64img];
    }
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)UpDateLogo:(NSString *)logo{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyShopLogoWithUser_ID:[Stockpile sharedStockpile].ID Logo:logo Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if([code isEqualToString:@"0"] && models){
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:[models objectForKey:@"logo"] forKey:@"logo"];
            [model setObject:Info forKey:@"shop_info"];
            [[Stockpile  sharedStockpile]setModel:model];
            [_table reloadData];
        }
    }];
}
-(void)UpDateZhaoPai:(NSString *)logo{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyShopZhaoPaiWithUser_ID:[Stockpile sharedStockpile].ID ZhaoPai:logo Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if([code isEqualToString:@"0"] && models){
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:[models objectForKey:@"zhaopai"] forKey:@"shop_zhaopai"];
            [model setObject:Info forKey:@"shop_info"];
            [[Stockpile  sharedStockpile]setModel:model];
            [_table reloadData];
        }
    }];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺设置";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
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
