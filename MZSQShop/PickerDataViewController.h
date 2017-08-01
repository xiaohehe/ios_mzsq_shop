//
//  PickerDataViewController.h
//  MeiYanShop
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "SuperViewController.h"
typedef void(^PickerDataBlock)(NSString *pickerstr);
@interface PickerDataViewController : SuperViewController
- (void)getPickerDate:(NSArray *)data Block:(PickerDataBlock)block;
@end
