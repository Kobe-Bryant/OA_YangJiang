//
//  PingShenHuiDetailViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-3-15.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "PingShenHuiDetailViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "FileUtil.h"
#import "NSStringUtil.h"

@interface PingShenHuiDetailViewController ()

@property (nonatomic, strong) UITableView *resTableView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSMutableDictionary *infoDic;//会议通知基本信息
@property (nonatomic, strong) NSArray *toDisplayKeyTitle;
@property (nonatomic, strong) NSArray *toDisplayKey;
@property (nonatomic, strong) NSMutableArray *toDisplayHeightAry;//会议通知基本信息显示高度

@property (nonatomic, strong) NSArray *attachmentAry;//会议通知附件信息

@property (nonatomic, strong) NSArray *stepAry;//会议通知步骤列表
@property (nonatomic, strong) NSArray *stepHeightAry;//会议通知步骤高度

@property (nonatomic,strong) UIView* backView;    //编辑时的背景view
@property (nonatomic,strong) UIView* editText;    //编辑的view
@property (nonatomic,strong) UITextView* textV;   //装输入的内容
@property (nonatomic,assign) BOOL isPersonnelEdit;//是否人员编辑请求


@end

@implementation PingShenHuiDetailViewController
@synthesize backView,editText,textV,isPersonnelEdit;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详细信息";
    self.isPersonnelEdit = NO;
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"拟制日期：", @"会议内容：", @"办公室拟办参会人员：", @"分管领导意见：", @"局领导意见：", nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"CJSJ", @"HYNR", @"BGSNB", @"FGLDYJ", @"JLDYJ", nil];
    
    //加载视图组件
    [self addCustomView];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i< self.toDisplayKey.count; i++)
    {
        [aryTmp addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = aryTmp;
    
    //获取办理信息
    self.bOKFromTransfer = NO;
    if(self.isBanli)
    {
        //如果是从待办跳转过来的
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [self.actionsModel requestActionDatasByParams:self.itemParams];
        
        //添加人员编辑
        [self addPersonnelEditing];
    }

    
    //请求数据
    [self requestData];
    
}

- (void)addPersonnelEditing
{
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
    leftButton.frame = CGRectMake(2, 2, 50, 42);
    leftButton.backgroundColor = [UIColor brownColor];
    leftButton.alpha = 0.8;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismissEdint) forControlEvents:UIControlEventTouchUpInside];
    [editText addSubview:leftButton];
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(346, 2, 50, 42);
    rightButton.backgroundColor = [UIColor brownColor];
    rightButton.alpha = 0.8;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editsAction) forControlEvents:UIControlEventTouchUpInside];
    [editText addSubview:rightButton];
    
    [self.navigationController.view addSubview:editText];
    
    textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, 400, 256)];
    textV.font = [UIFont fontWithName:@"Helvetica" size:19];
    [editText addSubview:textV];

}

//修改会议拟办人员输入后把数据取消
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

//修改人员 后把数据存入服务 并把数据显示
- (void)editsAction
{
    self.isPersonnelEdit = YES;
    [self.infoDic removeObjectForKey:@"BGSNB"];
    [self.infoDic setObject:textV.text forKey:@"BGSNB"];
    // 这增加链接把修改的微博内容存入服务器
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [jsonDic setObject:[self.infoDic objectForKey:@"XH"] forKey:@"XH"];
    [jsonDic setObject:[self transformString:[self.infoDic objectForKey:@"BGSNB"]] forKey:@"BGSNB"];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"UPDATE_HYTZ" forKey:@"service"];
    [params setObject:jsonDic forKey:@"hytzjson"];
    
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
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private Methods

//添加视图组件
- (void)addCustomView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    bgView.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:bgView];
    
    self.resTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, 728, 920) style:UITableViewStylePlain];
    self.resTableView.delegate = self;
    self.resTableView.dataSource = self;
    [self.view addSubview:self.resTableView];
}

#pragma mark - UITableView DataSource & Delegate Methods

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
    if (section == 0)  headerView.text= @"  会议通知信息";
    else if (section == 1)  headerView.text= @"  附件";
    else if (section == 2)  headerView.text= @"  处理步骤";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(self.toDisplayHeightAry)
        {
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        return 60.0;
    }
    else if (indexPath.section == 1)
    {
        return 80.0f;
    }
    else if(indexPath.section == 2)
    {
        if(self.stepHeightAry)
        {
            return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        return 60.0;
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 )
    {
        return self.toDisplayKeyTitle.count;
    }
    else if (section == 1)
    {
        return (self.attachmentAry == nil || self.attachmentAry.count == 0) ? 1 : self.attachmentAry.count;
    }
    else if (section == 2)
    {
        return (self.stepAry == nil || self.stepAry.count == 0) ? 1 : self.stepAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        //主办单位
        NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
        NSString *value = [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]];
        CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"AttachCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        
        if (self.attachmentAry == nil|| self.attachmentAry.count == 0)
        {
            cell.textLabel.text = @"无";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [self.attachmentAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image =[FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)
    {
        if (self.stepAry == nil|| self.stepAry.count == 0)
        {
            static NSString *identifier = @"StepCell";
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
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@", [dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"处理意见：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        if ([self.attachmentAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [self.attachmentAry objectAtIndex:indexPath.row];
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
        if (self.isBanli) {
            controller.isHY = YES;
        }
        controller.fileFiles = [NSMutableDictionary dictionaryWithDictionary:dicTmp];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section == 0 && indexPath.row ==2&&self.isBanli)
    {
        editText.hidden = NO;
        backView.hidden = NO;
        textV.text = @"";
        editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height, 400, 300);
        [UIView animateWithDuration:.3 animations:^{
            editText.frame = CGRectMake(self.view.frame.size.width/2-200, self.view.frame.size.height/2-150, 400, 300);
        }];

    }
}

#pragma mark - Network Hanlder Method

- (void)requestData
{
    self.isLoading = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_HYTZ_DETAIL" forKey:@"service"];
    [params setObject:self.LCSLBH forKey:@"LCSLBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    self.isLoading = NO;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        if (self.isPersonnelEdit)
        {
            NSDictionary* dic = [[NSDictionary alloc]initWithDictionary:[resultJSON objectFromJSONString]];
            if ([dic  objectForKey:@"result"])
            {
                [self showAlertMessage:@"微博内容修改成功"];
            }else [self showAlertMessage:@"微博内容修改失败!"];
        }else{
            self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"hytzinfo"] lastObject];
            self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"bzxx"];
            self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"hytzfjxx"];
        }
    }
    else
    {
        bParseError = YES;
    }
    
    //计算基本信息高度
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i< self.toDisplayKey.count; i++)
    {
        CGFloat cellHeight = 60.0f;
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:i]]];
        cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0] + 20;
        if(cellHeight < 60)
        {
            cellHeight = 60.0f;
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
    
    [self.resTableView reloadData];
    
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
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

- (NSString*)transformString:(NSString*)str
{
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, nil,kCFStringEncodingUTF8));
}


@end
