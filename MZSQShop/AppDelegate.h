//
//  AppDelegate.h
//  MZSQShop
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) NSMutableArray* deliverymanArray;//购物车配送员列表
@property(nonatomic,strong) NSMutableArray* deliverymanNameArray;//购物车配送员姓名列表
-(void)newTabBarViewController;
-(void)OutLogin;
-(int)ReshData;
-(void)ZhuCeJPush;
@end

