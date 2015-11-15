//
//  LinDaoRiChenController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LinDaoRiChenController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "SystemConfigContext.h"
#import "UITableViewCell+Custom.h"
#import "SystemConfigContext.h"

@implementation LinDaoRiChenController

@synthesize rcTableView,daysPngName,curDayInAWeek,dicWeekTodo,labelWeekRange;
@synthesize curShowDate;
@synthesize isLoading,dicWeekHeight;
@synthesize webHelper;
@synthesize deptID,allDeptAry,wordsPopoverController,wordsSelectViewController;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"日程安排";
    
    self.usersHelper = [[UsersHelper alloc] init];
    //判断当前用户是什么部门 局领导和办公室都可以查看全部日程,其他只查看自己科室的日程
    self.deptID = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"depart"];
    
    self.bgsId = @"41702";
    self.shbjldId = @"41701";
    if([self.deptID isEqualToString:self.bgsId] || [self.deptID isEqualToString:self.shbjldId])
    {
        //办公室 厅领导
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"选择部门" style:UIBarButtonItemStylePlain target:self action:@selector(chooseDepart:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }

    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.curShowDate = [NSDate date];
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	rcTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 106)];
    UIImageView *imgView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"top.png"]];
    [headerView addSubview:imgView];
    UILabel *rangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(256, 50, 256, 40)];
    
    rangeLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:rangeLabel];
    rcTableView.tableHeaderView = headerView;
    self.labelWeekRange = rangeLabel;
    
    self.daysPngName = [NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    [self getWeekDatas:[NSDate date] andType:-1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if (self.wordsPopoverController != nil)
    {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 网络数据处理

-(void)processWebData:(NSData*)webData
{
    if([self.deptID isEqualToString:self.bgsId] || [self.deptID isEqualToString:self.shbjldId])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    if([webData length] <=0 )
    {
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        NSDictionary *dicTmp = [tmpParsedJsonAry lastObject];
        NSMutableArray *ary0 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"0"]];
        NSMutableArray *ary1 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"1"]];
        NSMutableArray *ary2 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"2"]];
        NSMutableArray *ary3 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"3"]];
        NSMutableArray *ary4 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"4"]];
        NSMutableArray *ary5 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"5"]];
        NSMutableArray *ary6 = [NSMutableArray arrayWithArray: [dicTmp objectForKey:@"6"]];
        self.dicWeekTodo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:ary0,ary1,ary2,ary3,ary4,ary5,ary6, [dicTmp objectForKey:@"dateInfo"],nil] forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"dateInfo", nil]];
    }
    
    NSMutableDictionary *dictmp = [[NSMutableDictionary alloc] initWithCapacity:20];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    for (int i = 0; i < 7; i++)
    {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSArray *ary = [dicWeekTodo objectForKey:key];
        int aryCount = [ary count];
        if (aryCount > 0)
        {
            NSMutableArray *aryHeights = [NSMutableArray arrayWithCapacity:5];
            for (int j = 0; j < aryCount; j++)
            {
                NSDictionary *dicTmp = [ary objectAtIndex:j];
                CGFloat aHeight = [self calculateTextHeight:[dicTmp objectForKey:@"PTRY"] byFont:font andWidth:510];
                if (aHeight < 24)
                {
                    aHeight = 24.0;
                }
                [aryHeights addObject:[NSNumber numberWithFloat:aHeight]];
            }
            [dictmp setObject:aryHeights forKey:key];
        }
    }
    self.dicWeekHeight = dictmp;
    [self.rcTableView reloadData];
}

-(void)processError:(NSError *)error
{
    if([self.deptID isEqualToString:self.bgsId] || [self.deptID isEqualToString:self.shbjldId])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return;
}

-(void)getWeekDatas:(NSDate*)curDate andType:(NSInteger)type
{
    //请求日程服务前先将导航栏右边的按钮设为不可用
    if([self.deptID isEqualToString:self.bgsId] || [self.deptID isEqualToString:self.shbjldId])
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)fromDate:[NSDate date]];
    curDayInAWeek = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    NSString *fromDateString = nil;
    NSString *endDateString = nil;


    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_RDRCLIST" forKey:@"service"];
    [params setObject:self.deptID forKey:@"bmbh"];//部门编号

    if (type == 0)
    {
        //上一周
        NSDate *fromDate = [NSDate dateWithTimeInterval:(-6-curDayInAWeek)*60*60*24 sinceDate:curDate];
        NSDate *endDate = [NSDate dateWithTimeInterval:(-curDayInAWeek)*60*60*24 sinceDate:curDate];
        fromDateString = [dateFormatter stringFromDate:fromDate];
        endDateString = [dateFormatter stringFromDate:endDate];
        
        NSString *curDateString = [dateFormatter stringFromDate:curDate];
        /*
        if (![curDate isEqualToDate:[NSDate date]])
        {
            curDayInAWeek = NOT_CURWEEK;
        }*/
        if(![self existBetweenFromDate:fromDateString andEndDate:endDateString])
        {
            curDayInAWeek = NOT_CURWEEK;
        }

        [params setObject:curDateString forKey:@"current"];
        [params setObject:@"0" forKey:@"type"];

    }
    else if (type == 1)
    {
        //下一周
        NSDate *fromDate = [NSDate dateWithTimeInterval:(8-curDayInAWeek)*60*60*24 sinceDate:curDate];
        NSDate *endDate = [NSDate dateWithTimeInterval:(14-curDayInAWeek)*60*60*24 sinceDate:curDate];
        fromDateString = [dateFormatter stringFromDate:fromDate];
        endDateString = [dateFormatter stringFromDate:endDate];
        /*if (![curDate isEqualToDate:[NSDate date]])
        {
            curDayInAWeek = NOT_CURWEEK;
        }*/
        
        if(![self existBetweenFromDate:fromDateString andEndDate:endDateString])
        {
            curDayInAWeek = NOT_CURWEEK; 
        }
        
        NSString *curDateString = [dateFormatter stringFromDate:curDate];

        [params setObject:curDateString forKey:@"current"];
        [params setObject:@"1" forKey:@"type"];
    }
    else
    {
        NSDate *fromDate = [NSDate dateWithTimeIntervalSinceNow:(1-curDayInAWeek)*60*60*24];
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:(7-curDayInAWeek)*60*60*24];
        fromDateString = [dateFormatter stringFromDate:fromDate];
        endDateString = [dateFormatter stringFromDate:endDate];
    }
    
    labelWeekRange.text = [NSString stringWithFormat:@"(%@ - %@)",fromDateString,endDateString];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - 按钮点击

-(IBAction)lastWeekPressed:(id)sender
{
    [self getWeekDatas:curShowDate andType:0];
    self.curShowDate = [NSDate dateWithTimeInterval:-7*60*60*24 sinceDate:curShowDate];
}

-(IBAction)nextWeekPressed:(id)sender
{
    [self getWeekDatas:curShowDate andType:1];
    self.curShowDate = [NSDate dateWithTimeInterval:7*60*60*24 sinceDate:curShowDate];
}

-(void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseDepart:(id)sender
{
    if(self.wordsPopoverController)
    {
        [self.wordsPopoverController dismissPopoverAnimated:YES];
    }
    
    NSMutableArray *bmNameAry = [NSMutableArray arrayWithCapacity:20];
    NSArray *depAry = [[[UsersHelper alloc] init] queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    
    for (NSDictionary *aItem in depAry) {
        [bmNameAry addObject:[aItem objectForKey:@"ZZQC"]];
    }
    self.allDeptAry = bmNameAry;
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
    tmpController.contentSizeForViewInPopover = CGSizeMake(250, 400);
    tmpController.delegate = self;
    tmpController.wordsAry = self.allDeptAry;
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
    self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
	[self.wordsSelectViewController.tableView reloadData];
    [self.wordsPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

#pragma mark - UITableView Delegate Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.section];
    NSArray *ary = [dicWeekHeight objectForKey:key];
    if ([ary count] <= 0)
    {
        return 100;
    }
    CGFloat nHeight = [[ary objectAtIndex:indexPath.row] floatValue];
	return 150+nHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%d",section];
    if([[dicWeekTodo objectForKey:key] count] == 0)
        return 1;
    return [[dicWeekTodo objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = nil;
    
    if (indexPath.row == 0)
    {
        //仅在row＝0 有图标
        NSString *pngName = nil;
        if (curDayInAWeek == indexPath.section+1)
        {
            pngName = [NSString stringWithFormat:@"%@_.png",[daysPngName objectAtIndex:indexPath.section]];
        }
        else
        {
            pngName = [NSString stringWithFormat:@"%@.png",[daysPngName objectAtIndex:indexPath.section]];
        }
        image = [UIImage imageNamed:pngName];
    }
    NSString *key = [NSString stringWithFormat:@"%d",indexPath.section];
    if ([[dicWeekTodo objectForKey:key] count] == 0) {
        
        UIImageView *imgView = nil;
        UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom0"];
        if (aCell == nil) {
            aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom0"];
        }
        
        CGRect tRect1 = CGRectMake(-5, -5, 110, 98);
        imgView = [[UIImageView alloc] initWithFrame:tRect1];
        imgView.image = image;
        [aCell.contentView addSubview:imgView];
        
        UILabel *labelTmp = [[UILabel alloc] initWithFrame: CGRectMake(80, 40, 500, 40)]; //此处使用id定义任何控件对象
        [labelTmp setBackgroundColor:[UIColor clearColor]];
        
        labelTmp.font = [UIFont fontWithName:@"Helvetica" size:19.0];
        
        labelTmp.textAlignment = UITextAlignmentCenter;
        labelTmp.text = @"提示：今天无日程。";
        [aCell.contentView addSubview:labelTmp];
        
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return aCell;
    }
    
    NSArray *ary = [dicWeekTodo objectForKey:key];
    NSDictionary *dicTmp = [ary objectAtIndex:indexPath.row];
    NSString *date = [[dicWeekTodo objectForKey:@"dateInfo"] objectAtIndex:indexPath.section];
    
    if ([date length] >=10) {
        date = [date substringToIndex:10];
    }
    
    
    NSArray *aryHeight = [dicWeekHeight objectForKey:key];
    CGFloat nHeight = 100;
    if ([ary count] > 0) {
        nHeight = [[aryHeight objectAtIndex:indexPath.row] floatValue];
    }
    
    
    NSArray *titleToDisplay = [NSArray arrayWithObjects:date,
                               [dicTmp objectForKey:@"YHMC"],
                               [dicTmp objectForKey:@"RCSSR"] ,
                               [dicTmp objectForKey:@"HDNR"] ,
                               [dicTmp objectForKey:@"RCMS"],
                               [dicTmp objectForKey:@"PTRY"],nil];
    
    UITableViewCell *cell = [UITableViewCell makeWeekCell:tableView
                                                withTexts:titleToDisplay
                                                 andImage:image
                                            andPTRYHeight:nHeight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)calculateTextHeight:(NSString*) text byFont:(UIFont*)font andWidth:(CGFloat)width
{
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 20;
    
}

#pragma mark - CommonWordSelect Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    NSDictionary *aItem = [depAry objectAtIndex:row];
    self.deptID = [aItem objectForKey:@"ZZBH"];
    if (self.wordsPopoverController != nil)
    {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
    [self getWeekDatas:[NSDate date] andType:-1];
}

- (BOOL)existBetweenFromDate:(NSString *)fromStr andEndDate:(NSString *)endStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [df dateFromString:fromStr];
    NSDate *endDate = [df dateFromString:endStr];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval from = [fromDate timeIntervalSince1970];
    NSTimeInterval end = [endDate timeIntervalSince1970];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    if(now >= from && now <= end)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
