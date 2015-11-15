//
//  BaseOnlineEnterpriseViewController.m
//  BoandaProject
//
//  Created by ihumor on 13-12-5.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "BaseOnlineEnterpriseViewController.h"
#import "UITableViewCell+Custom.h"
#import "WasteAirOnlineViewController.h"
#import "WasteWaterOnlineViewController.h"

@interface BaseOnlineEnterpriseViewController ()

@end

@implementation BaseOnlineEnterpriseViewController

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
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
}

#pragma mark - NetWork Hander Methods

- (void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:5];
    [params setObject:self.serviceName forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    if(webData.length <= 0)
    {
        return;
    }
    
    NSString *log = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSArray *tmpAry = [log objectFromJSONString];
    if(tmpAry != nil && tmpAry.count > 0)
    {
        NSDictionary *tmpDict = [tmpAry objectAtIndex:0];
        self.dataArray = [tmpDict objectForKey:@"dataInfos"];
    }
    
    [self.listTableView reloadData];
}

- (void)processError:(NSError *)error
{
    
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
    return @"    查询结果";
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
    NSString *wryhylx_value = @"";
    NSString *wryszqy_value = [NSString stringWithFormat:@"联系人：%@", [item objectForKey:@"LINKMAN"]];
    NSString *wryjgjb_value = [NSString stringWithFormat:@"法人代表：%@", [item objectForKey:@"CORPORATIONNAME"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
    if([self.serviceName isEqualToString:kServiceName_WasteAir])
    {
        WasteAirOnlineViewController *wa = [[WasteAirOnlineViewController alloc] init];
        wa.WRYMC = [item objectForKey:@"PSNAME"];
        wa.PSCODE = [item objectForKey:@"PSCODE"];
        [self.navigationController pushViewController:wa animated:YES];
    }
    else if ([self.serviceName isEqualToString:kServiceName_WasteWater])
    {
        WasteWaterOnlineViewController *ww = [[WasteWaterOnlineViewController alloc] init];
        ww.WRYMC = [item objectForKey:@"PSNAME"];
        ww.PSCODE = [item objectForKey:@"PSCODE"];
        [self.navigationController pushViewController:ww animated:YES];
    }
}



@end
