//
//  LaiWenSearchController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LaiWenSearchController.h"
#import "ServiceUrlString.h"
#import "NSStringUtil.h"
#import "PDJsonkit.h"
#import "LaiWenDetailController.h"

@implementation LaiWenSearchController
@synthesize resultAry,resultTableView,bHaveShowed;
@synthesize titleField,titleLabel,danweiLabel,danweiField,searchBtn;
@synthesize wenHaoLabel,wenHaoField;
@synthesize pageCount,currentPage;
@synthesize isLoading,resultHeightAry;
@synthesize webHelper,currentTag;
@synthesize fromDateField,fromDateLabel,endDateField,endDateLabel,popController,dateController;
@synthesize xuhaoLabel,xuhaoField,urlString;

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

#pragma mark - View lifecycle
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    titleField.hidden = NO;
    titleLabel.hidden = NO;
    danweiLabel.hidden = NO;
    danweiField.hidden = NO;
    searchBtn.hidden = NO;
    wenHaoLabel.hidden = NO;
    wenHaoField.hidden = NO;
    xuhaoLabel.hidden = NO;
    xuhaoField.hidden = NO;
    fromDateField.hidden = NO;
    fromDateLabel.hidden = NO;
    endDateField.hidden = NO;
    endDateLabel.hidden = NO;
}


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
    //[params setObject:@"QUERY_LWLIST" forKey:@"service"];
    [params setObject:@"QUERY_YBRWTASK" forKey:@"service"];
    [params setObject:kTaskDone_LW_Tag forKey:@"gwType"];
    
    if ([titleField.text length] > 0)
    {
        [params setObject:titleField.text forKey:@"lwbt"];
    }
    if ([danweiField.text length] > 0)
    {
        [params setObject:danweiField.text forKey:@"lwdw"];
    }
    if ([wenHaoField.text length] > 0)
    {
        [params setObject:wenHaoField.text forKey:@"lwwh"];
    }
    if([fromDateField.text length] > 0 || [endDateField.text length] >0)
    {
        [params setObject:@"1" forKey:@"inType"];
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

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		
		switch (currentTag) {
			case 1:
				fromDateField.text = dateString;
                //     NSLog(@"11%@",XWKSSJ);
                //  self.TZSJDateValue = date;
				break;
			case 2:
				endDateField.text = dateString;
                //  self.JSCLSJDateValue = date;
				
				break;
			default:
				break;
		}
	}else {
        switch (currentTag) {
			case 1:
				fromDateField.text = @"";
				break;
			case 2:
				endDateField.text = @"";
				
				break;
			default:
				break;
		}
    }
    
}

-(void)showSearchBar:(id)sender
{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        CGRect origFrame = resultTableView.frame;
       
        [aItem setTitle:@"开启查询"];
        titleField.hidden = YES;
        titleLabel.hidden = YES;
        danweiLabel.hidden = YES;
        danweiField.hidden = YES;
        searchBtn.hidden = YES;
        wenHaoLabel.hidden = YES;
        wenHaoField.hidden = YES;
        xuhaoLabel.hidden = YES;
        xuhaoField.hidden = YES;
        
  
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
    else
    {
        [aItem setTitle:@"关闭查询"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"来文列表";
    
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
    [params setObject:kTaskDone_LW_Tag forKey:@"gwType"];
    //[params setObject:@"QUERY_LWLIST" forKey:@"service"];
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
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Network Handler Methods

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
        if (pageInfoDic ) {
            pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
            currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
        }
        else
            bParseError = YES;
        
        NSArray *parsedItemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
        
        if (parsedItemAry == nil) {
            bParseError = YES;
        }
        else{
            // [resultAry removeAllObjects];
            [resultAry addObjectsFromArray:parsedItemAry];
        }
        
    }
    else
        bParseError = YES;
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [resultAry count];i++) {
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
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //不让日期textfield可以编辑
	return NO;
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [resultAry count];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[resultHeightAry objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *identifier = @"CellId_laiwensearch";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];

        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

	}
    cell.imageView.image = [UIImage imageNamed:@"lw"];
	NSString *itemTitle = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
	cell.textLabel.text = itemTitle;
    NSString *lwdate = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
    if ([lwdate length] > 9) {
        lwdate = [lwdate substringToIndex:10];
    }
    NSString *lwdw = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"BZMC"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"来文日期:%@    步骤名称:%@", lwdate, lwdw];
    cell.detailTextLabel.textAlignment = UITextAlignmentRight;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *xh = [[resultAry objectAtIndex:indexPath.row] objectForKey:@"LCSLBH"];
    LaiWenDetailController *controller = [[LaiWenDetailController alloc] initWithNibName:@"LaiWenDetailController" andLCSLBH:xh isBanli:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (currentPage == pageCount)
    {
        return;
    }
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

@end
