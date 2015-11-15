//
//  MeetingDetailsViewController.m
//  GuangXiOA
//
//  Created by sz apple on 11-12-30.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "MeetingDetailsViewController.h"
#import "ReplyMeetingViewController.h"
#import "MeetingReadingInfoVC.h"
#import "PDJsonkit.h"
#import "FileUtil.h"
#import "DisplayAttachFileController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"


@interface MeetingDetailsViewController()

@property(nonatomic,strong) NSArray *aryDWQK;//单位阅读情况
@property(nonatomic,strong) NSArray *aryGRQK;//个人阅读情况

@end

@implementation MeetingDetailsViewController

@synthesize baseInfoDic,tzbh,myTableView,attachmentInfoAry;
@synthesize baseTitleAry,baseKeyAry,myWebView;

@synthesize aryDWQK,aryGRQK;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.baseTitleAry = [[NSArray alloc] initWithObjects:@"编辑人：",@"编辑单位：",@"编辑日期：",@"处室核稿人：",nil];
        self.baseKeyAry = [[NSArray alloc] initWithObjects:@"NGR",@"ZBDW",@"NGSJ",@"CSHGR", nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)modifyNavigationBar
{
    UIBarButtonItem *aBarItemReply = [[UIBarButtonItem alloc] initWithTitle:@"意见反馈" style:UIBarButtonItemStylePlain target:self action:@selector(replyAction:)];
    UIBarButtonItem *aBarItemTH = [[UIBarButtonItem alloc] initWithTitle:@"阅读情况" style:UIBarButtonItemStylePlain target:self action:@selector(readingInfo:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:aBarItemReply, aBarItemTH, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self modifyNavigationBar];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setObject:@"QUERY_HYCONTENT" forKey:@"service"];
    [params setObject:tzbh forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    //NSLog(@"%@", strUrl);
}


-(void)viewWillDisappear:(BOOL)animated
{
   
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Private methods and delegates

- (UITableViewCell*) getCell:(NSString*) CellIdentifier forTablieView:(UITableView*) tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (UITableViewCell *)makeSubCell:(UITableView *)tableView withTitle:(NSString *)aTitle andValue:(NSString *)aValue
{
    UILabel* tLabel = nil;
    UILabel* vLabel = nil;
    
    UITableViewCell* aCell = [self getCell:@"Cell_baseInfo" forTablieView:tableView];
    
    if (aCell.contentView != nil)
    {
        tLabel = (UILabel *)[aCell.contentView viewWithTag:1];
        vLabel = (UILabel *)[aCell.contentView viewWithTag:2];
    }
    
    if (tLabel == nil)
    {
        CGRect tRect1 = CGRectMake(0, 0, 130, 55);
        tLabel = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [tLabel setTextColor:[UIColor darkGrayColor]];
        tLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        tLabel.textAlignment = UITextAlignmentRight;
        tLabel.numberOfLines = 4;
        tLabel.tag = 1;
        [aCell.contentView addSubview:tLabel];
        
        CGRect tRect2 = CGRectMake(140, 0, 450, 55);
        vLabel = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
        [vLabel setBackgroundColor:[UIColor clearColor]];
        [vLabel setTextColor:[UIColor blackColor]];
        vLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        vLabel.textAlignment = UITextAlignmentLeft;
        vLabel.numberOfLines = 4;
        vLabel.tag = 2;
        [aCell.contentView addSubview:vLabel];
        
    }
    
    [tLabel setText:aTitle];
    [vLabel setText:aValue];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    aCell.accessoryType = UITableViewCellAccessoryNone;
    
    return aCell;
}

#pragma mark - 网络数据处理

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.baseInfoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        if (baseInfoDic == nil)
            bParseError = YES;
        else{
            
            NSString *djsj = [NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"NGSJ"]];
            if([djsj length] >=16){
                NSString *subSj = [djsj substringWithRange:NSMakeRange(11, 5)];
                if([subSj isEqualToString:@"00:00"]){
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:baseInfoDic];
                    [dic setObject:[djsj substringToIndex:11] forKey:@"NGSJ"];
                    self.baseInfoDic = dic;
                }
                
            }
            
            NSString *htmlPath = nil;
            if ([[baseInfoDic objectForKey:@"TZMB"] intValue] == 2 ) {
                htmlPath = [[NSBundle mainBundle] pathForResource:@"NoticeTitle2" ofType:@"html"];
            }
            else{
                htmlPath = [[NSBundle mainBundle] pathForResource:@"NoticeTitle1" ofType:@"html"];
            }
            /*NSMutableString *html = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            [html appendFormat:@"%@", @"<td width=\"100%\" valign=\"top\"><p><font size=6 style=\"letter-spacing:2px;\">"];
            [html appendString:[baseInfoDic objectForKey:@"TZNR"]];
            [html appendFormat:@"%@", @"</font></p></td>"];
            [myWebView loadHTMLString:html baseURL:nil];*/
            
            NSString *content = [baseInfoDic objectForKey:@"TZNR"];
            NSMutableString *strNR = [NSMutableString stringWithString:content];
            [strNR replaceOccurrencesOfString:@"\r\n" withString:@"</br></p><p>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length]) ];
            
            NSMutableString *html = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            [html appendFormat:@"<div id=\"wrap\"><p>%@</p></div>",strNR];
            [html appendFormat:@"%@", @"</div></body></html>"];
            [myWebView loadHTMLString:html baseURL:nil];
        }
        
        
        self.attachmentInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.aryDWQK = [[tmpParsedJsonAry lastObject] objectForKey:@"dwydqk"];
        self.aryGRQK = [[tmpParsedJsonAry lastObject] objectForKey:@"grydqk"];
        
    }
    else
        bParseError = YES;
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    } else
        [self.myTableView reloadData];
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

#pragma mark - 按钮点击事件处理

-(void)replyAction:(id)sender
{
    ReplyMeetingViewController *controller = [[ReplyMeetingViewController alloc] initWithNibName:@"ReplyMeetingViewController" bundle:nil];
    controller.tzbh = tzbh;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)readingInfo:(id)sender
{
    MeetingReadingInfoVC *controller = [[MeetingReadingInfoVC alloc] initWithNibName:@"MeetingReadingInfoVC" bundle:nil];
    controller.aryGRQK = aryGRQK;
    controller.aryDWQK = aryDWQK;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - TableView Delegate Method

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
    if(section == 0)
    {
        headerView.text = @"  附件";
    }
    else if (section == 1)
    {
        headerView.text = @"  会议基本信息";
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if(attachmentInfoAry == nil)
        {
            return 0;
        }
        else  if ([attachmentInfoAry count]>0)
        {
            return [attachmentInfoAry count];
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return [baseTitleAry count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_Attachment";
    UITableViewCell *cell;
    NSString *key;
    NSString *title;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        if ([attachmentInfoAry count]>0)
        {
            NSDictionary *aItem = [attachmentInfoAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [aItem objectForKey:@"WDMC"];
            cell.detailTextLabel.text = [aItem objectForKey:@"WDDX"];
            NSString *pathExt = [[aItem objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.textLabel.text = @"暂无附件信息";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else
    {
        key = [baseKeyAry objectAtIndex:indexPath.row];
        title = [baseTitleAry objectAtIndex:indexPath.row];
        cell = [self makeSubCell:myTableView withTitle:title andValue:[baseInfoDic objectForKey:key]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //打开附件
        if ([attachmentInfoAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [attachmentInfoAry objectAtIndex:indexPath.row];
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
        
        //TODO:打开附件
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

@end
