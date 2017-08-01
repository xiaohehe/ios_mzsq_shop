//
//  AddSeverAreaViewController.h
//  MZSQShop
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^AddSeverAreaBlock)();
@interface AddSeverAreaViewController : SuperViewController
-(id)initWithBlock:(AddSeverAreaBlock)block;
@property(nonatomic,strong)NSString *ShengID;
@property(nonatomic,strong)NSString *ShiID;
@property(nonatomic,strong)NSString *XianID;
@property(nonatomic,assign)BOOL isModel;
@end
