//
//  FuWuOrderInfoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^FuWuOrderInfoBlock)();
@interface FuWuOrderInfoViewController : SuperViewController
-(id)initWithBlock:(FuWuOrderInfoBlock)block;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,assign)BOOL isPush;
@end
