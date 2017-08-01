//
//  FuWuOrderListViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FuWuOrderListViewController.h"
#import "FuWuOrderTableViewCell.h"
#import "PeiSongPopleViewController.h"
#import "CellView.h"
#import "FUWUCell.h"
#import "FuWuOrderInfoViewController.h"
#import "RCDChatViewController.h"
#import "RCDChatListViewController.h"
#import "CXAlertView.h"
@interface FuWuOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,FuWuOrderTableViewCellDelegate,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UIView *heardView;
@property(nonatomic,strong)NSString *Key;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UIButton *SelectedButton;
@property(nonatomic,strong)CellView *ToolView;
@end

@implementation FuWuOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Key=@"";
    _dataSource=[NSMutableArray new];
    [self returnVi];
    [self topVi];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self MoreList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
  //   [self ReshMessage];
}
-(void)MoreList{
    _index=0;
    [self ReshData];
}
-(void)orderCount{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[AnalyzeObject new];
    [analy ShopOrderOrderCountWithUser_id:[Stockpile sharedStockpile].ID Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"] && [models isKindOfClass:[NSDictionary class]]) {
            [self ReshView:models];
        }
    }];
}
-(void)ReshView:(NSDictionary *)dic{
    NSInteger notCheckedCount=[[dic objectForKey:@"notCheckedCount"] integerValue];
    UILabel *Label=(UILabel *)[self.view viewWithTag:500];
    Label.hidden=notCheckedCount<1;
    Label.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"notCheckedCount"]] EmptyStringByWhitespace];
    
    NSInteger waitForDeliveryCount=[[dic objectForKey:@"waitForDeliveryCount"] integerValue];
    UILabel *Label_1=(UILabel *)[self.view viewWithTag:501];
    Label_1.hidden=waitForDeliveryCount<1;
    Label_1.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"waitForDeliveryCount"]] EmptyStringByWhitespace];
    
    NSInteger deliveriedCount=[[dic objectForKey:@"deliveriedCount"] integerValue];
    UILabel *Label_2=(UILabel *)[self.view viewWithTag:502];
    Label_2.hidden=deliveriedCount<1;
    Label_2.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"deliveriedCount"]] EmptyStringByWhitespace];
}
-(void)ReshData{
      _index++;
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy OrderListWithUser_ID:[Stockpile sharedStockpile].ID Status:[NSString stringWithFormat:@"%ld",(long)_SelectedButton.tag+1] Pindex:[NSNumber numberWithInteger:_index] Keyword:_Key Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [_tableView.footer endRefreshing];
        [_tableView.header endRefreshing];
        NSArray *Arr=models;
        if (_index==1) {
            _tableView.footer.hidden=NO;
            [_dataSource removeAllObjects];
            [self orderCount];
        }
        if ([code isEqualToString:@"0"] && Arr && Arr.count>0) {
            [_dataSource addObjectsFromArray:Arr];
        }
        if (!Arr || Arr.count<FenYe || !models || [code isEqualToString:@"1"]) {
            _tableView.footer.hidden=YES;
        }
        //[self orderCount];
        [_tableView  reloadData];
    }];
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _heardView.bottom, self.view.width, self.view.height-_heardView.bottom) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView registerClass:[FuWuOrderTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(ReshData)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(MoreList)];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.section];
    
        FuWuOrderTableViewCell *PCell=(FuWuOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [PCell.HeaderImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"buyer_avatar"]]] placeholderImage:[UIImage imageNamed:@"not_1"]];
        PCell.NameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"buyer_nick_name"]];
        PCell.SHRLabel.contentLabel.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"delivery_to_name"]] EmptyStringByWhitespace];
    PCell.TelLabel.contentLabel.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"delivery_to_mobile"]] EmptyStringByWhitespace];
    PCell.delegate=self;
     PCell.inexPath=indexPath;
        PCell.ADLabel.contentLabel.text=[[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"delivery_address_name"],[dic objectForKey:@"delivery_house_number"]] EmptyStringByWhitespace];
    NSString *Items=@"";
    NSArray *Arr=[dic objectForKey:@"products"];
    for (NSDictionary *dic in Arr) {
        Items=[NSString stringWithFormat:@"%@、%@",Items,[dic objectForKey:@"item_name"]];
    }
    if(Items.length>0){
        Items=[Items substringFromIndex:1];
    }
    PCell.Items=[[NSString stringWithFormat:@"%@",Items] EmptyStringByWhitespace];
    PCell.TimeLabel.contentLabel.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"send_time"]] EmptyStringByWhitespace];
    PCell.MarkLabel.contentLabel.text=[[NSString stringWithFormat:@"%@",[dic objectForKey:@"memo"]] EmptyStringByWhitespace];
    PCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return PCell;
  }
-(void)FindFuWuOrderPresonSendMsg:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.section];
    RCDChatViewController *chatService=[[RCDChatViewController alloc]init];
    //chatService.userName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyer_nick_name"]];
    chatService.targetId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyer_user_id"]];;
    chatService.conversationType = ConversationType_PRIVATE;//ConversationType_PRIVATE
    chatService.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"buyer_nick_name"]];
    [self.navigationController pushViewController:chatService animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      NSDictionary *dic = [_dataSource objectAtIndex:indexPath.section];
    NSString *Items=@"";
    NSArray *Arr=[dic objectForKey:@"products"];
    for (NSDictionary *dic in Arr) {
        Items=[NSString stringWithFormat:@"%@、%@",Items,[dic objectForKey:@"item_name"]];
    }
    if(Items.length>0){
        Items=[Items substringFromIndex:1];
    }
    FUWUCell *cell=[[FUWUCell alloc]init];
    cell.frame=CGRectMake(0, 0, self.view.width, 20*self.scale);
    cell.content=[[NSString stringWithFormat:@"%@",Items] EmptyStringByWhitespace];
    
   return 150*self.scale+cell.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *HBView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50*self.scale)];
    NSDictionary *dic =[_dataSource objectAtIndex:section];
    NSInteger Status=[[dic objectForKey:@"status"] integerValue];
    HBView.backgroundColor=superBackgroundColor;
    CellView *HView=[[CellView alloc]initWithFrame:CGRectMake(0, 10*self.scale, self.view.width, 40*self.scale)];
    HView.topline.hidden=NO;
    HView.titleLabel.text=[NSString stringWithFormat:@"订单号：%@",[dic  objectForKey:@"sub_order_no"]];
    [HView.titleLabel sizeToFit];
    HView.titleLabel.centerY=HView.height/2;
    switch (Status) {
        case 1:
            HView.contentLabel.text=@"未付款";
            HView.contentLabel.textColor=[UIColor redColor];
            break;
        case 2:
            HView.contentLabel.text=@"待接单";
            HView.contentLabel.textColor=[UIColor redColor];
            break;
        case 3:
            HView.contentLabel.text=@"待发货";
            HView.contentLabel.textColor=[UIColor redColor];
            break;
        case 4:
            HView.contentLabel.text=@"已发货";
            HView.contentLabel.textColor=[UIColor redColor];
            break;
        case 5:
            HView.contentLabel.text=@"已完成";
            HView.contentLabel.textColor=[UIColor redColor];
            break;
        case 6:
            HView.contentLabel.text=@"已取消";
             HView.contentLabel.textColor=[UIColor redColor];
           // HView.contentLabel.textColor=grayTextColor;
            break;
            
        default:
            break;
    }
    HView.contentLabel.textAlignment=NSTextAlignmentRight;
    [HBView addSubview:HView];
    return HBView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*self.scale;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSDictionary *dic =[_dataSource objectAtIndex:section];
    NSInteger Sam=0;
    NSArray *Arr=[dic objectForKey:@"products"];
    for (NSDictionary *P in Arr) {
        Sam+=[[P objectForKey:@"prod_count"] integerValue];
    }
    CellView *FView=[[CellView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40*self.scale)];
    NSInteger Status=[[dic objectForKey:@"status"] integerValue];
    FView.contentLabel.textAlignment=NSTextAlignmentRight;
    NSString *Model=[NSString stringWithFormat:@"%@",[dic objectForKey:@"delivery_mode"]];
    if (Status == 3 && ![Model isEmptyString]) {
        FView.contentLabel.text=@"正在处理中";
    }else{
        FView.contentLabel.text=@"";
        [self newFooterView:FView viewForFooterInSection:section Sattus:Status];
    }
    
    [FView.titleLabel sizeToFit];
    return FView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dic =[_dataSource objectAtIndex:indexPath.section];
  FuWuOrderInfoViewController *infoVC=[[FuWuOrderInfoViewController alloc]init];
   infoVC.ID=[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]];
    [self.navigationController pushViewController:infoVC animated:YES];
}
-(void)newFooterView:(CellView *)cell viewForFooterInSection:(NSInteger)section Sattus:(NSInteger)status{
    
    switch (status) {
        case 2:
        {
            /* UIButton *DelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-65*self.scale, cell.height/2-12*self.scale, 55*self.scale, 24*self.scale)];
             [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
             [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
             [DelButton setTitle:@"取消" forState:UIControlStateNormal];
             [DelButton setTitleColor:grayTextColor forState:UIControlStateNormal];
             DelButton.tag=section;
             DelButton.titleLabel.font=SmallFont(self.scale);
             [cell addSubview:DelButton];*/
            
            UIButton *JieDanButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-65*self.scale, cell.height/2-12*self.scale, 55*self.scale, 24*self.scale)];
            [JieDanButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [JieDanButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [JieDanButton setTitle:@"接单" forState:UIControlStateNormal];
            JieDanButton.tag=section;
            JieDanButton.titleLabel.font=SmallFont(self.scale);
            [JieDanButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            // [JieDanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [JieDanButton addTarget:self action:@selector(JieDanButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:JieDanButton];
        }
            break;
        case 3:
        {
            
           /* UIButton *DelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-75*self.scale, cell.height/2-12*self.scale, 65*self.scale, 24*self.scale)];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [DelButton setTitle:@"第三方配送" forState:UIControlStateNormal];
            DelButton.tag=section;
            DelButton.titleLabel.font=SmallFont(self.scale);
            [DelButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            [DelButton addTarget:self action:@selector(DiSanFangFaHuoEvent:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:DelButton];*/
            
           // UIButton *JieDanButton=[[UIButton alloc]initWithFrame:CGRectMake(DelButton.left-75*self.scale, cell.height/2-12*self.scale, 65*self.scale, 24*self.scale)];
            UIButton *JieDanButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-75*self.scale, cell.height/2-12*self.scale, 65*self.scale, 24*self.scale)];
            [JieDanButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [JieDanButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [JieDanButton setTitle:@"立即配送" forState:UIControlStateNormal];
            JieDanButton.tag=section;
            [JieDanButton addTarget:self action:@selector(FaHuoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            JieDanButton.titleLabel.font=SmallFont(self.scale);
            [JieDanButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            [cell addSubview:JieDanButton];
        }
            break;
        case 4:
        {
            UIButton *DelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, cell.height/2-12*self.scale, 60*self.scale, 24*self.scale)];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [DelButton setTitle:@"已完成" forState:UIControlStateNormal];
            [DelButton addTarget:self action:@selector(WanChengButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            DelButton.tag=section;
            DelButton.titleLabel.font=SmallFont(self.scale);
            [DelButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            [cell addSubview:DelButton];
        }
            break;
        case 5:
        {
            UIButton *DelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, cell.height/2-12*self.scale, 60*self.scale, 24*self.scale)];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [DelButton setTitle:@"删除" forState:UIControlStateNormal];
            [DelButton addTarget:self action:@selector(DeletaButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            DelButton.tag=section;
            DelButton.titleLabel.font=SmallFont(self.scale);
            [DelButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            [cell addSubview:DelButton];
        }
            break;
        case 6:
        {
            UIButton *DelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-70*self.scale, cell.height/2-12*self.scale, 60*self.scale, 24*self.scale)];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn"] forState:UIControlStateNormal];
            [DelButton setBackgroundImage:[UIImage setImgNameBianShen:@"center_dd_btn_b"] forState:UIControlStateHighlighted];
            [DelButton setTitle:@"删除" forState:UIControlStateNormal];
            [DelButton addTarget:self action:@selector(DeletaButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            DelButton.tag=section;
            DelButton.titleLabel.font=SmallFont(self.scale);
            [DelButton setTitleColor:grayTextColor forState:UIControlStateNormal];
            [cell addSubview:DelButton];
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
    }else
    {
        UILabel *label=(UILabel *)[self.view viewWithTag:12];
        label.hidden=NO;
    }
    NSString * name =[textView.text trimString];
    if (name.length>100) {
        textView.text=[name substringToIndex:100];
    }
}

-(void) orderReceiving:(UIButton *)button WithTextView:(UITextView *) Text andDeliveryID:(NSString*) deliveryid{
    NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy AcceptOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] msg:[Text.text trimString] DeliveryID:deliveryid Block:^(id models, NSString *code, NSString *msg) {
        NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
        NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];
        [Info setObject:[[NSString stringWithFormat:@"%@",[models objectForKey:@"msg"]] EmptyStringByWhitespace] forKey:@"order_msg"];
        [model setObject:Info forKey:@"shop_info"];
        [[Stockpile  sharedStockpile]setModel:model];
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        [self MoreList];
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


#pragma mark - 订单操作
-(void)JieDanButtonEvent:(UIButton *)button{
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

    
    
   /* NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy AcceptOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        _index=0;
        [self MoreList];
    }];*/
    
}
-(void)CancelJieDanButtonEvent:(UIButton *)button{
    
}
-(void)FaHuoButtonEvent:(UIButton *)button{
    self.hidesBottomBarWhenPushed=YES;
    PeiSongPopleViewController *peiSongVc=[[PeiSongPopleViewController alloc]initWithBlock:^(NSDictionary *preson) {
        NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
        [self.activityVC startAnimating];
        AnalyzeObject *analy=[[AnalyzeObject alloc]init];
        [analy SelectStarffWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] Starff_id:[NSString stringWithFormat:@"%@",[preson  objectForKey:@"id"]] Block:^(id models, NSString *code, NSString *msg) {
            [self.activityVC stopAnimating];
            [self ShowAlertWithMessage:msg];
            _index=0;
            [self MoreList];
        }];
    }];
    [self.navigationController pushViewController:peiSongVc animated:YES];
    
}
-(void)DiSanFangFaHuoEvent:(UIButton *)button{
    NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy SelectPubStarffWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        _index=0;
        [self MoreList];
    }];
}
-(void)WanChengButtonEvent:(UIButton *)button{
    NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy FinishOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        [self ShowAlertWithMessage:msg];
        _index=0;
        [self MoreList];
    }];
    
}
-(void)DeletaButtonEvent:(UIButton *)button{
    
    [self ShowAlertTitle:@"提示" Message:@"您确定要删除该订单吗？" Delegate:self Block:^(NSInteger index) {
        if (index == 1) {
            NSDictionary *dic =[_dataSource objectAtIndex:button.tag];
            [self.activityVC startAnimating];
            AnalyzeObject *analy=[[AnalyzeObject alloc]init];
            [analy DelOrderWithUser_ID:[Stockpile sharedStockpile].ID Order_no:[NSString stringWithFormat:@"%@",[dic  objectForKey:@"sub_order_no"]] Block:^(id models, NSString *code, NSString *msg) {
                [self.activityVC stopAnimating];
                [self ShowAlertWithMessage:msg];
                _index=0;
                [self MoreList];
            }];
        }
        
    }];
}
#pragma mark---顶部搜索框  和未付款 新订单  代发货  已发货  已完成 已取消
-(void)topVi{
    _heardView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 164*self.scale)];
    _heardView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_heardView];
    
    UIImageView *SearchBG=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10, self.view.width-20*self.scale, 32*self.scale)];
    SearchBG.image=[UIImage setImgNameBianShen:@"gg_pingjia_box"];
    SearchBG.userInteractionEnabled=YES;
    [_heardView addSubview:SearchBG];
    
    UIImageView *IconImage=[[UIImageView alloc]initWithFrame:CGRectMake(SearchBG.width-SearchBG.height, 0, SearchBG.height, SearchBG.height)];
    IconImage.image=[UIImage imageNamed:@"search"];
    [SearchBG addSubview:IconImage];
    UITextField *searchText=[[UITextField alloc]initWithFrame:CGRectMake(8*self.scale, 0, SearchBG.width-IconImage.height-5*self.scale , SearchBG.height)];
    searchText.font=DefaultFont(self.scale);
    searchText.placeholder=@"请输入关键字";
    searchText.delegate=self;
    [SearchBG addSubview:searchText];
    
    NSArray *arr = @[@"新订单",@"待发货",@"已发货",@"已完成",@"已取消"];
    _ToolView= [[CellView alloc]initWithFrame:CGRectMake(0,SearchBG.bottom+10*self.scale, self.view.width, 40*self.scale)];
    _ToolView.backgroundColor = [UIColor whiteColor];
    _ToolView.topline.hidden=NO;
    [_heardView addSubview:_ToolView];
    
    for (int i=0; i<arr.count; i++) {
        UIButton *daiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [daiBtn setTitle:arr[i] forState:UIControlStateNormal];
        [daiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        daiBtn.titleLabel.font = DefaultFont(self.scale);
        if (_isPush) {
            daiBtn.selected=(i==1);
        }
        else{
            daiBtn.selected=(i==0);
        }
        
        daiBtn.tag=1+i;
        if (daiBtn.selected) {
            _SelectedButton=daiBtn;
        }
        [daiBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        daiBtn.frame = CGRectMake(i*self.view.width/arr.count, 0, self.view.width/arr.count, _ToolView.height);
        
        [daiBtn addTarget:self action:@selector(DaiButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *SumLabel=[[UILabel alloc]initWithFrame:CGRectMake(daiBtn.width-16*self.scale, 3*self.scale, 14*self.scale, 14*self.scale)];
        SumLabel.layer.masksToBounds=YES;
        SumLabel.layer.cornerRadius=SumLabel.height/2;
        SumLabel.textAlignment=NSTextAlignmentCenter;
        SumLabel.backgroundColor=[UIColor redColor];
        SumLabel.textColor=[UIColor whiteColor];
        SumLabel.tag = 500+i;
        SumLabel.font=Small10Font(self.scale);
        SumLabel.hidden=YES;
       // SumLabel.text=@"10";
        [daiBtn addSubview:SumLabel];
        [_ToolView addSubview:daiBtn];
        if (i!=3) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(daiBtn.right,_ToolView.height/4, .5, _ToolView.height/2)];
            line.backgroundColor = blackLineColore;
            [_ToolView addSubview:line];
        }
    }
    float W=self.view.width/5;
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake((_SelectedButton.tag-1)*W, _ToolView.height-1, W, 1)];
    line.backgroundColor=[UIColor redColor];
    line.tag=666;
    [_ToolView addSubview:line];
    _heardView.height=_ToolView.bottom;
}

-(void)DaiButtonEvent:(UIButton *)button{
    [self.view endEditing:YES];
    if (_SelectedButton) {
        _SelectedButton.selected=NO;
    }
    if (_SelectedButton !=button) {
        _SelectedButton=button;
        _index=0;
        [self MoreList];
    }
    
    _SelectedButton.selected=YES;
    
    [UIView animateWithDuration:.3 animations:^{
        UIView *line=[self.view viewWithTag:666];
        line.frame=CGRectMake((button.tag-1)*line.width, line.top, line.width, line.height);
        
    }];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _Key=textField.text;
    _index=0;
    [self MoreList];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark-----通用头；；；

-(void)goDingDanXingQing:(UIButton *)sender{
    self.hidesBottomBarWhenPushed=YES;
}

-(void)quxiaoEvent:(UIButton *)sender{
    
}


#pragma mark -----返回按钮
-(void)returnVi{
    
    self.TitleLabel.text=@"订单管理";
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    /*UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-50*self.scale, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [saveBtn setTitle:@"发布" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = BigFont(self.scale);
    [saveBtn addTarget:self action:@selector(saveBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:saveBtn];*/
    
  /*  UIButton *talkImg = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [talkImg addSubview:CarNum];*/
    
}
/*-(void)ChatBtnVC:(id)sender{
    self.hidesBottomBarWhenPushed=YES;
    RCDChatListViewController *hisVC=[[RCDChatListViewController alloc]init];
    [self.navigationController pushViewController:hisVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
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
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ReshMessage];
    });
    
}
*/
#pragma mark ------返回按钮方法
-(void)PopVC:(UIButton *)sender{
    if (_isPush) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}
-(void)saveBtnEvent:(UIButton *)sender{
    
    
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
