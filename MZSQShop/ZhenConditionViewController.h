//
//  ZhenConditionViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ZhenBlock)(NSDictionary *Zhen,BOOL pop);
@interface ZhenConditionViewController : SuperViewController
-(id)initWithBlock:(ZhenBlock)block;
@property(nonatomic,strong)NSString *AID;
@property(nonatomic,strong)NSString *PID;
@property(nonatomic,strong)NSString *CID;
@property(nonatomic,strong)NSString *Name;
@property(nonatomic,assign)NSInteger MaxNum;
@property(nonatomic,assign)NSInteger nowNum;
@property(nonatomic,strong)NSArray *nowComArr;
-(void)selectedZhenByAreaID:(NSString *)AID PID:(NSString *)PID CID:(NSString *)CID   Block:(ZhenBlock)cityblock;
@end
