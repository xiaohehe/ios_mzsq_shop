//
//  HuoQuDiTuZuoBiaoViewController.m
//  HuanBaoWeiShi
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "HuoQuDiTuZuoBiaoViewController.h"
#import <MapKit/MapKit.h>
#import "CLLocation+YCLocation.h"
#import "CCLocation.h"
#import "CellView.h"
@implementation QiTuPlace
@end
@interface HuoQuDiTuZuoBiaoViewController ()<MKMapViewDelegate>

@property(nonatomic,strong) MKMapView *mapView;

@property(nonatomic,strong) HuoQuDiTuZuoBiaoBlock block;

@property(nonatomic,strong)NSDictionary *Dic;
@property(nonatomic,strong)CellView *LocationCell;
@property(nonatomic,strong)UIImageView *centerImg;
@end

@implementation HuoQuDiTuZuoBiaoViewController

- (void)getZuoBiaoBlock:(HuoQuDiTuZuoBiaoBlock)block{

    _block = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
   /* UIAlertView *alt =  [[UIAlertView alloc] initWithTitle:@"长按选中您要发布的地址" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alt show];*/
    [self newMap];
}
- (void)newMap{
    
    
    
    _mapView = [[MKMapView alloc] init];
    _mapView.frame = CGRectMake(0, self.NavImg.bottom, self.view.width, (self.view.height - self.NavImg.bottom)/2);
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;//标准模式
    _mapView.showsUserLocation = YES;//显示自己
    [self.view addSubview:_mapView];
    
    _LocationCell=[[CellView alloc]initWithFrame:CGRectMake(0, _mapView.bottom, _mapView.width, 44*self.scale)];
    _LocationCell.titleLabel.width=self.view.width-20*self.scale;
    _LocationCell.topline.hidden=NO;
    _LocationCell.backgroundColor=[UIColor clearColor];
    _LocationCell.bottomline.hidden=YES;
    [self.view addSubview:_LocationCell];
    
    _centerImg=[[UIImageView alloc]initWithFrame:CGRectMake(_mapView.width/2-14, _mapView.height/2-28, 28, 28)];
    [_mapView addSubview:_centerImg];
    _centerImg.image=[UIImage imageNamed:@"map_annotation"];
    
    UIButton *LoginBtn=[[UIButton alloc]initWithFrame:CGRectMake(18*self.scale, _LocationCell.bottom, self.view.width-36*self.scale, 30*self.scale)];
    [LoginBtn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.6]] forState:UIControlStateNormal];
    //[LoginBtn setBackgroundImage:[UIImage setImgNameBianShen:@"btn_b"] forState:UIControlStateHighlighted];
    [LoginBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    [LoginBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    LoginBtn.titleLabel.font=BigFont(self.scale);
    LoginBtn.layer.cornerRadius=5;
    LoginBtn.layer.masksToBounds=YES;
    [LoginBtn addTarget:self action:@selector(LoginButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginBtn];
    
   /* UILabel *TiShiLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, 22*self.scale)];
    TiShiLabel.backgroundColor=[UIColor colorWithRed:225/255.0 green:148/255.0 blue:49/255.0 alpha:0.8];
    TiShiLabel.font=SmallFont(self.scale);
    TiShiLabel.text=@"长按获取您选中的经纬度";
    TiShiLabel.textAlignment=NSTextAlignmentCenter;
    TiShiLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:TiShiLabel];*/
    
    [_mapView removeAnnotations:_mapView.annotations];
    /*添加大头针*/
    NSMutableDictionary *model=[[Stockpile sharedStockpile].model mutableCopy];
    NSMutableDictionary *Info=[[model objectForKey:@"shop_info"] mutableCopy];

    QiTuPlace *myPlace=[[QiTuPlace alloc] init];
    myPlace.title=@"店铺位置";
    myPlace.subtitle=[NSString stringWithFormat:@"%@",[Info objectForKey:@"address"]];
    myPlace.coordinate=CLLocationCoordinate2DMake([[Info objectForKey:@"latitude"] floatValue], [[Info objectForKey:@"longitude"] floatValue]);
   //  _LocationCell.titleLabel.text=[NSString stringWithFormat:@"%@",[Info objectForKey:@"address"]];
    [_mapView addAnnotation:myPlace];
    
    
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.3;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    //给MKMapView加上长按事件
    [self.mapView addGestureRecognizer:lpress];//mapView是MKMapView的实例

    [self GetNowPoint:nil];
    
}
-(void)GetNowPoint:(id)sender{
    [[CCLocation sharedCCLocation] getLocation:^(CLLocationCoordinate2D locationCoordinate2D, NSString *country, NSString *city, NSString *place) {
        
        if ([place isEmptyString]) {
            place=@"";
        }
        

        
        _Dic= [[NSDictionary alloc] initWithObjectsAndKeys:
               [NSString stringWithFormat:@"%f",locationCoordinate2D.latitude],
               @"latitude",
               [NSString stringWithFormat:@"%f",locationCoordinate2D.longitude],
               @"longitude",place,@"address",
               nil];

            _LocationCell.titleLabel.text=place;

        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(locationCoordinate2D,1600 ,1600);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
    }];
}
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){  //这个状态判断很重要
        //坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        NSLog(@"%f",touchMapCoordinate.latitude);
        NSLog(@"%f",touchMapCoordinate.longitude);
        CLLocation *Location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
      CLLocation *Fir=Location  ;
        
       // Location = [Location locationMarsFromEarth];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:Fir completionHandler:^(NSArray* placemarks,NSError *error)
         {
             if (placemarks.count >0 )
             {
                 CLPlacemark * plmark = [placemarks objectAtIndex:0];
                 NSString *place=plmark.name;
                 if ([place isEmptyString]) {
                     place=@"";
                 }
                 _Dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%f",Location.coordinate.latitude],
                       @"latitude",
                       [NSString stringWithFormat:@"%f",Location.coordinate.longitude],
                       @"longitude",place,@"address",
                       nil];
                 
                 [_mapView removeAnnotations:_mapView.annotations];
                 /*添加大头针*/
                 QiTuPlace *myPlace=[[QiTuPlace alloc] init];
                 myPlace.title=@"店铺位置";
                 myPlace.subtitle=place;
                 myPlace.coordinate=touchMapCoordinate;
                 _LocationCell.titleLabel.text=place;
                 [_mapView addAnnotation:myPlace];
                 
             }
             
             
         }];
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    CLLocation *Location = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLLocation *Fir=Location;
    
    Location = [Location locationBaiduFromMars];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:Fir completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0 )
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSString *place=plmark.name;
             if ([place isEmptyString]) {
                 place=@"";
             }
         /*   _Dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSString stringWithFormat:@"%f",Location.coordinate.latitude],
                   @"latitude",
                   [NSString stringWithFormat:@"%f",Location.coordinate.longitude],
                   @"longitude",place,@"address",
                   nil];*/
              _LocationCell.titleLabel.text=place;
           //  [_mapView removeAnnotations:_mapView.annotations];
             /*添加大头针*/
            /* QiTuPlace *myPlace=[[QiTuPlace alloc] init];
             myPlace.title=@"店铺位置";
             myPlace.subtitle=place;
             myPlace.coordinate=touchMapCoordinate;
             _LocationCell.titleLabel.text=place;
             [_mapView addAnnotation:myPlace];*/
         }
     }];
}

- (void)newNav{
    
    self.TitleLabel.text = @"地图";
    
   UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    UIButton * SaveBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-self.TitleLabel.height,self.TitleLabel.top,self.TitleLabel.height, self.TitleLabel.height)];
    [SaveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SaveBtn.titleLabel.font=DefaultFont(self.scale) ;
    [SaveBtn addTarget:self action:@selector(SaveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:SaveBtn];
    
    
   /* UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, 90*self.scale, self.TitleLabel.height)];
      [popBtn setTitle:@"选择当前位置" forState:UIControlStateNormal];
    //[popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
   // [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    popBtn.titleLabel.font=DefaultFont(1) ;
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];*/
    
    
}
-(void)LoginButtonEvent:(id)sender{
    [_mapView removeAnnotations:_mapView.annotations];
    [self GetNowPoint:sender];
}
-(void)SaveButtonEvent:(id)sender{
    if (_block && _Dic) {
        _block(_Dic);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)PopVC:(id)sender{
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
