//
//  ShiConditionViewController.h
//  Wedding
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void (^CityBlock)(NSDictionary *ShiObj);
@interface ShiConditionViewController : SuperViewController
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *titlename;
@property(nonatomic,strong)NSString *Sheng;
-(void)selectedCityByShengID:(NSString *)ShengID Block:(CityBlock)cityblock;
@end
