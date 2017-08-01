//
//  XianViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^XianBlock)(NSDictionary *Xian,NSDictionary *Zhen);
@interface XianViewController : SuperViewController
-(id)initWithBlock:(XianBlock)block;
@property(nonatomic,strong)NSString *CID;
@property(nonatomic,strong)NSString *Name;
@property(nonatomic,assign)BOOL isMenu;
@property(nonatomic,assign)BOOL isAdress;
-(void)ReshViewByCID:(NSString *)cid Name:(NSString *)name Block:(XianBlock)block;
@end
