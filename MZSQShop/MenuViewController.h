//
//  MenuViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^MenuBlock)(NSDictionary *Sheng,NSDictionary *Shi,NSDictionary *Xian,NSDictionary *Zhen);
@interface MenuViewController : SuperViewController
-(id)initWithBlock:(MenuBlock)block;
@property(nonatomic,strong)NSDictionary *Sheng;
@property(nonatomic,strong)NSDictionary *Shi;
@property(nonatomic,strong)NSDictionary *Xian;
@property(nonatomic,strong)NSDictionary *Zhen;
-(void)SelectedNum:(NSInteger)num Block:(MenuBlock)block;
@end
