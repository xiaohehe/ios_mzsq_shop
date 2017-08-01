//
//  ShopXiangQingViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopXiangQingViewController.h"
#import "ZLPickerViewController.h"
#import "ZLPickerBrowserPhoto.h"
#import "CellView.h"
#import "BigImageViewController.h"
@interface ShopXiangQingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>
@property(nonatomic,strong)UILabel *labeltext;
@property(nonatomic,strong)NSMutableArray *ImageArr;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIView *ImView;
@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,strong)UIImage *DefImg;
@property(nonatomic,strong)NSArray *webImgArr;

@property(nonatomic,strong)NSMutableArray *NetImages;
@end

@implementation ShopXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self returnVi];
    [self BigVi];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)ReshData
{
    [self.activityVC startAnimating];
    AnalyzeObject *analyze=[[AnalyzeObject alloc]init];
     [analyze ShopDetailWithUser_ID:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        _infoDic=[models mutableCopy ];
         NSArray *Arr=[_infoDic objectForKey:@"imgs"];
         _webImgArr=[Arr mutableCopy];
         [self topImageVi];
         for (int i=0; i<Arr.count; i++) {
             [_ImageArr addObject:_DefImg];
         }
         [_NetImages addObjectsFromArray:_ImageArr];
         [self ReshView];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self ReshView];
}
-(void)topImageVi{
    UIView *TextBg=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale,10*self.scale, self.view.width-20*self.scale, 220*self.scale)];
    TextBg.backgroundColor=[UIColor whiteColor];
    TextBg.layer.borderColor=blackLineColore.CGColor;
    TextBg.layer.borderWidth = .5;
    TextBg.tag=11;
    [_mainScrollView addSubview:TextBg];
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, TextBg.width-30, 20)];
    placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    placeLabel.text=@"请输入本店的介绍信息";//最多输入140个字符
    placeLabel.tag=12;
    placeLabel.numberOfLines=0;
    placeLabel.font=DefaultFont(self.scale);
    [TextBg addSubview:placeLabel];
    
    UITextView *contentText=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, TextBg.width-20, 150*self.scale)];
    contentText.backgroundColor=[UIColor clearColor];
    contentText.tag=10;
    contentText.delegate=self;
    contentText.font=DefaultFont(self.scale);
    if (_infoDic) {
        contentText.text=[[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"detail"]] EmptyStringByWhitespace];
        if (![contentText.text isEmptyString]) {
            placeLabel.hidden=YES;
        }
    }
    [TextBg addSubview:contentText];
    _ImView=[[UIView alloc]initWithFrame:CGRectMake(contentText.left,  contentText.bottom+10*self.scale, contentText.width, (contentText.width-30*self.scale)/4)];
    [TextBg addSubview:_ImView];
    UIButton *vi = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,(_ImView.width-20*self.scale)/3, (_ImView.width-20*self.scale)/4)];
    [vi setBackgroundImage:[UIImage imageNamed:@"pj_jia_img"] forState:UIControlStateNormal];
    vi.tag=5;
    [vi addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
    [_ImView addSubview:vi];
    TextBg.height = _ImView.bottom+10*self.scale;
}
-(void)BigVi{
    _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _mainScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    _ImageArr=[NSMutableArray new];
    _NetImages=[NSMutableArray new];
    _DefImg=[UIImage imageNamed:@"not_1"];
}
-(void)ReshView{
    UIView *TextBg =(UIView *)[self.view viewWithTag:11];
     UITextView *contentText =(UITextView *)[self.view viewWithTag:10];
    [_ImView removeFromSuperview];
    _ImView=nil;
    _ImView=[[UIView alloc]initWithFrame:CGRectMake(contentText.left,  contentText.bottom+10*self.scale, contentText.width, (contentText.width-30*self.scale)/4)];
    [TextBg addSubview:_ImView];
    UIButton *vi = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,(_ImView.width-20*self.scale)/3, (_ImView.width-20*self.scale)/4)];
    [vi setBackgroundImage:[UIImage imageNamed:@"pj_jia_img"] forState:UIControlStateNormal];
    vi.tag=5;
    [vi addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
    [_ImView addSubview:vi];
    
    float SetX=0;
    float SetY=0;
    for (int i=0; i<_ImageArr.count; i++)
    {
        UIImageView *Image=[[UIImageView alloc]initWithFrame:CGRectMake((i%3)*(vi.width+10*self.scale), (i/3)*(vi.height+10*self.scale), vi.width, vi.height)];
        __block UIImageView *blockImg=Image;
        UIImage *img=[_ImageArr objectAtIndex:i];
        if (![img isEqual:_DefImg]) {
            Image.image=img;
        }else{
            [Image setImageWithURLRequest:  [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_webImgArr objectAtIndex:i]]]] placeholderImage:[UIImage imageNamed:@"not_1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (_ImageArr.count>i && image) {
                    [_ImageArr replaceObjectAtIndex:i withObject:image];
                    NSData *data=UIImageJPEGRepresentation(image, 1);
                    [_NetImages replaceObjectAtIndex:i withObject:data];
                    blockImg.image=image;
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        }
        Image.tag=i;
        Image.userInteractionEnabled=YES;
        Image.contentMode=UIViewContentModeScaleAspectFill;
         Image.clipsToBounds=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImageEvent:)];
        [Image addGestureRecognizer:tap];
        [_ImView addSubview:Image];
        SetX=Image.right;
        SetY=Image.bottom;
    }
    if (_ImageArr.count>=9) {
        vi.hidden=YES;
    }else{
        vi.hidden=NO;
        vi.frame=CGRectMake((_ImageArr.count%3)*(vi.width+10*self.scale), (_ImageArr.count/3)*(vi.height+10*self.scale), vi.width, vi.width);
        _ImView.height=vi.bottom;
         SetY=vi.bottom;
    }
    _ImView.height = SetY;
     TextBg.height = _ImView.bottom+10*self.scale;
    TextBg.clipsToBounds=YES;
}
-(void)BigImageEvent:(UITapGestureRecognizer *)tap{
    UIImageView *Img=(UIImageView *)[tap view];
    self.hidesBottomBarWhenPushed=YES;
    BigImageViewController *bigVC=[[BigImageViewController alloc]init];
    bigVC.indexPage=Img.tag;
    bigVC.ImageArr=_ImageArr;
    //bigVC.webImgArr=[_webImgArr mutableCopy];
    [self.navigationController pushViewController:bigVC animated:NO];
}
-(void)addImg{
    [self.view endEditing:YES];
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [action showInView:self.view];

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
                //picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
        }
            break;
        case 1:{
            NSLog(@"从相册选择");
            ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
             pickerVc.status = PickerViewShowStatusGroup;
            pickerVc.minCount=9-_ImageArr.count;
            [pickerVc show];
            pickerVc.callBack= ^(NSArray *assets){
              //  NSLog(@"----- %@",assets);
                for (int i=0; i<assets.count; i++) {
                     ZLPickerBrowserPhoto *zl = [ZLPickerBrowserPhoto photoAnyImageObjWith:[assets objectAtIndex:i]];
                    [_ImageArr addObject:zl.photoImage];
                }
             //   [_ImageArr addObjectsFromArray:assets];
                [self ReshView];
            };
            
           /* SGImagePickerController *picker=[[SGImagePickerController alloc]initWithRootViewController:self];
            [picker setDidFinishSelectImages:^(NSArray *images) {
                [_ImageArr addObjectsFromArray:images];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self ReshView];
                });
            }];
            [self presentViewController:picker animated:YES completion:nil];*/
        }
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        [_ImageArr addObject:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
    /*  if (textView.text.length>140) {
     textView.text=[textView.text substringToIndex:140];
     }*/
    // UILabel *zi =(UILabel *)[self.view viewWithTag:20];
    // zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)textView.text.length];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"店铺详情";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];
    
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
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
-(void)saveBtnEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    UITextView *Advise=(UITextView *)[self.view viewWithTag:10];
    NSString *content=[Advise.text trimString];
    if (!content || content.length<1) {
        [self ShowAlertWithMessage:@"请输入有效的建议内容"];
        return;
    }
    NSString *Img1=@"";
    NSString *Img2=@"";
    NSString *Img3=@"";
    NSString *Img4=@"";
    NSString *Img5=@"";
    NSString *Img6=@"";
    NSString *Img7=@"";
    NSString *Img8=@"";
    NSString *Img9=@"";
    for (int i=0; i<_ImageArr.count; i++)
    {
        
        //NSData *imgData=UIImageJPEGRepresentation([_ImageArr objectAtIndex:i], 0.3);
        UIImage *image = [self imageWithImageSimple:(UIImage *)[_ImageArr objectAtIndex:i] scaledToSize:CGSizeMake(800, 800)];
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
        NSString *base64img=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
        switch (i) {
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
            case 6:
                Img7=base64img;
                break;
            case 7:
                Img8=base64img;
                break;
            case 8:
                Img9=base64img;
                break;
                
            default:
                break;
        }
    }
    
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy ModifyShopDetailWithUser_ID:[Stockpile sharedStockpile].ID Detail:content Img1:Img1 Img2:Img2 Img3:Img3 Img4:Img4 Img5:Img5 Img6:Img6 Img7:Img7 Img8:Img8 Img9:Img9 Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
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
