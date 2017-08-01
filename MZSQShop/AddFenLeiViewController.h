//
//  AddFenLeiViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^AddFenLeiBlock)();
@interface AddFenLeiViewController : SuperViewController
-(id)initWithBlock:(AddFenLeiBlock)block;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *Name;
@end
