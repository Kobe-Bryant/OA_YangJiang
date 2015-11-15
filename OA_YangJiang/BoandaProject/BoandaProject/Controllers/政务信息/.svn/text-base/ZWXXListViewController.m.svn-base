//
//  ZWXXListViewController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-18.
//
//

#import "ZWXXListViewController.h"
#import "PDJSONKit.h"
#import "ZWXXDetailViewController.h"
#import "ServiceUrlString.h"
#import "UsersHelper.h"

@interface ZWXXListViewController ()
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupDateViewController *dateController;
@property (nonatomic,assign) NSInteger currentTag;

@property(nonatomic,assign)BOOL bHaveShowed;
@property(nonatomic,strong) NSMutableArray *resultAry;
@property(nonatomic,assign) NSInteger pageCount;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoading;
@property(nonatomic,strong)NSString *urlString; //不含p_CURRENT的url
//部门信息

@property (nonatomic,strong)CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong)UIPopoverController *wordsPopoverController;
@property(nonatomic,strong)NSString *bsbmDM;
@end

@implementation ZWXXListViewController
@synthesize btField,btLabel,bsdwField,bsdwLabel,kssjField,kssjLabel;
@synthesize jssjField,jssjLabel,searchButton,bHaveShowed,resultAry;
@synthesize webHelper,myTableView;
@synthesize popController,dateController,currentTag;
@synthesize pageCount,currentPage, isLoading,urlString;
@synthesize wordsPopoverController,wordsSelectViewController,bsbmDM;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)processWebData:(NSData*)webData{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *aryDate = [resultJSON objectFromJSONString];
    NSDictionary *dicDate = [aryDate objectAtIndex:0];
    NSArray *retAry = [dicDate objectForKey:@"dataInfos"];
    NSDictionary *pageInfoDic = [dicDate  objectForKey:@"pageInfo"];
 
    /******************/
    if (pageInfoDic ) {
        pageCount = [[pageInfoDic objectForKey:@"pages"] intValue];
        currentPage = [[pageInfoDic objectForKey:@"current"] intValue];
    }
    if (retAry == nil||[retAry count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

        
    }
    [resultAry addObjectsFromArray:retAry];
    
    //[dicDate release];
    [myTableView reloadData];
}

-(void)processError:(NSError *)error{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    [myTableView reloadData];
    return;
}

-(IBAction)btnTextBSDW:(id)sender{
    UITextField *ctrl = (UITextField*)sender;
    ctrl.text = @"";
    //currentTag = ctrl.tag;
    NSMutableArray *bmNameAry = [NSMutableArray arrayWithCapacity:20];
    NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    
    for (NSDictionary *aItem in depAry) {
        [bmNameAry addObject:[aItem objectForKey:@"ZZQC"]];
    }
    
    CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil];
	tmpController.contentSizeForViewInPopover = CGSizeMake(180, 400);
	tmpController.delegate = self;
    tmpController.wordsAry = bmNameAry;
    
    UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    CGRect rect;
	rect.origin.x = ctrl.frame.origin.x;
	rect.origin.y = ctrl.frame.origin.y;
	rect.size.width = ctrl.frame.size.width;
	rect.size.height = ctrl.frame.size.height;
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromRect:rect
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    bsdwField.text = words;
    NSArray *depAry = [[[UsersHelper alloc] init]  queryAllSubDept:@"ROOT"];
    if (depAry == nil) return;
    
    NSDictionary *aItem = [depAry objectAtIndex:row];
    self.bsbmDM = [aItem objectForKey:@"ZZBH"];
    
    if (self.wordsPopoverController != nil) {
		[self.wordsPopoverController dismissPopoverAnimated:YES];
	}
}


-(IBAction)btnSearch:(id)sender{
    if(webHelper)
        [webHelper cancel];
    [resultAry removeAllObjects];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZWXX_LIST" forKey:@"service"];
   
   

    if ([btField.text length] > 0)
         [params setObject:btField.text forKey:@"q_BT"];

    if ([bsdwField.text length] > 0)
        [params setObject:bsbmDM forKey:@"q_BSDW"];
    if ([kssjField.text length] > 0)
        [params setObject:kssjField.text forKey:@"q_CJSJ"];
    if ([jssjField.text length] > 0)
        [params setObject:jssjField.text forKey:@"q_CJSJ2"];

    
    isLoading = YES;
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    btField.hidden = NO;
    btLabel.hidden = NO;
    bsdwField.hidden = NO;
    bsdwLabel.hidden = NO;
    kssjField.hidden = NO;
    kssjLabel.hidden = NO;
    jssjField.hidden = NO;
    jssjLabel.hidden = NO;
        
    searchButton.hidden = NO;
}


-(void)showSearchBar:(id)sender{
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShowed)
    {
        bHaveShowed = NO;
        aItem.title = @"开启查询";
        
        btField.hidden = YES;
        btLabel.hidden = YES;
        bsdwField.hidden = YES;
        bsdwLabel.hidden = YES;
        kssjField.hidden = YES;
        kssjLabel.hidden = YES;
        jssjField.hidden = YES;
        jssjLabel.hidden = YES;
        
        searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        myTableView.frame = CGRectMake(30, 30, 708, 916);
        [UIView commitAnimations];
        
    }
    else{
        aItem.title = @"关闭查询";
        bHaveShowed = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        myTableView.frame = CGRectMake(30, 120, 708, 826);
        
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"政务信息报送列表";
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain
															 target:self
															 action:@selector(showSearchBar:)];
	self.navigationItem.rightBarButtonItem = aItem;
    bHaveShowed = YES;
    [self showSearchBar:aItem];

    self.resultAry = [NSMutableArray arrayWithCapacity:35];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_ZWXX_LIST" forKey:@"service"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;

	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	currentTag = btn.tag;
	
	
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"YYYY-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];

		switch (currentTag) {
			case 1:
				kssjField.text = dateString;
                //     NSLog(@"11%@",XWKSSJ);
                //  self.TZSJDateValue = date;
				break;
			case 2:
				jssjField.text = dateString;
                //  self.JSCLSJDateValue = date;
				
				break;
			default:
				break;
		}
	}else {
        switch (currentTag) {
			case 1:
				kssjField.text = @"";
				break;
			case 2:
				jssjField.text = @"";
				
				break;
			default:
				break;
		}
    }
    
}
//不让日起textfield可以编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return NO;
}



#pragma mark - tableview dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    
    headerView.text = @"政务信息列表";
    
    return headerView;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	}
	NSUInteger row = [indexPath row];
    NSDictionary *dic = [resultAry objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"BT"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"报送单位：%@    报送时间：%@",[dic objectForKey:@"BSDW"],[dic objectForKey:@"CJSJ"]];
    
    
    return cell;
}

#pragma mark -
#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZWXXDetailViewController *infoController = [[ZWXXDetailViewController alloc] initWithNibName:@"ZWXXDetailViewController" bundle:nil];

    NSDictionary *dic = [resultAry objectAtIndex:indexPath.row];
    infoController.q_XH = [dic objectForKey:@"XH"];
    infoController.title = [dic objectForKey:@"BT"];
    [self.navigationController pushViewController:infoController animated:YES];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
    
    if (currentPage == pageCount)
        return;
	if (isLoading) {
        return;
    }
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        // Released above the header
		
        currentPage++;
        
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",urlString, currentPage];
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}

@end

