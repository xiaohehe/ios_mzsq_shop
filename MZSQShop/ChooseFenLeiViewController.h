//
//  ChooseFenLeiViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^ChooseFenLeiBlock)(NSDictionary *dic);
@interface ChooseFenLeiViewController : SuperViewController
-(id)initWithBlock:(ChooseFenLeiBlock)block;
@end
