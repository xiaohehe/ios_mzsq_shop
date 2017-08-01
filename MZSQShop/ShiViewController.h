//
//  ShiViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ShiBlock)(NSDictionary *Shi,NSDictionary *Xian,NSDictionary *Zhen);
@interface ShiViewController : SuperViewController
-(id)initWithBlock:(ShiBlock)block;
@property(nonatomic,strong)NSString *PID;
@property(nonatomic,strong)NSString *Name;
@property(nonatomic,assign)BOOL isMenu;
@property(nonatomic,assign)BOOL isAdress;
-(void)ReshViewByPID:(NSString *)pid Name:(NSString *)name Block:(ShiBlock)block;
@end
