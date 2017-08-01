//
//  LinShouTypeViewController.h
//  MuZhiSheQu
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
@class ServiceAreaTableViewCell;
typedef void(^LinShouTypeBlock)(NSDictionary *TypeDic);
@interface LinShouTypeViewController : SuperViewController
@property(nonatomic,strong)NSString *AID;
@property(nonatomic,strong)NSString *Name;
-(void)ReshViewByAID:(NSString *)aid Name:(NSString *)name Block:(LinShouTypeBlock)block;
@end
