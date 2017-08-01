//
//  LingShouMenuViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"

@class HelpTableViewCell;
@class LinShouTypeViewController;

typedef void(^LingShouMenuBlock)(NSDictionary *TypeDic,NSDictionary *Detail);
@interface LinShouMenuViewController : SuperViewController
@property(nonatomic,strong)NSString *StopType;
-(void)SelectedShopType:(NSString *)shopType Block:(LingShouMenuBlock)block;

@end
