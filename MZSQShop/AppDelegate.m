//
//  AppDelegate.m
//  MZSQShop
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "GeRenZhongXinViewController.h"
#import "FuWuPresonCenterViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"
#import "JPUSHService.h"
#import <RongIMKit/RongIMKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WebViewController.h"
#import "FuWuOrderInfoViewController.h"
#import "OderXiangQingViewController.h"

#import "RCDChatListViewController.h"

#import "ChineseToPinyin.h"
#import "DingDanManagerViewController.h"
#import "FuWuOrderListViewController.h"
#import <AdSupport/AdSupport.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,JPUSHRegisterDelegate>
@property(nonatomic,strong)UINavigationController *presonNav;
@property(nonatomic,strong)UINavigationController *fuWupresonNav;
@end
BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [application setApplicationIconBadgeNumber:0];
    [self newJPushWithOptions:launchOptions];
    [self RongRunInitApplication:application];
    [self NavStye];
     [self newTabBarViewController];
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"n9sBG2yO0QSvBGkIHFFZf6rF" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
      /*  BaiDuMapLocationManager *share=[BaiDuMapLocationManager sharedBaiDuMapLocationManager];
        [share AllowLocationWithUpDataMap:^(BMKUserLocation *userLocation) {
            
        } GeoCodeResultBlock:^(BMKReverseGeoCodeResult *result) {
            
        }];*/
       /* [share AllowLocationAndGetAddress:^(BMKUserLocation *userLocation, BMKReverseGeoCodeResult *result) {
            NSLog(@"********** %@  %@ %@ %@ %@     %f  %f",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName , result.addressDetail.streetNumber,result.location.latitude,result.location.longitude);
        }];*/
    }
    self.deliverymanArray=[NSMutableArray array];
    self.deliverymanNameArray=[NSMutableArray array];
    return YES;
}

-(void)NavStye{
    float scale=Scale;
    UIFont* font =Big17BoldFont(scale);
    NSDictionary* textAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBackgroundColor:blueTextColor];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage ImageForColor:blueTextColor] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 融云
-(void)RongRunInitApplication:(UIApplication *)application {
    [[RCIM sharedRCIM] initWithAppKey:@"uwd1c0sxur0i1"];//测试pvxdm17jpc1zr    原来z3v5yqkbvnbm0
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    [RCIM sharedRCIM].enableMessageAttachUserInfo=YES;
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    //[RCIM sharedRCIM].receiveMessageDelegate=self;
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    NSString *token =[Stockpile sharedStockpile].token;
    NSString *userId=[Stockpile sharedStockpile].ID;
    //userId=[NSString stringWithFormat:@"N%@",userId];
    NSLog(@"token==%@,userid==%@",token,userId);
    NSString *userName = [Stockpile sharedStockpile].nickName;
    if (token.length && userId.length &&[Stockpile sharedStockpile].isLogin) {
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userId
                                      name:userName
                                  portrait:nil];
        [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            NSDictionary *model=[Stockpile sharedStockpile].model;
            NSString *ShopName=@"";
            if (model && [model objectForKey:@"shop_info"]) {
                ShopName=[[[NSString stringWithFormat:@"%@",[[model objectForKey:@"shop_info"] objectForKey:@"shop_name"]] trimString] EmptyStringByWhitespace];
            }
            RCUserInfo *_currentUserInfo = [[RCUserInfo alloc]initWithUserId:userId name:ShopName portrait:[NSString stringWithFormat:@"%@",[Stockpile sharedStockpile].logo]];
            NSLog(@"%@",[Stockpile sharedStockpile].logo);
            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        } error:^(RCConnectErrorCode status) {
            NSLog(@"RCConnectErrorCode==%d",status);
        } tokenIncorrect:^{
            NSLog(@"RCConnectErrorCodetokenIncorrect");

        }];
    }
    
//[[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(didReceiveMessageNotification:)
//     name:RCKitDispatchMessageNotification
//     object:nil];
    
}
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    
    NSString *uid=userId;
    if([userId hasPrefix:@"N"]==1){
        uid=[userId  substringFromIndex:1];
    }
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy GetNickAndAvatarWithUser_ID:uid Block:^(id models, NSString *code, NSString *msg) {
        NSLog(@"GetNickAndAvatarWithUser_ID==%@",models);
        NSArray *Arr=models;
        if (Arr && Arr.firstObject && [code isEqualToString:@"0"]) {
            NSDictionary *dic = Arr.firstObject;
            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%@",dic[@"id"]] name:[NSString stringWithFormat:@"%@",dic[@"nick_name"]] portrait:[NSString stringWithFormat:@"%@",dic[@"avatar"]]];
            completion(info);
        }
    }];
}

#pragma mark - RCIMConnectionStatusDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
    // UINavigationController *nav=(UINavigationController *)_tabBarController.viewControllers[1];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unreadMsgCount<1) {
            //   nav.tabBarItem.badgeValue=nil;
        }else{
            //  nav.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadMsgCount];
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
        NSLog(@"jpush==onRCIMReceiveMessage");
    });
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号在别的设备上登录，您被迫下线！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [self OutLogin];
        [[NSNotificationCenter defaultCenter]postNotificationName:orderLineKey object:nil];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}
-(int)ReshData{
    return [[RCIMClient sharedRCIMClient]getUnreadCount: @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_PUBLICSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
}
-(void)OutLogin{
    [[Stockpile  sharedStockpile] setIsLogin:NO];
      //NSString *tag =[NSString stringWithFormat:@"mzsq_%@",[Stockpile sharedStockpile].ID];
   // JPUSHService setAlias:<#(NSString *)#> callbackSelector:<#(SEL)#> object:<#(id)#>
     [JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
     [[RCIM sharedRCIM] disconnect:NO];
    [self newTabBarViewController];
    [self.deliverymanArray removeAllObjects];
    [self.deliverymanNameArray removeAllObjects];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark - TabBarViewController
-(void)newTabBarViewController{
    _presonNav=[[UINavigationController alloc]initWithRootViewController:[[GeRenZhongXinViewController alloc]init]];
    _fuWupresonNav=[[UINavigationController alloc]initWithRootViewController:[[FuWuPresonCenterViewController alloc]init]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"GuideKey"]) {
        GuideViewController *guideVC=[[GuideViewController alloc]initWithBlock:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"GuideKey"];
                if (![Stockpile sharedStockpile].isLogin) {
                    UINavigationController *LoginNav=[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]initWithBlock:^{
                        if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
                            self.window.rootViewController = _presonNav;
                        }else{
                            self.window.rootViewController=_fuWupresonNav;
                        }
                         [RCIM sharedRCIM].userInfoDataSource=self;
                    }]];
                    self.window.rootViewController = LoginNav;
                }else{
                    if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
                        self.window.rootViewController = _presonNav;
                    }else{
                        self.window.rootViewController=_fuWupresonNav;
                    }
                     [RCIM sharedRCIM].userInfoDataSource=self;
                }
            });
        }];
        self.window.rootViewController = guideVC;
    }else{
        if (![Stockpile sharedStockpile].isLogin) {
            UINavigationController *LoginNav=[[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]initWithBlock:^{
                if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
                    self.window.rootViewController = _presonNav;
                }else{
                    self.window.rootViewController=_fuWupresonNav;
                }
                 [RCIM sharedRCIM].userInfoDataSource=self;
            }]];
            self.window.rootViewController = LoginNav;
        }else{
            if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
                self.window.rootViewController = _presonNav;
            }else{
                self.window.rootViewController=_fuWupresonNav;
            }
             [RCIM sharedRCIM].userInfoDataSource=self;
        }
    }
}

#pragma mark - JPush
-(void)newJPushWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"launchOptions==%@",launchOptions);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    if ([UIApplication sharedApplication].isRegisteredForRemoteNotifications) {
        [self ZhuCeJPush];
    }else if (![[NSUserDefaults standardUserDefaults]boolForKey:@"GuideKey"]) {
         [self ZhuCeJPush];
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"b4613b60520a99bcd09c2380"
                          channel:@"Publish channel"
                 apsForProduction:TRUE];
     [JPUSHService setLogOFF];
    [JPUSHService resetBadge];
    if ([Stockpile sharedStockpile].isLogin) {
        NSString *tag =[NSString stringWithFormat:@"mzsq_%@",[Stockpile sharedStockpile].ID];
        [JPUSHService setAlias:tag callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

-(void)ZhuCeJPush{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

//     [[UIApplication sharedApplication] unregisterForRemoteNotifications];
//    
//    UIApplication *application=[UIApplication sharedApplication];
//   if ([application
//         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        //注册推送, iOS 8
//       UIUserNotificationSettings *settings = [UIUserNotificationSettings
//                                                settingsForTypes:(UIUserNotificationTypeBadge |
//                                                                  UIUserNotificationTypeSound |
//                                                                  UIUserNotificationTypeAlert)
//                                                categories:nil];
//        [application registerUserNotificationSettings:settings];
//       
//        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound) categories:nil];
//    } else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeAlert |
//        UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
//        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                       UIUserNotificationTypeSound |
//                                                       UIUserNotificationTypeAlert)
//                                           categories:nil];
//    }
//    
//    [self ZhuCeTuiSong];
    /*float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound) categories:nil];
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    else{
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
   
    }

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                   UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound)
                                       categories:nil];
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeAlert |
    UIRemoteNotificationTypeSound;
    [application registerForRemoteNotificationTypes:myTypes];*/
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [JPUSHService registerDeviceToken:deviceToken];
    NSString* token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSLog(@"token        %@", deviceToken);
    [[RCIMClient sharedRCIMClient]setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 AudioServicesPlaySystemSound(1007);
    NSLog(@"jpush==didReceiveLocalNotification");

}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
   AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
   AudioServicesPlaySystemSound(1007);
    NSLog(@"jpush==didReceiveMessageNotification");
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"[XGDemo] click notification");
    NSLog(@"jpush==userNotificationCenter");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    NSDictionary *userInfo=response.notification.request.content.userInfo;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self TapNextView:userInfo];
        });
    }else{
        NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alt show];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    NSLog(@"jpush==didReceiveRemoteNotification==%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    if ( application.applicationState != UIApplicationStateActive){
        dispatch_async(dispatch_get_main_queue(), ^{
              [self TapNextView:userInfo];
        });
        application.applicationIconBadgeNumber = [self ReshData];
    }else{
        NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alt show];
         [application setApplicationIconBadgeNumber:0];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if ( application.applicationState != UIApplicationStateActive){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self TapNextView:userInfo];
        });
        application.applicationIconBadgeNumber = [self ReshData];
    }else{
        NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alt show];
         [application setApplicationIconBadgeNumber:0];
    }
     // [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)playCustomSound{
    //播放composer_open.wav文件
    static SystemSoundID soundIDTest = 0;//当soundIDTest == kSystemSoundID_Vibrate的时候为震动
    NSString * path = [[NSBundle mainBundle] pathForResource:@"order" ofType:@"caf"];
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    AudioServicesPlaySystemSound( soundIDTest );
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"jpush==jpushNotificationCenter==%@",notification);
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if ( [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TapNextView:userInfo];
            });
            [UIApplication sharedApplication].applicationIconBadgeNumber = [self ReshData];
        }else{
            NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }else {
        // 判断为本地通知
        //NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置 UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //NSLog(@"jpush==NotificationCenter==%@==%@",response, response.notification.request.content.userInfo);
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    AudioServicesPlaySystemSound(1007);
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if ( [UIApplication sharedApplication].applicationState != UIApplicationStateActive){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TapNextView:userInfo];
            });
            [UIApplication sharedApplication].applicationIconBadgeNumber = [self ReshData];
        }else{
            NSString * str  = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"消息" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]&&([[userInfo objectForKey:@"order_type"] integerValue]==1)) {
                [self playCustomSound];
            }else{
                //1. 播放系统音
                AudioServicesPlaySystemSound(1007);
                //震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }else {
        // 判断为本地通知
        //NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionSound);  // 系统要求执行这个方法
}
#endif




-(void)TapNextView:(NSDictionary *)dic{
    if (![Stockpile sharedStockpile].isLogin) {
        return;
    }
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
    if ([[Stockpile sharedStockpile].Role isEqualToString:@"1"]) {
       NSString *push_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_to"]];
        if ([push_type isEqualToString:@"1"]) {
            WebViewController *webVC=[[WebViewController alloc]init];
            webVC.isPush=YES;
            webVC.webType=WebTypeID;
            webVC.Content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_id"]];
            [_presonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:webVC] animated:NO completion:nil];
        }else{
           if([[dic objectForKey:@"order_type"] integerValue]==1){
                OderXiangQingViewController *orderVC=[[OderXiangQingViewController alloc]init];
                orderVC.isPush=YES;
                orderVC.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
                 [_presonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:orderVC] animated:NO completion:nil];
            }
        }
        NSString *push_typeA=[NSString stringWithFormat:@"%@",[dic objectForKey:@"push_type"]];
        if ([dic objectForKey:@"push_type"]  ) {
            if ([push_typeA isEqualToString:@"single"]) {
                DingDanManagerViewController *dingdanVc=[[DingDanManagerViewController alloc]init];
                dingdanVc.isPush   =YES;
                [_presonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:dingdanVc] animated:NO completion:nil];
            }
        }else{
            RCDChatListViewController *rcdVC=[[RCDChatListViewController alloc]init];
            rcdVC.isPush=YES;
            [_presonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:rcdVC] animated:NO completion:nil];
        }
        [_presonNav popToRootViewControllerAnimated:NO];
    }else{
        
        NSString *push_type=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_to"]];
        if ([push_type isEqualToString:@"1"]) {
            WebViewController *webVC=[[WebViewController alloc]init];
            webVC.isPush=YES;
            webVC.webType=WebTypeID;
            webVC.Content=[NSString stringWithFormat:@"%@",[dic objectForKey:@"redirect_id"]];
            [_fuWupresonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:webVC]  animated:NO completion:nil];
        }else{
            if([[dic objectForKey:@"order_type"] integerValue]==2){
       
                FuWuOrderInfoViewController *orderVC=[[FuWuOrderInfoViewController alloc]init];
                orderVC.isPush=YES;
                orderVC.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
                [_fuWupresonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:orderVC] animated:NO completion:nil];
            }
        }
        
        NSString *push_typeA=[NSString stringWithFormat:@"%@",[dic objectForKey:@"push_type"]];
        
        if ([dic objectForKey:@"push_type"] ) {
         
            if ([push_typeA isEqualToString:@"single"]) {
                FuWuOrderInfoViewController *orderVC=[[FuWuOrderInfoViewController alloc]init];
                orderVC.isPush=YES;
                orderVC.ID=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_order_no"]];
                [_fuWupresonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:orderVC] animated:NO completion:nil];
            }
            
        }else{
            RCDChatListViewController *rcdVC=[[RCDChatListViewController alloc]init];
            rcdVC.isPush=YES;
            [_fuWupresonNav presentViewController:[[UINavigationController alloc]initWithRootViewController:rcdVC] animated:NO completion:nil];
        }
        [_fuWupresonNav popToRootViewControllerAnimated:NO];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    if ([Stockpile sharedStockpile].isLogin) {
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [JPUSHService resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
