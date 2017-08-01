//
//  ShopZhaoPaiViewController.m
//  MZSQShop
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopZhaoPaiViewController.h"
#import "VPImageCropperViewController.h"
#import "ZLPickerBrowserViewController.h"
@interface ShopZhaoPaiViewController ()<VPImageCropperDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)NSDictionary *InfoDic;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)NSMutableArray *ImageArr;
@property(nonatomic,strong)UIImage *Img;
@property(nonatomic,strong)UIImageView *SelectedImage;

@property(nonatomic,strong)NSMutableArray *NetImages;
@end

@implementation ShopZhaoPaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       _Img=[UIImage imageNamed:@"not_1"];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)ReshData
{
    [self.activityVC startAnimating];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
    [analyze ShopDetailWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            _InfoDic=[models mutableCopy];
             NSArray *Arr=[_InfoDic objectForKey:@"shop_zhaopai_arr"];
            NSLog(@"============ %@",Arr);
            if ([Arr isKindOfClass:[NSArray class]] && Arr) {
                for (int i=0; i<Arr.count; i++) {
                    
                    [_ImageArr replaceObjectAtIndex:i withObject:[Arr objectAtIndex:i]];
                }
                [_NetImages addObjectsFromArray:_ImageArr];
                 [self ReshView];
            }
          
           
        }
    }];
}
-(void)ReshView{
   // NSArray *Arr=[_InfoDic objectForKey:@"shop_zhaopai_arr"];

    for(int i=0; i<6; i++){
    UIImageView *btn=(UIImageView *)[self.view viewWithTag:10+i];
        if ( i<_ImageArr.count) {
            id img=[_ImageArr objectAtIndex:i];
            if ([img isKindOfClass:[NSString class]]){
                 __block UIImageView *blockImg=btn;
                [btn setImageWithURLRequest:  [NSURLRequest requestWithURL:[NSURL URLWithString:img]] placeholderImage:[UIImage imageNamed:@"not_1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    if (_ImageArr.count>i) {
                                        [_ImageArr replaceObjectAtIndex:i withObject:image];
                                        NSData *data=UIImageJPEGRepresentation(image, 1);
                                        [_NetImages replaceObjectAtIndex:i withObject:data];
                                    }
                        blockImg.image=image;
                                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                    
                             }];

            //    [btn setImageWithURL:[NSURL URLWithString:(NSString *)img] placeholderImage:[UIImage imageNamed:@"not_1"] ];
            }else if([img isKindOfClass:[UIImage class]]){
                btn.image = (UIImage *)img;
            }

         //
           //   NSLog(@"============ %@",bor.photoURL);
          //  btn.image=bor.photoImage;
//            if ([img isEqual: _Img]){
//                  __block UIImageView *blockImg=btn;
//                NSString *imgurl=[[[NSString stringWithFormat:@"%@",[Arr objectAtIndex:i]] EmptyStringByWhitespace] trimString];
//                [btn setImageWithURLRequest:  [NSURLRequest requestWithURL:[NSURL URLWithString:imgurl]] placeholderImage:[UIImage imageNamed:@"shang_jia"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                    if (_ImageArr.count>i) {
//                        [_ImageArr replaceObjectAtIndex:i withObject:image];
//                        blockImg.image=image;
//                    }
//                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                    
//                }];
//                [btn setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"shang_jia"]];
//            }else{
//                btn.image=[_ImageArr objectAtIndex:i];
//            }
//        }else{
//            if (i<_ImageArr.count) {
//                 btn.image=[_ImageArr objectAtIndex:i];
//            }else{
//                btn.image=_Img;
//            }
        }
    }
}
-(void)newView{
    _ImageArr=[NSMutableArray new];
        _NetImages = [[NSMutableArray alloc]init];
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    float W = (self.view.width-30*self.scale)/2;
    
    float SetY = 0.0;
    for (int i=0; i<6; i++)
    {
        UIImageView *Btn=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale+(i%2)*(W+10*self.scale), 10*self.scale+(i/2)*(30*self.scale+W*3/4), W, W*3/4)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AddImage:)];
        [Btn addGestureRecognizer:tap];
        Btn.userInteractionEnabled=YES;
        Btn.clipsToBounds=YES;
        Btn.contentMode=UIViewContentModeScaleAspectFill;
        Btn.image=_Img;
        Btn.tag=10+i;
        [_ImageArr addObject:@""];
        [_mainScrollView addSubview:Btn];
        
        UIButton *DelBtn=[[UIButton alloc]initWithFrame:CGRectMake(Btn.left+20*self.scale, Btn.bottom, Btn.width-40*self.scale, 20*self.scale)];
        [DelBtn setTitle:@"重置" forState:UIControlStateNormal];
        DelBtn.titleLabel.font=DefaultFont(self.scale);
        DelBtn.tag = Btn.tag+10;
        [DelBtn setTitleColor:grayTextColor forState:UIControlStateNormal];
        [DelBtn addTarget:self action:@selector(ChongZhiEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:DelBtn];
        SetY=Btn.bottom;
    }
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, SetY+25*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
    [LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [LoginBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [LoginBtn setTitleColor:whiteLineColore forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:LoginBtn];
    _mainScrollView.contentSize=CGSizeMake(self.view.width, LoginBtn.bottom+10*self.scale);
}
-(void)ChongZhiEvent:(UIButton *)button{
    UIImageView *btn=(UIImageView *)[self.view viewWithTag:button.tag-10];
    [_ImageArr replaceObjectAtIndex:button.tag-20 withObject:@""];
    btn.image=_Img;
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
-(void)LoginButtonEvent:(id)sender{
    NSString *Img1=@"";
    NSString *Img2=@"";
    NSString *Img3=@"";
    NSString *Img4=@"";
    NSString *Img5=@"";
    NSString *Img6=@"";
    for (int i=0; i<_ImageArr.count;  i++)
    {
        id img = [_ImageArr objectAtIndex:i];
        NSData *imgData;
        if ([img isKindOfClass:[NSString class]]){
            imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:(NSString *)img]];
        }else if ([img isKindOfClass:[UIImage class]]){
            
            UIImage *image = [self imageWithImageSimple:(UIImage *)img scaledToSize:CGSizeMake(800, 800)];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            BOOL Y = YES;
            for (NSInteger j=0; j<_NetImages.count; j++) {
                
                NSData *d1 =[_NetImages objectAtIndex:i];
                if ([d1 isKindOfClass:[NSData class]] && [d1 isEqualToData:data] ) {
                    Y=NO;
                    break;
                }
            }
            if (Y) {
                data = UIImageJPEGRepresentation(image,0.8);
            }
            imgData = data;
//            imgData=UIImageJPEGRepresentation((UIImage *)img, 1);
//            if ([imgData length]/1000>1024) {
//                  imgData=UIImageJPEGRepresentation((UIImage *)img, 0.3);
//            }
        }
        NSString *base64img=[imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        int j=0;
        if (Img1.length>0) {
            j=1;
        }
        if (Img2.length>0) {
            j=2;
        }
        if (Img3.length>0) {
            j=3;
        }
        if (Img4.length>0) {
            j=4;
        }
        if (Img5.length>0) {
            j=5;
        }
        switch (j) {
            case 0:
                Img1=base64img;
                break;
            case 1:
                Img2=base64img;
                break;
            case 2:
                Img3=base64img;
                break;
            case 3:
                Img4=base64img;
                break;
            case 4:
                Img5=base64img;
                break;
            case 5:
                Img6=base64img;
                break;
            default:
                break;
        }
    }

    if (Img1.length<1) {
        
        [self ShowAlertWithMessage:@"请上传您的店铺招牌"];
        return;
    }
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[AnalyzeObject new];
    [analy ShopUsermodifyShopZhaoPaiWithUser_id:[Stockpile sharedStockpile].ID shop_zhaopai:Img1 shop_zhaopai2:Img2 shop_zhaopai3:Img3 shop_zhaopai4:Img4 shop_zhaopai5:Img5 shop_zhaopai6:Img6 Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"] && models) {
             NSLog(@"*****   %@",models);
            NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
            NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
            [Info setObject:[models objectForKey:@"zhaopai"] forKey:@"shop_zhaopai"];
            [model setObject:Info forKey:@"shop_info"];
            [[Stockpile  sharedStockpile]setModel:model];
            [self PopVC:nil];
        }
    }];
}
-(void)AddImage:(UITapGestureRecognizer *)tap{
    _SelectedImage=(UIImageView *)[tap view];
    
    UIActionSheet *_action1 = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [_action1 showInView:self.view];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        float H = self.view.width*3/4.0;
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, self.view.height/2-H/2, self.view.frame.size.width, H) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}
-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    _SelectedImage.image=editedImage;
    if (_ImageArr.count>_SelectedImage.tag-10) {
        [_ImageArr replaceObjectAtIndex:_SelectedImage.tag-10 withObject:editedImage];
    }else{
        [_ImageArr addObject:editedImage];
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"店铺招牌";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
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
