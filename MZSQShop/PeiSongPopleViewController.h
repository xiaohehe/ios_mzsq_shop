//
//  PeiSongPopleViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^PeiSongBlock)(NSDictionary *preson);
@interface PeiSongPopleViewController : SuperViewController
-(id)initWithBlock:(PeiSongBlock)block;
@end
