//
//  PingShenHuiSearchViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-15.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "PingShenHuiSearchViewController.h"
#import "PingShenHuiDetailViewController.h"
#import "PopupDateViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"

@interface PingShenHuiSearchViewController ()<PopupDateDelegate,UITextFieldDelegate>

@property (nonatomic, assign) BOOL bHaveShowed;
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, strong) NSMutableArray *resultAry;
@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;

@end

#define kFieldTag_KSSJ 100 //开始时间
#define kFieldTag_JSSJ 101

@implementation PingShenHuiSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)makeCustomView
{
    self.hyxxField.placeholder = @"输入会议通知的标题进行查询";
    
    self.kssjField.tag = kFieldTag_KSSJ;
    self.jssjField.tag = kFieldTag_JSSJ;
    
    [self.kssjField addTarget:self action:@selector(touchDownForDate:) forControlEvents:UIControlEventTouchDown];
    [self.jssjField addTarget:self action:@selector(touchDownForDate:) forControlEvents:UIControlEventTouchDown];
    [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = aItem;
    
    self.bHaveShowed = YES;
    [self showSearchBar:aItem];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	self.dateController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"会议通知查询";
    
    [self makeCustomView];
    
    self.resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_HYTZ_Tag forKey:@"gwType"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.hyxxLabel.hidden = NO;
    self.hyxxField.hidden = NO;
    self.kssjxLabel.hidden = NO;
    self.kssjField.hidden = NO;
    self.jssjLabel.hidden = NO;
    self.jssjField.hidden = NO;
    self.searchButton.hidden = NO;
}

#pragma mark - Event Handler Methods

//搜索按钮点击
- (void)searchButtonClicked:(id)sender
{
    self.resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_HYTZ_Tag forKey:@"gwType"];
    if(self.hyxxField.text.length > 0)
    {
        [params setObject:self.hyxxField.text forKey:@"hymc"];
    }
    if(self.kssjField.text.length > 0)
    {
        [params setObject:self.kssjField.text forKey:@"startDate"];
    }
    if(self.jssjField.text.length > 0)
    {
        [params setObject:self.jssjField.text forKey:@"endDate"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

//开始查询/关闭查询按钮点击
- (void)showSearchBar:(id)sender
{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(self.bHaveShowed)
    {
        self.bHaveShowed = NO;
        CGRect origFrame = self.listTableView.frame;
        aItem.title = @"开启查询";
        
        self.hyxxLabel.hidden = YES;
        self.hyxxField.hidden = YES;
        self.kssjxLabel.hidden = YES;
        self.kssjField.hidden = YES;
        self.jssjLabel.hidden = YES;
        self.jssjField.hidden = YES;
        self.searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.listTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.01f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.listTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-90, origFrame.size.width, origFrame.size.height+90);
        [UIView commitAnimations];
    }
    else
    {
        aItem.title = @"关闭查询";
        
        self.bHaveShowed = YES;
        CGRect origFrame = self.listTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.listTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.01f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.listTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+90, origFrame.size.width, origFrame.size.height-90);
        
        [UIView commitAnimations];
    }
}

//获取日期
- (void)touchDownForDate:(UITextField *)sender
{
    self.currentTag = sender.tag;
    if(self.popController.isPopoverVisible)
    {
        [self.popController dismissPopoverAnimated:YES];
    }
    [self.popController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - UITableView DataSource & Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = @"  搜索结果列表";
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.resultHeightAry objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
	NSString *itemTitle = [[self.resultAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil)
    {
        itemTitle = @"";
    }
    cell.imageView.image = [UIImage imageNamed:@"tzgg"];
	cell.textLabel.text = itemTitle;
    NSString *lwdate = [[self.resultAry objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
    if ([lwdate length] > 9)
    {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"拟制日期:%@    步骤名称:%@",lwdate,[[self.resultAry objectAtIndex:indexPath.row] objectForKey:@"BZMC"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *lcslbh = [[self.resultAry objectAtIndex:indexPath.row] objectForKey:@"LCSLBH"];
    PingShenHuiDetailViewController *detail = [[PingShenHuiDetailViewController alloc] initWithNibName:Nil andLCSLBH:lcslbh isBanli:NO];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.currentPage == self.pageCount)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d", self.urlString, self.currentPage];
        self.isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

#pragma mark - Network Handle Method

- (void)processWebData:(NSData*)webData
{
    self.isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic )
        {
            self.pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            self.currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
        {
            bParseError = YES;
        }
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        if ([parsedItemAry count]>0)
        {
            [self.resultAry addObjectsFromArray:parsedItemAry];
        }
    }
    else
    {
        bParseError = YES;
    }
    if (bParseError)
    {
        [self showAlertMessage:@"获取数据出错."];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [self.resultAry count];i++)
    {
        NSDictionary *dicTmp = [self.resultAry objectAtIndex:i];
        NSString *text = [dicTmp objectForKey:@"DWMC"];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:520.0]+20;
        if(cellHeight < 80)cellHeight = 80.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.resultHeightAry = aryTmp;
    
    [self.listTableView reloadData];
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self.listTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}

#pragma mark - PopupDateViewController Delegate Method

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date
{
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (self.currentTag)
        {
			case kFieldTag_KSSJ:
				self.kssjField.text = dateString;
				break;
			case kFieldTag_JSSJ:
				self.jssjField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (self.currentTag)
        {
			case kFieldTag_KSSJ:
				self.kssjField.text = @"";
				break;
			case kFieldTag_JSSJ:
				self.jssjField.text = @"";
				break;
			default:
				break;
		}
    }
}

@end
