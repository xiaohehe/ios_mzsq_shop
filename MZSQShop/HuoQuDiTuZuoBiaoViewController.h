//
//  HuoQuDiTuZuoBiaoViewController.h
//  HuanBaoWeiShi
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SuperViewController.h"
#import <RongIMKit/RongIMKit.h>
typedef void(^HuoQuDiTuZuoBiaoBlock)(NSDictionary *dic);
@interface QiTuPlace : NSObject<MKAnnotation>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end
@interface HuoQuDiTuZuoBiaoViewController : SuperViewController

- (void)getZuoBiaoBlock:(HuoQuDiTuZuoBiaoBlock)block;

@end
