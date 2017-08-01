//
//  AnalyzeObject.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyzeObject : NSObject
#pragma mark - MD5加密
/**
 *MD5加密
 */
-(NSString *)md5:(NSString *)str;


#pragma mark - 获取用户头像,id,昵称信息接口
/**
 *获取用户头像,id,昵称信息接口
 */
-(void)GetNickAndAvatarWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - ***********  商家端的个人中心 *********
#pragma mark - 1、用户注册
/**
 *用户注册
 */
-(void)UserRegisterWithMobile:(NSString *)mobile Password:(NSString *)password Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -2、用户登录接口
/**
 *用户登录接口
 */
-(void)UserLoginWithMobile:(NSString *)mobile Password:(NSString *)password Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 用户手机验证码接口
/**
 *用户手机验证码接口
 *2、type( 类型，)1：注册，2：忘记密码，3：支付,4:登录
 */
-(void)UserGetVerifyCodeWithMobile:(NSString *)mobile Type:(NSString *)type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 3、获取帮助信息接口（商家端）
/**
 *获取帮助信息接口（商家端）
 *terminal_type 终端类型：1：买家端，2：卖家端，3：抢单端
 */
-(void)UserHelpInfoWithType:(NSString *)terminal_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 4、意见反馈
/**
 *4、意见反馈
 *terminal_type 终端类型：1：买家端，2：卖家端，3：抢单端
 */
-(void)FeedbackWithUser_ID:(NSString *)user_id Content:(NSString *)content  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 6、修改用户头像
/**
 *6、修改用户头像
 */
-(void)ModifyLogoWithUser_ID:(NSString *)user_id Logo:(NSString *)logo  Block:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark - 7、修改商家配送费
/**
 *7、修改商家配送费
 */
-(void)ModifyDeleverFeeWithUser_ID:(NSString *)user_id Amount:(NSString *)amount  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 8、修改商家满多少配送
/**
 *8、修改商家满多少配送
 */
-(void)ModifyFreeAmountWithUser_ID:(NSString *)user_id Amount:(NSString *)amount  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 9、修改商家联系人
/**
 *9、修改商家联系人
 */
-(void)ModifyContactNameWithUser_ID:(NSString *)user_id Contact_name:(NSString *)contact_name  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 10、修改商家登录密码
/**
 *10、修改商家登录密码
 */
-(void)ModifyLoginPassWithUser_ID:(NSString *)user_id Old_login_pass:(NSString *)old_login_pass Passwrod:(NSString *)passwrod  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 13、修改店铺logo接口
/**
 *13、修改店铺logo接口
 */
-(void)ModifyShopLogoWithUser_ID:(NSString *)user_id Logo:(NSString *)logo  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 14、修改店铺名称接口
/**
 *14、修改店铺名称接口
 */
-(void)ModifyShopNameWithUser_ID:(NSString *)user_id Shop_name:(NSString *)shop_name  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 15、修改店铺招牌接口
/**
 *15、修改店铺招牌接口
 */
-(void)ModifyShopZhaoPaiWithUser_ID:(NSString *)user_id ZhaoPai:(NSString *)zhaoPai  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 16、修改店铺地址接口
/**
 *16、修改店铺地址接口
 */
-(void)ModifyShopAddressWithUser_ID:(NSString *)user_id Address:(NSString *)address  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 17、修改店铺坐标接口
/**
 *17、修改店铺坐标接口
 */
-(void)ModifyShopCoordinateWithUser_ID:(NSString *)user_id Lng:(NSString *)lng Lat:(NSString *)lat  Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 18、修改店铺热线电话接口
/**
 *18、修改店铺热线电话接口
 */
-(void)ModifyShopHotlineWithUser_ID:(NSString *)user_id Hotline:(NSString *)hotline Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 19、修改店铺公告接口
/**
 *19、修改店铺公告接口
 */
-(void)ModifyShopNoticeWithUser_ID:(NSString *)user_id Notice:(NSString *)notice Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 20、修改店铺详情接口
/**
 *20、修改店铺详情接口
 */
-(void)ModifyShopDetailWithUser_ID:(NSString *)user_id Detail:(NSString *)detail Img1:(NSString *)img1 Img2:(NSString *)img2 Img3:(NSString *)img3 Img4:(NSString *)img4 Img5:(NSString *)img5 Img6:(NSString *)img6 Img7:(NSString *)img7 Img8:(NSString *)img8 Img9:(NSString *)img9 Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 21、查看店铺详情接口
/**
 *21、查看店铺详情接口
 */
-(void)ShopDetailWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 22、省份列表接口
/**
 *22、省份列表接口
 */
-(void)GetProvinceListWithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 23、城市列表接口
/**
 *23、城市列表接口
 */
-(void)GetCityListWithProvince_id:(NSString *)province_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 24、区县列表接口
/**
 *24、区县列表接口
 */
-(void)GetDistrictListWithCity_id:(NSString *)city_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 25、社区列表接口
/**
 *25、社区列表接口
 */
-(void)GetCommunityListWithDistrict_id:(NSString *)district_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 26、申请新增社区接口
/**
 *26、申请新增社区接口
 */
-(void)ApplyCommunityWithUser_id:(NSString *)user_id Province:(NSString *)province City:(NSString *)city District:(NSString *)district Community_name:(NSString *)community_name Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 27、添加配送员工接口
/**
 *27、添加配送员工接口
 */
-(void)AddStaffWithUser_id:(NSString *)user_id Staff_name:(NSString *)staff_name Staff_mobile:(NSString *)staff_mobile Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 28、删除配送员工接口
/**
 *28、删除配送员工接口
 */
-(void)DelStaffWithUser_id:(NSString *)user_id Staff_ID:(NSString *)staff_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 29、配送员工列表接口
/**
 *29、配送员工列表接口
 */
-(void)StaffListWithUser_id:(NSString *)user_id Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 30、商品分类列表接口
/**
 *30、商品分类列表接口
 */
-(void)ProdClassListWithUser_id:(NSString *)user_id Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 31、添加商品分类接口
/**
 *31、添加商品分类接口
 */
-(void)AddProdClassWithUser_id:(NSString *)user_id Class_name:(NSString *)class_name Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 32、删除商品分类接口
/**
 *32、删除商品分类接口
 */
-(void)DelProdClassWithUser_id:(NSString *)user_id Class_id:(NSString *)class_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 33、编辑商品分类接口
/**
 *33、编辑商品分类接口
 */
-(void)ModifyProdClassWithUser_id:(NSString *)user_id Class_id:(NSString *)class_id Class_name:(NSString *)class_name Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 34、添加商品接口
/**
 *34、添加商品接口
 */
-(void)AddProdWithUser_ID:(NSString *)user_id Prod_name:(NSString *)prod_name Price:(NSString *)price Unit:(NSString *)unit origin_price:(NSString *)origin_price inventroty_alarm:(NSString *)inventroty_alarm Class_id:(NSString *)class_id Inventory:(NSString *)inventory Desc:(NSString *)desc  Img1:(NSString *)img1 Img2:(NSString *)img2 Img3:(NSString *)img3 Img4:(NSString *)img4 Img5:(NSString *)img5 Img6:(NSString *)img6 Img7:(NSString *)img7 Img8:(NSString *)img8 Img9:(NSString *)img9 Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 35、修改商品接口
/**
 *35、修改商品接口
 */
-(void)ModifyProdWithUser_ID:(NSString *)user_id Prod_id:(NSString *)prod_id Prod_name:(NSString *)prod_name Price:(NSString *)price Unit:(NSString *)unit origin_price:(NSString *)origin_price inventroty_alarm:(NSString *)inventroty_alarm Class_id:(NSString *)class_id Inventory:(NSString *)inventory Desc:(NSString *)desc  img_add:(NSString *)img_add img_delete:(NSString *)img_delete Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 36、删除商品接口
/**
 *36、删除商品接口
 */
-(void)DelProdWithUser_ID:(NSString *)user_id Prod_id:(NSString *)prod_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 37、商品上架/下架接口
/**
 *37、商品上架/下架接口
 */
-(void)OnOffShelveProdWithUser_ID:(NSString *)user_id Prod_id:(NSString *)prod_id State:(NSString *)state Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 38、商品列表接口
/**
 *38、商品列表接口
 */
-(void)ProdListWithUser_ID:(NSString *)user_id Class_id:(NSString *)class_id Status:(NSString *)status Keyword:(NSString *)keyword Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 39、订单列表接口
/**
 *39、订单列表接口 1:未付款 2:待发货 3:已发货 4:已完成 5:已取消
 */
-(void)OrderListWithUser_ID:(NSString *)user_id Status:(NSString *)status Pindex:(NSNumber *)pindex Keyword:(NSString *)keyword Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 58、商家接单接口
/**
 *58、商家接单接口
 */
-(void)AcceptOrderWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no msg:(NSString *)msg DeliveryID:(NSString*) deliveryid Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 40、取消订单接口
/**
 *40、取消订单接口
 */
-(void)CancelOrderWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 41、删除订单接口
/**
 *41、删除订单接口
 */
-(void)DelOrderWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 42、选择配送人员接口
/**
 *42、选择配送人员接口
 */
-(void)SelectStarffWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Starff_id:(NSString *)starff_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 43、第三方配送接口
/**
 *43、第三方配送接口
 */
-(void)SelectPubStarffWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 44、订单详情接口
/**
 *44、订单详情接口
 */
-(void)OrderDetailWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 64、结束订单接口（已测试）
/**
 *64、结束订单接口（已测试）
 */
-(void)FinishOrderWithUser_ID:(NSString *)user_id Order_no:(NSString *)order_no Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 45、销售统计接口
/**
 *45、销售统计接口
 */
-(void)SaleStatisWithUser_ID:(NSString *)user_id Start_time:(NSString *)start_time End_time:(NSString *)end_time Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 46、申请提现接口
/**
 *46、申请提现接口
 */
-(void)ApplyWithDrawWithUser_ID:(NSString *)user_id Account_type:(NSString *)account_type Account:(NSString *)account Amout:(NSString *)amout Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 47、提现明细列表接口
/**
 *47、提现明细列表接口
 */
-(void)WithDrawListWithUser_ID:(NSString *)user_id Start_time:(NSString *)start_time End_time:(NSString *)end_time Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 48、提现明细批量删除接口
/**
 *48、提现明细批量删除接口
 */
-(void)DelWithDrawWithIDS:(NSString *)ids Block:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark - 商家服务类型接口
/**
 *商家服务类型接口
 */
-(void)ShopUsermyServeTypeList2WithShop_type:(NSString *)shop_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 49、服务类商家申请接口
/**
 *49、服务类商家申请接口
 */
-(void)ApplyServeShopWithUser_ID:(NSString *)user_id
                    Contact_name:(NSString *)contact_name
                          Mobile:(NSString *)mobile
                       Shop_name:(NSString *)shop_name
                         Address:(NSString *)address
                      Serve_type:(NSString *)serve_type
                       Community:(NSString *)community
                         Idcard1:(NSString *)idcard1
                         Idcard2:(NSString *)idcard2
                         License:(NSString *)license
                   Certification:(NSString *)certification
                      Buss_scope:(NSString *)buss_scope
                       Shop_type:(NSString *)shop_type
                      Is_weishop:(NSString *)is_weishop
                             lng:(NSString *)lng
                             lat:(NSString *)lat
                        province:(NSString *)province
                            city:(NSString *)city
                        district:(NSString *)district
                           Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 50、服务类商家服务项目添加接口
/**
 *50、服务类商家服务项目添加接口
 */
-(void)AddServeItemWithWithUser_ID:(NSString *)user_id Item_name:(NSString *)item_name Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 51、服务类商家服务项目列表接口
/**
 *51、服务类商家服务项目列表接口
 */
-(void)ServeItemListWithWithUser_ID:(NSString *)user_id Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 52、删除服务项目接口
/**
 *52、删除服务项目接口
 */
-(void)DelServeItemWithWithUser_ID:(NSString *)user_id ServeItem_id:(NSString *)serveItem_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 53、商家服务社区列表接口
/**
 *53、商家服务社区列表接口
 */
-(void)ServeCommunityListWithWithUser_ID:(NSString *)user_id Pindex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 54、商家添加服务社区接口
/**
 *54、商家添加服务社区接口
 */
-(void)AddServeCommunityWithWithUser_ID:(NSString *)user_id Community_id:(NSString *)community_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 55、商家删除服务社区接口
/**
 *55、商家删除服务社区接口
 */
-(void)DelServeCommunityWithWithUser_ID:(NSString *)user_id Community_id:(NSString *)community_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 56、商家接单信息设置接口
/**
 *56、商家接单信息设置接口
 */
-(void)ModifyOrderMsgWithWithUser_ID:(NSString *)user_id Order_msg:(NSString *)order_msg Block:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark - 59、商家添加服务类型接口
/**
 *59、商家添加服务类型接口
 */
-(void)AddServeTypeWithWithUser_ID:(NSString *)user_id Serve_type_id:(NSString *)serve_type_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 60、商家删除服务类型接口
/**
 *60、商家删除服务类型接口
 */
-(void)DelServeTypeWithWithUser_ID:(NSString *)user_id Serve_type_id:(NSString *)serve_type_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 61、所有服务类型列表接口
/**
 *61、所有服务类型列表接口
 */
-(void)ServeTypeListWithWithShop_type:(NSString *)shop_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 62、商家已选择服务类型列表接口
/**
 *62、商家已选择服务类型列表接口
 */
-(void)CurrentServeTypeListWithWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 63、获取商家账号信息接口
/**
 *63、获取商家账号信息接口
 */
-(void)ShopUserInfoWithWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -64、 周六休息设置接口
/**
 *64、 周六休息设置接口
 */
-(void)OffOnSaturdayWithWithUser_ID:(NSString *)user_id Status:(NSString *)status Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -65、 周日休息设置接口
/**
 *65、 周日休息设置接口
 */
-(void)OffOnSundayWithWithUser_ID:(NSString *)user_id Status:(NSString *)status Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -66、 商家歇业设置接口
/**
 *66、 商家歇业设置接口
 */
-(void)CloseOrOpenShopWithWithUser_ID:(NSString *)user_id Status:(NSString *)status Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -67、商家服务时间获取
/**
 *67、商家服务时间获取
 */
-(void)GetServeHourWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark -68、商家服务时间设置接口
/**
 *68、商家服务时间设置接口
 */
-(void)ModifyServeHourWithWithUser_ID:(NSString *)user_id Business_hour:(NSString *)business_hour Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 69、商家详情接口
/**
 *69、商家详情接口
 */
-(void)QueryShopDetailWithUser_ID:(NSString *)user_id Shop_id:(NSString *)shop_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -70、商家评价列表接口
/**
 *70、商家评价列表接口
 */
-(void)CommentListWithShop_id:(NSString *)shop_id PIndex:(NSNumber *)pindex Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -71、商家服务类型列表接口
/**
 *71、商家服务类型列表接口
 */
-(void)MyServeTypeListWithUser_ID:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -72、商家服务类型修改接口
/**
 *72、商家服务类型修改接口
 */
-(void)ModifyServeTypeWithUser_ID:(NSString *)user_id Serve_type:(NSString *)serve_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -73、申请商铺类别的名称
/**
 *73、申请商铺类别的名称
 */
-(void)ApplyServeTypeWithUser_ID:(NSString *)user_id Serve_type_name:(NSString *)serve_type_name Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -74、抢单端用户忘记密码接口
/**
 *74、抢单端用户忘记密码接口
 */
-(void)ForgetLoginPassWithMobile:(NSString *)mobile Login_pass:(NSString *)login_pass User_type:(NSString *)user_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;

#pragma mark -75、用户使用协议
/**
 *75、用户使用协议
 */
-(void)GetMzAgreementWithTerminal_type:(NSString *)terminal_type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark -76、获取推送web信息接口
/**
 *76、获取推送web信息接口
 */
-(void)GetPushDetailWithID:(NSString *)ID Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 商家服务时间设置接口
/**
 *商家服务时间设置接口
 */
-(void)ModifyServeHourWithWithUser_ID:(NSString *)user_id Hour_type:(NSString *)hour_type Is_check:(NSString *)is_check Business_start_hour:(NSString *)business_start_hour Business_end_hour:(NSString *)business_end_hour Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 我的公告
/**
 *我的公告
 */
-(void)getNoticeListwithDic:(NSDictionary *)dic WithBlock:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 编辑公告
/**
 *编辑公告
 */
-(void)editNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 添加公告
/**
 *添加公告
 */
-(void)addNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 删除公告
/**
 *删除公告
 */
-(void)delNoticeWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 公告详情
/**
 *公告详情
 */
-(void)noticeDetailWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 公告墙
/**
 *公告墙
 */
-(void)NoticeWallcommentWithDic:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 72、商家简介接口
/**
 *商家简介接口
 */
-(void)SummaryWithUser_ID:(NSString *)user_id Summary:(NSString *)summary Type:(NSString *)type Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 商家端获取社区服务电话接口
/**
 *商家端获取社区服务电话接口
 */
-(void)ShopUsergetComuunityTelWithMobile:(NSString *)mobile Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 招牌
/**
 *招牌
 */
-(void)ShopUsermodifyShopZhaoPaiWithUser_id:(NSString *)user_id
                               shop_zhaopai:(NSString *)shop_zhaopai
                               shop_zhaopai2:(NSString *)shop_zhaopai2
                               shop_zhaopai3:(NSString *)shop_zhaopai3
                               shop_zhaopai4:(NSString *)shop_zhaopai4
                               shop_zhaopai5:(NSString *)shop_zhaopai5
                               shop_zhaopai6:(NSString *)shop_zhaopai6 Block:(void(^)(id models, NSString *code ,NSString * msg))block;
#pragma mark - 订单数量接口
/**
 *订单数量接口
 */
-(void)ShopOrderOrderCountWithUser_id:(NSString *)user_id Block:(void(^)(id models, NSString *code ,NSString * msg))block;

/**
 *商家处理退款订单
 */
-(void)orderRefund:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *配送人列表
 */
-(void)deliverymanList:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *获取暂停营业状态（0正常营业1暂停营业）
 */
-(void)getOffOnline:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
/**
 *获取暂停营业状态（0正常营业1暂停营业）
 */
-(void)setOffOnline:(NSDictionary *)dic Block:(void(^)(id models, NSString *code ,NSString * msg))block;
@end
