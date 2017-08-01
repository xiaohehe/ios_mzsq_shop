//
//  BigImageViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^BigImageBlock)();
@interface BigImageViewController : SuperViewController
-(id)initWithBlock:(BigImageBlock)block;
@property(nonatomic,strong)NSMutableArray *ImageArr;
@property(nonatomic,strong)NSMutableArray *webImgArr;
//@property(nonatomic,strong)UIImage *DefImg;
@property(nonatomic,assign)NSInteger indexPage;
@end
