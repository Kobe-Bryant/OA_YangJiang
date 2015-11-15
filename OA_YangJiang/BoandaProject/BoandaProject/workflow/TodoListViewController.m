//
//  TodoListViewController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-14.
//  Copyright (c) 2012年 zhang. All rights reserved.
//   

#import "TodoListViewController.h"
#import "PDJsonkit.h"

#import "StepUserItem.h"
#import "ServiceUrlString.h"

#import "TodoItemDetailViewController.h"

#import "UITableViewCell+Custom.h"
#import "LaiWenDetailController.h"
#import "FaWenDetailController.h"
#import "DBDetailViewController.h"
#import "WBDetailsViewController.h"
#import "WNWZDetailViewController.h"
#import "PingShenHuiDetailViewController.h"

@interface TodoListViewController ()

@property (nonatomic,assign) BOOL isLoading;
@property(nonatomic,strong)  NSURLConnHelper *webHelper;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) BOOL bHaveShow;
@property (nonatomic,strong) UIPopoverController *datePopover;
@property (nonatomic,strong) PopupDateViewController *dateSelectCtrl;
@end

@implementation TodoListViewController
@synthesize aryItems,myTableView,isLoading,webHelper;
@synthesize titleLbl,typeLbl,startDateLbl,endDateLbl,titleField;
@synthesize typeField,startDateField,endDateField,searchBtn;
@synthesize datePopover,dateSelectCtrl,bHaveShow,currentTag,typeStr,index;

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
    if([webData length] <=0 ){
        [myTableView reloadData];
        return;
    }
        
    [aryItems removeAllObjects];
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        /*NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:20];
        //临时过滤
        for(NSDictionary *dic in tmpParsedJsonAry){
            NSString *lclxbh = [dic objectForKey:@"LCLXBH"];
            if( [lclxbh isEqualToString:typeStr])
                [aryTmp addObject:dic];
        }
        [aryItems addObjectsFromArray:aryTmp];*/
        [aryItems addObjectsFromArray:tmpParsedJsonAry];
        
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

    }
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

-(void)getFirstListData{

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_TODO_TASK_LIST" forKey:@"service"];

    if([titleField.text length] > 0)
        [dicParams setObject:titleField.text forKey:@"dwmc"];
    
    if([typeStr length] > 0)
        [dicParams setObject:typeStr forKey:@"type"];
    if([startDateField.text length] > 0)
        [dicParams setObject:titleField.text forKey:@"kssj"];
    if([endDateField.text length] > 0)
        [dicParams setObject:titleField.text forKey:@"jssj"];
  
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];

    isLoading = YES;

    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    titleField.hidden = NO;
    titleLbl.hidden = NO;
  //  typeLbl.hidden = NO;
  //  typeField.hidden = NO;
    startDateLbl.hidden = NO;
    startDateField.hidden = NO;
    endDateLbl.hidden = NO;
    endDateField.hidden = NO;
    searchBtn.hidden = NO;
}

- (void)showSearchBar:(id)sender {
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if(bHaveShow)
    {
        [titleField resignFirstResponder];
        [startDateField resignFirstResponder];
        [endDateField resignFirstResponder];        
        bHaveShow = NO;
        [aItem setTitle:@"开启查询"];
        
        titleField.hidden = YES;
        titleLbl.hidden = YES;
 //       typeLbl.hidden = YES;
 //       typeField.hidden = YES;
        startDateLbl.hidden = YES;
        startDateField.hidden = YES;
        endDateLbl.hidden = YES;
        endDateField.hidden = YES;
        searchBtn.hidden = YES;
        
        CGRect origFrame = myTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y-100, origFrame.size.width, origFrame.size.height+100);
        [UIView commitAnimations];
        
    }
    else{
        [aItem setTitle:@"关闭查询"];
        
        bHaveShow = YES;
        CGRect origFrame = myTableView.frame;  
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(myTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        myTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+100, origFrame.size.width, origFrame.size.height-100);
        
        [UIView commitAnimations];
        
    }
}

- (IBAction)selectDate:(id)sender
{
    if (datePopover)
        [datePopover dismissPopoverAnimated:YES];
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    
    UIControl *btn = (UIControl *)sender;
    currentTag = btn.tag;
    [datePopover presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PopoverDate delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date;
{
    if (bSaved) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        if (currentTag == 1)
            startDateField.text = dateString;
        else
            endDateField.text = dateString;
    }
    
    [datePopover dismissPopoverAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (IBAction)searchBtnPressed:(id)sender{
    [self getFirstListData];
}

-(void)refresh:(id)sender{
    if(aryItems)[aryItems removeAllObjects];
    [self getFirstListData];
}

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"待办任务";
    
  
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStyleBordered target:self action:@selector(showSearchBar:)];

    self.navigationItem.rightBarButtonItem = aItem;
    
    bHaveShow = YES;
    [self showSearchBar:aItem];
    self.navigationItem.rightBarButtonItem = nil;//隐藏
    
    self.aryItems = [[NSMutableArray alloc] init];
    
    PopupDateViewController *dateCtrl = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
    self.dateSelectCtrl = dateCtrl;
    dateSelectCtrl.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateSelectCtrl];
    UIPopoverController *popCtrl1 = [[UIPopoverController alloc] initWithContentViewController:nav];
    self.datePopover = popCtrl1;

    /*
    UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered  target:self action:@selector(refresh:)];
    
    self.navigationItem.leftBarButtonItem = item2;
    [item2 release];
    */
    
    // Do any additional setup after loading the view from its nib.
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillAppear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
    if(aryItems)[aryItems removeAllObjects];
    [self getFirstListData];
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(isLoading)return nil;
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  待办任务(%d条)",[aryItems count]];
    
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [aryItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	NSString *itemTitle = [[aryItems objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
    NSDictionary *dic  = [aryItems objectAtIndex:indexPath.row];
    //cell.textLabel.text = itemTitle;
    NSString *qixian = [dic objectForKey:@"LCQX"]; //办文期限
    if([qixian length]>10)
        qixian = [qixian substringToIndex:10];
    
    NSString *fbr = [NSString stringWithFormat:@"交办人：%@",[dic objectForKey:@"BZCJR"]];
    
    NSString *fbsj = [NSString stringWithFormat:@"发布时间：%@",[dic objectForKey:@"BZKSSJ"]];
    
    NSString *bljd = [NSString stringWithFormat:@"办理阶段：%@",[dic objectForKey:@"BZMC"]];
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:itemTitle andSubvalue1:fbr andSubvalue2:fbsj andSubvalue3:bljd andSubvalue4:[NSString stringWithFormat:@"办文期限：%@",qixian]];
    
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"发布人：%@    发布时间：%@    \n办理阶段：%@    办文期限：%@      ",[dic objectForKey:@"BZCJR"],[dic objectForKey:@"BZKSSJ"],[dic objectForKey:@"BZMC"],qixian];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *lclxbh = [dic objectForKey:@"LCLXBH"];
    if ([lclxbh isEqualToString:kLCLXBH_LW])
    {
       cell.imageView.image = [UIImage imageNamed:@"lw.png"];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_FW])
    {
        cell.imageView.image = [UIImage imageNamed:@"fw.png"];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_DBRW])
    {
        cell.imageView.image = [UIImage imageNamed:@"dbrw.png"];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_WBFW])
    {
        cell.imageView.image = [UIImage imageNamed:@"wb.png"];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_WNWZ])
    {
        cell.imageView.image = [UIImage imageNamed:@"wnwz.png"];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_HYTZ])
    {
        cell.imageView.image = [UIImage imageNamed:@"tzgg.png"];
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //"SJJKSXL":"  手机接口实现类，预留字段，可以在后台进行配置  com.szboanda.android#ipad#windows  使用#分隔三个值，第一个是android类名称,第二个是ipad名称,第三个是windows类名称
    
    NSDictionary *dic  = [aryItems objectAtIndex:indexPath.row];
   /* NSString *classStr = [dic objectForKey:@"SJJKSXL"];
    NSArray *aryClasses = [classStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    if([aryClasses count] > 1){
        NSString *ipadClass = [aryClasses objectAtIndex:1];
        Class classType = NSClassFromString(ipadClass);
        
        UIViewController *controller = [[classType alloc] initWithNibName:ipadClass bundle:nil];
        //要保证配置的类有params属性
        [controller setValue:dic forKey:@"params"];
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }else{
        TodoItemDetailViewController *controller = [[TodoItemDetailViewController alloc] initWithNibName:@"TodoItemDetailViewController" bundle:nil];
        //要保证配置的类有params属性
        [controller setValue:dic forKey:@"params"];
        controller.typeStr = typeStr;
        
        
        [self.navigationController pushViewController:controller animated:YES];
      //  [controller release];
    //}*/
    NSString *lclxbh = [dic objectForKey:@"LCLXBH"];
    if ([lclxbh isEqualToString:kLCLXBH_LW])
    {
        //来文
        LaiWenDetailController *controller = [[LaiWenDetailController alloc] initWithNibName:@"LaiWenDetailController" andLCSLBH:[dic objectForKey:@"LCSLBH"] isBanli:YES];
        [controller setValue:dic forKey:@"itemParams"];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if([lclxbh isEqualToString:kLCLXBH_FW])
    {
        //发文
        FaWenDetailController *controller = [[FaWenDetailController alloc] initWithNibName:@"FaWenDetailController" andLCSLBH:[dic objectForKey:@"LCSLBH"] isBanli:YES];
        [controller setValue:dic forKey:@"itemParams"];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if([lclxbh isEqualToString:kLCLXBH_DBRW])
    {
        //督办任务
        NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
        DBDetailViewController *controller = [[DBDetailViewController alloc] initWithNibName:@"DBDetailViewController" andLCSLBH:[dic objectForKey:@"LCSLBH"] andBZBH:[dic objectForKey:@"BZBH"] isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([lclxbh isEqualToString:kLCLXBH_WBFW])
    {
        //微博发文
        NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
        WBDetailsViewController *controller = [[WBDetailsViewController alloc] initWithNibName:@"WBDetailsViewController" andLCSLBH:[dic objectForKey:@"LCSLBH"] isBanli:YES];
        controller.itemParams = dic;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([lclxbh isEqualToString:kLCLXBH_WNWZ])
    {
        //网络问政
        NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
        WNWZDetailViewController *controller = [[WNWZDetailViewController alloc] initWithNibName:@"WNWZDetailViewController" andLCSLBH:[dic objectForKey:@"LCSLBH"] andBZBH:[dic objectForKey:@"BZBH"] isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([lclxbh isEqualToString:kLCLXBH_HYTZ])
    {
        //会议通知(评审会)
        NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
        PingShenHuiDetailViewController *controller = [[PingShenHuiDetailViewController alloc] initWithNibName:nil andLCSLBH:[dic objectForKey:@"LCSLBH"] isBanli:YES];
        [controller setValue:dic forKey:@"itemParams"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
