//
//  ShengConditionViewController.h
//  Wedding
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void (^CityBlock)(NSDictionary *ShengObject);
@interface ShengConditionViewController : SuperViewController
@property(nonatomic,strong)NSString *titlename;
@property(nonatomic,strong)NSString *Sheng;
-(void)selectedCity:(CityBlock)cityblock;
@end
