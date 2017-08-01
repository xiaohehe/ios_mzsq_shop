//
//  FaBuGongGaoViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
#import "ZLPickerViewController.h"
@interface FaBuGongGaoViewController : SuperViewController
@property(nonatomic,assign)int q;
@property(nonatomic,strong)NSString *conteent,*titlee,*gongid;
//@property(nonatomic,strong)NSMutableArray *imgData;
@property(nonatomic,strong)NSMutableArray *assetss,*imgData;
@property(nonatomic,assign)BOOL bian;

@end
