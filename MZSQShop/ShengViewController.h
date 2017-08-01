//
//  ShengViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ShengBlock)(NSDictionary *Sheng,NSDictionary *Shi,NSDictionary *Xian,NSDictionary *Zhen);
@interface ShengViewController : SuperViewController
-(id)initWithBlock:(ShengBlock)block;
@property(nonatomic,assign)BOOL isMenu;
@property(nonatomic,assign)BOOL isAdress;
-(void)ReshViewWithName:(NSString *)name Block:(ShengBlock)block;
@end
