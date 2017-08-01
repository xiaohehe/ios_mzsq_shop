//
//  LoginViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^LoginBlock)();
@interface LoginViewController : SuperViewController
-(id)initWithBlock:(LoginBlock)block;
@end
