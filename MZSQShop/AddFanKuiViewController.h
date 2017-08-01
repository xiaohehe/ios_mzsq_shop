//
//  AddFanKuiViewController.h
//  BaoJiaHuHang2
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^FanKuiBlock)();
@interface AddFanKuiViewController : SuperViewController
-(id)initWithBlock:(FanKuiBlock)block;
@end
