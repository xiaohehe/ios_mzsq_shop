//
//  GongGaoInfoViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GongGaoInfoViewController.h"
#import "IntroControll.h"


@interface GongGaoInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)CellView *bv;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)IntroControll *intro;
@end

@implementation GongGaoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource=[NSMutableArray new];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keybordWillhieeht:) name:UIKeyboardWillHideNotification object:nil];

    [self newNav];
  //  [self newView];
    [self.view addSubview:self.activityVC];
   
    [self reshData];

}

-(void)keybordWillChange:(NSNotification *)notification{
    _bv.hidden=NO;
     [_mesay becomeFirstResponder];
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        _bv.bottom=rect.origin.y;
    }];



}

-(void)keybordWillhieeht:(NSNotification *)notification{

    _bv.hidden=NO;
    [_mesay becomeFirstResponder];
    NSDictionary *info =notification.userInfo;
    CGRect rect=[info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration=[info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _bv.bottom=rect.origin.y;
    }];

}
-(void)fabiao{
    [self.view endEditing:YES];
    
    
    if ([_mesay.text isEqualToString:@""]) {
        [self ShowAlertWithMessage:@"请输入信息"];
        return;
    }
    if (_mesay.text.length>200) {
        [self ShowAlertWithMessage:@"最多只能输入200个字符"];
        return;
    }
    [self.view addSubview:self.activityVC];
    [self .activityVC startAnimating];
   
    AnalyzeObject *nale = [AnalyzeObject new];
    NSDictionary *dic = @{@"user_id":[Stockpile sharedStockpile].ID,@"content":_mesay.text,@"notice_id":self.gongID,@"notice_type":self.type};
    [nale NoticeWallcommentWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
         
          //  [self ShowAlertWithMessage:msg];
            [self.view endEditing:YES];
            _tf.text=@"";
            _mesay.text=@"";
          
            
            [self reshData];
            
        }
        
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

 [self.view endEditing:YES];

}
-(void)reshData{
    [_dataSource removeAllObjects];
     [self.activityVC startAnimating];
    AnalyzeObject *anle = [AnalyzeObject new];
    NSDictionary *dic = @{@"notice_id":self.gongID,@"notice_type":self.type};
    [anle noticeDetailWithDic:dic Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"]) {
            [_dataSource addObjectsFromArray:models];
            
            [self newView];
            [self newHeaderView];
            [_tableView reloadData];
        }
        
    }];

}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, [UIScreen mainScreen].bounds.size.height-self.NavImg.bottom-40)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[XiangQingTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_tableView];
   
    
//我也说两句
    CellView *bv = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 44*self.scale)];
    bv.backgroundColor=superBackgroundColor;
    [self.view addSubview:bv];
    
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 7, self.view.width-90*self.scale, 30*self.scale)];
    _tf.layer.borderWidth=.5;
    _tf.backgroundColor=[UIColor whiteColor];
    _tf.layer.borderColor=blackLineColore.CGColor;
    _tf.layer.cornerRadius=5;
    _tf.placeholder=@"  我也说两句";
    _tf.font=DefaultFont(self.scale);
    [bv addSubview:_tf];
    
    UIView *rightv = [[UIView alloc]initWithFrame:CGRectMake(_tf.right+10*self.scale, _tf.top, self.view.width-_tf.right-20*self.scale, _tf.height)];
    rightv.backgroundColor=[UIColor whiteColor];
    rightv.layer.cornerRadius=5;
    rightv.layer.borderWidth=.5;
    rightv.layer.borderColor=blackLineColore.CGColor;
    [bv addSubview:rightv];
    
    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(6*self.scale, rightv.height/2-9*self.scale, 20*self.scale, 18*self.scale)];
    im.image=[UIImage imageNamed:@"gg_pingjia_ico"];
    [rightv addSubview:im];
    
    UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(im.right+3*self.scale, rightv.height/2-10*self.scale, rightv.width-im.right-5*self.scale, 17*self.scale)];
    if (_dataSource.count<=0) {
         num.text=@"0";
    }else{
    
    num.text=_dataSource[0][@"comment_count"];
    }
    num.textAlignment=NSTextAlignmentCenter;
    num.font=SmallFont(self.scale);
    num.textColor=blueTextColor;
    [rightv addSubview:num];
    
    [self fabiaovi];
    
}


-(void)fabiaovi{
    
    
    
    _bv = [[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-44*self.scale, self.view.width, 80*self.scale)];
    _bv.backgroundColor=superBackgroundColor;
    [self.view addSubview:_bv];
    
    _bv.hidden=YES;

    
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 7, self.view.width-20*self.scale, 30*self.scale)];
    vi.layer.borderWidth=.5;
    vi.backgroundColor=[UIColor whiteColor];
    vi.layer.borderColor=blackLineColore.CGColor;
    vi.layer.cornerRadius=5;
    [_bv addSubview:vi];

    
    _mesay = [[UITextField alloc]initWithFrame:CGRectMake(10*self.scale, 0, vi.width-20*self.scale, 30*self.scale)];
//    _mesay.layer.borderWidth=.5;
//    _mesay.backgroundColor=[UIColor whiteColor];
    _mesay.layer.borderColor=blackLineColore.CGColor;
    _mesay.layer.cornerRadius=5;
    _mesay.placeholder=@"我也说两句";
    _mesay.font=DefaultFont(self.scale);
    [vi addSubview:_mesay];
    
    UILabel *xianzhi = [[UILabel alloc]initWithFrame:CGRectMake(_mesay.left, _mesay.bottom+10*self.scale, self.view.width-80*self.scale, 20*self.scale)];
    xianzhi.text=@"最多字符200个";
    xianzhi.font=DefaultFont(self.scale);
    xianzhi.textColor=grayTextColor;
    [_bv addSubview:xianzhi];
    
    UIButton *fa = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60*self.scale, _mesay.bottom+10*self.scale, 50*self.scale, 30*self.scale)];
    [fa setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:224/255.0 green:234/255.0 blue:238/255.0 alpha:1]]forState:UIControlStateNormal];
    fa.layer.cornerRadius=5;
    fa.layer.borderWidth=.5;
    fa.layer.borderColor=blackLineColore.CGColor;
    fa.titleLabel.font=DefaultFont(self.scale);
    [fa setTitle:@"发表" forState:UIControlStateNormal];
    [fa addTarget:self action:@selector(fabiao) forControlEvents:UIControlEventTouchUpInside];
    [fa setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bv addSubview:fa];


}
-(void)newHeaderView{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 130*self.scale)];
    headerView.backgroundColor=[UIColor whiteColor];
   /* UILabel *tit  =[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 10)];
    if (_dataSource.count>0) {
        tit.text=[NSString stringWithFormat:@" %@",_dataSource[0][@"title"]];
    }
    tit.textAlignment=NSTextAlignmentCenter;
    tit.font=BigFont(self.scale);
    tit.textColor=[UIColor blackColor];
    [tit sizeToFit];
    [headerView addSubview:tit];*/
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, self.view.width-20*self.scale, 10)];
    la.numberOfLines=0;
    la.font=DefaultFont(self.scale);
    la.textColor=grayTextColor;
    if (_dataSource.count>0) {
         la.text=[NSString stringWithFormat:@" %@",_dataSource[0][@"content"]];
    }
    [la sizeToFit];
    [headerView addSubview:la];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13*self.scale], NSParagraphStyleAttributeName:paragraphStyle.copy};
//    CGSize size = [la.text boundingRectWithSize:CGSizeMake(la.width, 3500*self.scale) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    la.height=size.height;
    NSMutableArray *a = [NSMutableArray new];
    if (_dataSource.count>0) {
        for (int i=0; i<9; i++) {
            NSString *str = [NSString stringWithFormat:@"img%d",i+1];
            NSString *na = _dataSource[0][str];
            if (![na isEqualToString:@""]) {
                [a addObject:na];
            }
        }
    }
    float setY=la.bottom+10*self.scale;
    if (a.count>0) {
        float W=(self.view.width-40*self.scale)/3;
        for (int i=0; i<a.count; i++) {
            float x = (W+10*self.scale)*(i%3);
            float y = (W-15*self.scale)*(i/3);
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(x+10*self.scale, y+la.bottom+10*self.scale, W, W*0.75)];
            im.userInteractionEnabled=YES;
            [im setImageWithURL:[NSURL URLWithString:a[i]] placeholderImage:[UIImage imageNamed:@"not_1"]];
            [headerView addSubview:im];
            im.tag=i;
            im.contentMode=UIViewContentModeScaleAspectFill;
            im.clipsToBounds = YES;
            UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBig:)];
            [im addGestureRecognizer:tap];
            setY = im.bottom+10*self.scale;
        }
    }
    CellView *k = [[CellView alloc]initWithFrame:CGRectMake(0, setY, self.view.width, 10*self.scale)];
    k.topline.hidden=NO;
    k.backgroundColor=superBackgroundColor;
    [headerView addSubview:k];
    headerView.height=k.bottom+0*self.scale;
    _tableView.tableHeaderView=headerView;
}

-(void)imgBig:(UITapGestureRecognizer *)tap{
    NSMutableArray *a = [NSMutableArray new];
        for (int i=0; i<9; i++) {
            NSString *str = [NSString stringWithFormat:@"img%d",i+1];
            NSString *na = _dataSource[0][str];
            if (![na isEqualToString:@""]) {
                [a addObject:na];
        }
    }
        NSMutableArray *pagesArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < a.count; i ++) {
            IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:[NSString stringWithFormat:@"%@",a[i]]];
            [pagesArr addObject:model1];
        }
    UIImageView *tapImg=(UIImageView *)[tap view];
        _intro = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:pagesArr];
      //  _intro.delegate=self;
    [_intro index:tapImg.tag];
        self.tabBarController.tabBar.hidden=YES;
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_intro];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource[0][@"comments"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    XiangQingTableViewCell *cell=(XiangQingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (![_dataSource[0][@"comments"][indexPath.row][@"avatar"] isKindOfClass:[NSNull class]]) {
         [cell.HeaderImage setImageWithURL:[NSURL URLWithString:_dataSource[0][@"comments"][indexPath.row][@"avatar"]] placeholderImage:[UIImage imageNamed:@"center_img"]];
    }else{
        [cell.HeaderImage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"center_img"]];
    }
    
    if (![_dataSource[0][@"comments"][indexPath.row][@"user_name"] isKindOfClass:[NSNull class]]) {
        cell.NameLabel.text=_dataSource[0][@"comments"][indexPath.row][@"user_name"];
    }else{
        cell.NameLabel.text=@"";
    }
    
    
    cell.ContentLabel.text=_dataSource[0][@"comments"][indexPath.row][@"content"];
    cell.DateLabel.text=_dataSource[0][@"comments"][indexPath.row][@"create_time"];
    cell.CaoZuoButton.hidden=YES;
    cell.indexPath=indexPath;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(60*self.scale, 0, self.view.width-70*self.scale, 35*self.scale)];
    la.numberOfLines=0;
    la.font=DefaultFont(self.scale);
    la.text=_dataSource[0][@"comments"][indexPath.row][@"content"];
    [la sizeToFit];
    
    
    return 70*self.scale+la.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  44*self.scale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    headerView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *kuang = [[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, headerView.height/2-10*self.scale, 20*self.scale, 20*self.scale)];
    kuang.image=[UIImage imageNamed:@"gg_pingjia"];
    [headerView addSubview:kuang];
    
    UILabel *pn = [[UILabel alloc]initWithFrame:CGRectMake(kuang.right+10*self.scale, kuang.top-2*self.scale, self.view.width-kuang.right, 20*self.scale)];
    pn.text=[NSString stringWithFormat:@"热门评论(%@)",_dataSource[0][@"comment_count"]];
    pn.textColor=grayTextColor;
    pn.font=DefaultFont(self.scale);
    [headerView addSubview:pn];
    return headerView;
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"公告详情";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
