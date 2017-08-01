//
//  WebViewController.m
//  LunTai
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WebViewController.h"
@interface WebViewController()
@property(nonatomic,strong)UIWebView *webView;
@end
@implementation WebViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
    [self.view addSubview:self.activityVC];
}

-(void)newView{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, self.view.width, self.view.height-self.NavImg.bottom)];
    _webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_webView];
    [self ChooseWebType];
}

-(void)ChooseWebType{
    if (self.webType == WebTypeContent) {
        [self WebViewLoadHTMLString:_Content];
    }else if (self.webType==WebTypeID){
        
        [self ReshData];
        
    }else if (self.webType == WebTypeURL){
        _Content=[_Content stringByReplacingOccurrencesOfString:@"http://" withString:@""];
         _Content=[_Content stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_Content]]]];
    }
}

-(void)ReshData{
    [self.activityVC startAnimating];
    AnalyzeObject *analy=[[AnalyzeObject alloc]init];
    [analy GetPushDetailWithID:_Content Block:^(id models, NSString *code, NSString *msg) {
        [self.activityVC stopAnimating];
        if ([code isEqualToString:@"0"] && models) {
            [self WebViewLoadHTMLString:[NSString stringWithFormat:@"%@",[models objectForKey:@"concent"]]];
        }
    }];
}

-(void)WebViewLoadHTMLString:(NSString *)content{
    NSString *webContent =[NSString stringWithFormat:@"<!doctype html><html>\n<meta charset=\"utf-8\"><style type=\"text/css\">body{padding:0; margin:0;}\n.view_h1{ width:90%%;display:block; overflow:hidden; margin:0 auto; font-size:1.3em; color:#333; padding:1em 0; line-height:1.2em; text-align:center;}\n.view_time{ width:90%%; display:block; text-align:center;overflow:hidden; margin:0 auto; font-size:1em; color:#999;}\n.con{width:90%%; margin:0 auto; color:#fff; color:#333; padding:0.5em 0; overflow:hidden; display:block; font-size:0.92em; line-height:1.8em;}\n.con h1,h2,h3,h4,h5,h6{ font-size:1em;}\n .con img{width: auto; max-width: 100%%;height: auto;margin:0 auto;}\n</style>\n<body style=\"padding:0; margin:0; \"><div class=\"con\">%@</div></body></html>",content];
    [_webView loadHTMLString:webContent baseURL:[NSURL URLWithString:ImgDuanKou]];
}

#pragma mark - 导航
-(void)newNav{
    self.TitleLabel.text=_NavTitle?_NavTitle:@"";
    UIButton * popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [popBtn setFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height , self.TitleLabel.height )];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

- (void)popVC:(id)sender{
    if (_isPush) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
