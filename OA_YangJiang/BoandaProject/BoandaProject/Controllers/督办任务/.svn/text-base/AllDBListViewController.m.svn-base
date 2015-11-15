//
//  AllDBListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-14.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "AllDBListViewController.h"
#import "DBDetailViewController.h"
#import "SharedInformations.h"
#import "DBRWInfoCell.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"

#define Start_Date_Tag 1
#define End_Date_Tag 2

@interface AllDBListViewController ()

@end

@implementation AllDBListViewController

@synthesize searchButton,titleField, titleLabel, startTimeLabel, startTimeField, endTimeLabel, endTimeField,resultTableView;
@synthesize statusLabel, statusSegment;
@synthesize dateController, popController;
@synthesize urlString, webHelper, isLoading, pageCount, currentPage;

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
    
    self.title = @"任务督办查询";
    
    //在导航栏添加按钮
    UIBarButtonItem *rightSearchBarButton = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(showSearchField:)];
    self.navigationItem.rightBarButtonItem = rightSearchBarButton;
    
    //初始化查询区域
    bHaveShowed = YES;
    [self showSearchField:rightSearchBarButton];
    
    resultAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    //初始化时间选择
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    //[params setObject:Service_Name forKey:@"service"];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_RWDB_Tag forKey:@"gwType"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    currentStatus = 0;
    
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
    //NSLog(@"%@", strUrl);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(popController)
    {
        [popController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidUnload
{
    [self setResultTableView:nil];
    [self setTitleLabel:nil];
    [self setTitleField:nil];
    [self setStartTimeLabel:nil];
    [self setStartTimeField:nil];
    [self setEndTimeLabel:nil];
    [self setEndTimeField:nil];
    [self setSearchButton:nil];
    [self setStatusLabel:nil];
    [self setStatusSegment:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate Method

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *identifier = @"DBRWInfoCell";
	DBRWInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DBRWInfoCell" owner:nil options:nil] lastObject];
    }
    
    NSDictionary *tmpDict = [resultAry objectAtIndex:indexPath.row] ;
    //序号
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", [tmpDict objectForKey:@"ROWNUMBER"]];
    //任务名称
    cell.rwmcLabel.text = [tmpDict objectForKey:@"DWMC"];
    //督办人
    cell.dbrLabel.text = [tmpDict objectForKey:@"YHM"];
    //紧急程度
    NSString *jjcdStr = [SharedInformations getJJCDFromInt:[[tmpDict objectForKey:@"S"] intValue]];
    cell.jjcdLabel.text = jjcdStr;
    //督办时间
    cell.dbsjLabel.text = [self parserDateString:[tmpDict objectForKey:@"CJSJ"] fromDateFormatter:@"yyyy-MM-dd HH:mm:ss" toDateFormatter:@"yyyy-MM-dd"];
    //任务期限
    cell.rwqxLabel.text = [self parserDateString:[tmpDict objectForKey:@"JSSJ"] fromDateFormatter:@"yyyy-MM-dd HH:mm:ss" toDateFormatter:@"yyyy-MM-dd"];
	return cell;*/
    static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        
	}
    
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
	cell.textLabel.text = itemTitle;
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
    if ([lwdate length] > 9) {
        lwdate = [lwdate substringToIndex:10];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"督办日期:%@    步骤名称:%@",lwdate,[[resultAry objectAtIndex:indexPath.row] objectForKey:@"LCMC"]];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
    cell.imageView.image = [UIImage imageNamed:@"dbrw"];
    // cell.detailTextLabel.textColor = [UIColor blueColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.resultHeightAry == nil || self.resultHeightAry.count <= 0)
    {
        return 80;
    }
    else
    {
        return [[self.resultHeightAry objectAtIndex:indexPath.row] floatValue];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  搜索结果列表(%d条)", totalCount];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dbid = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LCSLBH"];
    DBDetailViewController *detail = [[DBDetailViewController alloc] initWithNibName:@"DBDetailViewController" andLCSLBH:dbid andBZBH:nil isBanli:NO];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Button Click Handle

- (IBAction)statusSegmentClick:(UISegmentedControl *)sender
{
    currentStatus = sender.selectedSegmentIndex;
}

- (IBAction)touchDateField:(UITextField *)sender
{
    [popController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = sender.tag;
}

- (IBAction)searchButtonClick:(id)sender
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
    [params setObject:kTaskDone_RWDB_Tag forKey:@"gwType"];
    
    
    if ([titleField.text length] > 0)
    {
        [params setObject:titleField.text forKey:@"rwmc"];
    }
    if([startTimeField.text length] > 0 || [endTimeField.text length] >0)
    {
        if ([startTimeField.text length] > 0)
        {
            [params setObject:startTimeField.text forKey:@"q_BEGIN"];
        }
        if ([endTimeField.text length] > 0)
        {
            [params setObject:endTimeField.text forKey:@"q_END"];
        }
    }
    if(currentStatus != 0)
    {
        [params setObject:[NSNumber numberWithInt:currentStatus-1] forKey:@"jjcd"];
    }
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)showSearchField:(UIBarButtonItem *)sender
{
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;
        sender.title =@"开启查询";
        
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        startTimeField.hidden = YES;
        startTimeLabel.hidden = YES;
        endTimeField.hidden = YES;
        endTimeLabel.hidden = YES;
        statusLabel.hidden = YES;
        statusSegment.hidden = YES;
        searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        resultTableView.frame = CGRectMake(origFrame.origin.x,origFrame.origin.y-100, origFrame.size.width, origFrame.size.height+100);
        [UIView commitAnimations];
    }
    else
    {
        sender.title =@"关闭查询";
        
        bHaveShowed = YES;
        CGRect origFrame = resultTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+100, origFrame.size.width, origFrame.size.height-100);
        
        [UIView commitAnimations];
        
    }
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    startTimeField.hidden = NO;
    startTimeLabel.hidden = NO;
    endTimeField.hidden = NO;
    endTimeLabel.hidden = NO;
    statusLabel.hidden = NO;
    statusSegment.hidden = NO;
    searchButton.hidden = NO;
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == titleField)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - PopupDateController Delegate Method

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date
{
    [popController dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		switch (currentTag)
        {
			case Start_Date_Tag:
				startTimeField.text = dateString;
				break;
			case End_Date_Tag:
				endTimeField.text = dateString;
				break;
			default:
				break;
		}
	}
    else
    {
        switch (currentTag)
        {
			case Start_Date_Tag:
				startTimeField.text = @"";
				break;
			case End_Date_Tag:
				endTimeField.text = @"";
				break;
			default:
				break;
		}
    }
}

#pragma mark - Network Handler

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

#pragma mark - Private Method

- (NSString *)parserDateString:(NSString *)dateStr fromDateFormatter:(NSString *)fromDateFormatter toDateFormatter:(NSString *)toDateFormatter
{
    if([dateStr isEqualToString:@""] || [dateStr isEqual:[NSNull null]] || dateStr.length < 10)
    {
        return @"";
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:fromDateFormatter];
    NSDate *date = [df dateFromString:dateStr];
    [df setDateFormat:toDateFormatter];
    return [df stringFromDate:date];
}

@end
