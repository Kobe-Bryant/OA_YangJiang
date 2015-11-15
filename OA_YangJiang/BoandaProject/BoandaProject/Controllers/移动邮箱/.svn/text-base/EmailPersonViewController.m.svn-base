//
//  EmailPersonViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-10.
//
//

#import "EmailPersonViewController.h"
#import "QQSectionHeaderView.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

@interface EmailPersonViewController ()

- (void)initDataDefault;
- (void)loadSubViews;
- (void)addSegment;
- (void)addRefleshButton;
- (void)refleshButtonClick:(id)sender;
- (void)segmentIndextClick:(id)sender;
- (void)requestData;

@end

@implementation EmailPersonViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSubViews];
    [self initDataDefault];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

#pragma mark - 私有方法

- (void)initDataDefault
{
    _segTag = 0;
    if (_departmentArray.count <=0)
    {
        _departmentArray = [[NSMutableArray alloc] init];
    }
    if (_personArray.count <=0)
    {
        _personArray = [[NSMutableArray alloc] init];
    }
    if (_sdArray.count <=0) {
        _sdArray = [[NSMutableArray alloc] init];
    }
    if (_spArray.count <=0) {
        _spArray = [[NSMutableArray alloc] init];
    }
    if (_sdIsOpenArray.count <=0) {
        _sdIsOpenArray = [[NSMutableArray alloc] init];
    }
    if (_spIsOpenArray.count <=0) {
        _spIsOpenArray = [[NSMutableArray alloc] init];
    }
    _checkArray = [[NSMutableArray alloc]init];
}

- (void)loadSubViews
{
    self.contentSizeForViewInPopover = CGSizeMake(320,480);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:71 green:150 blue:170 alpha:0];
    [self addSegment];
    [self addRefleshButton];
    
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 450) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    else
    {
       [_tableView reloadData]; 
    }
}

- (void)addSegment
{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" 部 门 ",@" 个 人 ", nil]];
    self.navigationItem.titleView = seg;
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    [seg addTarget:self action:@selector(segmentIndextClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentIndextClick:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    int indext = seg.selectedSegmentIndex;
    if (_segChange)
    {
        [_checkArray removeAllObjects];
    }
    if (indext == 0)
    {
        if (seg.selected)
        {
            _segChange = NO;
            return;
        }
        else
        {
            _segChange = YES;
            [_checkArray removeAllObjects];
            _segTag = 0;
            _resultArray = [[NSUserDefaults standardUserDefaults]objectForKey:DEPARTMENT_ARRAY_KEY];
        }
    }
    else
    {
        if (seg.selected)
        {
            _segChange = NO;
            return;
        }
        else
        {
            _segChange = YES;
            [_checkArray removeAllObjects];
            _segTag = 1;
            _resultArray = [[NSUserDefaults standardUserDefaults] objectForKey:PERSON_ARRAY_KEY];
        }
    }
    [_tableView reloadData];
}

- (void)addRefleshButton
{
    
}

- (void)refleshButtonClick:(id)sender
{
    
}

- (void)reloaData
{
    [_tableView reloadData];
}

#pragma mark - 网络相关操作

- (void)requestData
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"DEPARTMENTANDUSER_LIST" forKey:@"service"];
   
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    

    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bParseError = NO;
    
    NSArray *dic = [resultJSON objectFromJSONString];
    
    NSMutableArray *dArray = [[dic objectAtIndex:0] objectForKey:@"departmentsInfo"];
    NSMutableArray *sdA  = [[NSMutableArray alloc] init];
    NSMutableArray *sdA1  = [[NSMutableArray alloc] init];
    
    NSMutableArray *pArray = [[dic objectAtIndex:0] objectForKey:@"usersInfo"];
    NSMutableArray *spA  = [[NSMutableArray alloc] init];
    NSMutableArray *spA1  = [[NSMutableArray alloc] init];
    
    if (dArray.count >0 && pArray.count > 0)
    {
        for (int i = 0;i<dArray.count;i++)
        {
            if ([[[dArray objectAtIndex:i]objectForKey:@"PID"] isEqualToString:@"ROOT"])
            {
                [sdA addObject:[[dArray objectAtIndex:i] objectForKey:@"MC"]];
                [sdA1 addObject:[[dArray objectAtIndex:i] objectForKey:@"ID"]];
                [_sdIsOpenArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
        [_sdArray addObjectsFromArray:sdA];
        for (int i = 0; i<_sdArray.count; i++)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j =0; j<dArray.count; j++)
            {
                if ([[sdA1 objectAtIndex:i] isEqualToString:[[dArray objectAtIndex:j]objectForKey:@"PID"]])
                {
                    [array addObject:[dArray objectAtIndex:j]];
                }
            }
            [_departmentArray insertObject:array atIndex:i];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_departmentArray forKey:DEPARTMENT_ARRAY_KEY];
        for (int i = 0;i<pArray.count;i++)
        {
            if ([[[pArray objectAtIndex:i]objectForKey:@"PID"] isEqualToString:@"ROOT"])
            {
                [spA addObject:[[pArray objectAtIndex:i] objectForKey:@"MC"]];
                [spA1 addObject:[[pArray objectAtIndex:i] objectForKey:@"ID"]];
                 [_spIsOpenArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
        [_spArray addObjectsFromArray:spA];
        for (int i = 0; i<_spArray.count; i++)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j =0; j<pArray.count; j++)
            {
                if ([[spA1 objectAtIndex:i] isEqualToString:[[pArray objectAtIndex:j]objectForKey:@"PID"]])
                {
                    [array addObject:[pArray objectAtIndex:j]];
                }
            }
            [_personArray addObject:array];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_personArray forKey:PERSON_ARRAY_KEY];
        
    }
    else
        bParseError = YES;
   
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    _resultArray = _departmentArray;
    [_tableView reloadData];
}

-(void)processError:(NSError *)error
{

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}

#pragma mark UITableViewDelegate ,UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_segTag == 0)
    {
        return _sdArray.count;
    }
	return _spArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 10;
    if (_segTag == 0)
    {
        NSString *aSubTitle = [_sdArray objectAtIndex:section];
        headerHeight = headerHeight + [self calculateTextHeight:aSubTitle byFont:[UIFont boldSystemFontOfSize:17.0f] andWidth:_tableView.bounds.size.width];
    }
    else
    {
        NSString *aSubTitle = [_spArray objectAtIndex:section];
        headerHeight = headerHeight +[self calculateTextHeight:aSubTitle byFont:[UIFont boldSystemFontOfSize:17.0] andWidth:_tableView.bounds.size.width];
    }
	return headerHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_segTag == 0)
    {
        BOOL open = [[_sdIsOpenArray objectAtIndex:section]boolValue];
        if (!open)
        {
            return 0;
        }
        else count = [[_resultArray objectAtIndex:section] count];
    }
    else
    {
        BOOL open = [[_spIsOpenArray objectAtIndex:section]boolValue];
        if (!open)
        {
            return 0;
        }
        else count = [[_resultArray objectAtIndex:section] count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segTag == 0)
    {
        _resultArray = _departmentArray;
    }
    else
        _resultArray = _personArray;
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    NSString *title = [[[_resultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"MC"];
    cell.textLabel.text = title;
    NSDictionary *dic = [[_resultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([_checkArray containsObject:dic])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
	return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 10;
    BOOL open = NO;
    NSString *title = nil;
    if (_segTag == 0)
    {
        title = [_sdArray objectAtIndex:section];
        open = [[_sdIsOpenArray objectAtIndex:section] boolValue];
    }
    else
    {
        title = [_spArray objectAtIndex:section];
        open = [[_spIsOpenArray objectAtIndex:section] boolValue];
    }
    headerHeight = headerHeight + [self calculateTextHeight:title byFontSize:17.0 andWidth:self.tableView.bounds.size.width];
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, headerHeight) title:title subTitle:nil section:section opened:open delegate:self];
	return sectionHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[_resultArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([_checkArray containsObject:dic])
    {
        [_checkArray removeObject:dic];
    }
    else
    {
        [_checkArray addObject:dic];
    }
    [_tableView reloadData];
    if (_segTag == 0)
    {
        [delegate didSelectedCellSendTo:@"D" array:_checkArray];
    }
    else
        [delegate didSelectedCellSendTo:@"U" array:_checkArray];
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    NSNumber *open = nil;
    if (_segTag == 0)
    {
        open = [_sdIsOpenArray objectAtIndex:section];
        [_sdIsOpenArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!open.boolValue]];
    }
    else
    {
        open = [_spIsOpenArray objectAtIndex:section];
        [_spIsOpenArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!open.boolValue]];
    }
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [_tableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		[self.tableView reloadData];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
    NSNumber *open = nil;
    if (_segTag == 0)
    {
        open = [_sdIsOpenArray objectAtIndex:section];
        [_sdIsOpenArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!open.boolValue]];
    }
    else
    {
        open = [_spIsOpenArray objectAtIndex:section];
        [_spIsOpenArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!open.boolValue]];
    }
    [_tableView reloadData];
}

- (CGFloat)calculateTextHeight:(NSString*) text byFontSize:(CGFloat)size andWidth:(CGFloat)width
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:size];
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize size1 = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size1.height + 20;
}

- (CGFloat)calculateTextWidth:(NSString*) text byFont:(UIFont*)font andHeight:(CGFloat)height
{
    CGSize constraintSize = CGSizeMake(MAXFLOAT, height);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.width + 20;
}

- (CGFloat)calculateTextHeight:(NSString*) text byFont:(UIFont*)font andWidth:(CGFloat)width
{
    CGSize constraintSize = CGSizeMake(width, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 20;
}

@end
