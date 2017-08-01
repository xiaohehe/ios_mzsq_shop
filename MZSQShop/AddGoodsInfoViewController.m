//
//  AddGoodsInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddGoodsInfoViewController.h"
#import "CellView.h"
#import "ChooseFenLeiViewController.h"
#import "BigImageViewController.h"
#import "ZLPickerViewController.h"
#import "ZLPickerBrowserPhoto.h"
@interface AddGoodsInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)AddGoodsInfoBlock block;
@property(nonatomic,strong)NSMutableArray *NetImages;
@property(nonatomic,assign)BOOL isHasPoint, isHasPoint1 ;
@end

@implementation AddGoodsInfoViewController
-(id)initWithBlock:(AddGoodsInfoBlock)block{
    self=[super init];
    if (self) {
        _imgArr = [[NSMutableArray alloc]init];
         _NetImages = [[NSMutableArray alloc]init];
        _block=block;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self returnVi];
    [self goodsInfo];
    [self.view addSubview:self.activityVC];
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (_imgArr) {
        for(int i=0;i<_imgArr.count;){
            NSString *imageurlstring=[NSString stringWithFormat:@"%@",[_imgArr objectAtIndex:i]];
             NSString *imagename = [imageurlstring lastPathComponent];
            if ([imagename isEqualToString:@"-1"]) {
                [_imgArr removeObjectAtIndex:i];
            }else{
                i++;
            }
        }
        
        [_NetImages addObjectsFromArray:_imgArr];
    }
   // _DefImg=[UIImage imageNamed:@"not_1"];
   // for (int i=0; i<_webImgArr.count; i++) {
     //   [_imgArr addObject:_DefImg];
   // }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    UITextField *YPwdText=(UITextField *)[self.view viewWithTag:10];
    NSString *ypwd=[YPwdText.text trimString];
    if (ypwd.length>25) {
        ypwd=[ypwd substringToIndex:25];
        YPwdText.text=ypwd;
    }
    UITextField *DanjiaText=(UITextField *)[self.view viewWithTag:66];
    NSString *danjia=[DanjiaText.text trimString];
    if (danjia.length>5) {
        danjia=[danjia substringToIndex:5];
        DanjiaText.text=danjia;
    }
}
-(void)keyboardChangeFrame:(NSNotification *)notification
{
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _scrollView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, rect.origin.y-self.NavImg.bottom);
        _scrollView.clipsToBounds = YES;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self ReshView];
}
#pragma mark----产品名字，价格分类 时间信息；
-(void)goodsInfo{

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _scrollView.backgroundColor = superBackgroundColor;
   // _scrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    float setY = 10*self.scale;
    NSArray *arr = @[@"产品名称",@"价格",@"原价",@"选择分类",@"库存",@"库存预警"];
    NSArray *Varr = @[@"",@"",@"",@"",@"",@""];
    if (_class_Name && _class_Name.length>0) {
        Varr = @[@"",@"",@"",[_class_Name EmptyStringByWhitespace],@"",@""];
    }
    if (_ID&&_ID.length>0) {
        Varr = @[[_name EmptyStringByWhitespace],[_price EmptyStringByWhitespace],[_origin_price EmptyStringByWhitespace],[_class_Name EmptyStringByWhitespace],[_inventory EmptyStringByWhitespace],[_inventroty_alarm EmptyStringByWhitespace]];
    }
    for (int i=0; i<arr.count; i++) {
        CellView *infoCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 44.0)];
        infoCell.backgroundColor = [UIColor whiteColor];
        [infoCell ShowRight:i==3];
        infoCell.topline.hidden = i!=0;
        infoCell.title=arr[i];
        UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake( infoCell.titleLabel.right-10*self.scale, 5*self.scale, infoCell.width- infoCell.titleLabel.right-20*self.scale, infoCell.height-10*self.scale)];
        textF.font=DefaultFont(self.scale);
            textF.placeholder=[NSString stringWithFormat:@"请%@",arr[i]];
        if (infoCell.RightImg.hidden) {
                textF.placeholder=[NSString stringWithFormat:@"请输入%@",arr[i]];
        }
        if (i==0) {
            [textF setMaxLength:Lenth10];
        }else if (i==4 || i==5){
              [textF setMaxLength:Lenth8];
        }
    
        textF.tag=10+i;
        textF.text=Varr[i];
        textF.delegate=self;
        if(i==1){
            textF.width=textF.width/2-20*self.scale;
            infoCell.contentLabel.frame=CGRectMake(textF.right,infoCell.contentLabel.top,40*self.scale, infoCell.contentLabel.height);
            infoCell.contentLabel.text=@"单位：";
          
            UITextField *DanJia=[[UITextField alloc]initWithFrame:CGRectMake(infoCell.contentLabel.right, textF.top, textF.width, textF.height)];
            DanJia.tag = 66;
            [DanJia setMaxLength:Lenth5];
            DanJia.delegate=self;
            DanJia.text=_unit;
            DanJia.placeholder=@"计量单位，比如：斤";
            DanJia.font=SmallFont(self.scale);
            [infoCell addSubview:DanJia];
        }
        
        [infoCell addSubview:textF];
        [_scrollView addSubview:infoCell];
        setY = infoCell.bottom;
    }
    CellView *imgCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY+15*self.scale, self.view.width, 300)];
    imgCell.backgroundColor = [UIColor whiteColor];
    imgCell.topline.hidden=NO;
    imgCell.tag=3;
    [_scrollView addSubview:imgCell];
    
    UILabel *titleLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    titleLa.text = @"产品图片";
    titleLa.textAlignment = NSTextAlignmentLeft;
    titleLa.font = DefaultFont(self.scale);
    [imgCell addSubview:titleLa];
    imgCell.height = setY;
    
#pragma mark-------产品介绍的Cell;
    
    CellView *goodXiangQingCell = [[CellView alloc]initWithFrame:CGRectMake(0, imgCell.bottom+10*self.scale, self.view.width, 120*self.scale)];
    goodXiangQingCell.tag=4;
    goodXiangQingCell.topline.hidden=NO;
    goodXiangQingCell.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:goodXiangQingCell];
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 11, goodXiangQingCell.width-30, 20)];
    placeLabel.textColor=[UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1];
    placeLabel.text=@"产品介绍";//最多输入140个字符
    placeLabel.tag=2;
    placeLabel.hidden = (_desc &&_desc.length>0);
    placeLabel.numberOfLines=0;
    placeLabel.font=DefaultFont(self.scale);
    [goodXiangQingCell addSubview:placeLabel];
    
    UITextView *contentText=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, goodXiangQingCell.width-20, goodXiangQingCell.height-10)];
    contentText.backgroundColor=[UIColor clearColor];
    contentText.tag=1;
    contentText.text=_desc;
    contentText.delegate=self;
    contentText.font=DefaultFont(self.scale);
    [goodXiangQingCell addSubview:contentText];

    UIButton *queDingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queDingBtn.frame = CGRectMake(10*self.scale, goodXiangQingCell.bottom+20*self.scale, self.view.width-20*self.scale, 30*self.scale);
    queDingBtn.tag=5;
   // queDingBtn.backgroundColor = [UIColor orangeColor];
    [queDingBtn  setBackgroundImage:[UIImage setImgNameBianShen:@"o_btn"] forState:UIControlStateNormal];
    [queDingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [queDingBtn  setBackgroundImage:[UIImage setImgNameBianShen:@"o_btn_b"] forState:UIControlStateHighlighted];
    [queDingBtn setTitle:@"确定" forState:UIControlStateNormal];
    queDingBtn.titleLabel.font=BigFont(self.scale);
    [queDingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queDingBtn addTarget:self action:@selector(queDingEvent) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:queDingBtn];
    _scrollView.contentSize = CGSizeMake(self.view.width, queDingBtn.bottom+20*self.scale);
    
}

-(void)ReshView{
 NSLog(@"********** %@",_NetImages);
    
    
    CellView *TextBg =(CellView *)[self.view viewWithTag:3];
        float setY=TextBg.top;
    [TextBg removeFromSuperview];
    TextBg=nil;
    CellView *imgCell = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 300)];
    imgCell.backgroundColor = [UIColor whiteColor];
    imgCell.topline.hidden=NO;
    imgCell.tag=3;
    [_scrollView addSubview:imgCell];
    
    UILabel *titleLa = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 20*self.scale)];
    titleLa.text = @"产品图片";
    titleLa.textAlignment = NSTextAlignmentLeft;
    titleLa.font = DefaultFont(self.scale);
    [imgCell addSubview:titleLa];
    
    UIImageView *vi = [[UIImageView alloc]initWithFrame:CGRectMake(titleLa.left, titleLa.bottom+10*self.scale,(titleLa.width-40*self.scale)/5, (titleLa.width-40*self.scale)*3/20)];
    [vi setImage:[UIImage imageNamed:@"pj_jia_img"]];
    vi.tag=5;
    vi.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImgBtnEvent)];
    [vi addGestureRecognizer:tap];
   // [vi addTarget:self action:@selector(addImgBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [imgCell addSubview:vi];
    
    float SetX=0;
    float SetY=vi.bottom;
    
    for (int i=0; i<_imgArr.count; i++)
    {
        UIImageView *Image=[[UIImageView alloc]initWithFrame:CGRectMake(vi.left+(i%5)*(vi.width+10*self.scale),vi.top+(i/5)*(vi.height+10*self.scale), vi.width, vi.height)];
        //__block UIImageView *blockImg=Image;
          //Image.backgroundColor=[UIColor redColor];
         id img = [_imgArr objectAtIndex:i];
        if([img isKindOfClass:[UIImage class]]) {
             Image.image=img;
        }else if ([img isKindOfClass:[NSString class]]){
            [Image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgArr objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"not_1"]];

//            [Image setImageWithURLRequest:  [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_imgArr objectAtIndex:i]]]] placeholderImage:[UIImage imageNamed:@"not_1"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                if (_imgArr.count>i) {
//                    [_imgArr replaceObjectAtIndex:i withObject:image];
//                    NSData *data=UIImageJPEGRepresentation(image, 1);
//                    [_NetImages replaceObjectAtIndex:i withObject:data];
//                }
//                  blockImg.image=image;
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//           
//            }];
        }
       
        Image.tag=i;
        Image.userInteractionEnabled=YES;
         Image.contentMode=UIViewContentModeScaleAspectFill;
        Image.clipsToBounds = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BigImageEvent:)];
        [Image addGestureRecognizer:tap];
        [imgCell addSubview:Image];
        SetX=Image.right;
        SetY=Image.bottom;
    }
    if (_imgArr.count>=9) {
        vi.hidden=YES;
    }else{
        vi.hidden=NO;
        vi.frame=CGRectMake(vi.left+(_imgArr.count%5)*(vi.width+10*self.scale),vi.top+(_imgArr.count/5)*(vi.height+10*self.scale), vi.width, vi.width);
      //  imgCell.height=vi.bottom;
        SetY=vi.bottom;
    }
    imgCell.height = SetY+10*self.scale;
    CellView *goodXiangQingCell =(CellView *)[self.view viewWithTag:4];
    goodXiangQingCell.origin=CGPointMake(0, imgCell.bottom+10*self.scale);
    
    UIButton *queDingBtn =(UIButton *)[self.view viewWithTag:5];
    queDingBtn.frame = CGRectMake(10*self.scale, goodXiangQingCell.bottom+20*self.scale, self.view.width-20*self.scale, 30*self.scale);
     _scrollView.contentSize = CGSizeMake(self.view.width, queDingBtn.bottom+20*self.scale);
}
-(void)BigImageEvent:(UITapGestureRecognizer *)tap{
    UIImageView *Img=(UIImageView *)[tap view];
    self.hidesBottomBarWhenPushed=YES;
    BigImageViewController *bigVC=[[BigImageViewController alloc]init];
    bigVC.indexPage=Img.tag;
    bigVC.ImageArr=_imgArr;
  //  bigVC.DefImg=_DefImg;
  bigVC.webImgArr=_NetImages;
    [self.navigationController pushViewController:bigVC animated:NO];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.tag == 11){
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            _isHasPoint = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return YES;
                    }
                }
         
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!_isHasPoint)//text中还没有小数点
                    {
                        _isHasPoint = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHasPoint) {//存在小数点
                        NSRange ran = [textField.text rangeOfString:@"."];
                        //判断小数点的位数
                        //NSRange ran = [textField.text rangeOfString:@"."];
                        if ((range.location - ran.location <= 2) || ran.location<Lenth8) {
                            
                            return YES;
                        }else{
                            
                            return NO;
                        }
                    }else{
                        if (range.location<Lenth8) {
                            return YES;
                        }
                        return NO;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    } else
    if(textField.tag == 12){
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            _isHasPoint1 = NO;
        }
        if ([string length] > 0) {
            
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
                
                //首字母不能为0和小数点
                if([textField.text length] == 0){
                    if(single == '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return YES;
                    }
                }
                
                //输入的字符是否是小数点
                if (single == '.') {
                    if(!_isHasPoint1)//text中还没有小数点
                    {
                        _isHasPoint1 = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    if (_isHasPoint1) {//存在小数点
                        NSRange ran = [textField.text rangeOfString:@"."];
                        //判断小数点的位数
                        //NSRange ran = [textField.text rangeOfString:@"."];
                        if ((range.location - ran.location <= 2) && ran.location<Lenth8) {
                            
                            return YES;
                        }else{
                            if(range.location - ran.location <= 2){
                                return YES;
                            }
                            return NO;
                        }
                    }else{
                        if (range.location<Lenth8) {
                            return YES;
                        }
                        return NO;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==13) {
        self.hidesBottomBarWhenPushed=YES;
        ChooseFenLeiViewController *choose = [[ChooseFenLeiViewController alloc]initWithBlock:^(NSDictionary *dic) {
            textField.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"class_name"]];
            _class_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        }];
        [self.navigationController pushViewController:choose animated:YES];
        return NO;
    }
    if(textField.tag == 11 || textField.tag == 12){
        textField.keyboardType=UIKeyboardTypeDecimalPad;
    }else if (textField.tag==14 || textField.tag == 15){
          textField.keyboardType=UIKeyboardTypeNumberPad;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
       [self.view endEditing:YES];
    return YES;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:2];
        label.hidden=YES;
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:2];
        label.hidden=NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)queDingEvent{
     [self.view endEditing:YES];
    
    UITextField *NameText=(UITextField *)[self.view viewWithTag:10];
    NSString *name=[NameText.text trimString];
    if (!name || name.length<1) {
       [self ShowAlertWithMessage:@"请输入产品名称"];
        return;
    }
    UITextField *PriceText=(UITextField *)[self.view viewWithTag:11];
    NSString *Price=[PriceText.text trimString];
    
    UITextField *origin_priceText=(UITextField *)[self.view viewWithTag:12];
    NSString *origin_price=[[origin_priceText.text trimString] EmptyStringByWhitespace];
    
    
    if (Price==nil || !Price || Price.length<1 || [Price floatValue]<=0 || [Price componentsSeparatedByString:@"."].count>2) {
        [self ShowAlertWithMessage:@"请输入产品价格"];
        return;
    }
    UITextField *DanjiaText=(UITextField *)[self.view viewWithTag:66];
    NSString *danjia=[DanjiaText.text trimString];
    if (danjia.length<1 || !danjia) {
        [self ShowAlertWithMessage:@"请输入产品的单位"];
        return;
    }
    
    if (!_class_id || _class_id.length<1) {
        [self ShowAlertWithMessage:@"请选择产品分类"];
        return;
    }
    UITextField *NumText=(UITextField *)[self.view viewWithTag:14];
    NSString *num=[NumText.text trimString];
    if (!num || num.length<1 || [num integerValue]<1 ) {
        [self ShowAlertWithMessage:@"请输入库存"];
        return;
    }
    UITextField *AlermText=(UITextField *)[self.view viewWithTag:15];
    NSString *alerm=[[AlermText.text trimString] EmptyStringByWhitespace];

    
    UITextView *Advise=(UITextView *)[self.view viewWithTag:1];
    NSString *content=[Advise.text trimString];
    //if (!content || content.length<1) {
     //   [self ShowAlertWithMessage:@"请输入商品介绍"];
       // return;
  //  }
    NSString *Img1=@"";
    NSString *Img2=@"";
    NSString *Img3=@"";
    NSString *Img4=@"";
    NSString *Img5=@"";
    NSString *Img6=@"";
    NSString *Img7=@"";
    NSString *Img8=@"";
    NSString *Img9=@"";
    NSArray *Arr = _imgArr;
    if (_NetImages.count>0) {
        Arr = _NetImages;
    }
    
    NSMutableArray *del_Arr=[[NSMutableArray alloc]init];
     NSMutableArray *add_Arr=[[NSMutableArray alloc]init];
    for (int i=0; i<Arr.count; i++)
    {
        NSString *base64img=@"";
        id img = [Arr objectAtIndex:i];
      
        if ([img isKindOfClass:[UIImage class]]) {
            UIImage *image = [self imageWithImageSimple:img scaledToSize:CGSizeMake(800, 800)];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            if (data.length>102400) {
                data = UIImageJPEGRepresentation(image, 0.8);
            }
            base64img=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [add_Arr addObject:base64img];
        }else if ([img isKindOfClass:[NSString class]] &&   [img length]<6){
            [del_Arr addObject:@(1+i)];
            base64img=@"-1";
        }
        
//        UIImage *image = [self imageWithImageSimple:(UIImage *)[_imgArr objectAtIndex:i] scaledToSize:CGSizeMake(800, 800)];
//        NSData *data = UIImageJPEGRepresentation(image, 1);
//        BOOL Y = YES;
//        for (NSInteger j=0; j<_NetImages.count; j++) {
//            
//            NSData *d1 =[_NetImages objectAtIndex:i];
//            if ([d1 isKindOfClass:[NSData class]] && [d1 isEqualToData:data] ) {
//                Y=NO;
//                break;
//            }
//        }
//        if (Y) {
//            data = UIImageJPEGRepresentation(image,0.8);
//        }
//        NSString *base64img=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
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
    
    if (_ID && _ID.length>0 && ![_ID isEmptyString]) {
        
        NSData *deldata=[NSJSONSerialization dataWithJSONObject:del_Arr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *delstr=[[NSString alloc]initWithData:deldata encoding:NSUTF8StringEncoding];
        
        NSData *adddata=[NSJSONSerialization dataWithJSONObject:add_Arr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *addstr=[[NSString alloc]initWithData:adddata encoding:NSUTF8StringEncoding];
        
        [analy ModifyProdWithUser_ID:[Stockpile sharedStockpile].ID Prod_id:_ID Prod_name:name Price:Price Unit:danjia origin_price:origin_price inventroty_alarm:alerm Class_id:_class_id Inventory:num Desc:content img_add:addstr img_delete:delstr Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                if (_block) {
                    _block();
                }
                [self PopVC:nil];
            }
        }];

       
    }else{
        [analy AddProdWithUser_ID:[Stockpile sharedStockpile].ID Prod_name:name Price:Price Unit:danjia origin_price:origin_price inventroty_alarm:alerm Class_id:_class_id Inventory:num Desc:content Img1:Img1 Img2:Img2 Img3:Img3 Img4:Img4 Img5:Img5 Img6:Img6 Img7:Img7 Img8:Img8 Img9:Img9 Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                if (_block) {
                    _block();
                }
                [self PopVC:nil];
            }
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
-(void)addImgBtnEvent{
     [self.view endEditing:YES];
    
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册中获取" otherButtonTitles:@"拍照", nil];
    [action showInView:self.view];
    

}
#pragma mark - 拍照片
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"相册");
        ZLPickerViewController *pickerVc = [[ZLPickerViewController alloc] init];
        pickerVc.status = PickerViewShowStatusGroup;
        pickerVc.minCount=9-_imgArr.count;
        [pickerVc show];
        pickerVc.callBack= ^(NSArray *assets){
            for (int i=0; i<assets.count; i++) {
                ZLPickerBrowserPhoto *zl = [ZLPickerBrowserPhoto photoAnyImageObjWith:[assets objectAtIndex:i]];
                [self ReplaceImageWithImage:zl.photoImage];
                [_imgArr addObject:zl.photoImage];
            }
            [self ReshView];
        };
    }else if (buttonIndex == 1) {
        NSLog(@"拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = actionSheet.tag == 1;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 2) {
        NSLog(@"取消");
        
    }
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
   //     [picker dismissViewControllerAnimated:YES completion:nil];
   // UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imgArr addObject:image];
[self ReplaceImageWithImage:image];
    //logo
      [self ReshView];
   [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)ReplaceImageWithImage:(UIImage *)image{
    if (_NetImages.count<1) {
        return;
    }
    BOOL Key = YES;
   /* for (int i=0; i<_NetImages.count; i++) {
        id img = [_NetImages objectAtIndex:i];
       
        if ([img isKindOfClass:[NSString class]] && [img length]<6) {
        
            [_NetImages replaceObjectAtIndex:i withObject:image];
            Key = NO;
            break;
        }
    }*/
    if (Key) {
        [_NetImages addObject:image];
    }
}
#pragma mark -----返回按钮
-(void)returnVi{
    self.TitleLabel.text = @"添加商品信息";
    
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
