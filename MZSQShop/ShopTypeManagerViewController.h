//
//  ShopTypeManagerViewController.h
//  MZSQShop
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ShopTypeBlock)(NSDictionary *shoptype);
@interface ShopTypeManagerViewController : SuperViewController
-(id)initWithBlock:(ShopTypeBlock)block;
@property(nonatomic,strong)NSString *shop_type;
@property(nonatomic,strong)NSDictionary *SelectedTypeDic;
@end
