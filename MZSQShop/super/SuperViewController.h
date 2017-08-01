//
//  SuperViewController.h
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultPageSource.h"
#import "NSString+Helper.h"
#import "UIViewAdditions.h"
#import "Stockpile.h"
#import "AppDelegate.h"

//#import "CustomSearchBar.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "AnalyzeObject.h"
#import "UIView+MJExtension.h"

#import "MJRefresh.h"
#import "LineView.h"
#import "UIImage+Helper.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"

#import "UITextField+RYNumberKeyboard.h"

typedef void(^AlertBlock)(NSInteger index);
@interface SuperViewController : UIViewController
@property(nonatomic,assign)float scale;
@property(nonatomic,strong)UIImageView *NavImg;
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UIActivityIndicatorView *activityVC;
@property(nonatomic,strong)UIImageView *Navline;
@property(nonatomic,strong)AppDelegate *appdelegate;
-(void)ShowAlertWithMessage:(NSString *)message;
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block;
-(void)setName:(NSString *)name;

-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone;
-(NSDictionary *)Style;
@end
