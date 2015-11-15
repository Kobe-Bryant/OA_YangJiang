//
//  OtherFactorListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-12-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OtherFactorListViewController.h"
#import "BECheckBox.h"
#import "BDKNotifyHUD.h"

@interface OtherFactorListViewController ()
@property (nonatomic, strong) NSArray *factorNameAry;//因子
@property (nonatomic, strong) NSArray *factorKeyAry;//因子
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) BDKNotifyHUD *notify;

@property (nonatomic, strong) NSMutableArray *selectedKeyAry;
@property (nonatomic, strong) NSMutableArray *selectedNameAry;
@end

@implementation OtherFactorListViewController

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
    
    self.title = @"请选择监测因子";
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 540);
    self.factorNameAry = [[NSArray alloc] initWithObjects:@"标态烟气量(m³/s)", @"烟尘实测浓度(mg/m³)", @"SO2实测浓度(mg/m³)", @"烟气流速(m³/h)", @"烟气压力(MPa)", @"烟气含氧量(%)", @"烟气温度(℃)", @"烟尘折算浓度(mg/Nm³)", @"SO2折算浓度(mg/Nm³)", @"NOx折算浓度(mg/Nm³)", @"烟气湿度(%)", @"NOx实测浓度(mg/m³)", nil];
    self.factorKeyAry = [NSArray arrayWithObjects:@"n_flow", @"a_dust", @"a_so2", @"speed", @"pressure", @"temperature", @"c_dust", @"c_so2", @"c_nox", @"humidity", @"a_nox", @"oxygen", nil];
    
    self.selectedNameAry = [[NSMutableArray alloc] initWithArray:self.selectedFactorNames];
    self.selectedKeyAry = [[NSMutableArray alloc] initWithArray:self.selectedFactorKeys];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancelClick:)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(onConfirmClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
	
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 540) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelClick:(id)sender
{
    [self.parentController dismissPopoverAnimated:YES];
}

- (void)onConfirmClick:(id)sender
{
    if(self.selectedNameAry.count < 5)
    {
        [self showNotifyHUDWithContent:@"请选择5个监测因子!"];
        return;
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(passWithSelectedNameValue:andWithKeyValue:)])
        {
            [self.delegate passWithSelectedNameValue:self.selectedNameAry andWithKeyValue:self.selectedKeyAry];
        }
    }
    [self.parentController dismissPopoverAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.factorNameAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *title = [self.factorNameAry objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if([self.selectedNameAry containsObject:title])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [self.factorNameAry objectAtIndex:indexPath.row];
    if([self.selectedNameAry containsObject:title])
    {
        NSString *key = [self.factorKeyAry objectAtIndex:indexPath.row];
        [self.selectedNameAry removeObject:title];
        [self.selectedKeyAry removeObject:key];
    }
    else
    {
        if(self.selectedNameAry.count >= 5)
        {
            //提示
            [self showNotifyHUDWithContent:@"可选的因子个数不能超过5个"];
        }
        else
        {
            NSString *key = [self.factorKeyAry objectAtIndex:indexPath.row];
            [self.selectedNameAry addObject:title];
            [self.selectedKeyAry addObject:key];
        }
    }
    [self.listTableView reloadData];
}

- (void)showNotifyHUDWithContent:(NSString *)content
{
    if (self.notify == nil)
    {
        self.notify = [BDKNotifyHUD notifyHUDWithImage:nil text:content];
        self.notify.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
    }
    else
    {
        self.notify.text = content;
    }
    [self.view addSubview:self.notify];
    [self.notify presentWithDuration:1.0f speed:1.0f inView:self.view completion:^{
        [self.notify removeFromSuperview];
    }];
}

@end
