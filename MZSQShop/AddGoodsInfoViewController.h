//
//  AddGoodsInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^AddGoodsInfoBlock)();
@interface AddGoodsInfoViewController : SuperViewController
@property(nonatomic,strong)NSMutableArray *imgArr;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *unit;
@property(nonatomic,strong)NSString *class_id;
@property(nonatomic,strong)NSString *class_Name;
@property(nonatomic,strong)NSString *inventory;
@property(nonatomic,strong)NSString *origin_price;
@property(nonatomic,strong)NSString *inventroty_alarm;
//@property(nonatomic,strong)NSMutableArray *webImgArr;
-(id)initWithBlock:(AddGoodsInfoBlock)block;

@end
