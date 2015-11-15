//
//  WNWZDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-7-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WNWZDetailViewController.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "FileUtil.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"

@interface WNWZDetailViewController ()

@property (nonatomic,strong) NSString *LCSLBH;
@property (nonatomic,strong) NSString *BZBH;
@property (nonatomic,assign) BOOL isBanli;

@property (nonatomic,strong) NSArray *toDisplayKey;//所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//所要显示的key对应的标题
@property (nonatomic,strong) NSMutableArray *toDisplayHeightAry;//每个Cell对应的高度

@property (nonatomic,strong) NSArray *stepAry;       //处理步骤
@property (nonatomic,strong) NSArray *stepHeightAry; //步骤的高度

@end

@implementation WNWZDetailViewController

@synthesize resultTableView, attachmentAry, wlwzinfoDict;
@synthesize urlString,isLoading,webHelper;
@synthesize WZID;
@synthesize LCSLBH, isBanli, actionsModel,itemParams;
@synthesize stepAry, stepHeightAry, toDisplayHeightAry, toDisplayKey, toDisplayKeyTitle;

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
    
    self.title = @"网络问政详情";
    self.bOKFromTransfer = NO;
    
    if(isBanli)
    {
        //如果是从待办跳转过来的
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        self.itemParams = [NSMutableDictionary dictionaryWithObject:self.BZBH forKey:@"BZBH"];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"办文编号：",@"紧急程度：",@"提交者：",@"Email地址：",@"联系电话：",@"手机号码：",@"通讯地址：",@"邮政编码：",@"提交时间：",@"要求回复时间：",@"邮件主题：",@"信件内容：",@"承办方回复内容：",@"办公室核稿意见：",@"分管领导批示：",@"局领导批示：",@"发布网络问政：", nil];
    //    SELECT WJBH,JJCD,CJR,CJRYX,DH,SJ,TXDZ,YZBM,ZT,convert(VARCHAR(50),CJSJ,20) CJSJ,convert(VARCHAR(50),XSHFRQ,20) XSHFRQ,NR,KSYJ,BGSYJ,FGLDYJ,LDYJ,RELEASEWLWZ ,XH FROM T_OA_WLWZ_DJB
    self.toDisplayKey = [NSArray arrayWithObjects:@"WJBH",@"JJCD",@"CJR",@"CJRYX",@"DH",@"SJ",@"TXDZ",@"YZBM",@"CJSJ",@"XSHFRQ",@"ZT",@"NR",@"KSYJ",@"BGSYJ",@"FGLDYJ",@"LDYJ",@"RELEASEWLWZ",nil];
    
    NSMutableArray *tmpToDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:10];
    for(int i = 0; i < 12; i++)
    {
        [tmpToDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tmpToDisplayHeightAry;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_PETITION_TASK_WLWZINFO" forKey:@"service"];
    [params setObject:self.LCSLBH forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    isLoading = YES;
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
	return 2;
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
        return 12;
    }
    //    else if(section == 1)
    //    {
    //        return (self.attachmentAry == nil || self.attachmentAry.count == 0) ? 1 : self.attachmentAry.count;
    //    }
    else
    {
        return (self.stepAry== nil || self.stepAry.count == 0) ? 1 : self.stepAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = nil;
        if(indexPath.row == 0)
        {
            //文件编号
            NSString *tjz = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:0]]];
            NSString *tjz_title = [self.toDisplayKeyTitle objectAtIndex:0];
            //邮箱
            NSString *email = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:1]]];
            NSString *email_title = [self.toDisplayKeyTitle objectAtIndex:1];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:tjz_title value2:email_title value3:tjz value4:email height:height];
        }
        else if(indexPath.row == 1)
        {
            //提交者
            NSString *tjz = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:2]]];
            NSString *tjz_title = [self.toDisplayKeyTitle objectAtIndex:2];
            //邮箱
            NSString *email = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:3]]];
            NSString *email_title = [self.toDisplayKeyTitle objectAtIndex:3];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:tjz_title value2:email_title value3:tjz value4:email height:height];
        }
        else if(indexPath.row == 2)
        {
            //联系电话
            NSString *lxdh_title = [self.toDisplayKeyTitle objectAtIndex:4];
            NSString *lxdh = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:4]]];
            //手机号码
            NSString *sjhm_title = [self.toDisplayKeyTitle objectAtIndex:5];
            NSString *sjhm = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:5]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:lxdh_title value2:sjhm_title value3:lxdh value4:sjhm height:height];
        }
        else if(indexPath.row == 3)
        {
            //通讯地址
            NSString *txdz_title = [self.toDisplayKeyTitle objectAtIndex:6];
            NSString *txdz = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:6]]];
            //邮政编码
            NSString *yzbm_title = [self.toDisplayKeyTitle objectAtIndex:7];
            NSString *yzbm = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:7]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:txdz_title value2:yzbm_title value3:txdz value4:yzbm height:height];
        }
        else if(indexPath.row == 4)
        {
            //提交时间
            NSString *tjsj_title = [self.toDisplayKeyTitle objectAtIndex:8];
            NSString *tjsj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:8]]];
            //要求回复时间
            NSString *yqhfsj_title = [self.toDisplayKeyTitle objectAtIndex:9];
            NSString *yqhfsj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:9]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:tjsj_title value2:yqhfsj_title value3:tjsj value4:yqhfsj height:height];
        }
        else
        {
            //邮件主题、信息内容等等。
            NSString *yjzt_title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row+5];
            NSString *yjzt = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row+5]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:yjzt_title value:yjzt andHeight:height];
            
        }
        //        else if(indexPath.row == 5)
        //        {
        //            //邮件主题
        //            NSString *yjzt_title = [self.toDisplayKeyTitle objectAtIndex:10];
        //            NSString *yjzt = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:10]]];
        //            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        //            cell = [UITableViewCell makeSubCell:tableView withTitle:yjzt_title value:yjzt andHeight:height];
        //        }
        //        else if(indexPath.row == 6)
        //        {
        //            //信件内容
        //            NSString *xjnr_title = [self.toDisplayKeyTitle objectAtIndex:11];
        //            NSString *xjnr = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:11]]];
        //            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        //            cell = [UITableViewCell makeSubCell:tableView withTitle:xjnr_title value:xjnr andHeight:height];
        //        }
        //        else
        //        {
        //            //拟回复内容
        //            NSString *hfnr_title = [self.toDisplayKeyTitle objectAtIndex:10];
        //            NSString *hfnr = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:10]]];
        //            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        //            cell = [UITableViewCell makeSubCell:tableView withTitle:hfnr_title value:hfnr andHeight:height];
        //        }
        return cell;
    }
    //    else if (indexPath.section == 1)
    //    {
    //        UITableViewCell *cell = nil;
    //        if(indexPath.row == 0)
    //        {
    //            //承办科室
    //            NSString *cbks_title = [self.toDisplayKeyTitle objectAtIndex:11];
    //            NSString *cbksvalue = [self getNonNullStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:11]]];
    //            cell = [UITableViewCell makeSubCell:tableView withTitle:cbks_title value:cbksvalue andHeight:60];
    //        }
    //        else if(indexPath.row == 1)
    //        {
    //            //承办时间
    //            NSString *cbsj_title = [self.toDisplayKeyTitle objectAtIndex:12];
    //            NSString *cbsj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:12]]];
    //            //办公室签收时间
    //            NSString *bgsqssj_title = [self.toDisplayKeyTitle objectAtIndex:13];
    //            NSString *bgsqssj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:13]]];
    //            cell = [UITableViewCell makeSubCell:tableView withValue1:cbsj_title value2:bgsqssj_title value3:cbsj value4:bgsqssj height:60];
    //        }
    //        else if(indexPath.row == 2)
    //        {
    //            //办结时间
    //            NSString *bjsj_title = [self.toDisplayKeyTitle objectAtIndex:14];
    //            NSString *bjsj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:14]]];
    //            //要求办结时限
    //            NSString *yqbjsj_title = [self.toDisplayKeyTitle objectAtIndex:15];
    //            NSString *yqbjsj = [self getDateStr:[self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:15]]];
    //            cell = [UITableViewCell makeSubCell:tableView withValue1:bjsj_title value2:yqbjsj_title value3:bjsj value4:yqbjsj height:60];
    //        }
    //        return cell;
    //    }
    //    else if (indexPath.section == 1)
    //    {
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fujianCell"];
    //        if(cell == nil)
    //        {
    //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fujianCell"];
    //            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    //        }
    //        if(self.attachmentAry.count == 0)
    //        {
    //            cell.textLabel.text = @"暂无附件信息";
    //        }
    //        else
    //        {
    //            //附件信息
    //            NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
    //            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
    //            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
    //            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
    //            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
    //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //        }
    //
    //        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    //        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    //        cell.selectedBackgroundView = bgview;
    //
    //        return cell;
    //    }
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
        if(self.toDisplayHeightAry  && self.toDisplayHeightAry.count > 0)
        {
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
            return 60;
        }
    }
    else if (indexPath.section == 2)
    {
        if(stepHeightAry)
        {
            return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
            return 80.0f;
        }
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
        headerView.text = @"  网络问政信息";
    }
    //    else if (section == 1)
    //    {
    //        headerView.text = @"  附件信息";
    //    }
    else
    {
        headerView.text = @"  处理步骤";
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
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
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    BOOL bParseError = NO;
    NSArray *resultJSONAry = [resultJSON objectFromJSONString];
    if(resultJSONAry == nil || resultJSONAry.count == 0)
    {
        bParseError = YES;
    }
    else
    {
        NSDictionary *resultJSONDict = [resultJSONAry objectAtIndex:0];
        self.attachmentAry = [resultJSONDict objectForKey:@"wlwzfjxx"];//附件信息
        self.wlwzinfoDict = [[resultJSONDict objectForKey:@"wlwzinfo"] objectAtIndex:0];//基本信息
        self.stepAry = [resultJSONDict objectForKey:@"bzxx"];//处理步骤
        
        //基本信息高度
        NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:10];
        for(int i = 0; i < 12; i++)
        {
            if(i>=5)
            {
                NSString *itemTitle = [self.wlwzinfoDict objectForKey:[self.toDisplayKey objectAtIndex:i+5]];
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
        self.toDisplayHeightAry = aryTmp1;
        
        //步骤的高度
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
    }
    
    [self.resultTableView reloadData];
    
    if(bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相关数据." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.resultTableView reloadData];
        return;
    }
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    [self.resultTableView reloadData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

#pragma mark - private Method

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
