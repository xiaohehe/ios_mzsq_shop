//
//  ShenQingFuWuLieShangJiaViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ShenQingFuWuLieShangJiaViewController.h"
#import "CellView.h"
//#import "XuanZeLeiXingFuWuViewController.h"
#import "LinShouMenuViewController.h"
#import "MenuViewController.h"
#import "VPImageCropperViewController.h"
#import "GetBaiDuMapViewController.h"
#import "ShopTypeManagerViewController.h"
@interface ShenQingFuWuLieShangJiaViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)NSDictionary *TypeDic;
@property(nonatomic,strong)MenuViewController *menuVC;
@property(nonatomic,strong)LinShouMenuViewController *linMenuVC;
@property(nonatomic,strong)NSString *StopType;
@property(nonatomic,strong)NSString *Card1,*Card2,*YY,*ZZ;
@property(nonatomic,strong)NSString *ComID,*IsWeiShang;
@property(nonatomic,assign)NSInteger TapImg;
@property(nonatomic,strong)NSDictionary *Sheng,*Shi,*Xian,*Location,*ShopType;;
@end

@implementation ShenQingFuWuLieShangJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    /*监听TextField的变化*/
   //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if (name.length>10) {
        name=[name substringToIndex:10];
    }
    NameText.text=name;
    UITextField *ShopNameText=(UITextField *)[self.view viewWithTag:12];
    NSString *shopName = [ShopNameText.text trimString];
    if (shopName.length>20) {
        shopName=[shopName substringToIndex:20];
    }
    ShopNameText.text=shopName;
//    UITextField *AdressText=(UITextField *)[self.view viewWithTag:13];
//    NSString *adress = [AdressText.text trimString];
//    if (adress.length>35) {
//        adress=[adress substringToIndex:35];
//    }
//    AdressText.text=adress;
}
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _mainScrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, rect.origin.y-self.NavImg.bottom);
    }];
}
-(void)newView{
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    _mainScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseKeyBoard)];
    [_mainScrollView addGestureRecognizer:tap];
    [self.view addSubview:_mainScrollView];
    float SetY =0;
    NSArray *Arr=@[@"联系人",@"电话",@"店铺名称",@"选择类型",@"商铺类型",@"选择店铺所属区域",@"店铺详细地址",@"店铺坐标",@"身份证上传",@"营业执照",@"资质证书"];
    for (int i=0; i<Arr.count; i++) {
        CellView *cell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 44*self.scale)];
        cell.titleLabel.text=[Arr objectAtIndex:i];
        [cell.titleLabel sizeToFit];
        cell.titleLabel.centerY=cell.height/2;
        cell.titleLabel.textAlignment=NSTextAlignmentLeft;
           cell.contentLabel.frame=CGRectMake(cell.titleLabel.right+6*self.scale, cell.titleLabel.top, cell.width-cell.titleLabel.right-25*self.scale, cell.titleLabel.height);
        cell.contentLabel.textColor=grayTextColor;
        if (i<3 || i==6) {
            UITextField *Text=[[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right+6*self.scale, cell.contentLabel.top-3*self.scale, cell.width-cell.titleLabel.right-25*self.scale, cell.contentLabel.height+6*self.scale)];
            Text.placeholder=[NSString stringWithFormat:@"请输入你的%@",[Arr objectAtIndex:i]];
            Text.font = cell.contentLabel.font;
            Text.tag = 10+i;
            Text.delegate=self;
            [cell addSubview:Text];
            if (i==0) {
                [Text setMaxLength:Lenth10];
            }else if (i==2){
                  [Text setMaxLength:Lenth20];
            }
        }else{
            cell.tag=i;
            [cell ShowRight:YES];
            if (i>=Arr.count-2)
            {
                UIImageView *ZZImg=[[UIImageView alloc]initWithFrame:CGRectMake(cell.RightImg.left-cell.height, 3, cell.height-6, cell.height-6)];
                ZZImg.image=[UIImage imageNamed:@"shang_jia"];
                ZZImg.tag=30+i;
                [cell addSubview:ZZImg];
                cell.contentLabel.textAlignment=NSTextAlignmentLeft;
                cell.contentLabel.font=Small10Font(self.scale);
                cell.contentLabel.textColor=grayTextColor;
                cell.contentLabel.text=(i==Arr.count-2)?@"(实体必填)":@"(特殊行业必填)";
            }
            if(i==8){
                UIButton *Btn=[[UIButton alloc]initWithFrame:CGRectMake(cell.contentLabel.left+10*self.scale, 3, cell.height-6, cell.height-6)];
                [Btn setImage:[UIImage imageNamed:@"shang_jia"] forState:UIControlStateNormal];
                Btn.tag=35;
                [Btn addTarget:self action:@selector(AddImgTag:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:Btn];
                
                UIButton *RBtn=[[UIButton alloc]initWithFrame:CGRectMake(Btn.right+10*self.scale, 3, cell.height-6, cell.height-6)];
                [RBtn setImage:[UIImage imageNamed:@"shang_jia"] forState:UIControlStateNormal];
                RBtn.tag=36;
                [RBtn addTarget:self action:@selector(AddImgTag:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:RBtn];
                
            }else{
                UITapGestureRecognizer *Tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectedTap:)];
                [cell addGestureRecognizer:Tap];
            }
        }
        [_mainScrollView addSubview:cell];
        SetY=cell.bottom;
    }
    SetY=SetY+10*self.scale;
    CellView *JinyingCell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 95*self.scale)];
    JinyingCell.topline.hidden=NO;
    JinyingCell.titleLabel.text=@"经营范围";
    JinyingCell.titleLabel.top=10*self.scale;
    UITextView *jinYinText=[[UITextView alloc]initWithFrame:CGRectMake(JinyingCell.titleLabel.right, 5*self.scale, self.view.width-JinyingCell.titleLabel.right-25*self.scale, JinyingCell.height-10*self.scale)];
    jinYinText.tag = 10+Arr.count;
    jinYinText.font=JinyingCell.titleLabel.font;
    [JinyingCell addSubview:jinYinText];
    [_mainScrollView addSubview:JinyingCell];
    
    UILabel *TiShiLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, JinyingCell.bottom, self.view.width-20*self.scale, 40*self.scale)];
    TiShiLabel.font=Small10Font(self.scale);
    TiShiLabel.textColor=grayTextColor;
    TiShiLabel.numberOfLines=0;
    TiShiLabel.text=@"提交申请成功后，我们会在5个工作日内完成审核，请耐心等待，审核通过后，直接跳转到登录页面";
    [_mainScrollView addSubview:TiShiLabel];
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, TiShiLabel.bottom+5*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"dian_btn"] forState:UIControlStateNormal];
    [LoginBtn setTitle:@"确认提交" forState:UIControlStateNormal];
  //  LoginBtn.tag = 7;
    [LoginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    [LoginBtn addTarget:self action:@selector(QueRenTiJiao:) forControlEvents:UIControlEventTouchUpInside];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    [_mainScrollView addSubview:LoginBtn];
    _mainScrollView.contentSize=CGSizeMake(self.view.width, LoginBtn.bottom+15*self.scale);
    
 _menuVC=[[MenuViewController alloc]init];
    _menuVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [self.view addSubview:_menuVC.view];
    
 _linMenuVC=[[LinShouMenuViewController alloc]init];
    _linMenuVC.view.frame=CGRectMake(self.view.width, 0, self.view.width, self.view.height);
    [self.view addSubview:_linMenuVC.view];
}
-(void)SelectedTap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    self.hidesBottomBarWhenPushed=YES;
    CellView *cell=(CellView *)[tap view];
    if ([cell tag]==3) {
    [_linMenuVC SelectedShopType:_shop_type Block:^(NSDictionary *Type, NSDictionary *Detail) {
        _IsWeiShang=[NSString stringWithFormat:@"%@",[Type objectForKey:@"weishang"]];
            _TypeDic=[Type mutableCopy];
            NSString *Str=[NSString stringWithFormat:@"%@",[Type objectForKey:@"name"]];
//            for (NSString *key in [Detail allKeys]) {
//                NSDictionary *item=[Detail objectForKey:key];
//                Str=[NSString stringWithFormat:@"%@,%@",Str,[item objectForKey:@"class_name"]];
//            }
//            if (Str.length>0) {
//                Str=[Str substringFromIndex:1];
//            }
            cell.contentLabel.text=Str;
        }];
        [UIView animateWithDuration:.3 animations:^{
            _linMenuVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }else if ([cell tag] == 5){
       [_menuVC SelectedNum:3 Block:^(NSDictionary *Sheng, NSDictionary *Shi, NSDictionary *Xian, NSDictionary *Zhen) {
            cell.contentLabel.text=[[NSString stringWithFormat:@"%@%@%@",[Sheng objectForKey:@"name"],[Shi objectForKey:@"name"],[Xian objectForKey:@"name"]] EmptyStringByWhitespace];
           _Sheng=[Sheng mutableCopy];
           _Shi=[Shi mutableCopy];
           _Xian=[Xian mutableCopy];
           // _ComID=[NSString stringWithFormat:@"%@",[Zhen objectForKey:@"id"]];
        }];
        [UIView animateWithDuration:.3 animations:^{
            _menuVC.view.frame = CGRectMake(0, 0, self.view.width , self.view.height);
        }];
    }else if ([cell tag]==9){
        _TapImg=3;
        [self goZhangHu];
    }else if ([cell tag] == 10){
        _TapImg=4;
        [self goZhangHu];
    }else if ([cell tag]==7){
        GetBaiDuMapViewController *huoQuVC=[[GetBaiDuMapViewController alloc]init];
        [huoQuVC getZuoBiaoBlock:^(NSDictionary *dic) {
          // cell.contentLabel.text=[[NSString stringWithFormat:@"%@%@%@",[Sheng objectForKey:@"name"],[Shi objectForKey:@"name"],[Xian objectForKey:@"name"]] EmptyStringByWhitespace];
            _Location=[dic mutableCopy];
            cell.contentLabel.text=[NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"]];
        }];
        [self.navigationController pushViewController:huoQuVC animated:YES];
    } else if ([cell tag] == 4){
        ShopTypeManagerViewController *shopVC=[[ShopTypeManagerViewController alloc]initWithBlock:^(NSDictionary *shoptype) {
            
            _ShopType =[shoptype mutableCopy];
            cell.contentLabel.text=[NSString stringWithFormat:@"%@",[shoptype objectForKey:@"class_name"]];

        }];
        shopVC.shop_type=_shop_type;
        shopVC.SelectedTypeDic=_ShopType;
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}
-(void)CloseKeyBoard{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==11) {
        textField.keyboardType=UIKeyboardTypePhonePad;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
      [self.view endEditing:YES];
    return YES;
}
-(void)AddImgTag:(UIButton *)button{
      [self.view endEditing:YES];
    if (button.tag==35) {
        _TapImg=1;
        [self goZhangHu];
    }else{
        _TapImg=2;
        [self goZhangHu];
    }
}
#pragma mark - 拍照片
-(void)goZhangHu{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册中获取" otherButtonTitles:@"拍照", nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"相册");
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else if (buttonIndex == 1) {
        NSLog(@"拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
         //   imagePicker.allowsEditing = actionSheet.tag == 1;
            imagePicker.allowsEditing = NO;
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImg=[self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    NSData *imgData=UIImageJPEGRepresentation(newImg, 0.5);
    NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    if (_TapImg==1) {
        
     /*   [picker dismissViewControllerAnimated:YES completion:^{
            float H = self.view.width*2/3.0;
            VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, self.view.height/2-H/2, self.view.frame.size.width, H) limitScaleRatio:3.0];
            imgCropperVC.delegate = self;
            [self presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }];*/
        UIButton *Img=(UIButton *)[self.view viewWithTag:35];
        [Img setImage:newImg forState:UIControlStateNormal];
        _Card1=base64img;
     //   return;

    }else if (_TapImg == 2){
      /*  [picker dismissViewControllerAnimated:YES completion:^{
            float H = self.view.width*2/3.0;
            VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, self.view.height/2-H/2, self.view.frame.size.width, H) limitScaleRatio:3.0];
            imgCropperVC.delegate = self;
            [self presentViewController:imgCropperVC animated:YES completion:^{
                // TO DO
            }];
        }];*/
        UIButton *Img=(UIButton *)[self.view viewWithTag:36];
        [Img setImage:newImg forState:UIControlStateNormal];
        _Card2=base64img;
         //return;
    }else if (_TapImg == 3){
        UIImageView *Img=(UIImageView *)[self.view viewWithTag:39];
        Img.image=newImg;
        _YY=base64img;
    }else if (_TapImg == 4){
        UIImageView *Img=(UIImageView *)[self.view viewWithTag:40];
        Img.image=newImg;
        _ZZ=base64img;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    NSData *imgData=UIImageJPEGRepresentation(editedImage, 0.5);
    NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
    if (_TapImg==1) {
        
        UIButton *Img=(UIButton *)[self.view viewWithTag:35];
        [Img setImage:editedImage forState:UIControlStateNormal];
        _Card1=base64img;
    }else if (_TapImg == 2){
        UIButton *Img=(UIButton *)[self.view viewWithTag:36];
        [Img setImage:editedImage forState:UIControlStateNormal];
        _Card2=base64img;
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)QueRenTiJiao:(id)sender{
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name = [NameText.text trimString];
    if ([name isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入您的联系人"];
        return;
    }
    UITextField *TelText=(UITextField *)[self.view viewWithTag:11];
    NSString *tel = [TelText.text trimString];
    if ([tel isEmptyString] || ![tel isValidateMobile]) {
        [self ShowAlertWithMessage:@"请输入您的电话"];
        return;
    }
    UITextField *ShopNameText=(UITextField *)[self.view viewWithTag:12];
    NSString *shopName = [ShopNameText.text trimString];
    if ([shopName isEmptyString]) {
        [self ShowAlertWithMessage:@"请输入您的店铺的名称"];
        return;
    }
    if(!_TypeDic || [_TypeDic allKeys].count<1){
        [self ShowAlertWithMessage:@"请选择店铺类型"];
        return;
    }
    
    if (!_ShopType || [_ShopType allKeys].count<1) {
        [self ShowAlertWithMessage:@"请选择商铺类型"];
        return;
    }
    if(!_Xian|| [_Xian allKeys].count<1 ){
        [self ShowAlertWithMessage:@"请选择店铺所属区域"];
        return;
    }
    UITextField *AdressText=(UITextField *)[self.view viewWithTag:16];
    NSString *adress = [AdressText.text trimString];
    if ([adress isEmptyString] || adress.length<1) {
        [self ShowAlertWithMessage:@"请输入您的店铺详细地址"];
        return;
    }
    if(!_Location || [_Location allKeys].count<1){
        [self ShowAlertWithMessage:@"请选择您的店铺坐标"];
        return;
    }

 NSString *Str=[NSString stringWithFormat:@"%@",[_ShopType objectForKey:@"id"]];
//    if (_ShopType && [_ShopType allKeys].count>0) {
//       //NSDictionary *item=[_ShopType objectForKey:key];
//       Str=[NSString stringWithFormat:@"%@",[_ShopType objectForKey:@"id"]];
//  }
//   if (Str.length>1) {
//        Str=[Str substringFromIndex:1];
//    }
 

  /*  if(!_Xian || [_Xian allKeys].count<1){
        [self ShowAlertWithMessage:@"请选择店铺所属区域"];
        return;
    }*/
    if (_Card1.length<1 || _Card2.length<1) {
        [self ShowAlertWithMessage:@"请上传身份证"];
        return;
    }
    if ([_IsWeiShang integerValue]>1 && _YY.length<1) {
        [self ShowAlertWithMessage:@"请上传营业执照"];
        return;
    }
    UITextView *DESText=(UITextView *)[self.view viewWithTag:21];
    NSString *des = [DESText.text trimString];
    if ([des isEmptyString] || !des) {
        [self ShowAlertWithMessage:@"请输入您的经营范围"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ApplyServeShopWithUser_ID:[Stockpile sharedStockpile].ID Contact_name:name Mobile:tel Shop_name:shopName Address:adress Serve_type:Str Community:_ComID Idcard1:_Card1 Idcard2:_Card2 License:_YY Certification:_ZZ Buss_scope:des Shop_type:_shop_type Is_weishop:_IsWeiShang lng:[NSString stringWithFormat:@"%@",[_Location objectForKey:@"longitude"]] lat:[NSString stringWithFormat:@"%@",[_Location objectForKey:@"latitude"]] province:[NSString stringWithFormat:@"%@",[_Sheng objectForKey:@"id"]] city:[NSString stringWithFormat:@"%@",[_Shi objectForKey:@"id"]] district:[NSString stringWithFormat:@"%@",[_Xian objectForKey:@"id"]]  Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"申请服务类商家";
    if ([_shop_type integerValue]==1) {
        self.TitleLabel.text=@"申请商品类商家";
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
