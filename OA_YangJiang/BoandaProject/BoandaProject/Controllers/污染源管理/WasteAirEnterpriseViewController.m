//
//  WasteAirEnterpriseViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WasteAirEnterpriseViewController.h"

@interface WasteAirEnterpriseViewController ()

@end

@implementation WasteAirEnterpriseViewController

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
    self.title = @"废气企业信息";
    [self requestData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_AIR_ENTERPRISE_LIST" forKey:@"service"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)doSearchWithName:(NSString *)name andWithAddress:(NSString *)addr
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_AIR_ENTERPRISE_LIST" forKey:@"service"];
    if (name != nil && name.length > 0) {
        [params setObject:name forKey:@"psname"];
    }
    if (addr != nil && addr.length > 0) {
        [params setObject:addr forKey:@"psaddress"];
    }
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WasteEnterpriseDetailViewController *detail = [[WasteEnterpriseDetailViewController alloc] initWithNibName:@"WasteEnterpriseDetailViewController" bundle:nil];
    detail.detailDict = [self.dataArray objectAtIndex:indexPath.row];
    detail.serviceName = @"Air_Online";
    [self.navigationController pushViewController:detail animated:YES];
}

@end
