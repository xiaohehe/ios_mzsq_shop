//
//  ZhenViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ZhenBlock)(NSDictionary *Zhen);
@interface ZhenViewController : SuperViewController
-(id)initWithBlock:(ZhenBlock)block;
@property(nonatomic,strong)NSString *AID;
@property(nonatomic,strong)NSString *PID;
@property(nonatomic,strong)NSString *CID;
@property(nonatomic,strong)NSString *Name;
@property(nonatomic,assign)BOOL isMenu;
@property(nonatomic,assign)BOOL isAdress;
-(void)selectedZhenByAreaID:(NSString *)AID PID:(NSString *)PID CID:(NSString *)CID Name:(NSString *)name Block:(ZhenBlock)cityblock;
@end
