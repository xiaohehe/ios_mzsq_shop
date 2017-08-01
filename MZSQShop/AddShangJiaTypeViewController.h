//
//  AddShangJiaTypeViewController.h
//  MZSQShop
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^AddShangJiaType_Block)(NSString *typeName);
@interface AddShangJiaTypeViewController : SuperViewController
-(id)initWithBlock:(AddShangJiaType_Block)block;
@property(nonatomic,assign)BOOL isModel;
@end
