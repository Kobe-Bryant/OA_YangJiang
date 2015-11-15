//
//  WasteEnterpriseDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WasteEnterpriseDetailViewController.h"
#import "UITableViewCell+Custom.h"
#import "EnterpriseMapCell.h"
#import "NSStringUtil.h"
#import "WasteWaterOnlineViewController.h"
#import "WasteAirOnlineViewController.h"

@interface WasteEnterpriseDetailViewController ()
@property (nonatomic,strong) NSArray *toDisplayKey;//所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//所要显示的key对应的标题
@property (nonatomic,strong) NSArray *toDisplayHeight;//所要显示高度
@end

@implementation WasteEnterpriseDetailViewController

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
    
    self.title = @"企业详细信息";
    self.toDisplayKey = [NSArray arrayWithObjects:@"PSNAME",@"PSADDRESS",@"CORPORATIONNAME",@"CORPORATIONCODE", @"COMMUNICATEADDR", @"LINKMAN", @"LONGITUDE", @"LATITUDE", @"COMMENT",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"单位名称：",@"单位地址：",@"法定代表人：",@"法人代码：", @"通讯地址：", @"联系人：", @"中心经度：", @"中心纬度：", @"备注：",nil];
    
    NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:5];
    for(int i = 0; i < 5; i++)
    {
        if(i == 4)
        {
            NSString *itemTitle = [self.detailDict objectForKey:[self.toDisplayKey objectAtIndex:i+4]];
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
            CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)
                cellHeight = 60.0f;
            [aryTmp1 addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        else
        {
            [aryTmp1 addObject:[NSNumber numberWithFloat:60.0f]];
        }
    }
    self.toDisplayHeight = aryTmp1;
    
    if(!self.serviceName)
    {
        self.serviceName = @"";
    }
    if([self.serviceName isEqualToString:@"Water_Online"])
    {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"废水实时数据" style:UIBarButtonItemStyleBordered target:self action:@selector(onRightClicked:)];
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    else if ([self.serviceName isEqualToString:@"Air_Online"])
    {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"废气实时数据" style:UIBarButtonItemStyleBordered target:self action:@selector(onRightClicked:)];
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Event Handler Methods

- (void)onRightClicked:(UIBarButtonItem *)sender
{
    if([self.serviceName isEqualToString:@"Water_Online"])
    {
        WasteWaterOnlineViewController *ww = [[WasteWaterOnlineViewController alloc] init];
        ww.WRYMC = [self.detailDict objectForKey:@"PSNAME"];
        ww.PSCODE = [self.detailDict objectForKey:@"PSCODE"];
        [self.navigationController pushViewController:ww animated:YES];
    }
    else if([self.serviceName isEqualToString:@"Air_Online"])
    {
        WasteAirOnlineViewController *wa = [[WasteAirOnlineViewController alloc] init];
        wa.WRYMC = [self.detailDict objectForKey:@"PSNAME"];
        wa.PSCODE = [self.detailDict objectForKey:@"PSCODE"];
        [self.navigationController pushViewController:wa animated:YES];
    }
    
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
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
    if (section == 0)
        headerView.text = @"  基本信息";
    else
        headerView.text = @"  位置信息";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [[self.toDisplayHeight objectAtIndex:indexPath.row] floatValue];
    }
    else
    {
        NSString *lat = [self.detailDict objectForKey:@"LATITUDE"];
        NSString *lon = [self.detailDict objectForKey:@"LONGITUDE"];
        if(lat.length > 0 && lon.length > 0)
        {
            return 600.0f;
        }
        else
        {
            return 60.0f;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
    {
        if(indexPath.row < 4)
        {
            NSString *title1 = [self.toDisplayKeyTitle objectAtIndex:indexPath.row*2];
            NSString *title2 = [self.toDisplayKeyTitle objectAtIndex:indexPath.row*2+1];
            NSString *value1 = [self.detailDict objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row*2]];
            NSString *value2 = [self.detailDict objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row*2+1]];
            CGFloat height = 60.0f;
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            NSString *itemTitle = [self.detailDict objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row*2]];
            CGFloat height = [[self.toDisplayHeight objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:[self.toDisplayKeyTitle objectAtIndex:indexPath.row*2] value:itemTitle andHeight:height];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
    }
    else
    {
        NSString *lat = [self.detailDict objectForKey:@"LATITUDE"];
        NSString *lon = [self.detailDict objectForKey:@"LONGITUDE"];
        if(lat.length > 0 && lon.length > 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MapViewCell"];
            if(cell == nil)
            {
                cell = [[EnterpriseMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MapViewCell"];
            }
            ((EnterpriseMapCell *)cell).title = [self.detailDict objectForKey:@"PSNAME"];
            ((EnterpriseMapCell *)cell).subTitle = [self.detailDict objectForKey:@"PSADDRESS"];
            ((EnterpriseMapCell *)cell).coordinate = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MapNoDataCell"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MapNoDataCell"];
            }
            cell.textLabel.text = @"暂无地理位置数据";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
