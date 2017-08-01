//
//  FaBuGongGaoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FaBuGongGaoViewController.h"
#import "CellView.h"


#import "ZLPickerViewController.h"
#import "UIView+Extension.h"
#import "ZLPickerBrowserViewController.h"
#import "ZLPickerCommon.h"
#import "ZLAnimationBaseView.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZLCameraViewController.h"
#import "BigImageViewController.h"

@interface FaBuGongGaoViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITextField *titleText;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UIScrollView *scroll;
@property(nonatomic,strong)UITextView *contentText;
@property(nonatomic,strong)NSMutableArray *imgURR;
@property(nonatomic,assign)NSInteger countt;
@property(nonatomic,strong)CellView *contentCell;
@property(nonatomic,strong)UIView *bigvi;
@property(nonatomic,strong)UIButton *PostBtn;
@end

@implementation FaBuGongGaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countt=9;
    _imgURR=[NSMutableArray new];
    _assetss=[NSMutableArray new];
    if (_imgData.count>0) {
        _assetss=_imgData;
    }
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}
-(void)newView{
    if (_scroll) {
        [_scroll removeFromSuperview];
    }
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _scroll.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scroll];
    
    
  /*  CellView *titleCell=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 44*self.scale)];
    titleCell.topline.hidden=NO;
    _titleText=[[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 6*self.scale, titleCell.width-20*self.scale, titleCell.height-12*self.scale)];
    _titleText.tag=5;
    _titleText.placeholder=@"请输入标题";
    _titleText.text=self.titlee;
    _titleText.font=DefaultFont(self.scale);
    [titleCell addSubview:_titleText];
    [_scroll addSubview:titleCell];*/
    
    _contentCell=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 134*self.scale)];
    _contentCell.topline.hidden=NO;
    
    _placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15*self.scale, 11*self.scale, _contentCell.width-30*self.scale, 20*self.scale)];
    _placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    if (self.conteent==nil || [self.conteent isEqualToString:@""]) {
        _placeLabel.text=@"说点儿什么呢？";//最多输入140个字符
    }
    _placeLabel.tag=12;
    
    
    _placeLabel.numberOfLines=0;
    [_placeLabel sizeToFit];
    _placeLabel.font=DefaultFont(self.scale);
    [_contentCell addSubview:_placeLabel];
    
    _contentText=[[UITextView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, _contentCell.width-20*self.scale, _contentCell.height-10*self.scale)];
    _contentText.backgroundColor=[UIColor clearColor];
    _contentText.tag=1;
    _contentText.text=self.conteent;
    _contentText.delegate=self;
    _contentText.font=DefaultFont(self.scale);
    [_contentCell addSubview:_contentText];
    
    
    [self imgView];
    
    
}
-(void)imgView{
    
    [_bigvi removeFromSuperview];
    _bigvi=nil;
    [_PostBtn removeFromSuperview];
    _PostBtn=nil;
    _bigvi = [[UIView alloc]initWithFrame:CGRectMake(0, _contentText.bottom, self.view.width, 100)];
    _bigvi.backgroundColor=[UIColor whiteColor];
    [_contentCell addSubview:_bigvi];
    
    NSInteger q=0;
    if (!(self.assetss.count<=0)) {
        q=_assetss.count;
    }
    float W=(self.view.width-40*self.scale)/3;
    float setY=0;
    for (int i=0; i<q+1; i++) {
        
        float x = (W+10*self.scale)*(i%3);
        float y = (W-15*self.scale)*(i/3);
        
        
        
        if (q-i==0) {
            if (q!=9) {
                
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x+10*self.scale, y, W*0.8, W*0.8)];
                [btn setBackgroundImage:[UIImage imageNamed:@"shang_jia"]  forState:UIControlStateNormal];
                btn.tag=123;
                [btn addTarget:self action:@selector(addimg) forControlEvents:UIControlEventTouchUpInside];
                [_bigvi addSubview:btn];
                
                
                setY = btn.bottom+10*self.scale;
                _bigvi.height=setY+10*self.scale;
            }
            
        }else{
            
            
            
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y, W, W*0.75)];
            im.backgroundColor=[UIColor redColor];
            
            im.clipsToBounds=YES;
            im.contentMode=UIViewContentModeScaleAspectFill;
            ALAsset *asset = self.assetss[i];
            if ([asset isKindOfClass:[ALAsset class]]) {
                im.image = [UIImage imageWithCGImage:[asset thumbnail]];
            }else if ([asset isKindOfClass:[NSString class]]){
                [im setImageWithURL:[NSURL URLWithString:(NSString *)asset] placeholderImage:[UIImage imageNamed:@"not_1"]];
            }else if([asset isKindOfClass:[UIImage class]]){
                im.image = (UIImage *)asset;
            }
            im.userInteractionEnabled=YES;
            im.tag = 50+i;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImageView:)];
            [im addGestureRecognizer:tap];
            [_bigvi addSubview:im];
            
            
            if (self.assetss.count>=9) {
                UIButton *b = (UIButton *)[self.view viewWithTag:123];
                [b removeFromSuperview];
            }
            
            
            
            
            setY = im.bottom+10*self.scale;
            _bigvi.height=setY+10*self.scale;
            
        }
    }
    _contentCell.height=_bigvi.bottom;
    
    
    _PostBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, _contentCell.bottom+15*self.scale, self.view.width-36*self.scale, 35*self.scale)];
    [_PostBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn"] forState:UIControlStateNormal];
    [_PostBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [_PostBtn setTitle:@"立即发布" forState:UIControlStateNormal];
    [_PostBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _PostBtn.titleLabel.font=BigFont(self.scale);
    [_PostBtn addTarget:self action:@selector(PostButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:_PostBtn];
    
    _scroll.contentSize = CGSizeMake(self.view.width, _PostBtn.bottom+20*self.scale);
    
    [_scroll addSubview:_contentCell];
    
}
-(void)BigImageView:(UITapGestureRecognizer *)tap{
    
    BigImageViewController *bigImg=[[BigImageViewController alloc]initWithBlock:^{
        [self imgView];
    }];
    bigImg.indexPage = [tap view].tag-50;
    bigImg.ImageArr = self.assetss;
    [self.navigationController pushViewController:bigImg animated:NO];
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
            
            _countt = 9-self.assetss.count;
            
            ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
            pickerVc.status = PickerViewShowStatusGroup;
            pickerVc.minCount = _countt;
            pickerVc.count=self.assetss.count;
            [pickerVc show];
            
            
            pickerVc.callBack = ^(NSArray *assets){
                NSMutableArray *a = [NSMutableArray arrayWithArray:assets];
                for (ALAsset *asset in a)
                {
                    ZLPickerBrowserPhoto *bor = [ZLPickerBrowserPhoto photoAnyImageObjWith:asset];
                      [self.assetss addObject:bor.photoImage];
                 /*   if ([asset isKindOfClass:[ALAsset class]]){
                        [self.assetss addObject:[UIImage imageWithCGImage:[asset thumbnail]]];
                    }else if([asset isKindOfClass:[UIImage class]]){
                       
                    }*/
                }
               
                [self imgView];
            };
            
            
            
            
            
            
        }
            
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
}




-(void)addimg{
    [self.view endEditing:YES];
    if (self.assetss.count>=9) {
        [self ShowAlertWithMessage:@"最多只能选择9张图片"];
        return;
    }
    
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [sheet showInView:self.view];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
         [self.assetss addObject:image];
        //logo
         [self imgView];
        [picker dismissViewControllerAnimated:YES completion:nil];
    
    }
    
    /*UIImage *im = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.assetss addObject:im];
    [self imgView];
    [self dismissViewControllerAnimated:YES completion:nil];*/
    
}

#pragma mark <ZLPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSUInteger)index{
    if (index > self.assetss.count) return;
    [self.assetss removeObjectAtIndex:index];
    //[self.tableView reloadData];
}

-(void)PostButtonEvent:(id)sender{
    
   /* if ([_titleText.text isEqualToString:@""]|| [_contentText.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"请完善信息后发布"];
        return;
    }*/
    NSString *content =_contentText.text;
   /* if (_contentText.text.length>140 || [_contentText.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"信息应大于0小于140个字符"];
        return;
    }*/
    if (!content) {
        content=@"";
    }
    content=[content trimString];
    content=[content stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (content.length<1 && self.assetss.count<1) {
        [self ShowAlertWithMessage:@"内容不能为空"];
        return;
    }
    content =_contentText.text;
    [self.activityVC startAnimating];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[Stockpile sharedStockpile].ID,@"user_id",@"",@"title",content,@"content",@"2",@"notice_type", nil];
    int i=1;
    for (ALAsset *asset in self.assetss) {
        ZLPickerBrowserPhoto *bor = [ZLPickerBrowserPhoto photoAnyImageObjWith:asset];
        UIImage *image = [self imageWithImageSimple:bor.photoImage scaledToSize:CGSizeMake(800, 800)];
       NSData *data = UIImageJPEGRepresentation(image,0.3);
     //   NSLog(@"%@       size %u",image,data.length/1000);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [dic setObject:encodedImageStr forKey:[NSString stringWithFormat:@"img%d",i]];
        i++;
    }

    if (_bian) {
        [dic setObject:self.gongid forKey:@"notice_id"];
        
        [anle editNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
                 [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
        
              [self PopVC:nil];
            }
        }];
    }else{
    [anle addNoticeWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
             [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
       
            [self PopVC:nil];
        }
      //  [self.navigationController popViewControllerAnimated:YES];

    }];
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
    if (textView.text.length>140) {
        textView.text=[textView.text substringToIndex:140];
    }
    //UILabel *zi =(UILabel *)[self.view viewWithTag:20];
    // zi.text=[NSString stringWithFormat:@"您最多还可以输入%lu个字",140-(unsigned long)textView.text.length];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"发布公告";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
