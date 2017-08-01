//
//  HelpViewController.m
//  MuZhiSheQu
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
    [self ReshData];
}
-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy UserHelpInfoWithType:@"2" Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if (models) {
            [self WebViewLoadHTMLString:[NSString stringWithFormat:@"%@",[models objectForKey:@"content"]]];
        }
        
    }];
}
-(void)WebViewLoadHTMLString:(NSString *)content{
    NSString *webContent =[NSString stringWithFormat:@"<!doctype html><html>\n<meta charset=\"utf-8\"><style type=\"text/css\">body{padding:0; margin:0;}\n.view_h1{ width:90%%;display:block; overflow:hidden; margin:0 auto; font-size:1.3em; color:#333; padding:1em 0; line-height:1.2em; text-align:center;}\n.view_time{ width:90%%; display:block; text-align:center;overflow:hidden; margin:0 auto; font-size:1em; color:#999;}\n.con{width:90%%; margin:0 auto; color:#fff; color:#333; padding:0.5em 0; overflow:hidden; display:block; font-size:0.92em; line-height:1.8em;}\n.con h1,h2,h3,h4,h5,h6{ font-size:1em;}\n .con img{width: auto; max-width: 100%%;height: auto;margin:0 auto;}\n</style>\n<body style=\"padding:0; margin:0; \"><div class=\"con\">%@</div></body></html>",content];
    [_webView loadHTMLString:webContent baseURL:[NSURL URLWithString:ImgDuanKou]];
}
-(void)newView{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _webView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_webView];
}
#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=@"帮助中心";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}
-(void)PopVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
