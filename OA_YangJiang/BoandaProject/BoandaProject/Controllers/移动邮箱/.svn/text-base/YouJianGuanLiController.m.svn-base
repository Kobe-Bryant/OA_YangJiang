//
//  YouJianGuanLiController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "YouJianGuanLiController.h"
#import "FileUtil.h"
#import "PDJsonkit.h"
#import "WriteEmailViewController.h"
#import "DisplayAttachFileController.h"
#import "SystemConfigContext.h"
#import "ASIHTTPRequest.h"
#import "ServiceUrlString.h"

@interface YouJianGuanLiController ()

- (void)writeEmail:(id)sender;
- (void)replyEmail:(id)sender;
- (void)transmitEmail:(id)sender;

@end

@implementation YouJianGuanLiController

@synthesize parsedOutBoxItemAry,parsedInBoxItemAry,listTableView,listDataType,fileTableView,nWebDataType,parsedFileItemAry;
@synthesize titleLabel,fromLabel,sendTimeLabel,mainTextView,curEmaiJBXXDic;
@synthesize isLoading,curPageOfSend,curPageOfRecv,pagesumOfSend,pagesumOfRecv;

@synthesize urlRecv,urlSend,readedSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void) getListDatas:(NSInteger)type
{
    NSString *cmd = nil;
    if (type == 0)
    {
        //收件箱只去未读
        if ([parsedInBoxItemAry count] > 0)
        {
            [self.listTableView reloadData];
            return;
        }
        cmd = @"QUERY_NBYJJSJLIST";
    }
    else
    {
        if ([parsedOutBoxItemAry count] > 0)
        {
            [self.listTableView reloadData];
            return;
        }
        cmd = @"QUERY_NBYJJFJLIST";
        
    }
    NSDate *fromDate = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*90];//倒数30＊3天
    NSDate *endDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fromDateString = [dateFormatter stringFromDate:fromDate];
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:cmd forKey:@"service"];
    [params setObject:fromDateString forKey:@"q_CJSJ1"];
    [params setObject:endDateString forKey:@"q_CJSJ2"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    if(type == 0)
        self.urlRecv = strUrl;
    else
        self.urlSend = strUrl;
    
    isLoading = YES;
    nWebDataType = nWebDataForEmailList;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)writeEmail:(id)sender
{
    WriteEmailViewController *vc = [[WriteEmailViewController alloc] initWithNibName:@"WriteEmailViewController" bundle:nil];
    vc.title = @"编写邮件";
    vc.fjlxTag = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)replyEmail:(id)sender
{
    if (!_choosed)
    {
        return;
    }
    WriteEmailViewController *vc = [[WriteEmailViewController alloc] initWithNibName:@"WriteEmailViewController" bundle:nil];
    vc.sjrString = self.fjrString;
    vc.btString = self.btString;
    vc.nrString = self.nrString;
    vc.receiverString = self.fjrID;
    vc.fjlxTag = 2;
    vc.title = @"回复邮件";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transmitEmail:(id)sender
{
    if (!_choosed)
    {
        return;
    }
    WriteEmailViewController *vc = [[WriteEmailViewController alloc] initWithNibName:@"WriteEmailViewController" bundle:nil];
    vc.fjrString = self.fjrString;
    vc.btString = self.btString;
    vc.nrString = self.nrString;
    vc.fjlxTag = 3;
    vc.fjbh = self.fjbh;
    vc.title = @"转发邮件";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    BOOL bParseError = NO;
    if(nWebDataType == nWebDataForEmailList)
    {
        if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
        {
            NSArray *itemAry = [[tmpParsedJsonAry lastObject] objectForKey:@"dataInfos"];
            if(itemAry == nil )
            {
                bParseError = YES;
            }
            
            NSDictionary *pageInfoDic = [[tmpParsedJsonAry lastObject] objectForKey:@"pageInfo"];
            if(pageInfoDic == nil )
            {
                bParseError = YES;
            }
            if(bParseError == NO)
            {
                if (listDataType == 0)
                {
                    [self.parsedInBoxItemAry addObjectsFromArray:itemAry];
                    pagesumOfRecv = [[pageInfoDic objectForKey:@"pages"] intValue];
                    curPageOfRecv = [[pageInfoDic objectForKey:@"current"] intValue];
                }
                else
                {
                    [self.parsedOutBoxItemAry addObjectsFromArray:itemAry];
                    pagesumOfSend = [[pageInfoDic objectForKey:@"pages"] intValue];
                    curPageOfSend = [[pageInfoDic objectForKey:@"current"] intValue];
                }
            }
        }
        else
        {
            bParseError = YES;
        }
    }
    else
    {
        NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
        if(tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
        {
            self.curEmaiJBXXDic = [[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"];
            if(curEmaiJBXXDic == nil )
            {
                bParseError = YES;
            }
            else
            {
                titleLabel.text = [curEmaiJBXXDic objectForKey:@"bt"];
                sendTimeLabel.text = [curEmaiJBXXDic objectForKey:@"cjsj"];
                fromLabel.text = [curEmaiJBXXDic objectForKey:@"cjr"];
                mainTextView.text = [curEmaiJBXXDic objectForKey:@"bz"];
                
                //转发,回复
                self.fjrString = [curEmaiJBXXDic objectForKey:@"cjr"];
                self.btString = [curEmaiJBXXDic objectForKey:@"bt"];
                self.nrString = [curEmaiJBXXDic objectForKey:@"bz"];
                self.fjrID = [curEmaiJBXXDic objectForKey:@"cjrid"];
            }
            
            [parsedFileItemAry removeAllObjects];
            NSArray *itemFileAry  = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
            if (itemFileAry.count > 0)
            {
                self.fjbh = [[itemFileAry objectAtIndex:0] objectForKey:@"appbh"];
            }
            if (itemFileAry != nil )
            {
                [self.parsedFileItemAry addObjectsFromArray:itemFileAry];
            }
            [fileTableView reloadData];
        }
        else
        {
            bParseError = YES;
        }
    }
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据出错。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(nWebDataType == nWebDataForEmailList)
    {
        [self.listTableView reloadData];
    }
}

-(void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求数据失败." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return;
}


- (void)modifyNavigationBar
{
      
    //标题
    self.title = @"邮件";
    
    //导航栏右边按钮
    UIBarButtonItem *aItem1 = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(writeEmail:)];
    UIBarButtonItem *aItem2 = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(replyEmail:)];
    UIBarButtonItem *aItem3 = [[UIBarButtonItem alloc] initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(transmitEmail:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:aItem3,aItem2,aItem1, nil];
}

- (void) segCtrlChanged:(id)sender
{
    UISegmentedControl *ctrl = (UISegmentedControl *)sender;
    listDataType = ctrl.selectedSegmentIndex;
    [self getListDatas:listDataType];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _choosed = NO;
    
    //修改导航栏
    [self modifyNavigationBar];
    
    
    NSArray *segmentControlTitles = [NSArray arrayWithObjects:@"收件箱",@"发件箱", nil];
    UISegmentedControl *segctrl = [[UISegmentedControl alloc] initWithItems:segmentControlTitles];
    [segctrl addTarget:self action:@selector(segCtrlChanged:) forControlEvents:UIControlEventValueChanged];
    segctrl.segmentedControlStyle = UISegmentedControlStyleBar;
    segctrl.frame = CGRectMake(50,17,156,30);
    segctrl.selectedSegmentIndex = 0;
    listDataType = 0;
    [self.view addSubview:segctrl];
    
    parsedInBoxItemAry = [[NSMutableArray alloc] initWithCapacity:30];
    parsedOutBoxItemAry = [[NSMutableArray alloc] initWithCapacity:30];
    parsedFileItemAry = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"white" ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
	fileTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    
    [self getListDatas:listDataType];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return [parsedFileItemAry count];
    }
    else
    {
        if (listDataType == 0)
            return [self.parsedInBoxItemAry count];
        else
            return [self.parsedOutBoxItemAry count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    NSMutableArray *tmpAry = nil;
    if (tableView.tag == 1)
    {
        static NSString *identifier = @"fileIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        
        if (parsedFileItemAry ==nil||[parsedFileItemAry count] == 0)
        {
            cell.textLabel.text = @"没有相关附件";
        }
        else
        {
            NSDictionary *dicTmp = [parsedFileItemAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [dicTmp objectForKey:@"wdmc"];
            cell.detailTextLabel.text =
            [dicTmp objectForKey:@"wddx"];
            cell.textLabel.numberOfLines = 3;
            NSString *pathExt = [[dicTmp objectForKey:@"wdmc"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else
    {
        static NSString *identifier = @"listIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        if (listDataType == 0)
            tmpAry = parsedInBoxItemAry;
        else
            tmpAry = parsedOutBoxItemAry;
        
        NSDictionary *tmpDic = [tmpAry objectAtIndex:indexPath.row];
        NSString *title = nil;
        NSString *deliverTime = nil;
        NSString *sendPerson = nil;
        if (tmpDic )
        {
            title = [tmpDic objectForKey:@"BT"];
            deliverTime = [tmpDic objectForKey:@"CJSJ"];
            if ([deliverTime length] > 9)
            {
                deliverTime = [deliverTime substringFromIndex:5];
            }
            sendPerson = [tmpDic objectForKey:@"CJR"];
        }
        if (title == nil )
            title = @"";
        if (deliverTime == nil )
            deliverTime = @"";
        if (sendPerson == nil )
            sendPerson = @"";
        
        if (tmpDic )
            title = [tmpDic objectForKey:@"BT"];
        if (title == nil )
            title = @"";
        NSString *detail = [NSString stringWithFormat:@"发件人:%@  时间:%@",sendPerson,deliverTime];
        
        cell.textLabel.text = title ;
        cell.textLabel.numberOfLines = 3;
        
        cell.detailTextLabel.text = detail;
        cell.imageView.image = [UIImage imageNamed:@"mail_unread.png"];
        if([[tmpDic objectForKey:@"SFCK"] isEqualToString:@"1"])//SFCK 0是未读。 1是已读
            cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
        else if (readedSet) {
            if ([readedSet containsObject: [NSNumber numberWithInt:indexPath.row] ]) {
                cell.imageView.image =[UIImage imageNamed:@"mail_readed.png"];
            }
        }
        //发件箱都用已读图标
        if (listDataType == 1)
            cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
    }
    
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _choosed = YES;
    if (tableView.tag == 1)
    {
        //打开附件
        if ([parsedFileItemAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [parsedFileItemAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"wdbh"];
        NSString *appidStr = [dicTmp objectForKey:@"appbh"];
        if (idStr == nil )
        {
            return;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
       
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"wdmc"]];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"mail_readed.png"];
        nWebDataType = nWebDataForContent;
        mainTextView.text = @"";
        NSMutableArray *tmpAry = nil;
        if (listDataType == 0)
        {
            tmpAry = parsedInBoxItemAry;
            if (readedSet ==nil)
            {
                readedSet = [[NSMutableSet alloc] initWithCapacity:5];
            }
            [readedSet addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        else
        {
            tmpAry = parsedOutBoxItemAry;
        }
        NSDictionary *tmpDic = [tmpAry objectAtIndex:indexPath.row];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
        [params setObject:@"QUERY_NBYJJCONTENT" forKey:@"service"];
        [params setObject:[tmpDic objectForKey:@"LBBH"] forKey:@"id"];

        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        
        isLoading = YES;
        nWebDataType = nWebDataForContent;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
        
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading)
    {
        return;
    }
    if(scrollView.tag == 1)
        return;//是附件表格在拉动
    if(listDataType == 0)
    {
        if (curPageOfRecv >= pagesumOfRecv)
        {
            return;
        }
    }
    else
    {
        if (curPageOfSend >= pagesumOfSend)
        {
            return;
        }
    }
    
    NSString *strUrl = nil;
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        if (listDataType == 0)
        {
            curPageOfRecv++;
            strUrl =[NSString stringWithFormat:@"%@&P_CURRENT=%d",urlRecv,curPageOfRecv];
        }
        else
        {
            curPageOfSend++;
            strUrl =[NSString stringWithFormat:@"%@&P_CURRENT=%d",urlSend,curPageOfSend];
        }
        isLoading = YES;
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}


@end
