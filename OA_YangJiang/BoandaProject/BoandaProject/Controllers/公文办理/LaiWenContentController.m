//
//  LaiwenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LaiWenContentController.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "SharedInformations.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"

@implementation LaiWenContentController
@synthesize jbxxDic,wjxxAry,lwid,toDisplayKey,toDisplayKeyTitle,resTableView; 
@synthesize toDisplayHeightAry;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andLWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.lwid = idstr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"来文详细信息";
    
    /*self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ",@"XSBJRQ",@"xzdw",@"LWLX",@"LWWH",@"JJCD",@"BMJB",@"LWBT",@"TNBYJ",@"TLDPS",@"WJBJQK",@"BZ",@"CJR",@"CJSJ",@"XGR",@"XGSJ",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"文件类型：",@"来文文号：",@"紧急程度：",@"密级：",@"文件标题：",@"拟办意见：",@"领导批示：",@"办理情况：",@"备       注：",@"登  记  人：",@"登记时间：",@"修  改  人：",@"修改时间：",nil];
    NSMutableArray *tempDisplayHeight = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i = 0 ; i < 12; i++) {
        [tempDisplayHeight addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeight;*/
    
    self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ",@"XSBJRQ",@"xzdw",@"LWLX",@"LWWH",@"JJCD",@"BMJB",@"LWBT",@"BZ",@"CJR",@"CJSJ",@"XGR",@"XGSJ",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"文件类型：",@"来文文号：",@"紧急程度：",@"密级：",@"文件标题：",@"备       注：",@"登  记  人：",@"登记时间：",@"修  改  人：",@"修改时间：",nil];
    NSMutableArray *tempDisplayHeight = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i = 0 ; i < 8; i++) {
        [tempDisplayHeight addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeight;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWCONTENT" forKey:@"service"];
    [params setObject:self.LCSLBH forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView Delegate Methods

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
    if (section == 0)  headerView.text = @"  来文信息";
    else if(section == 1)headerView.text = @"  来文附件";
    else headerView.text = @"  处理步骤";
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        //return 11;
        return 8;
    }
    else if(section == 1)
    {
        if ([wjxxAry count] == 0 || wjxxAry == nil)
        {
            return 1;
        }
        else
        {
            return [wjxxAry count];
        }
    }
    else
    {
        return self.stepAry.count > 0 ? self.stepAry.count : 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    else if (indexPath.section == 2)
    {
        if(self.stepAry == nil || self.stepAry.count == 0)
        {
            return 60.0f;
        }
        else
        {
            return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
        }
    }
    else
    {
        return 60.0f;
    }
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
        if(indexPath.row == 0)
        {
            //来文日期 限办结日期
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:0]];
            if([value1 length]>10)value1 = [value1 substringToIndex:10];
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:1]];
            if([value2 length]>10)value2 = [value2 substringToIndex:10];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if( indexPath.row == 1)
        {
            //来文单位 文件类型
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:2]];
            NSString *lwType = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:3]];
            NSString *value2 = [SharedInformations getLWLXFromStr:lwType];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if( indexPath.row == 2)
        {
            //来文文号 紧急程度
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:4]]];
            int num = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:5]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:num];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if( indexPath.row == 3)
        {
            //密级
            NSString *title = [toDisplayKeyTitle objectAtIndex:6];
            NSString *value = [SharedInformations getBMJBFromInt:[[jbxxDic objectForKey:[toDisplayKey objectAtIndex:6]] intValue]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if( indexPath.row == 4)
        {
            //文件标题
            NSString *title = [toDisplayKeyTitle objectAtIndex:7];
            NSString *value = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:7]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        /*else if( indexPath.row == 5)
        {
            //拟办意见
            NSString *title = [toDisplayKeyTitle objectAtIndex:8];
            NSString *value = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:8]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if( indexPath.row == 6)
        {
            //领导批示
            NSString *title = [toDisplayKeyTitle objectAtIndex:9];
            NSString *value = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:9]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if( indexPath.row == 7)
        {
            //办理情况
            NSString *title = [toDisplayKeyTitle objectAtIndex:10];
            NSString *value = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:10]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }*/
        else if( indexPath.row == 5)
        {
            //备注
            NSString *title = [toDisplayKeyTitle objectAtIndex:8];
            NSString *value = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:8]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if(indexPath.row == 6)
        {
            //登记人 登记时间
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:9];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:10];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:9]];
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:10]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            //修改人 修改时间
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:11];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:12];
            NSString *value1 = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:11]]];
            NSString *value2 = [self getNonNullStr:[jbxxDic objectForKey:[toDisplayKey objectAtIndex:12]]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = nil;
        static NSString *identifier = @"cellLaiwenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (wjxxAry ==nil||[wjxxAry count] == 0) {
            cell.textLabel.text = @"暂无附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [wjxxAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        
        return cell;
    }
    else
    {
        if (self.stepAry == nil || [self.stepAry count] == 0)
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
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
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
    
    if(indexPath.section == 1){
        if ([wjxxAry count] <= 0) {
            return;
        }

        NSDictionary *dicTmp = [wjxxAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
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

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", resultJSON);
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        self.wjxxAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwbz"];
    }
    else
        bParseError = YES;
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
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for(int i = 0; i < 8; i++)
    {
        if (i>=4 && i<= 5)
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i+3]]];
            CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)
            {
                cellHeight = 60.0f;
            }
            [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        else
        {
            [aryTmp addObject:[NSNumber numberWithFloat:60.0f]];
        }
    }
    self.toDisplayHeightAry = aryTmp;
    
    //处理步骤的高度
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [self.stepAry count];i++)
    {
        NSDictionary *dicTmp = [self.stepAry objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.stepHeightAry = aryTmp2;
    
    [resTableView reloadData];
}

- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
    return;
}

#pragma mark - Private Mehtod

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

- (NSString *)getNonNullStr:(id)str
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

- (CGFloat)getCellHeight:(NSString *)itemTitle
{
    if(itemTitle == nil || [itemTitle isEqualToString:@""])
    {
        return 60.0f;
    }
    else
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        return cellHeight;
    }
}

@end

