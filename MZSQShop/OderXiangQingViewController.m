//
//  OderXiangQingViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/9/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OderXiangQingViewController.h"
#import "CellView.h"
#import "GoodsDingDanTableViewCell.h"
#import "RCDChatViewController.h"
#import "PeiSongPopleViewController.h"
#import "CXAlertView.h"
@interface OderXiangQingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSDictionary *infoDic;
@property(nonatomic,strong)CellView *bottomView;
@end

@implementation OderXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self xiangQing];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

-(void)newAdDetail{
    UIView *HeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 55*self.scale)];
    UIImageView*CDImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 5*self.scale)];
    CDImage.image=[UIImage imageNamed:@"dd_line"];
    [HeaderView addSubview:CDImage];
    CellView *nameCell=[[CellView alloc]initWithFrame:CGRectMake(0, CDImage.bottom, self.view.width, 25*self.scale)];
    nameCell.titleLabel.text=@"联系人：";
    [nameCell.titleLabel sizeToFit];
    nameCell.titleLabel.centerY=nameCell.height/2;
    nameCell.content=[[NSString stringWithFormat:@"%@    %@",[_infoDic objectForKey:@"delivery_to_name"],[_infoDic objectForKey:@"delivery_to_mobile"]] EmptyStringByWhitespace];
    nameCell.contentLabel.numberOfLines=1;
    nameCell.bottomline.hidden=YES;
    [HeaderView addSubview:nameCell];
    CellView*AdCell=[[CellView alloc]initWithFrame:CGRectMake(0, nameCell.bottom, self.view.width, 25*self.scale)];
    AdCell.titleLabel.text=@"收货地址：";
    AdCell.titleLabel.size=CGSizeMake(70*self.scale, AdCell.titleLabel.height);
    AdCell.titleLabel.centerY=AdCell.height/2;
    AdCell.content=[[NSString stringWithFormat:@"%@%@",[_infoDic objectForKey:@"delivery_address_name"],[_infoDic objectForKey:@"delivery_house_number"]] EmptyStringByWhitespace];
    [HeaderView addSubview:AdCell];
    HeaderView.height=AdCell.bottom;
    _tableView.tableHeaderView=HeaderView;
}

-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy OrderDetailWithUser_ID:[Stockpile sharedStockpile].ID Order_no:_ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        NSLog(@"detail==%@",models);
        //  [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            _infoDic=[models mutableCopy];
            NSArray * Arr=[_infoDic objectForKey:@"products"];
            if (Arr) {
                [_dataSource addObjectsFromArray:Arr];
            }
            [self newAdDetail];
            [_tableView reloadData];
            [self newFooterView];
            [self BottomView];
        }
    }];
}
-(void)xiangQing{
    
    _dataSource=[NSMutableArray new];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom) ];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[GoodsDingDanTableViewCell class] forCellReuseIdentifier:@"RCell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    _bottomView=[[CellView alloc]initWithFrame:CGRectMake(0, self.view.height-40*self.scale, self.view.width, 40*self.scale)];
    _bottomView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_bottomView];
}


#pragma mark - FooterView
-(void)newFooterView{
    UIView *FooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    FooterView.backgroundColor=[UIColor clearColor];
    CellView *SumCell=[[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    SumCell.contentLabel.textAlignment=NSTextAlignmentRight;
    SumCell.contentLabel.textColor=[UIColor redColor];
    SumCell.contentLabel.text=[NSString stringWithFormat:@"合计：￥%.2f", [[_infoDic objectForKey:@"sub_amount"] doubleValue]];//+[[_infoDic objectForKey:@"delivery_fee"] doubleValue]
   
    [FooterView addSubview:SumCell];
    CellView *TimeCell=[[CellView alloc]initWithFrame:CGRectMake(0, SumCell.bottom, self.view.width, 40*self.scale)];
    TimeCell.contentLabel.textAlignment=NSTextAlignmentRight;
    TimeCell.titleLabel.text=@"配送时间";
    TimeCell.contentLabel.text=[NSString stringWithFormat:@"%@",_infoDic[@"send_time"]];
    TimeCell.contentLabel.textColor=grayTextColor;
    [FooterView addSubview:TimeCell];
    CellView *MarkCell=[[CellView alloc]initWithFrame:CGRectMake(0, TimeCell.bottom, self.view.width, 40*self.scale)];
    MarkCell.titleLabel.text=@"备注";
    MarkCell.titleLabel.textColor=[UIColor redColor];
    MarkCell.content=[NSString stringWithFormat:@"%@",_infoDic[@"memo"]];
    MarkCell.contentLabel.textColor=grayTextColor;
    [FooterView addSubview:MarkCell];
    
    CellView *OrderCell=[[CellView alloc]initWithFrame:CGRectMake(0, MarkCell.bottom+10*self.scale, self.view.width, 40*self.scale)];
    OrderCell.titleLabel.text=@"订单信息";
    OrderCell.topline.hidden=NO;
    OrderCell.shotLine=YES;
    OrderCell.titleLabel.textColor=grayTextColor;
    //  OrderCell.bottomline.frame=CGRectMake(10*self.scale, OrderCell.height-.5, self.view.width-20*self.scale, .5);
    [FooterView addSubview:OrderCell];
    NSString *Str=@"";
    switch ([_infoDic[@"pay_type"] integerValue]) {
        case 1:
            Str=@"支付宝支付";
            break;
        case 2:
            Str=@"微信支付";
            break;
        case 3:
            Str=@"货到付款";
            break;
        default:
            break;
    }
    NSArray *Arr=@[@"订单编号：",@"下单时间：",@"支付方式：",@"配送员：",@"配送电话："];
   NSArray *ValArr=@[[NSString stringWithFormat:@"%@",_infoDic[@"sub_order_no"]],[NSString stringWithFormat:@"%@",_infoDic[@"order_create_time"]],Str,[NSString stringWithFormat:@"%@ ",_infoDic[@"delivery_name"]],[NSString stringWithFormat:@"%@",_infoDic[@"delivery_mobile"]]];
   float  SetY=OrderCell.bottom;
    for(int i=0;i<Arr.count;i++){
        CellView *cell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 25*self.scale)];
        cell.titleLabel.text=Arr[i];
        cell.titleLabel.textColor=grayTextColor;
        cell.bottomline.hidden=YES;
        cell.content=ValArr[i];
        cell.contentLabel.textColor=grayTextColor;
        if (i== Arr.count-1) {
            cell.contentLabel.userInteractionEnabled=YES;

            UIButton *TelBtn=[[UIButton alloc]initWithFrame:CGRectMake(cell.width/2+15*self.scale,0, 25*self.scale, 25*self.scale)];
            [TelBtn setImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
            [TelBtn addTarget:self action:@selector(TelPeiSong:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:TelBtn];
            
            NSString *tel=[[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_starff_mobile"]] EmptyStringByWhitespace];
            TelBtn.hidden=tel.length<=0;
            
            if ([[_infoDic objectForKey:@"delivery_mode"] integerValue] ==2) {
                UIButton *MsgBtn=[[UIButton alloc]initWithFrame:CGRectMake(TelBtn.right+5*self.scale,0, 25*self.scale, 25*self.scale)];
                [MsgBtn setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
                [MsgBtn addTarget:self action:@selector(TelPeiEvent:) forControlEvents:UIControlEventTouchUpInside];
                  [cell addSubview:MsgBtn];
            }
           // UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TelPeiSong:)];
          //  [cell.contentLabel addGestureRecognizer:tap];
        }
        [FooterView addSubview:cell];
        SetY=cell.bottom;
    }
    CellView *cell=[[CellView alloc]initWithFrame:CGRectMake(0, SetY, self.view.width, 8*self.scale)];
     [FooterView addSubview:cell];
     SetY=cell.bottom;
    FooterView.height=SetY+15*self.scale;
    [_tableView setTableFooterView:FooterView];
    
    
}
-(void)TelPeiEvent:(id)sender{
    RCDChatViewController *chatService=[[RCDChatViewController alloc]init];
    //chatService.userName = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_nick_name"]];
    chatService.targetId = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_starff"]];;
    chatService.conversationType = ConversationType_PRIVATE;//ConversationType_PRIVATE
    chatService.title = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_starff_name"]];
    [self.navigationController pushViewController:chatService animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *Pro=[_dataSource objectAtIndex:indexPath.row];
    GoodsDingDanTableViewCell *RCell=(GoodsDingDanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RCell" forIndexPath:indexPath];
    NSString *IM=[NSString stringWithFormat:@"%@",[Pro objectForKey:@"img1"]];

    [RCell.HeaderImg setImageWithURL:[NSURL URLWithString:[IM EmptyStringByWhitespace]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    RCell.NameLabel.text=[[NSString stringWithFormat:@"%@",[Pro objectForKey:@"prod_name"]] EmptyStringByWhitespace];
    RCell.ContentLabel.text=[[NSString stringWithFormat:@"%@",[Pro objectForKey:@"description"]] EmptyStringByWhitespace];
    RCell.PriceLabel.text=[[NSString stringWithFormat:@"￥%@",[Pro objectForKey:@"price"]] EmptyStringByWhitespace];
    RCell.NumLabel.text=[[NSString stringWithFormat:@"x%@",[Pro objectForKey:@"prod_count"]] EmptyStringByWhitespace];
    RCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return RCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CellView *PresonCell=[[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44*self.scale)];
    if (!_infoDic) {
        PresonCell.backgroundColor=[UIColor clearColor];
        PresonCell.bottomline.hidden=YES;
        return nil;
    }
    NSInteger Status=[[_infoDic objectForKey:@"status"] integerValue];
    switch (Status) {
        case 1:
            PresonCell.contentLabel.text=@"未付款";
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
        case 2:
            PresonCell.contentLabel.text=@"待接单";
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
        case 3:
            PresonCell.contentLabel.text=@"待发货";
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
        case 4:
            PresonCell.contentLabel.text=@"已发货";
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
        case 5:
            PresonCell.contentLabel.text=@"已完成";
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
        case 6:
            PresonCell.contentLabel.text=@"已取消";
           // PresonCell.contentLabel.textColor=grayTextColor;
            PresonCell.contentLabel.textColor=[UIColor redColor];
            break;
            
        default:
            break;
    }
    PresonCell.contentLabel.textAlignment=NSTextAlignmentRight;
    PresonCell.topline.hidden=NO;
    PresonCell.bottomline.hidden=NO;
    UIImageView *HeaderImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, PresonCell.height-10*self.scale, PresonCell.height-10*self.scale)];
    [HeaderImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_avatar"]]] placeholderImage:[UIImage imageNamed:@"not_1"]];
    HeaderImg.layer.masksToBounds=YES;
    HeaderImg.layer.cornerRadius=HeaderImg.height/2;
    [PresonCell addSubview:HeaderImg];
    
    UILabel *NameLabel=[[UILabel alloc]init];
    NameLabel.font=DefaultFont(self.scale);
    NameLabel.text=[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_nick_name"]];
    NameLabel.frame=CGRectMake(HeaderImg.right+5*self.scale, HeaderImg.top, [self Text:NameLabel.text Size:CGSizeMake(self.view.width/2, HeaderImg.height) Font:NameLabel.font].width, HeaderImg.height);
    
    [PresonCell addSubview:NameLabel];
    
    UIButton *MsgBtn=[[UIButton alloc]initWithFrame:CGRectMake(NameLabel.right+5*self.scale, NameLabel.centerY-12*self.scale, 24*self.scale, 24*self.scale)];
    [MsgBtn setImage:[UIImage imageNamed:@"ganxi_ico_01"] forState:UIControlStateNormal];
    [MsgBtn addTarget:self action:@selector(MsgButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [PresonCell addSubview:MsgBtn];
    
    UIButton *TelBtn=[[UIButton alloc]initWithFrame:CGRectMake(MsgBtn.right+5*self.scale, NameLabel.centerY-12*self.scale, 24*self.scale, 24*self.scale)];
    [TelBtn setImage:[UIImage imageNamed:@"ganxi_ico_02"] forState:UIControlStateNormal];
    [TelBtn addTarget:self action:@selector(TelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [PresonCell addSubview:TelBtn];
    return PresonCell;
}
-(void)MsgButtonEvent:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    RCDChatViewController *chatService=[[RCDChatViewController alloc]init];
   // chatService.userName = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_nick_name"]];
    chatService.targetId = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_user_id"]];;
    chatService.conversationType = ConversationType_PRIVATE;//ConversationType_PRIVATE
    chatService.title = [NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"buyer_nick_name"]];
    [self.navigationController pushViewController:chatService animated:YES];
}
-(void)TelButtonEvent:(id)sender{
    NSString *tel=[[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_to_mobile"]] EmptyStringByWhitespace];
    if ([[tel trimString] isEmptyString]) {
        return;
    }
    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",tel];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)TelPeiSong:(UIButton *)tap{
     NSString *tel=[[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_starff_mobile"]] EmptyStringByWhitespace];
    if ([[tel trimString] isEmptyString]) {
        return;
    }
    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",tel];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)BottomView{
    if (!_infoDic) {
        return;
    }
    NSString *Model=[[NSString stringWithFormat:@"%@",[_infoDic objectForKey:@"delivery_mode"]] EmptyStringByWhitespace];
      NSInteger state=[[_infoDic objectForKey:@"status"] integerValue];
    if (state == 3 &&( ![Model isEmptyString] || [Model isEqualToString:@"0"]) ){
        return;
    }
  
    switch (state) {
        case 2:
        {
            _tableView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale);
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
            [button setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [button setTitle:@"接单" forState:UIControlStateNormal];
            button.titleLabel.font=BigFont(self.scale);
            [button addTarget:self action:@selector(QueRenOrderEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
        }
            break;
        case 3:
        {
           /*  _tableView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale);
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width/2, 40*self.scale)];
            [button setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [button setTitle:@"立即配送" forState:UIControlStateNormal];
            button.titleLabel.font=BigFont(self.scale);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(PingJiaDingDanEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
            
            UIButton *ToSuButton=[[UIButton alloc]initWithFrame:CGRectMake(button.right, 0, self.view.width/2, 40*self.scale)];
            // [ToSuButton setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [ToSuButton setTitle:@"第三方配送" forState:UIControlStateNormal];
            ToSuButton.titleLabel.font=BigFont(self.scale);
            [ToSuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [ToSuButton addTarget:self action:@selector(TouSuMaiJiaEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:ToSuButton];*/
        }
            break;
        case 4:
        {
            _tableView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale);
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
            [button setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [button setTitle:@"已完成" forState:UIControlStateNormal];
            button.titleLabel.font=BigFont(self.scale);
            [button addTarget:self action:@selector(WanChengButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
        }
            break;
        case 5:
        {
            _tableView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale);
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
            [button setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [button setTitle:@"删除" forState:UIControlStateNormal];
            button.titleLabel.font=BigFont(self.scale);
            [button addTarget:self action:@selector(DelOrderEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
        }
            break;
        case 6:
        {
            _tableView.frame=CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom-40*self.scale);
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
            [button setBackgroundImage:[UIImage setImgNameBianShen:@"huoqu_btn"] forState:UIControlStateNormal];
            [button setTitle:@"删除" forState:UIControlStateNormal];
            button.titleLabel.font=BigFont(self.scale);
            [button addTarget:self action:@selector(DelOrderEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_bottomView addSubview:button];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=YES;
    }else{
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
    NSString * name =[textView.text trimString];
    if (name.length>100) {
        textView.text=[name substringToIndex:100];
    }
}

-(void)QueRenOrderEvent:(UIButton *)sender{
    NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
    NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
    UITextView *Text=[[UITextView alloc]initWithFrame:CGRectMake(5*self.scale,0, 270, 95*self.scale)];
    Text.delegate=self;
    Text.backgroundColor=[UIColor clearColor];
    Text.font=DefaultFont(1);
    Text.text=[[NSString stringWithFormat:@"%@",[Info objectForKey:@"order_msg"]] EmptyStringByWhitespace];
    if (Text.text.length<1) {
        Text.text=@"商家已经收到您的订单，正在紧张的处理中，请您耐心的等待！";
    }
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, .5)];
    line.backgroundColor=blackLineColore;
    
    UIView *Alert=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 95*self.scale)];
    [Alert addSubview:Text];
    [Alert addSubview:line];
    
    CXAlertView *alertView=[[CXAlertView alloc]initWithTitle:@"是否接单" contentView:Alert cancelButtonTitle:nil];
    [alertView addButtonWithTitle:@"取消" type:CXAlertViewButtonTypeCancel handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        [alertView dismiss];
        [self.view endEditing:YES];
    }];
    [alertView addButtonWithTitle:@"接单" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        [self.view endEditing:YES];
        [alertView dismiss];
        if (Text.text.length<1) {
            [self ShowAlertWithMessage:@"接单信息不能为空"];
            return ;
        }
        if(self.appdelegate.deliverymanArray.count==0){
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            NSDictionary *param=[[NSDictionary alloc] init];
            [analy deliverymanList:param Block:^(id models, NSString *code, NSString *msg) {
                NSArray* array=models;
                [self.appdelegate.deliverymanArray addObjectsFromArray:array];
                [self showActionSheet:button andTextView:Text];
            }];
        }else{
            [self showActionSheet:button andTextView:Text];
        }
    }];
    [alertView show];
}


-(void) orderReceiving:(UIButton *)button WithTextView:(UITextView *) Text andDeliveryID:(NSString*) deliveryid{
    NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
    [self.activityVC startAnimating];
    NSString* subOrderNo=[dic  objectForKey:@"sub_order_no"];
    if(_isPush)
        subOrderNo=_ID;
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy AcceptOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",subOrderNo] msg:[Text.text trimString] DeliveryID:deliveryid Block:^(id models, NSString *code, NSString *msg) {
        NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
        NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
        [Info setObject:[[NSString stringWithFormat:@"%@",[models objectForKey:@"msg"]] EmptyStringByWhitespace] forKey:@"order_msg"];
        [model setObject:Info forKey:@"shop_info"];
        [[Stockpile  sharedStockpile]setModel:model];
        
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];
    
}

-(void) showActionSheet:(UIButton *)button andTextView:(UITextView *) Text{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择配送员"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //取消:style:UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    for(int i=0;i<self.appdelegate.deliverymanArray.count;i++){
        NSDictionary* dic=self.appdelegate.deliverymanArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:dic[@"TrueName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"truename==%@",dic);
            [self orderReceiving:button WithTextView:Text andDeliveryID:dic[@"ID"]];
        }];
        [alertController addAction:action];
        
    }
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)PingJiaDingDanEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
    PeiSongPopleViewController *peiSongVc=[[PeiSongPopleViewController alloc]initWithBlock:^(NSDictionary *preson) {
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy SelectStarffWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[_infoDic  objectForKey:@"sub_order_no"]] Starff_id:[NSString stringWithFormat:@"%@",[preson  objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            if ([code isEqualToString:@"0"]) {
                [self PopVC:nil];
            }
        }];
    }];
    [self.navigationController pushViewController:peiSongVc animated:YES];
}
-(void)TouSuMaiJiaEvent:(UIButton *)sender{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy SelectPubStarffWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[_infoDic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }

    }];
}
-(void)WanChengButtonEvent:(id)sender{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy FinishOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[_infoDic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        if ([code isEqualToString:@"0"]) {
            [self PopVC:nil];
        }
    }];
}

-(void)DelOrderEvent:(id)sender{
    [self ShowAlertTitle:@"提示" Message:@"您确定要删除该订单吗？" Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            [self.activityVC startAnimating];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[_infoDic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimating];
                [self ShowAlertWithMessage:msg];
                if ([code isEqualToString:@"0"]) {
                    [self PopVC:nil];
                }
            }];
        }
        
    }];
}


#pragma mark -----导航
-(void)newNav{
    self.TitleLabel.text=@"订单详情";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_isPush) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
          [self.navigationController popViewControllerAnimated:YES];
    }
  
    
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
