//
//  FawenDetailController.m
//  GuangXiOA
//
//  Created by 曾静 on 11-12-29.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FaWenContentController.h"
#import "PDJsonkit.h"
#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "ServiceUrlString.h"

@interface FaWenContentController ()
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString;
@end

@implementation FaWenContentController
@synthesize toDisplayKey,toDisplayKeyTitle,bsgwFilesAry,isHaveZSGW,jbxxDic,fwid,resTableView;
@synthesize toDisplayHeightAry,zsgwFilesAry;


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil andFWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.fwid = idstr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, imag etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"发文详细信息";
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"主办单位：",@"拟稿人：",@"拟稿时间：",@"主办单位领导签署：",@"领导批示：",@"分管领导意见：",@"会签意见：",@"核稿意见：",@"发行范围及份数：",@"密级：",@"紧急程度：",@"发文文号：",@"文件标题：",@"主题词：",nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"FBDW",@"ZBDWHRGR",@"BNRQ",@"CSSG",@"NDYJ",@"FGLDYJ",@"HQDWYJ",@"BGSHG",@"ZS",@"BMJB",@"JJCD",@"WH",@"WJMC",@"ZTC",nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i=0; i<12; i++) {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWCONTENT" forKey:@"service"];
    [params setObject:fwid forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    if (section == 0)   headerView.text = @"  发文信息";
    else if (section == 1)  headerView.text = @"  附件信息";
    else if(section == 2) headerView.text = @"  处理步骤";
    else   headerView.text = @"  正式打印公文";
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 12;
    }
    else if (section == 1)
    {
        return (self.bsgwFilesAry == nil || self.bsgwFilesAry.count == 0) ? 1 : self.bsgwFilesAry.count;
    }
    else if(section == 2)
    {
        return (self.stepAry.count > 0 || self.stepAry) ? self.stepAry.count : 1;
    }
    /*else
    {
        //只要一条正式公文
        if(isHaveZSGW)
            return [zsgwFilesAry count]+1;
        else
            return [zsgwFilesAry count];
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
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
    else if (indexPath.section == 2)
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
    else
    {
        return 60.0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
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
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:0]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if(indexPath.row == 1)
        {
            //拟稿人 拟稿时间
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:1];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:1]];
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:2]];
            if(value2.length > 10)
            {
                value2 = [value2 substringToIndex:10];
            }
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if( indexPath.row == 2)
        {
            //主办单位领导签署
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:3]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 3)
        {
            //领导批示
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:4]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 4)
        {
            //分管领导意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:5]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 5)
        {
            //会签意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:6];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:6]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 6)
        {
            //核稿意见
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:7];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:7]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 7)
        {
            //发行范围
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:8];
            NSString *tmpStr1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:8]];
            NSString *tmpStr2 = [jbxxDic objectForKey:@"DNUM"];
            NSString *value1 = [NSString stringWithFormat:@"范围：%@，发行%@份",tmpStr1, tmpStr2];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if( indexPath.row == 8)
        {
            //密级
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:9];
            int mj = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:9]] intValue];
            NSString *value1 = [SharedInformations getBMJBFromInt:mj];
            //紧急程度
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:10];
            int jjcd = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:10]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:jjcd];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if (indexPath.row == 9)
        {
            //文号
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:11];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:11]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else if(indexPath.row == 10)
        {
            //文件标题
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:12];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:12]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        else
        {
            //主题词
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:13];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:13]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title1 value:value1 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(indexPath.section == 1)
    {
        static NSString *identifier = @"cellFawenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if(indexPath.section == 1)
        {
            if (bsgwFilesAry ==nil||[bsgwFilesAry count] == 0)
            {
                cell.textLabel.text = @"暂无附件信息";
            }
            else
            {
                NSDictionary *dicTmp = [bsgwFilesAry   objectAtIndex:indexPath.row];
                cell.textLabel.text = [dicTmp objectForKey:@"WDMC"];
                NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
                cell.imageView.image = [FileUtil imageForFileExt:pathExt];
                cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
    }
    else if (indexPath.section == 2)
    {
        if (self.stepAry ==nil||[self.stepAry count] == 0)
        {
            static NSString *identifier = @"stepcell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = @"没有相关处理步骤";
        }
        else
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@", [dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    /*else if(indexPath.section == 3)
    {
        int indexRow = indexPath.row;
        BOOL flag = NO;
        if(isHaveZSGW == NO)
        {
            flag = YES;
        }
        else
        {
            if(indexPath.row == 0)
            {
                NSString *title = [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WJMC"]];
                NSString *title1 = [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] oldString:title];
                cell.textLabel.text = title1;
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                flag = YES;
                indexRow += 1;//第一条显示的是正式公文pdf
            }
        }
        if(flag == YES)
        {
            if(indexRow < [zsgwFilesAry count]){
                NSDictionary *dicTmp = [zsgwFilesAry   objectAtIndex:indexRow];
                cell.textLabel.text = [dicTmp objectForKey:@"WDMC"];
                NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
                cell.imageView.image = [FileUtil imageForFileExt:pathExt];
                cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }
    }*/
	UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if ([bsgwFilesAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [bsgwFilesAry objectAtIndex:indexPath.row];
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
         controller.isFW = YES;
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
    }    
    /*else if(indexPath.section == 2)
    {
        if(isHaveZSGW && indexPath.row == 0)
        {
            NSString *xh = [jbxxDic objectForKey:@"XH"];
            NSString *fileName= [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WH"]];
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
            [params setObject:@"DOWN_OA_FWZSGW" forKey:@"service"];
            [params setObject:xh forKey:@"xh"];
            NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
            DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:fileName];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            if ([zsgwFilesAry count] <= 0)
            {
                return;
            }
            NSDictionary *dicTmp = [zsgwFilesAry objectAtIndex:indexPath.row];            
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
            [self.navigationController pushViewController:controller animated:YES];

        }
    }*/
}

#pragma mark - Network Hanlder Method

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", resultJSON);
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        self.bsgwFilesAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        //self.zsgwFilesAry = [[tmpParsedJsonAry lastObject] objectForKey:@"sczsgw"];
        self.isHaveZSGW = [[jbxxDic objectForKey:@"ZSGWPATH"] length] > 0;//正式公文
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"fwbz"];//处理步骤
    }
    else
    {
        bParseError = YES;
    }
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据出错。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //基本信息高度
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< 12;i++)
    {
        CGFloat cellHeight = 60.0f;
        if(i==1 || i==8)
        {
            cellHeight = 60.0f;
        }
        else
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i+1]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
            if(cellHeight < 60)
                cellHeight = 60.0f;
        }
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.toDisplayHeightAry = aryTmp;
    //步骤高度
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [self.stepAry count];i++) {
        NSDictionary *dicTmp = [self.stepAry   objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@",
                          [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.stepHeightAry = aryTmp2;
    
    [resTableView reloadData];
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"请求数据失败."];
    return;
}

#pragma mark - Private Method

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString
{
    NSUInteger location = 0;
    NSUInteger length = [oldString length];
    unichar charBuffer[length];
    [oldString getCharacters:charBuffer];
    int i = 0;
    for (i = 0;i < length;i++)
    {
        location ++;
        if ([characterSet characterIsMember:charBuffer[i]])
        {
            break;
        }
    }
    return [oldString substringWithRange:NSMakeRange(0,location)];
}

@end
