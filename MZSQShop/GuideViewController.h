//
//  GuideViewController.h
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^GuideBlock)(BOOL success);
@interface GuideViewController : SuperViewController
-(id)initWithBlock:(GuideBlock)block;
@end
