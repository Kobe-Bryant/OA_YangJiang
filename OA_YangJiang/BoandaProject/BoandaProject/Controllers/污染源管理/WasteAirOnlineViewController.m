//
//  WasteAirOnlineViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-12-5.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WasteAirOnlineViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "OtherFactorListViewController.h"

@interface WasteAirOnlineViewController ()
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) NSArray *listDataArray;

@property (nonatomic, strong) NSArray *currentShowFactorNames;
@property (nonatomic, strong) NSArray *currentShowFactorKeys;
@property (nonatomic, strong) UIPopoverController *factoryPopoverController;
@property (nonatomic, strong) OtherFactorListViewController *factoryViewController;
@end

@implementation WasteAirOnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"废气实时数据";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isLoading = NO;
    [self requestData];
    
    self.currentShowFactorNames = [NSArray arrayWithObjects:@"标态烟气量(m³/s)", @"烟尘实测浓度(mg/m³)", @"SO2实测浓度(mg/m³)", @"烟气流速(m³/h)", @"烟气压力(MPa)", nil];
    self.currentShowFactorKeys = [NSArray arrayWithObjects:@"n_flow", @"a_dust", @"a_so2", @"speed", @"pressure", nil];
    
    self.factoryViewController = [[OtherFactorListViewController alloc] init];
    self.factoryViewController.selectedFactorNames = [[NSMutableArray alloc] initWithArray:self.currentShowFactorNames];
    self.factoryViewController.delegate = self;
    self.factoryViewController.selectedFactorKeys = [[NSMutableArray alloc] initWithArray:self.currentShowFactorKeys];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.factoryViewController];
    self.factoryPopoverController = [[UIPopoverController alloc] initWithContentViewController:navi];
    self.factoryViewController.contentSizeForViewInPopover = CGSizeMake(320, 480);
    self.factoryViewController.parentController = self.factoryPopoverController;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"其他监测因子" style:UIBarButtonItemStyleBordered target:self action:@selector(onRightBarClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.myWebView.backgroundColor = [UIColor clearColor];
    [(UIScrollView *)[[self.myWebView subviews] objectAtIndex:0] setBounces:NO];
    [self.myWebView setScalesPageToFit:NO];//yes:根据webview自适应，NO：根据内容自适应
    [self.myWebView setDelegate:self];
    [self.view addSubview:self.myWebView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.factoryPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - NetWork Hander Methods

- (void)requestData
{
    self.isLoading = YES;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setObject:@"QUERY_ZAJC_FQQYSS_LIST" forKey:@"service"];
    [params setObject:self.PSCODE forKey:@"PSCODE"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    NSMutableString *log = [[NSMutableString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    [log replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, log.length)];
    //NSLog(@"%@", log);
    
    NSArray *tmpAry = [log objectFromJSONString];
    if(tmpAry!= nil && tmpAry.count > 0)
    {
        NSDictionary *tmpDict = [tmpAry objectAtIndex:0];
        self.listDataArray = [tmpDict objectForKey:@"dataInfos"];
    }
    
    NSString *html = [self generateHtmlData];
    [self.myWebView loadHTMLString:html baseURL:nil];
}

- (void)processError:(NSError *)error
{
    
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
}

#pragma mark - Event Handler Method

- (void)onRightBarClick:(UIBarButtonItem *)sender
{
    [self.factoryPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - ChooseFacotr Delegate Method

- (void)passWithSelectedNameValue:(NSArray *)nameAry andWithKeyValue:(NSArray *)keyAry
{
    self.currentShowFactorKeys = keyAry;
    self.currentShowFactorNames = nameAry;
    NSString *html = [self generateHtmlData];
    [self.myWebView loadHTMLString:html baseURL:nil];
}

- (NSString *)generateHtmlData
{
    //生成HTML的Table Header
    NSMutableString *tableHeaderStr = [[NSMutableString alloc] init];
    [tableHeaderStr appendFormat:@"%@", @"<tr>"];
    [tableHeaderStr appendFormat:@"<td width=\"%d%%\">%@</td>", 10, @"序号"];
    [tableHeaderStr appendFormat:@"<td width=\"%d%%\">%@</td>", 30, @"时间"];
    for (int i = 0; i < self.currentShowFactorNames.count; i++)
    {
        NSString *key = [self.currentShowFactorNames objectAtIndex:i];
        [tableHeaderStr appendFormat:@"<td width=\"%d%%\">%@</td>", 12, key];
    }
    [tableHeaderStr appendFormat:@"%@", @"</tr>"];
    
    //生成HTML的Table Body
    NSMutableString *tableBodyStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.listDataArray.count ; i++)
    {
        NSDictionary *dict = [self.listDataArray objectAtIndex:i];
        [tableBodyStr appendFormat:@"%@", @"<tr>"];
        [tableBodyStr appendFormat:@"<td>%d</td>", i+1];//序号
        NSString *gettime = [dict objectForKey:@"gettime"];
        [tableBodyStr appendFormat:@"<td>%@</td>", gettime];//时间
        for (int j = 0; j < self.currentShowFactorKeys.count; j++)
        {
            NSString *key = [self.currentShowFactorKeys objectAtIndex:j];
            NSString *value = [dict objectForKey:key];
            [tableBodyStr appendFormat:@"<td>%@</td>", value];
        }
        [tableBodyStr appendFormat:@"%@", @"</tr>"];
    }
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"WasteAir" ofType:@"html"];
    NSMutableString *html = [[NSMutableString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    [html replaceOccurrencesOfString:@"t_WRYMC_t" withString:self.WRYMC options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
    //替换HTML表头
    [html replaceOccurrencesOfString:@"t_HEADER_t" withString:tableHeaderStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
    //替换HTML的表的内容
    if(self.listDataArray == nil || self.listDataArray.count <= 0)
    {
        [html replaceOccurrencesOfString:@"t_LIST_t" withString:@" <tr><td colspan=\"7\">暂无数据</td></tr>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
    }
    else
    {
        [html replaceOccurrencesOfString:@"t_LIST_t" withString:tableBodyStr options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
    }
    return html;
}

@end
