//
//  SuperViewController.m
//  MissAndFound
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()<UIAlertViewDelegate>
@property(nonatomic,strong)AlertBlock alertBlock;
@end
@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _scale=1.0;
    if ([[UIScreen mainScreen] bounds].size.height > 480)
    {
         _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
    }
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
   self.navigationController.navigationBarHidden=YES;
    
    self.view.backgroundColor = superBackgroundColor;
    self.NavImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    self.NavImg.backgroundColor=blueTextColor;
    self.NavImg.userInteractionEnabled = YES;
    self.NavImg.clipsToBounds = YES;
    [self.view  addSubview:self.NavImg];
    
    self.TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45*self.scale, 20, self.view.width-90*self.scale, 44)];
    self.TitleLabel.textColor = [UIColor whiteColor];
    self.TitleLabel.textAlignment = 1;
    self.TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17*_scale];
    self.TitleLabel.backgroundColor = [UIColor clearColor];
    [self.NavImg addSubview:self.TitleLabel];
    
    _activityVC=[[UIActivityIndicatorView alloc]init];
    _activityVC.frame=CGRectMake(0, 0, self.view.width, self.view.height);
    _activityVC.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    _activityVC.color=[UIColor blackColor];
    
 //   _Navline=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.NavImg.height-1*self.scale, self.view.width, 1*self.scale)];
//    _Navline.backgroundColor=blackLineColore;
   //[self.NavImg addSubview:_Navline];
}
-(void)ShowAlertWithMessage:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)setName:(NSString *)name{
    self.navigationController.title=name;
}
-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBlock)block{

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
  //alert.tintColor=pinkTextColor;
    [alert show];
    _alertBlock=block;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if (_alertBlock) {
        _alertBlock(buttonIndex);
    }
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines=0;
    label.text=text;
    label.font=fone;
    [label sizeToFit];
    return label.size;
}
-(NSDictionary *)Style{
    NSDictionary *style=@{
                          @"body":[UIFont systemFontOfSize:12*self.scale],
                          @"Big":[UIFont systemFontOfSize:14*self.scale],
                          @"red":[UIColor redColor],
                          @"orange":@[[UIColor colorWithRed:255/255.0 green:132/225.0 blue:0/255.0 alpha:1],[UIFont fontWithName:@"HelveticaNeue" size:15*self.scale]],
                          @"gray13":@[[UIColor grayColor],[UIFont fontWithName:@"HelveticaNeue" size:13*self.scale  ]],
                          @"red13":@[[UIColor redColor],[UIFont systemFontOfSize:13*self.scale]],
                          @"gray10":@[[UIColor grayColor],[UIFont systemFontOfSize:10*self.scale]],
                          @"gray12":@[[UIColor grayColor],[UIFont systemFontOfSize:12*self.scale]],
                          @"red12":@[[UIColor redColor],[UIFont systemFontOfSize:12*self.scale]],
                          @"red15":@[[UIColor redColor],[UIFont systemFontOfSize:15*self.scale]],
                          @"Org10":@[  [UIColor colorWithRed:255/255 green:136/255.0 blue:34/255.0 alpha:1],[UIFont systemFontOfSize:10*self.scale]],
                          };
    return style;
}
#pragma mark - 屏幕选转
- (BOOL)shouldAutorotate
{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
