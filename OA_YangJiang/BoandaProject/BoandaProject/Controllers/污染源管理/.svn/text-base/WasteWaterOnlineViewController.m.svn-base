//
//  WasteWaterOnlineViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-12-5.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WasteWaterOnlineViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

@interface WasteWaterOnlineViewController ()
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) NSArray *listDataArray;
@property (nonatomic, strong) NSArray *listKeyArray;
@end

@implementation WasteWaterOnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"废水实时数据";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isLoading = NO;
    [self requestData];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.delegate = self;
    [self.view addSubview:self.myWebView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetWork Hander Methods

- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setObject:@"QUERY_ZAJC_FSQYSS_LIST" forKey:@"service"];
    [params setObject:self.PSCODE forKey:@"PSCODE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    if(webData.length <= 0)
    {
        return;
    }
    
    NSMutableString *log = [[NSMutableString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    [log replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, log.length)];
    
    //这里不同企业返回的数据是不一致的，需要动态处理
    NSDictionary *tmpParsedAry = [log objectFromJSONString];
    if (tmpParsedAry != nil)
    {
        self.listDataArray = [tmpParsedAry objectForKey:@"values"];
        self.listKeyArray = [[tmpParsedAry objectForKey:@"keys"] componentsSeparatedByString:@","];
        
        //拼接HTML表头
        int f = (int)100/(self.listKeyArray.count);
        NSMutableString *tableHeaderStr = [[NSMutableString alloc] init];
        [tableHeaderStr appendFormat:@"%@", @"<tr>"];
        for (int i = 0; i < self.listKeyArray.count; i++)
        {
            NSString *key = [self.listKeyArray objectAtIndex:i];
            if([key isEqualToString:@"GETTIME"])
            {
                key = @"时间";
            }
            [tableHeaderStr appendFormat:@"<td width=\"%d%%\">%@</td>", f, key];
        }
        [tableHeaderStr appendFormat:@"%@", @"</tr>"];
        
        //拼接HTML 表格内容
        NSMutableString *tableBodyStr = [[NSMutableString alloc] init];
        if(self.listDataArray != nil && self.listDataArray.count > 0)
        {
            for (NSDictionary *dict in self.listDataArray)
            {
                [tableBodyStr appendFormat:@"%@", @"<tr>"];
                for (int i = 0; i < self.listKeyArray.count; i++)
                {
                    NSString *key = [self.listKeyArray objectAtIndex:i];
                    NSString *value = [dict objectForKey:key];
                    [tableBodyStr appendFormat:@"<td>%@</td>", value];
                }
                [tableBodyStr appendFormat:@"%@", @"</tr>"];
            }
        }
        else
        {
            [tableBodyStr appendFormat:@"%@", @"<tr>"];
            [tableBodyStr appendFormat:@"<td colspan=\"%d\">%@</td>", self.listKeyArray.count, @"暂无数据"];
            [tableBodyStr appendFormat:@"%@", @"</tr>"];
        }
        
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"WasteWater" ofType:@"html"];
        NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        
        [html replaceOccurrencesOfString:@"t_WRYMC_t" withString:self.WRYMC options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        [html replaceOccurrencesOfString:@"t_HEADER_t" withString:tableHeaderStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        [html replaceOccurrencesOfString:@"t_LIST_t" withString:tableBodyStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
        [self.myWebView loadHTMLString:html baseURL:nil];

    }
    else
    {
        [self.myWebView loadHTMLString:@"暂无数据" baseURL:nil];
    }
    
}

- (void)processError:(NSError *)error
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
}

@end
