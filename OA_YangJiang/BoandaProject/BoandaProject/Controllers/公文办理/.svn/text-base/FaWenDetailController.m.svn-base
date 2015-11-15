//
//  FaWenDetailController.m
//  GuangXiOA
//
//  Created by 曾静 on 11-12-27.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FaWenDetailController.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "SharedInformations.h"

@implementation FaWenDetailController
@synthesize infoDic,toDisplayKey,toDisplayKeyTitle;
@synthesize stepAry,attachmentAry,gwInfoAry,resTableView;
@synthesize toDisplayHeightAry;
@synthesize webHelper,stepHeightAry,LCSLBH,actionsModel,itemParams;

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh isBanli:(BOOL)banli
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.LCSLBH = bh;
        self.isBanli = banli;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)initData
{
    
    //    select  replace(NDYJ,'@><@','')  NDYJ 1, FBDW 1,ZBDWHRGR 1, BNRQ 1, BLJZRQ 1,YBLD,ZYLD,FGLDYJ 1, HQDWYJ 1,CHRZJYJ,CHYJ,FHYJ,ZS 1,DNUM,WH 1, MJ ,JJCD 1, JDR 1,GKFS 1 ,PRINTNUMBER 1,WJMC 1,BH,XH from  T_OA_FWDJJBXX
    
//    BGSHG BMJB
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"主办单位：",@"拟稿人：",@"拟稿时间：",@"办理截止时间：",@"主办单位领导签署：",@"领导批示：",@"分管领导意见：",@"会签意见：",@"核稿意见：",@"发行范围及份数：",@"密级：",@"紧急程度：",@"校队人：",@"公开方式：",@"办文编号：",@"打印份数：",@"文件标题：",nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"FBDW",@"ZBDWHRGR",@"BNRQ",@"BLJZRQ",@"YBLD",@"ZYLD",@"NDYJ",@"FGLDYJ",@"HQDWYJ",@"CHRZJYJ",@"CHYJ",@"FHYJ",@"ZS",@"MJ",@"JJCD",@"JDR",@"GKFS",@"WH",@"PRINTNUMBER",@"WJMC",nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i=0; i< 13;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"发文详细信息";
    
    self.bOKFromTransfer = NO;
    
    [self initData];
    
    if(self.isBanli)
    {
        //如果是从待办跳转过来的
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    [self upLoaddata];
}

- (void)upLoaddata
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWBL" forKey:@"service"];
    [params setObject:LCSLBH forKey:@"LCSLBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self upLoaddata];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
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
    if (section == 0)  headerView.text= @"  发文信息";
    else if (section == 1)  headerView.text= @"  附件";
    else if (section == 2)  headerView.text= @"  处理步骤";
    //    else   headerView.text= @"  正式公文信息";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(self.toDisplayHeightAry && self.toDisplayHeightAry.count > 0)
        {
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
            return 60.0f;
        }
    }
    else if (indexPath.section == 1)
    {
        return 60.0f;
    }
    else if(indexPath.section == 2)
    {
        return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0){
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 )
    {
        return 13;
    }
    else if (section == 1)
    {
        return (self.attachmentAry == nil || self.attachmentAry.count == 0) ? 1 : self.attachmentAry.count;
    }
    else if (section == 2)
    {
        return (self.stepAry == nil || self.stepAry.count == 0) ? 1 : self.stepAry.count;
    }
    else
    {
        return (self.gwInfoAry == nil || self.gwInfoAry.count == 0) ? 1 : self.gwInfoAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //主办单位
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:0]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if(indexPath.row == 1)
        {
            //拟稿人 拟稿时间
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:1];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:1]];
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:2]];
            if(value2.length > 10)
            {
                value2 = [value2 substringToIndex:10];
            }
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if( indexPath.row == 2)
        {
            //办理截止时间
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:3]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 3)
        {
            //主办单位领导签署
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *value1 = [NSString stringWithFormat:@"%@ %@",[infoDic objectForKey:[toDisplayKey objectAtIndex:4]],[infoDic objectForKey:[toDisplayKey objectAtIndex:5]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 4)
        {
            //领导批示
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:6]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 5)
        {
            //分管领导意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:6];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:7]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 6)
        {
            //会签意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:7];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:8]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 7)
        {
            //核稿意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:8];
            NSString *value1 = [NSString stringWithFormat:@"%@ %@ %@",[infoDic objectForKey:[toDisplayKey objectAtIndex:9]],[infoDic objectForKey:[toDisplayKey objectAtIndex:10]],[infoDic objectForKey:[toDisplayKey objectAtIndex:11]]];
            
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 8)
        {
            //发行范围
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:9];
            NSString *value1 = [NSString stringWithFormat:@"范围：%@，发行%@份",[infoDic objectForKey:[toDisplayKey objectAtIndex:12]], [infoDic objectForKey:@"DNUM"]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
            
        }
        else if (indexPath.row == 9)
        {
            //密级
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:10];
            int mj = [[infoDic objectForKey:[toDisplayKey objectAtIndex:13]] intValue];
            NSString *value1 = [self getBMJBStr:mj];
            //紧急程度
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:11];
            int jjcd = [[infoDic objectForKey:[toDisplayKey objectAtIndex:14]] intValue];
            NSString *value2 = [self getJJCDStr:jjcd];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if (indexPath.row == 10)
        {
            //校对人
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:12];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:15]];
            //公开方式
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:13];
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:16]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if(indexPath.row == 11)
        {
            //文号
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:14];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:17]];
            //打印份数
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:15];
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:18]];
            
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
            
        }
        else if(indexPath.row == 12)
        {
            //文件标题
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:16];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:19]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        
        /*else
         {
         //主题词
         NSString *title1 = [toDisplayKeyTitle objectAtIndex:13];
         NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:13]];
         CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
         cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
         }*/
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"fujiancell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (attachmentAry ==nil||[attachmentAry count] == 0)
        {
            cell.textLabel.text = @"无";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [attachmentAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image =[FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)
    {
        if (stepAry ==nil||[stepAry count] == 0)
        {
            static NSString *identifier = @"fujiancell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = @"暂无相关处理步骤";
        }
        else
        {
            NSDictionary *dicTmp = [stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@", [dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 3)
    {
        static NSString *identifier = @"CellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.textLabel.numberOfLines = 0;
        }
        if (gwInfoAry ==nil||[gwInfoAry count] == 0)
        {
            cell.textLabel.text = @"暂无正式公文信息";
        }
        else
        {
            NSDictionary *dicTmp = [gwInfoAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        BOOL isModify = YES;
        if ([attachmentAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil )
        {
            return;
        }else
        {//判断是否为原文档
            for (NSDictionary* dic in attachmentAry) {
                NSString* str1 = [[dic objectForKey:@"WDBH"] length]>[idStr length]?[dic objectForKey:@"WDBH"]:idStr;
                NSString* str2 = [[dic objectForKey:@"WDBH"] length]>[idStr length]?idStr:[dic objectForKey:@"WDBH"];
                if (![str1 isEqualToString:str2])
                {
                    if ([[str1 substringWithRange:NSMakeRange(0, [str2 length])] isEqualToString:str2]&&[[idStr substringWithRange:NSMakeRange([idStr length]-1, 1)] compare:@"a"]==-1)
                    {
                        isModify = NO;
                    }
                }
            }
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        if (self.isBanli&&isModify) {
            controller.isFW = YES;
        }
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else  if(indexPath.section == 3)
    {
        if ([gwInfoAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [gwInfoAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil )
        {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        if (self.isBanli) {
            controller.isFW = YES;
        }
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Network Hanlder Method
- (void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", resultJSON);
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"fwInfo"] lastObject];
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"fwbz"];
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"fwfj"];
        self.gwInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"zsgw"];
    }
    else
    {
        bParseError = YES;
    }
    
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

    
    //计算基本信息高度
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i=0; i< 13;i++)
    {
        CGFloat cellHeight = 60.0f;
        if(i<=2 || (i>=8&&i<=11))
        {
            cellHeight = 60.0f;
        }
        else if (i==3)
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@ %@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+1]],[infoDic objectForKey:[toDisplayKey objectAtIndex:i+2]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)cellHeight = 60.0f;

        }
        else if(i>3&&i<7)
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+2]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)cellHeight = 60.0f;

        }
        else if(i==7)
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@ %@ %@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+2]],[infoDic objectForKey:[toDisplayKey objectAtIndex:i+3]],[infoDic objectForKey:[toDisplayKey objectAtIndex:i+4]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)cellHeight = 60.0f;
        }
        else
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+7]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)cellHeight = 60.0f;
        }
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp;
    
    //计算处理步骤高度
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [self.stepAry count];i++)
    {
        NSDictionary *dicTmp = [self.stepAry objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.stepHeightAry = aryTmp2;
    
    [resTableView reloadData];
}

- (void)processError:(NSError *)error
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

#pragma mark - Private Methods

- (NSString *)getJJCDStr:(int)code
{
    NSString *jjcdStr = @"一般";
    switch (code) {
        case 0:
            jjcdStr = @"一般";
            break;
        case 1:
            jjcdStr = @"紧急";
            break;
        case 2:
            jjcdStr = @"特急";
            break;
        default:
            break;
    }
    return jjcdStr;
}

- (NSString *)getBMJBStr:(int)code
{
    NSString *jjcdStr = @"无密";
    switch (code) {
        case 1:
            jjcdStr = @"无密";
            break;
        case 2:
            jjcdStr = @"秘密";
            break;
        case 3:
            jjcdStr = @"机密";
            break;
        case 4:
            jjcdStr = @"绝密";
            break;
        default:
            break;
    }
    return jjcdStr;
}

@end

