//
//  OnlineFileListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OnlineFileListViewController.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"

@interface OnlineFileListViewController ()

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation OnlineFileListViewController

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
    
    self.title = self.folderName;
    
    [self addCustomView];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求与数据解析

- (void)requestData
{
    if(self.wdbh.length <= 0)
    {
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_MeetingList" forKey:@"service"];
    [params setObject:self.wdbh forKey:@"fwdbh"];
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    self.isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *log = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSArray *tmpAry = [log objectFromJSONString];
    if(tmpAry)
    {
        NSDictionary *tmpDict = [tmpAry objectAtIndex:0];
        self.listArray = [tmpDict objectForKey:@"result"];
    }
    [self.listTableView reloadData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据失败!"];
}

#pragma mark - Private Methods

//添加视图组件
- (void)addCustomView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    bgView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgView];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, 728, 920) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
}

#pragma makr - UITableView DataSource & Delegate Methods

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
    headerView.text = [NSString stringWithFormat:@"  资料列表(%d个)", self.listArray.count];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
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
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
	}
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    NSString *WDMC = [item objectForKey:@"WDMC"];
    NSString *CJR = [item objectForKey:@"CJR"];
    NSString *CJSJ = [item objectForKey:@"CJSJ"];
    NSString *WDDX = [item objectForKey:@"WDDX"];
    cell.textLabel.text = WDMC;
    NSString *WDLX = [item objectForKey:@"WDLX"];
    if([WDLX isEqualToString:@"F"])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"上传人：%@ 上传时间：%@", CJR, CJSJ];
    }
    else if ([WDLX isEqualToString:@"D"])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"文件大小：%@字节 \n上传人：%@ 上传时间：%@", WDDX, CJR, CJSJ];
    }
    cell.imageView.image = [FileUtil imageForFileExtNew:[WDMC pathExtension]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listArray objectAtIndex:indexPath.row];
    
    NSString *WDLX = [item objectForKey:@"WDLX"];
    if([WDLX isEqualToString:@"F"])
    {
        OnlineFileListViewController *list = [[OnlineFileListViewController alloc] init];
        list.wdbh = [item objectForKey:@"WDBH"];
        list.folderName = [item objectForKey:@"WDMC"];
        [self.navigationController pushViewController:list animated:YES];
    }
    else if([WDLX isEqualToString:@"D"])
    {
        NSString *WDMC = [item objectForKey:@"WDMC"];
        NSString *WDKBH = [item objectForKey:@"WDKBH"];
        NSString *WDBH = [item objectForKey:@"WDBH"];
        NSString *DQBB = [NSString stringWithFormat:@"%@", [item objectForKey:@"DQBB"]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"QUERY_MeetingDocDown" forKey:@"service"];
        [params setObject:WDBH forKey:@"documentId"];
        [params setObject:WDKBH forKey:@"wdkbh"];
        [params setObject:DQBB forKey:@"dqbb"];
        NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *download = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController" fileURL:strURL andFileName:WDMC];
        download.fileFiles = [NSMutableDictionary dictionaryWithDictionary:item];
        [self.navigationController pushViewController:download animated:YES];
    }
}

@end
