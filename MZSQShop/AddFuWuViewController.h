//
//  AddFuWuViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^AddFuWuBlock)();
@interface AddFuWuViewController : SuperViewController
-(id)initWithBlock:(AddFuWuBlock)block;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *Name;
@end
