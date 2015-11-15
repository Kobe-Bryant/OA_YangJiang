//
//  WRYListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WRYListViewController.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "WRYDetailViewController.h"
#import "CommenWordsViewController.h"

#define WRY_LIST_SERVICE_NAME @"QUERY_WRY_LIST"
#define WRY_LIST_SZQY_TAG 101 //所在区域
#define WRY_LIST_JGJB_TAG 102 //监管级别
#define WRY_LIST_HYLX_TAG 103 //行业类型

#define WRY_SERVICE_NORMAL_TAG 104 //正常请求
#define WRY_SERVICE_SEARCH_TAG 105 //搜索

@interface WRYListViewController () <WordsDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) int currentDwlx;//单位类型
@property (nonatomic,assign) int currentJgjb;//监管级别

@end

@implementation WRYListViewController

@synthesize dataArray,isLoading,urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"污染源管理";
    
    UIBarButtonItem *rightSearchBarButton = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightSearchBarButton;
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    //初始化查询区域
    bHaveShowed = YES;
    [self rightBarButtonClick:rightSearchBarButton];
    
    //请求数据
    currentPage = 1;
    pageCount = 0;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:WRY_LIST_SERVICE_NAME forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
    
    [self.szqyField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [self.jgjbField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [self.hylxField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    self.wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.wordSelectCtrl];
    self.wordsPopover = popCtrl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    
    NSDictionary *tmpParsedJsonDict = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict)
    {
        pageCount = [[[tmpParsedJsonDict objectForKey:@"totalCount"] objectForKey:@"ZS"] intValue];
        if(pageCount > 0)
        {
            [self.dataArray addObjectsFromArray:[tmpParsedJsonDict objectForKey:@"data"]];
        }
    }
    else
    {
        bParseError = YES;
    }

    [self.resultTableView reloadData];
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据出错." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)processError:(NSError *)error
{
    isLoading = NO;
    [self.resultTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}

#pragma mark - UITableView Delegate & DataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"查询结果";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = @"  查询结果";
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
    NSString *wrymc_value = [item objectForKey:@"WRYMC"];
    NSString *wrydz_value = [NSString stringWithFormat:@"地址：%@", [item objectForKey:@"DWDZ"]];
    NSString *wryhylx_value = [NSString stringWithFormat:@"行业类型：%@", [item objectForKey:@"HYLX"]];
    NSString *wryszqy_value = [NSString stringWithFormat:@"所在区域：%@", [self getRegionNameWithCode:[item objectForKey:@"GXGS"]]];
    NSString *wryjgjb_value = [NSString stringWithFormat:@"监管级别：%@", [self getJGJBString:[item objectForKey:@"GLJBDM"]]];
    if([[item objectForKey:@"GLJBDM"] isEqualToString:@"888"])
    {
        wryjgjb_value = @"监管级别：";
    }
    
    int rowNumber = [[item objectForKey:@"ROWNUMBER"] intValue];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:rowNumber-1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRYDetailViewController *detail = [[WRYDetailViewController alloc] initWithNibName:@"WRYDetailViewController" bundle:nil];
    detail.wrybh = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"WRYBH"];
    detail.wrymc = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"WRYMC"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int page = (pageCount%100 == 0) ? (pageCount/100) : (pageCount/100)+1;
    if (currentPage == page || pageCount == 0)
        return;
	if (isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

#pragma mark - Button Click Handler

- (void)rightBarButtonClick:(UIBarButtonItem *)sender
{
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = self.resultTableView.frame;
        sender.title =@"开启查询";
        
        self.dwmcLabel.hidden = YES;
        self.dwmcField.hidden = YES;
        self.szqyField.hidden = YES;
        self.szqyLabel.hidden = YES;
        self.jgjbField.hidden = YES;
        self.jgjbLabel.hidden = YES;
        self.hylxField.hidden = YES;
        self.hylxLabel.hidden = YES;
        self.searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.resultTableView.frame = CGRectMake(origFrame.origin.x,origFrame.origin.y-100, origFrame.size.width, origFrame.size.height+100);
        [UIView commitAnimations];
    }
    else
    {
        sender.title =@"关闭查询";
        
        bHaveShowed = YES;
        CGRect origFrame = self.resultTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+100, origFrame.size.width, origFrame.size.height-100);
        
        [UIView commitAnimations];
    }
}

- (IBAction)searchButtonClick:(id)sender
{
    if(self.dataArray)
    {
        [self.dataArray removeAllObjects];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:WRY_LIST_SERVICE_NAME forKey:@"service"];
    //单位名称
    if(self.dwmcField.text != nil && self.dwmcField.text.length > 0)
    {
        [params setObject:self.dwmcField.text forKey:@"wrymc"];
    }
    //监管级别
    if(self.jgjbField.text != nil && self.jgjbField.text.length > 0)
    {
        if([self.jgjbField.text isEqualToString:@"国控"])
        {
            [params setObject:@"1" forKey:@"jgjb"];
        }
        if([self.jgjbField.text isEqualToString:@"省控"])
        {
            [params setObject:@"2" forKey:@"jgjb"];
        }
        if([self.jgjbField.text isEqualToString:@"市控"])
        {
            [params setObject:@"3" forKey:@"jgjb"];
        }
        if([self.jgjbField.text isEqualToString:@"非控"])
        {
            [params setObject:@"9" forKey:@"jgjb"];
        }
    }
    //行政区域
    if(self.szqyField.text != nil && self.szqyField.text.length > 0)
    {
        [params setObject:[self getRegionCodseWithName:self.szqyField.text] forKey:@"szqx"];
    }
    //单位类型
    if(self.hylxField.text != nil && self.hylxField.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.currentDwlx] forKey:@"dwlx"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    pageCount = 0;
    currentPage = 1;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)selectWord:(id)sender
{
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    
    UITextField *field = (UITextField *)sender;
    field.text = @"";
    self.currentTag = field.tag;
    
    switch (self.currentTag)
    {
        case WRY_LIST_SZQY_TAG:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"江城区",@"阳西县",@"阳东县",@"海陵区",@"岗侨区",@"阳春市", nil];
            break;
        case WRY_LIST_JGJB_TAG:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"国控",@"省控",@"市控",@"非控", nil];
            break;
        case WRY_LIST_HYLX_TAG:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"工业",@"三产",@"建筑施工",@"市政设施",@"医疗机构",@"其它", nil];
            break;
        default:
            break;
    }
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:[field bounds] inView:field permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Private Method

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.dwmcLabel.hidden = NO;
    self.dwmcField.hidden = NO;
    self.szqyField.hidden = NO;
    self.szqyLabel.hidden = NO;
    self.jgjbField.hidden = NO;
    self.jgjbLabel.hidden = NO;
    self.hylxField.hidden = NO;
    self.hylxLabel.hidden = NO;
    self.searchButton.hidden = NO;
}

//根据区域代码获得区域名称
- (NSString *)getRegionNameWithCode:(NSString *)code
{
    if(code == nil || [code isEqualToString:@""])
    {
        return @"";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"阳江市" forKey:@"441700000000"];
    [dict setObject:@"江城区" forKey:@"441702000000"];
    [dict setObject:@"阳西县" forKey:@"441721000000"];
    [dict setObject:@"阳东县" forKey:@"441723000000"];
    [dict setObject:@"海陵区" forKey:@"441771000000"];
    [dict setObject:@"岗侨区" forKey:@"441772000000"];
    [dict setObject:@"阳春市" forKey:@"441781000000"];
    return [dict objectForKey:code];
}

- (NSString *)getRegionCodseWithName:(NSString *)name
{
    if(name != nil && name.length > 0)
    {
        if([name isEqualToString:@"江城区"])
        {
            return @"441702000000";
        }
        else if ([name isEqualToString:@"阳西县"])
        {
            return @"441721000000";
        }
        else if ([name isEqualToString:@"阳东县"])
        {
            return @"441723000000";
        }
        else if ([name isEqualToString:@"海陵区"])
        {
            return @"441771000000";
        }
        else if ([name isEqualToString:@"岗侨区"])
        {
            return @"441772000000";
        }
        else if ([name isEqualToString:@"阳春市"])
        {
            return @"441781000000";
        }
        else
        {
            return @"441700000000";//默认
        }
    }
    else
    {
        return @"441700000000";//默认
    }
}

- (NSString *)getJGJBString:(NSString *)code
{
    NSString *ret = @"";
    if([code isEqualToString:@"1"])
    {
        ret = @"国控";
    }
    else if([self.jgjbField.text isEqualToString:@"2"])
    {
         ret = @"省控";
    }
    else if([self.jgjbField.text isEqualToString:@"3"])
    {
        ret = @"市控";
    }
    else if([self.jgjbField.text isEqualToString:@"9"])
    {
        ret = @"非控";
    }
    return ret;
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (self.currentTag)
    {
        case WRY_LIST_SZQY_TAG:
            self.szqyField.text = words;
            break;
        case WRY_LIST_JGJB_TAG:
            self.jgjbField.text = words;
            break;
        case WRY_LIST_HYLX_TAG:
        {
            self.currentDwlx = row;
            self.hylxField.text = words;
        }
            break;
        default:
            break;
    }
    
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == WRY_LIST_HYLX_TAG || textField.tag == WRY_LIST_JGJB_TAG || textField.tag == WRY_LIST_SZQY_TAG)
    {
        return NO;
    }
    return YES;
}

@end
