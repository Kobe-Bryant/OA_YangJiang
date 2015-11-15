//
//  DBDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "DBDetailViewController.h"
#import "PDJsonkit.h"
#import "FileUtil.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "NSStringUtil.h"
#import "SharedInformations.h"

#define Service_Name @"QUERY_PETITION_TASK_RWDBINFO" //服务名

@interface DBDetailViewController ()
@property (nonatomic,strong) NSString *LCSLBH;
@property (nonatomic,strong) NSString *BZBH;
@property (nonatomic,assign) BOOL isBanli;

@property (nonatomic,strong) NSArray *toDisplayKey;//所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//所要显示的key对应的标题
@property (nonatomic,strong) NSMutableArray *toDisplayHeightAry;//每个Cell对应的高度

@property (nonatomic,strong) NSArray *stepAry;       //处理步骤
@property (nonatomic,strong) NSArray *stepHeightAry; //步骤的高度

@end

@implementation DBDetailViewController

@synthesize resultTableView;
@synthesize urlString, webHelper,isLoading;
@synthesize DBID;
@synthesize rwdbinfoDict, attachmentAry;
@synthesize actionsModel, LCSLBH, BZBH, isBanli, itemParams;
@synthesize stepAry, stepHeightAry;
@synthesize toDisplayKey, toDisplayKeyTitle, toDisplayHeightAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh andBZBH:(NSString *)bz isBanli:(BOOL)banli
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.LCSLBH = bh;
        self.BZBH = bz;
        self.isBanli = banli;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"督办任务详情";
    self.bOKFromTransfer = NO;
    if(isBanli){
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        self.itemParams = [NSMutableDictionary dictionaryWithObject:self.BZBH forKey:@"BZBH"];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"任务发起人：",@"任务发起时间：",@"督办人：",@"督办时间：",@"紧急程度：",@"任务期限：",@"任务名称：",@"任务描述：", nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"FQR",@"FQSJ",@"DBR",@"DBSJ",@"JJCD",@"RWQX",@"RWMC",@"RWMS", nil];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:Service_Name forKey:@"service"];
    [params setObject:LCSLBH forKey:@"id"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.actionsModel && self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [self setResultTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else if(section == 1)
    {
        return (attachmentAry.count == 0 || attachmentAry == nil) ? 1 : attachmentAry.count;
    }
    else
    {
        return (stepAry.count == 0 || stepAry == nil) ? 1 : stepAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = nil;
        if(indexPath.row == 0)
        {
            //任务发起人
            NSString *fqr_title = [self.toDisplayKeyTitle objectAtIndex:0];
            NSString *fqr = [self getNonNullStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:0]]];
            //任务发起时间
            NSString *fqsj_title = [self.toDisplayKeyTitle objectAtIndex:1];
            NSString *fqsj = [self getDateStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:1]]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:fqr_title value2:fqsj_title value3:fqr value4:fqsj height:60];
        }
        else if(indexPath.row == 1)
        {
            //督办人
            NSString *dbr_title = [self.toDisplayKeyTitle objectAtIndex:2];
            NSString *dbr = [self getNonNullStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:2]]];
            //督办时间
            NSString *dbsj_title = [self.toDisplayKeyTitle objectAtIndex:3];
            NSString *dbsj = [self getDateStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:3]]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:dbr_title value2:dbsj_title value3:dbr value4:dbsj height:60];
        }
        else if(indexPath.row == 2)
        {
            //紧急程度
            NSString *jjcd_title = [self.toDisplayKeyTitle objectAtIndex:4];
            int jjcd = [[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:4]] intValue];
            NSString *jjcdStr =[SharedInformations getJJCDFromInt:jjcd];
            //任务期限
            NSString *rwqx_title = [self.toDisplayKeyTitle objectAtIndex:5];
            NSString *rwqx = [self getDateStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:5]]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:jjcd_title value2:rwqx_title value3:jjcdStr value4:rwqx height:60];
        }
        else if(indexPath.row == 3)
        {
            //任务名称
            NSString *rwmc_title = [self.toDisplayKeyTitle objectAtIndex:6];
            NSString *rwmc = [self getNonNullStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:6]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:rwmc_title value:rwmc andHeight:height];
        }
        else
        {
            //任务描述
            NSString *rwms_title = [self.toDisplayKeyTitle objectAtIndex:7];
            NSString *rwms = [self getNonNullStr:[self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:7]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:rwms_title value:rwms andHeight:height];
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fujianCell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fujianCell"];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        }
        if(self.attachmentAry.count == 0)
        {
            cell.textLabel.text = @"无";
        }
        else
        {
            //附件信息
            NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    else
    {
        if (stepAry == nil || [stepAry count] == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stepCell"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stepCell"];
            }
            
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.text = @"暂无处理步骤";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = nil;
            NSDictionary *dicTmp = [stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(self.toDisplayHeightAry && self.toDisplayHeightAry.count > 0)
        {
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
            return 60;
        }
    }
    else if(indexPath.section == 1)
    {
        return 80.0f;
    }
    else
    {
        return 80.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)
    {
        headerView.text= @"  督办任务信息";
    }
    else if(section == 1)
    {
        headerView.text= @"  附件";
    }
    else
    {
        headerView.text = @"  处理步骤";
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if ([attachmentAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil)
        {
            return;
        }
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Network Handle Method

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0)
    {
        return;
    }
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *resultJSONAry = [resultJSON objectFromJSONString];
    
    if(resultJSONAry && resultJSONAry.count > 0)
    {
        NSDictionary *resultJSONDict = [resultJSONAry objectAtIndex:0];
        if([[resultJSONDict objectForKey:@"rwdbinfo"] count] > 0)
        {
            self.rwdbinfoDict =  [[resultJSONDict objectForKey:@"rwdbinfo"] objectAtIndex:0];//详细信息
        }
        self.attachmentAry = [resultJSONDict objectForKey:@"rwdbfjxx"];//附件信息
        self.stepAry = [resultJSONDict objectForKey:@"bzxx"];//处理步骤
    }
    else
    {
        bParseError = YES;
    }
    
    if(bParseError)
    {
        [self showAlertMessage:@"获取数据出错。"];
    }
    //计算详细信息Cell的高度
    if(self.rwdbinfoDict)
    {
        NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:8];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
        for(int i = 0; i < 5; i++)
        {
            if(i>=3)
            {
                NSString *itemTitle = [self.rwdbinfoDict objectForKey:[self.toDisplayKey objectAtIndex:i+3]];
                if([itemTitle isEqual:[NSNull null]])
                {
                    itemTitle = @"";
                }
                else
                {
                    if(itemTitle == nil || [itemTitle isEqualToString:@""])
                    {
                        itemTitle = @"";
                    }
                }
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
        self.toDisplayHeightAry = aryTmp1;
    }
    //计算处理步骤Cell的高度
    if(stepAry && stepAry.count > 0)
    {
        UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
        NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i=0; i< [stepAry count];i++)
        {
            NSDictionary *dicTmp = [stepAry objectAtIndex:i];
            NSString *value =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"]];
            CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
            if(cellHeight < 60)cellHeight = 60.0f;
            [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        self.stepHeightAry = aryTmp2;
    }
  
    [self.resultTableView reloadData];
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self.resultTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

- (NSString *)getDateStr:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || str.length < 10 || [str isEqualToString:@""])
    {
        return @"";
    }
    else
    {
        return [str substringToIndex:10];
    }
}

- (NSString *)getNonNullStr:(NSString *)str
{
    if([str isEqual:[NSNull null]] || str == nil || [str isEqualToString:@""])
    {
        return @"";
    }
    else
    {
        return str;
    }
}



@end
