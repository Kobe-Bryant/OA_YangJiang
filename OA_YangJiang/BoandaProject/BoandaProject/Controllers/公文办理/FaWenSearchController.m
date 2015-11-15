//
//  FaWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FaWenSearchController.h"
#import "PDJsonkit.h"
#import "FaWenDetailController.h"
#import "UsersHelper.h"
#import "SharedInformations.h"
#import "ServiceUrlString.h"
#import "NSStringUtil.h"

#define kTag_KSSJ_Field 1
#define kTag_JSSJ_Field 2
#define kTag_NWDW_Field 3
#define kTag_FWLX_Field 4

@interface FaWenSearchController ()

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString;

@end

@implementation FaWenSearchController

@synthesize resultAry,resultTableView,bHaveShowed;
@synthesize titleField,titleLabel,niwenField,niwenLabel,searchBtn,danweiDM;
@synthesize wenHaoLabel,wenHaoField;
@synthesize pageCount,currentPage,wordsPopoverController,wordsSelectViewController;
@synthesize fwlxField,fwlxLabel;
@synthesize isLoading;
@synthesize webHelper,currentTag;
@synthesize fromDateField,fromDateLabel,endDateField,endDateLabel,popController,dateController,urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString {
    NSUInteger location = 0;
    NSUInteger length = [oldString length];
    unichar charBuffer[length];
    [oldString getCharacters:charBuffer];
    int i = 0;
    for (i = 0;i < length;i++) {
        location ++;
       
        if ([characterSet characterIsMember:charBuffer[i]]) {
            break;
        }
    }
    
    return [oldString substringWithRange:NSMakeRange(0,location)];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    niwenField.hidden = NO;
    niwenLabel.hidden = NO;
    searchBtn.hidden = NO;
    wenHaoLabel.hidden = NO;
    wenHaoField.hidden = NO;
    fwlxLabel.hidden = NO;
    fwlxField.hidden = NO;
    
    fromDateField.hidden = NO;
    fromDateLabel.hidden = NO;
    endDateField.hidden = NO;
    endDateLabel.hidden = NO;
}

-(void)showSearchBar:(id)sender{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;
        aItem.title =@"开启查询"; 
       
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        niwenField.hidden = YES;
        niwenLabel.hidden = YES;
        searchBtn.hidden = YES;
        wenHaoLabel.hidden = YES;
        fwlxField.hidden = YES;
        fwlxLabel.hidden = YES;
        wenHaoField.hidden = YES;
        
        fromDateField.hidden = YES;
        fromDateLabel.hidden = YES;
        endDateField.hidden = YES;
        endDateLabel.hidden = YES;
    
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-140, origFrame.size.width, origFrame.size.height+140);        
        [UIView commitAnimations];

    }
    else{
        aItem.title =@"关闭查询";
        
        bHaveShowed = YES;
        CGRect origFrame = resultTableView.frame;
        
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+140, origFrame.size.width, origFrame.size.height-140);
        
        [UIView commitAnimations];
        
    }
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    if (self.wordsPopoverController != nil)
    {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
    if(self.currentTag == kTag_NWDW_Field)
    {
        self.niwenField.text = words;
        NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
        if (depAry == nil) return;
        NSDictionary *aItem = [depAry objectAtIndex:row];
        self.danweiDM = [aItem objectForKey:@"ZZBH"];
    }
    else if (self.currentTag == kTag_FWLX_Field)
    {
        self.fwlxField.text = words;
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发文列表";
    // Do any additional setup after loading the view from its nib.
    [self.niwenField addTarget:self action:@selector(touchDownForDepartment:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = aItem;
    
    bHaveShowed = YES;
    [self showSearchBar:aItem];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_FW_Tag forKey:@"gwType"];
    //[params setObject:@"QUERY_FWLIST" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView DataSource & Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
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
	return [resultAry count];
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
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil)
    {
        itemTitle = @"";
    }
    cell.imageView.image = [UIImage imageNamed:@"fw"];
	cell.textLabel.text = [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] oldString:itemTitle];
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
    if ([lwdate length] > 9)
    {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"发文日期:%@    步骤名称:%@",lwdate,[[resultAry objectAtIndex:indexPath.row] objectForKey:@"BZMC"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *lcslbh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LCSLBH"];
    FaWenDetailController *controller = [[FaWenDetailController alloc] initWithNibName:@"FaWenDetailController" andLCSLBH:lcslbh isBanli:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage == pageCount)
        return;
	if (isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

#pragma mark - Network Handle Method

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
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
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
        {
            bParseError = YES;
        }
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        if ([parsedItemAry count]>0)
        {
            [resultAry addObjectsFromArray:parsedItemAry];
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
    for (int i=0; i< [resultAry count];i++)
    {
        NSDictionary *dicTmp = [resultAry objectAtIndex:i];
        NSString *text = [dicTmp objectForKey:@"DWMC"];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:520.0]+20;
        if(cellHeight < 80)cellHeight = 80.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.resultHeightAry = aryTmp;
    
    [self.resultTableView reloadData];
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self.resultTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //不让日起textfield可以编辑
	return NO;
}

#pragma mark - Event Handler

-(IBAction)btnSearchPressed:(id)sender
{
    if (!resultAry)
    {
        resultAry = [[NSMutableArray alloc] initWithCapacity:30];
    }
    else
    {
        [resultAry removeAllObjects];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_FW_Tag forKey:@"gwType"];
    //[params setObject:@"QUERY_FWLIST" forKey:@"service"];
    //发文标题 wjmc、拟文单位 wjsclj、发文类型 wjlx、发文文号wh、开始日期、截止日期
    if ([titleField.text length] > 0)
    {
        [params setObject:titleField.text forKey:@"wjmc"];
    }
    if ([niwenField.text length] > 0)
    {
        [params setObject:danweiDM forKey:@"wjsclj"];
    }
    if ([wenHaoField.text length] > 0)
    {
        [params setObject:wenHaoField.text forKey:@"wh"];
    }
    if (fwlxField.text.length > 0)
    {
        [params setObject:[SharedInformations getFWLXFromCode:self.fwlxField.text] forKey:@"wjlx"];
    }
    if([fromDateField.text length] > 0 || [endDateField.text length] >0)
    {
        //接收日期JRSJ  厅办收文日期SGRQ 办结日期BJRQ
        [params setObject:@"JRSJ" forKey:@"q_RQNAME"];
        if ([fromDateField.text length] > 0)
        {
            [params setObject:fromDateField.text forKey:@"q_BEGIN"];
        }
        if ([endDateField.text length] > 0)
        {
            [params setObject:endDateField.text forKey:@"q_END"];
        }
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(IBAction)touchFromDate:(id)sender
{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
}

- (IBAction)touchDownForType:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(180, 400);
	tmpController.delegate = self;
    
    tmpController.wordsAry = [NSArray arrayWithObjects:@"阳环函", @"办公室下行文", @"办公室上行文", @"环保局下行文", @"环保局上行文", nil];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)touchDownForDepartment:(id)sender
{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    currentTag = ctrl.tag;
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(180, 400);
	tmpController.delegate = self;
    NSMutableArray *bmNameAry = [NSMutableArray arrayWithCapacity:20];
    NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    
    for (NSDictionary *aItem in depAry)
    {
        [bmNameAry addObject:[aItem objectForKey:@"ZZQC"]];
    }
    tmpController.wordsAry = [[NSArray alloc] initWithArray:bmNameAry];
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopupDate Delegate Method

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
    [popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (currentTag)
        {
			case kTag_KSSJ_Field:
				fromDateField.text = dateString;
				break;
			case kTag_JSSJ_Field:
				endDateField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (currentTag)
        {
			case kTag_KSSJ_Field:
				fromDateField.text = @"";
				break;
			case kTag_JSSJ_Field:
				endDateField.text = @"";
				break;
			default:
				break;
		}
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
