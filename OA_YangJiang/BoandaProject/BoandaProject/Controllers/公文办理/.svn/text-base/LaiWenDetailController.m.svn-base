//
//  BanLiDetaiController.m
//  GuangXiOA
//
//  Created by 曾静 on 13-12-26.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LaiWenDetailController.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "SharedInformations.h"
#import "ServiceUrlString.h"
#import "DetailCellInfo.h"

@interface LaiWenDetailController ()

@property (nonatomic, strong) NSArray *baseDetailCellAry;

@end

@implementation LaiWenDetailController
@synthesize infoDic,stepAry,attachmentAry,toDisplayKeyTitle;
@synthesize resTableView,chushiOpinionAry,toDisplayKey,LCSLBH;
@synthesize toDisplayHeightAry,stepHeightAry;
@synthesize webHelper,itemParams,actionsModel;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh isBanli:(BOOL)banli
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        // Custom initialization
        self.LCSLBH = bh;
        self.isBanli = banli;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //隐藏Popover View
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"阳江市环境保护局办公室文件呈批表";
    
    //初始化数据
    [self initData];
    
    if(self.isBanli)
    {
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWBL" forKey:@"service"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];//441700201400648
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//	return 4; 去除处室意见信息
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
    if (section == 0)  headerView.text= @"  来文信息";
    else if (section == 1)  headerView.text= @"  附件";
    else if (section == 2)  headerView.text= @"  处理步骤";
    else   headerView.text= @"  处室意见信息";
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
    {
        return self.toDisplayKeyTitle.count;
    }
    else if (section == 1)
    {
        return (self.attachmentAry && self.attachmentAry.count > 0) ? [self.attachmentAry count] : 1;
    }
    else if (section == 2)
    {
        return (self.stepAry && self.stepAry.count > 0) ? self.stepAry.count : 1;
    }
    else if(section == 3)
    {
        return (self.chushiOpinionAry && self.chushiOpinionAry.count > 0) ? [self.chushiOpinionAry count] : 1;
    }
    return 0;
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
            return 60.0f;
        }
    }
    else if(indexPath.section == 1)
    {
        return 80.0f;
    }
    else if(indexPath.section == 2)
    {
        if(self.stepHeightAry && self.stepHeightAry.count > 0)
        {
            return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
            return 60.0f;
        }
    }
    else if(indexPath.section == 3)
    {
        if(self.chushiOpinionAry && self.chushiOpinionAry.count > 0)
        {
            return 100;
        }
        else
        {
            return 60.0f;
        }
        
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = nil;
        
        //左边显示的字段内容
        DetailCellInfo *info = [self.baseDetailCellAry objectAtIndex:indexPath.row];
        if(info.cellType == DetailCellDoubleType)
        {
            NSString *title1 = [NSString stringWithFormat:@"%@：", info.leftTitle];
            NSString *title2 = [NSString stringWithFormat:@"%@：", info.rightTitle];
            NSString *value1 = @"";
            if([self.infoDic objectForKey:info.leftKey])
            {
                value1 = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:info.leftKey]];
            }
            if([info.leftKey isEqualToString:@"JJCD"])
            {
                //紧急程度
                int jjcd = [[self.infoDic objectForKey:info.leftKey] intValue];
                value1 = [self getJJCDStr:jjcd];
            }
            
            //右边字段显示的内容
            NSString *value2 = @"";
            if([self.infoDic objectForKey:info.rightKey])
            {
                value2 = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:info.rightKey]];
            }
            if([info.rightKey isEqualToString:@"BMJB"])
            {
                value2 = @"无密";
            }
            NSLog(@"%@ %@", title1, title2);
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%@：", info.leftTitle];
            NSString *value = @"";
            if([self.infoDic objectForKey:info.leftKey])
            {
                value = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:info.leftKey]];
            }
            
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *identifier = @"fujiancell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (self.attachmentAry ==nil||[self.attachmentAry count] == 0)
        {
            cell.textLabel.text = @"无";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [self.attachmentAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        return cell;
    }
    else if(indexPath.section == 2)
    {
        if (self.stepAry == nil || [self.stepAry count] == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stepCell"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stepCell"];
            }
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.text = @"暂无处理步骤信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            
            return cell;
        }
        else
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"]];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
                   
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            return cell;
        }
    }
    else
    {
        if (self.chushiOpinionAry == nil || [self.chushiOpinionAry count] == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"opinionCell"];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"opinionCell"];
            }
            
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.text = @"暂无处室意见信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            
            return cell;
        }
        else
        {
            NSDictionary *dicTmp = [self.chushiOpinionAry   objectAtIndex:indexPath.row];
            NSString *value1 =[NSString stringWithFormat:@"%d. 意见：%@", indexPath.row+1,[dicTmp objectForKey:@"YJ"]];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"TCRMC"] ];
            NSString *title =[NSString stringWithFormat:@"单位／处室：%@", [dicTmp objectForKey:@"ZZJC"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"CJSJ"]];
            UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1 SubValue2:value2 SubValue3:value3 andHeight:100];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
            bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
            cell.selectedBackgroundView = bgview;
            return cell;
        }
    }
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

#pragma mark - Network Handler Method

- (void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSMutableString *tmpJSONString = [[NSMutableString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    [tmpJSONString replaceOccurrencesOfString:@"@><@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmpJSONString.length)];
    resultJSON = tmpJSONString;
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"lwInfo"] lastObject];
        NSString *djsj = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"DJSJ"]];
        if([djsj length] >=16)
        {
            NSString *subSj = [djsj substringWithRange:NSMakeRange(11, 5)];
            if([subSj isEqualToString:@"00:00"])
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
                [dic setObject:[djsj substringToIndex:11] forKey:@"DJSJ"];
                self.infoDic = dic;
            }
        }
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwbz"];
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwfj"];
        self.chushiOpinionAry = [[tmpParsedJsonAry lastObject] objectForKey:@"csyjInfo"];
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
    
    //基本信息Cell高度
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *aryHeightTmp = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.toDisplayKeyTitle.count; i++)
    {
        NSString *t = [self.toDisplayKeyTitle objectAtIndex:i];
        NSString *k = [self.toDisplayKey objectAtIndex:i];
        DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:self.infoDic andWithTitleInfo:t andWithKeyInfo:k];
        [aryTmp addObject:info];
        CGFloat h = [info getRowHeight];
        [aryHeightTmp addObject:[NSNumber numberWithFloat:h]];
    }
    self.baseDetailCellAry = aryTmp;
    self.toDisplayHeightAry = aryHeightTmp;
    
    //处理步骤Cell高度
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for(int i=0; i< [stepAry count];i++)
    {
        NSDictionary *dicTmp = [stepAry objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700] + 30;
        if(cellHeight < 60)
        {
            cellHeight = 60.0f;
        }
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

//初始化数据
- (void)initData
{
    /*
     2014-03-15 zengjing 修改来文显示的详细信息的字段布局，调整部分字段的位置
     NSArray *tmpTitleAry = [NSArray arrayWithObjects:@"文件标题", @"密级" ,@"来文单位#紧急程度",@"文件类型#流水号", @"来文日期#限时办结日期", @"来文文种#来文文号", @"拟办意见", @"核稿意见", @"领导批示", @"登记人#登记时间", @"修改人#修改时间", @"备注",nil];
     NSArray *tmpKeyAry = [NSArray arrayWithObjects:@"LWBT", @"BMJB" ,@"xzdw#JJCD",@"LWLX#LWLSH", @"LWRQ#XSBJRQ", @"LWWZ#LWWH", @"TNBYJ", @"HGYJ", @"TLDPS", @"CJR#CJSJ", @"XGR#XGSJ", @"BZ",nil];
     */
    
    /*
     2014-03-22 zengjing 修改来文显示的详细信息的字段布局，调整部分字段的位置
     NSArray *tmpTitleAry = [NSArray arrayWithObjects:@"文件标题", @"密级" ,@"来文单位#紧急程度",@"文件类型#流水号", @"来文日期#办结日期", @"来文文种#来文文号", @"登记人拟办人#登记时间", @"拟办意见", @"核稿意见", @"备注",nil];
     NSArray *tmpKeyAry = [NSArray arrayWithObjects:@"LWBT", @"BMJB" ,@"xzdw#JJCD",@"LWLX#LWLSH", @"LWRQ#XSBJRQ", @"LWWZ#LWWH", @"CJR#CJSJ", @"TNBYJ", @"HGYJ", @"BZ",nil];
     */
    
    /*
     2014-04-02 zengjing 修改来文显示的详细信息的字段布局，调整部分字段的位置
     NSArray *tmpTitleAry = [NSArray arrayWithObjects:@"紧急程度#密级",@"办文编号", @"来文单位#收文时间", @"文种#文号" , @"标题", @"拟办意见", @"办公室负责人\n意见", @"领导批示", @"科室领导意见", @"传阅签名", @"文件处理情况", nil];
     NSArray *tmpKeyAry = [NSArray arrayWithObjects:@"JJCD#BMJB", @"LWLSH", @"xzdw#LWRQ", @"LWWZ#LWWH", @"LWBT", @"TNBYJ", @"TBGSFZRYJ", @"TLDPS", @"TKSLDYJ", @"CYQM", @"WJCLQK",nil];
     */
    //@"登记人#登记时间" @"CJR#CJSJ"
    NSArray *tmpTitleAry = [NSArray arrayWithObjects:@"紧急程度#密级", @"办文编号#来文时间", @"来文单位", @"文种#文号" , @"标题", @"拟办意见", @"办公室负责人意见", @"分管领导批示", @"领导批示", @"科室办理情况负责人",@"科室办理情况承办人",@"传阅签名",/*@"登记人#登记时间", @"修改人#修改时间",*/ nil];
    NSArray *tmpKeyAry = [NSArray arrayWithObjects:@"JJCD#MJ", @"DQBH#LWRQ", @"XZDW", @"LWWZ#LWWH" , @"LWBT", @"TNBYJ", @"TBGSFZRYJ", @"FGLDPS", @"JZPS", @"KSBLQKFZR",@"KSBLQKCBR",@"CYQM",/*@"CJR#CJSJ", @"XGR#XGSJ",*/ nil];
    self.toDisplayKey = tmpKeyAry;
    self.toDisplayKeyTitle = tmpTitleAry;
    
    NSMutableArray *tempDetailCellAry = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0 ; i < tmpTitleAry.count; i++)
    {
        NSString *t = [self.toDisplayKeyTitle objectAtIndex:i];
        NSString *k = [self.toDisplayKey objectAtIndex:i];
        DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:nil andWithTitleInfo:t andWithKeyInfo:k];
        [tempDetailCellAry addObject:info];
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.baseDetailCellAry = tempDetailCellAry;
    self.toDisplayHeightAry = tempDisplayHeightAry;
}

/**
 *  根据紧急程度的代码获取紧急程度的描述
 *
 *  @param jjcd 紧急程度代码值
 *
 *  @return 紧急程度的描述
 */
- (NSString *)getJJCDStr:(int)jjcd
{
    NSString *value1 = @"平件";
    if(jjcd == 0)
    {
        value1 = @"平件";
    }
    else if (jjcd == 1)
    {
        value1 = @"急";
    }
    else if (jjcd == 2)
    {
        value1 = @"特急";
    }
    else if (jjcd == 3)
    {
        value1 = @"特提";
    }
    return value1;
}

@end
