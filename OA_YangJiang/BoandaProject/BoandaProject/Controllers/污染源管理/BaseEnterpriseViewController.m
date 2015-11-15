//
//  BaseEnterpriseViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseEnterpriseViewController.h"

@interface BaseEnterpriseViewController ()

@end

@implementation BaseEnterpriseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestData
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightSearchBarButton = [[UIBarButtonItem alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightSearchBarButton;
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    //初始化查询区域
    self.bHaveShowed = YES;
    [self rightBarButtonClick:rightSearchBarButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - Button Click Handler

- (void)rightBarButtonClick:(UIBarButtonItem *)sender
{
    if(self.bHaveShowed)
    {
        self.bHaveShowed = NO;
        CGRect origFrame = self.resultTableView.frame;
        sender.title =@"开启查询";
        
        self.dwmcLabel.hidden = YES;
        self.dwmcField.hidden = YES;
        self.szqyField.hidden = YES;
        self.szqyLabel.hidden = YES;
        self.searchButton.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.resultTableView.frame = CGRectMake(origFrame.origin.x,origFrame.origin.y-55, origFrame.size.width, origFrame.size.height+55);
        [UIView commitAnimations];
    }
    else
    {
        sender.title =@"关闭查询";
        
        self.bHaveShowed = YES;
        CGRect origFrame = self.resultTableView.frame;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:(__bridge void *)(self.resultTableView)];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.resultTableView.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y+55, origFrame.size.width, origFrame.size.height-55);
        
        [UIView commitAnimations];
    }
}

- (void)doSearchWithName:(NSString *)name andWithAddress:(NSString *)addr
{
    
}

- (IBAction)searchButtonClick:(id)sender
{
    [self doSearchWithName:self.dwmcField.text andWithAddress:self.szqyField.text];
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
    NSString *wrymc_value = [item objectForKey:@"PSNAME"];
    NSString *wrydz_value = [NSString stringWithFormat:@"地址：%@", [item objectForKey:@"PSADDRESS"]];
    NSString *wryhylx_value = [NSString stringWithFormat:@"中心经度：%@", [item objectForKey:@"LONGITUDE"]];
    NSString *wryszqy_value = [NSString stringWithFormat:@"中心纬度：%@", [item objectForKey:@"LATITUDE"]];
    NSString *wryjgjb_value = [NSString stringWithFormat:@"法人代表：%@", [item objectForKey:@"CORPORATIONNAME"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.dwmcLabel.hidden = NO;
    self.dwmcField.hidden = NO;
    self.szqyField.hidden = NO;
    self.szqyLabel.hidden = NO;
    self.searchButton.hidden = NO;
}
#pragma mark - Network Handler Method

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSDictionary *tmpParsedJsonDict = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonDict)
    {
        self.dataArray = [tmpParsedJsonDict objectForKey:@"result"];
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
    self.isLoading = NO;
    [self.resultTableView reloadData];
    [self showAlertMessage:@"请求数据失败."];
}

@end
