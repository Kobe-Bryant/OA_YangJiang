//
//  FaWenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WBDetailsViewController.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "SystemConfigContext.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "SharedInformations.h"
#import "CustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface WBDetailsViewController()

@property (nonatomic,strong) NSMutableDictionary *infoDic; //微博信息
@property (nonatomic,strong) NSArray *toDisplayKey;//微博信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property (nonatomic,strong) NSMutableArray *toDisplayHeightAry;
@property (nonatomic,strong) NSString *LCSLBH;
@property (nonatomic,strong) NSArray *stepAry;      //微博步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic,strong) NSArray *attachmentAry; //微博附件
@property (nonatomic,strong) NSArray *gwInfoAry; //正式公文信息
@property (nonatomic,assign) BOOL isBanli;

@property (nonatomic,strong) UIView* backView;    //编辑时的背景view
@property (nonatomic,strong) UIView* editText;    //编辑的view
@property (nonatomic,strong) UITextView* textV;   //装输入的内容
@property (nonatomic,assign) BOOL isMicroblogEdit;//是否微博内容编辑请求

@end

@implementation WBDetailsViewController
@synthesize infoDic,toDisplayKey,toDisplayKeyTitle;
@synthesize stepAry,attachmentAry,gwInfoAry,resTableView;
@synthesize toDisplayHeightAry,isBanli;
@synthesize stepHeightAry,LCSLBH,actionsModel,itemParams;
@synthesize backView,editText,textV;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh isBanli:(BOOL)banli
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    { 
        self.LCSLBH = bh;
        self.isBanli = banli;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title =@"微博详细信息";
    
    self.bOKFromTransfer = NO;
    self.isMicroblogEdit = NO;
    //select XH,WJBH,NGRQ,FBBWDW,NR,HGYJ,WLFYRYJ,LDYJ,RELEASEBLOG from T_OA_WBFW
 
//    SELECT WJBH,convert(VARCHAR(50),NGRQ,20) NGRQ,FBBWDW,NR,HGYJ,WLFYRYJ,LDYJ,RELEASEBLOG,XH FROM T_OA_WBFW

    self.toDisplayKey = [NSArray arrayWithObjects:@"WJBH",@"NGRQ",@"FBBWDW",@"NR",@"HGYJ",@"WLFYRYJ",@"LDYJ",@"RELEASEBLOG",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"办文编号:",@"拟文时间:",@"发表博文科室:",@"微博内容:",@"办公室核稿意见:",@"网络发言人批示:",@"局领导批示:",@"发布微博:",nil];
    NSMutableArray *tmpDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:8];
    for(int i = 0; i < 8; i++)
    {
        [tmpDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tmpDisplayHeightAry;
    
    if(isBanli)
    {
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    //添加微博内容cell可修改的界面
    backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.hidden = YES;
    [self.navigationController.view addSubview:backView];
    
    editText = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-150, 400, 300)];
    editText.backgroundColor = [UIColor blackColor];
    editText.alpha = 1;
    editText.hidden = YES;
    
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(2, 2, 50, 44);
    leftButton.backgroundColor = [UIColor brownColor];
    leftButton.alpha = 0.8;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismissEdint) forControlEvents:UIControlEventTouchUpInside];
    [editText addSubview:leftButton];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(346, 2, 50, 44);
    rightButton.backgroundColor = [UIColor brownColor];
    rightButton.alpha = 0.8;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editsAction) forControlEvents:UIControlEventTouchUpInside];
    [editText addSubview:rightButton];
    
    [self.navigationController.view addSubview:editText];
    
    textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, 400, 256)];
    textV.font = [UIFont fontWithName:@"Helvetica" size:19];
    [editText addSubview:textV];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_WBFWXQ" forKey:@"service"];
    [params setObject:LCSLBH forKey:@"LCSLBH"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    //NSLog(@"%@", strUrl);
}

//修改微博内容输入后把数据取消
- (void)dismissEdint
{
    editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-150, 400, 300);
    [UIView animateWithDuration:.3 animations:^{
        editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height, 400, 300);
    }completion:^(BOOL finished) {
        editText.hidden = YES;
        backView.hidden = YES;
        
    }];
     [self.textV resignFirstResponder];
}

//修改微博内容后把数据存入服务 并把数据显示
- (void)editsAction
{
    self.isMicroblogEdit = YES;
    [infoDic removeObjectForKey:@"NR"];
    [infoDic setObject:textV.text forKey:@"NR"];
    // 这增加链接把修改的微博内容存入服务器
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [jsonDic setObject:[infoDic objectForKey:@"XH"] forKey:@"XH"];
    [jsonDic setObject:[self transformString:[infoDic objectForKey:@"NR"]] forKey:@"NR"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"UPDATE_WBFW" forKey:@"service"];
    [params setObject:jsonDic forKey:@"wbfwjson"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];

    //动画过度
    editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-150, 400, 300);
    [UIView animateWithDuration:.3 animations:^{
        editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height, 400, 300);
    }completion:^(BOOL finished) {
        editText.hidden = YES;
        backView.hidden = YES;
        
    }];
    [self.textV resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissEdint];
    if(self.actionsModel && self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
        headerView.text = @"  微博信息";
    //    else if (section == 1)
    //        headerView.text = @"  微博附件";
    else
        headerView.text = @"  处理步骤";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* if (indexPath.section == 1 )
     {
     return 80.0f;
     }
     else*/ if(indexPath.section == 0)
     {
         if(toDisplayHeightAry)
         {
             return [[toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
         }
         else
         {
             return 60;
         }
     }
     else if (indexPath.section == 1)
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
	return 80.0f;
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
        return 8;
    }
    //    else if(section == 1)
    //    {
    //        if(attachmentAry == nil || [attachmentAry count] == 0)
    //        {
    //            return 1;
    //        }
    //        else
    //        {
    //            return [attachmentAry count];
    //        }
    //    }
    else
    {
        if(stepAry == nil || stepAry.count == 0)
        {
            return 1;
        }
        else
        {
            return [stepAry count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = nil;
        //        if(indexPath.row == 0)
        //        {
        //            NSString *title1 = [self.toDisplayKeyTitle objectAtIndex:0];
        //            NSString *title2 = [self.toDisplayKeyTitle objectAtIndex:1];
        //            NSString *value1 = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:0]];
        //            NSString *value2 = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:1]];
        //            CGFloat height = 60.0f;
        //            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        //        }
        //        else if(indexPath.row == 1)
        //        {
        //            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        //            NSString *itemTitle = [infoDic objectForKey:[toDisplayKey objectAtIndex:2]];
        //            if(itemTitle.length > 10)
        //                itemTitle = [itemTitle substringToIndex:10];
        //            cell = [UITableViewCell makeSubCell:tableView withTitle:[toDisplayKeyTitle objectAtIndex:2] value:itemTitle andHeight:nHeight];
        //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        }
        //        else if(indexPath.row == 2)
        //        {
        CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        NSString *itemTitle = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row]];
        cell = [UITableViewCell makeSubCell:tableView withTitle:[toDisplayKeyTitle objectAtIndex:indexPath.row] value:itemTitle andHeight:nHeight];
        if (indexPath.row != 3)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //        }
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        
        return cell;
    }/*
      //    else if (indexPath.section == 1)
      //    {
      //        UITableViewCell *cell = nil;
      //        static NSString *identifier = @"fujiancell";
      //        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
      //        if (cell == nil)
      //        {
      //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
      //            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
      //            cell.textLabel.numberOfLines = 2;
      //        }
      //        if (attachmentAry ==nil||[attachmentAry count] == 0)
      //        {
      //            cell.textLabel.text = @"暂无附件信息";
      //            cell.detailTextLabel.text = @"";
      //            cell.accessoryType = UITableViewCellAccessoryNone;
      //        }
      //        else
      //        {
      //            NSDictionary *dicTmp = [attachmentAry   objectAtIndex:indexPath.row];
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
      //    }*/
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
        if (isBanli) {
             controller.isFW = YES;
        }
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (indexPath.section == 0&& indexPath.row == 3&&isBanli)
    {
        NSLog(@"this is indexpath row3");
        editText.hidden = NO;
        backView.hidden = NO;
        textV.text = @"";
        editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height, 400, 300);
        [UIView animateWithDuration:.3 animations:^{
            editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-150, 400, 300);
        }];
    }
}

#pragma mark - Network Handler Method
-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", resultJSON);
//    NSLog(@"%@",[resultJSON JSONString]);
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        if (self.isMicroblogEdit)
        {
             NSDictionary* dic = [[NSDictionary alloc]initWithDictionary:[resultJSON objectFromJSONString]];
            if ([dic  objectForKey:@"result"])
            {
                [self showAlertMessage:@"微博内容修改成功"];
            }else [self showAlertMessage:@"微博内容修改失败!"];
        }else{
            self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];//基本信息
            self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];//附件
            self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"bzxx"];//TODO:处理步骤
        }
    }
    else
        bParseError = YES;
    
    if (bParseError)
    {
        [self showAlertMessage:@"获取数据出错。"];
    }
    
    if(infoDic)
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
        NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i=0; i< 8;i++)
        {
            if(i>2)
            {
                NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i]]];
                CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
                if(cellHeight < 60)cellHeight = 60.0f;
                [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
            }
            else
            {
                [aryTmp addObject:[NSNumber numberWithFloat:60.0f]];
            }
        }
        self.toDisplayHeightAry = aryTmp;
    }
    
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
    
    [resTableView reloadData];
    self.isMicroblogEdit = NO;
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"请求数据失败。"];
}

- (NSString*)transformString:(NSString*)str
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, nil,kCFStringEncodingUTF8));
}

@end

