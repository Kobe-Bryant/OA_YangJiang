//
//  WRYDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WRYDetailViewController.h"
#import "HtmlTableGenerator.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

#define WRY_DETAIL_SERVICE_NAME @"QUERY_WRY_INFO"

@interface WRYDetailViewController ()
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) UIWebView *detailWebView;
@end

@implementation WRYDetailViewController

@synthesize wrybh,wrymc;
@synthesize isLoading,urlString;
@synthesize detailWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.wrymc;
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.detailWebView.delegate = self;
    [self.view addSubview:self.detailWebView];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:WRY_DETAIL_SERVICE_NAME forKey:@"service"];
    [params setObject:self.wrybh forKey:@"wrybh"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Network Handler Method

- (void)processWebData:(NSData *)webData
{
    isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [resultJSON objectFromJSONString];
    if(dict)
    {
        NSString *htmlTitle = [NSString stringWithFormat:@"%@-污染源基本信息", [dict objectForKey:@"WRYMC"]];
        
        if([[dict objectForKey:@"SFTGQJSC"] intValue] == 0)
        {
            [dict setObject:@"不通过" forKey:@"SFTGQJSC"];
            [dict setObject:@"" forKey:@"QJSCTGSJ"];
        }
        else
        {
            [dict setObject:@"通过" forKey:@"SFTGQJSC"];
            NSString *QJSCTGSJ = [dict objectForKey:@"QJSCTGSJ"];
            if(QJSCTGSJ != nil && QJSCTGSJ.length > 10)
            {
                QJSCTGSJ = [QJSCTGSJ substringToIndex:10];
            }
            else
            {
                QJSCTGSJ = @"";
            }
            [dict setObject:QJSCTGSJ forKey:@"QJSCTGSJ"];
        }
        
        //CSWRWZL FS,FQ,GF,ZS,
        NSMutableString *CSWRWZL = [NSMutableString stringWithFormat:@"%@", [dict objectForKey:@"CSWRWZL"]];
        if(CSWRWZL != nil && CSWRWZL.length > 0)
        {
            [CSWRWZL replaceOccurrencesOfString:@"FS" withString:@"废水" options:NSCaseInsensitiveSearch range:NSMakeRange(0, CSWRWZL.length)];
            [CSWRWZL replaceOccurrencesOfString:@"FQ" withString:@"废气" options:NSCaseInsensitiveSearch range:NSMakeRange(0, CSWRWZL.length)];
            [CSWRWZL replaceOccurrencesOfString:@"GF" withString:@"固废" options:NSCaseInsensitiveSearch range:NSMakeRange(0, CSWRWZL.length)];
            [CSWRWZL replaceOccurrencesOfString:@"ZS" withString:@"噪声" options:NSCaseInsensitiveSearch range:NSMakeRange(0, CSWRWZL.length)];
            [dict setObject:CSWRWZL forKey:@"CSWRWZL"];
        }

        NSString *content = [HtmlTableGenerator genContentWithTitle1:htmlTitle andParaMeters:dict andType:WRY_DETAIL_SERVICE_NAME];
        [self.detailWebView loadHTMLString:content baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    else
    {
        [self.detailWebView loadHTMLString:@"暂无数据" baseURL:nil];
    }
    
}

- (void)processError:(NSError *)error
{
    isLoading = NO;
    [self showAlertMessage:@"请求数据失败."];
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
}

@end
