//
//  PickerViewController.h
//  LeLeFangChan
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SuperViewController.h"

typedef void(^PickerBlock)(NSString *pickerstr);
@interface PickerViewController : SuperViewController

- (void)getPickerDateBlock:(PickerBlock)block;

@end
