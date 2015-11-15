//
//  ToDoDetailDataModel.m
//  HNYDZF
//
//  Created by zhang on 12-12-8.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ToDoActionsDataModel.h"
#import "PDJsonkit.h"
#import "NSURLConnHelper.h"
#import "ServiceUrlString.h"
#import "StepUserItem.h"
#import "TaskActionEntity.h"
#import "TaskActionViewController.h"
#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
#import "CopyActionViewController.h"
#import "AutoTranslateViewController.h"
#import "EndorseForSeriesActionController.h"
#import "TaskActionBaseViewController.h"

#define kServiceType_XF 1
#define kServiceType_GW 2
#define kWORKFLOW_FINISH_ACTION 0 //结束流程
#define kWORKFLOW_SINGLEFINISH_ACTION 1 //结束步骤

@interface ToDoActionsDataModel()

@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) TaskActionBaseViewController* target;
@property (nonatomic, copy)   NSString *resultHtml;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSArray *aryAttachFiles;//附件
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy)   NSDictionary *params;
@property (nonatomic, strong) NSDictionary *dicActionInfo;
@property (nonatomic, assign) WorkflowShowStyle showStyle;

@property (nonatomic, strong) NSArray *actionListAry;
@end

@implementation ToDoActionsDataModel
@synthesize webHelper,parentView,target,resultHtml,title,typeStr,aryAttachFiles,params,dicActionInfo,isLoading;

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param atarget 目标ViewController
 *  @param inView  展示指示器的View
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)atarget andParentView:(UIView*)inView
{
    return [self initWithTarget:atarget andParentView:inView andShowStyle:WorkflowShowStyleDefault];
}

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param aTarget 目标ViewController
 *  @param inView  展示指示器的View
 *  @param aStyle  流程动作展示样式 @see 'WorkflowShowStyle', 默认是WorkflowShowStyleDefault在导航栏显示
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)aTarget andParentView:(UIView*)inView andShowStyle:(WorkflowShowStyle)aStyle
{
    if(self = [super init])
    {
        self.parentView = inView;
        self.target = aTarget;
        self.showStyle = aStyle;
    }
    return self;
}

//结束流程
- (void)finishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_FINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//结束步骤
- (void)singleFinishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_SINGLEFINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//流转
- (void)transitionAction:(id)sender
{
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    NSArray *nextSteps = [dicActionInfo objectForKey:@"nextSteps"];
    
    NSMutableArray *filterAry = [[NSMutableArray alloc] init];
    for(NSDictionary *nextStepDict in nextSteps)
    {
        NSString *isCountersignStep = [nextStepDict objectForKey:@"isCountersignStep"];
        if([isCountersignStep isEqualToString:@"true"])
        {
            NSString *stepDesc = [nextStepDict objectForKey:@"stepDesc"];
            [filterAry addObject:stepDesc];
        }
    }
    controller.filterStepsAry = filterAry;
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
}

//会签
- (void)countersignAction:(id)sender
{
    UIBarButtonItem *barItem = (UIBarButtonItem *)sender;
    
    CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
    for(NSDictionary *item in aryNextSteps)
    {
        if([[item objectForKey:@"isCountersignStep"] isEqualToString:@"true"] && [barItem.title isEqualToString:[item objectForKey:@"stepDesc"]])
        {
            controller.nextStepId = [item objectForKey:@"stepId"];
        }
    }
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    controller.stepDesc = item.title;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//退回
- (void)sendBackAction:(id)sender
{
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
}

//返回
- (void)feedbackAction:(id)sender
{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
}

//加签
- (void)endorseAction:(id)sender
{
    //"countersignType":"SERIAL"
    NSString *countersignType = [dicActionInfo objectForKey:@"countersignType"];
    if([countersignType isEqualToString:@"SERIAL"])
    {
        //串行
        EndorseForSeriesActionController *controller = [[EndorseForSeriesActionController alloc] initWithNibName:@"EndorseForSeriesActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        //controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = (id<HandleGWDelegate>)self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = (id<HandleGWDelegate>)self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
}

//抄送
- (void)copyAction:(id)sender
{
    CopyActionViewController *controller = [[CopyActionViewController alloc] initWithNibName:@"CopyActionViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

//已阅
- (void)autotranslateAction:(id)sender
{
    AutoTranslateViewController *controller = [[AutoTranslateViewController alloc] initWithNibName:@"AutoTranslateViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Network Handler Method

- (void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    self.dicActionInfo = [resultJSON objectFromJSONString];
    BOOL resultFailed = NO;
    if (dicActionInfo == nil)
    {
        resultFailed = YES;
    }
    else
    {
        NSString *tmp = [dicActionInfo objectForKey:@"result"];
        if(![tmp isEqualToString:@"success"])
        {
            resultFailed = YES;
        }
    }
    if(resultFailed)
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
    
    [self createWorkflowActionData:self.showStyle];
}

- (void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

- (void)requestActionDatasByParams:(NSDictionary *)info
{
    self.params = info;
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_TASK_STATE" forKey:@"service"];
    [dicParams setObject:[params objectForKey:@"BZBH"] forKey:@"BZBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentView delegate:self];
}

- (void)createWorkflowActionData:(WorkflowShowStyle)aStyle
{
    if(aStyle == WorkflowShowStyleDefault)
    {
        NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
        
        //抄送(默认全部都有抄送选项)
        UIBarButtonItem *aBarItemCopy = [[UIBarButtonItem  alloc] initWithTitle:@"抄送" style:UIBarButtonItemStyleBordered target:self action:@selector(copyAction:)];
        [aryBarItems addObject:aBarItemCopy];
        
        //是否是第一个步骤
        NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
        
        //手工流转
        UIBarButtonItem *transitionBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"流转" style:UIBarButtonItemStyleBordered target:self action:@selector(transitionAction:)];
        NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
        if([canTransition isEqualToString:@"true"])
        {
            [aryBarItems addObject:transitionBarItem];
        }
        
        //退回
        NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
        if([canSendback isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                //如果当前步骤不是第一个步骤，才支持退回操作
                UIBarButtonItem *aBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回修改" style:UIBarButtonItemStyleBordered target:self action:@selector(sendBackAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        //反馈
        NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
        if([isCanFeedback isEqualToString:@"true"])
        {
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"反馈" style:UIBarButtonItemStyleBordered target:self action:@selector(feedbackAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        //加签
        NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
        if([isCanEndorse isEqualToString:@"true"])
        {
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"加签" style:UIBarButtonItemStyleBordered target:self action:@selector(endorseAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        //已阅
        NSString *processType = [dicActionInfo objectForKey:@"processType"];
        if([processType isEqualToString:@"READER"])
        {
            UIBarButtonItem *aBarItemRead = [[UIBarButtonItem  alloc] initWithTitle:@"已阅" style:UIBarButtonItemStyleBordered target:self action:@selector(autotranslateAction:)];
            [aryBarItems addObject:aBarItemRead];
        }
        
        //会签步骤
        NSArray *nextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        int counterSignStepNum = 0;
        for(NSDictionary *nextStepDict in nextSteps)
        {
            NSString *isCountersignStep = [nextStepDict objectForKey:@"isCountersignStep"];
            if([isCountersignStep isEqualToString:@"true"])
            {
                NSString *stepDesc = [nextStepDict objectForKey:@"stepDesc"];
                UIBarButtonItem *aBarItemRead = [[UIBarButtonItem  alloc] initWithTitle:stepDesc style:UIBarButtonItemStyleBordered target:self action:@selector(countersignAction:)];
                [aryBarItems addObject:aBarItemRead];
                counterSignStepNum ++;
            }
            else
            {
                //如果下一个步骤是结束的话，默认不处理（因为我们不把结束流程放在流转的界面里面）
                NSString *stepDesc = [nextStepDict objectForKey:@"stepDesc"];
                if([stepDesc isEqualToString:@"结束"])
                {
                    counterSignStepNum ++;
                }
            }
        }
        //如果展开的下一个步骤的个数等于全部个数那么不显示流转按钮
        if(counterSignStepNum == nextSteps.count)
        {
            [aryBarItems removeObject:transitionBarItem];
        }
        
        //结束流程
        NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
        if([canFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"结束流程" style:UIBarButtonItemStyleBordered target:self action:@selector(finishAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        //结束步骤
        NSString *canSingleFinish = [dicActionInfo objectForKey:@"canSingleFinish"];
        if([canSingleFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"结束" style:UIBarButtonItemStyleBordered target:self action:@selector(singleFinishAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        self.target.navigationItem.rightBarButtonItems = aryBarItems;
    }
    else if (aStyle == WorkflowShowStylePopover)
    {
        NSMutableArray *aryActionItems = [NSMutableArray arrayWithCapacity:5];
        
        //抄送
        TaskActionEntity *copyTask = [[TaskActionEntity alloc] init];
        copyTask.actionName = @"copyAction";
        copyTask.actionTitle = @"抄送";
        copyTask.actionIcon = @"icon_抄送.png";
        [aryActionItems addObject:copyTask];
        
        //流转
        TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
        transitionTask.actionName = @"transitionAction";
        transitionTask.actionTitle = @"手工流转";
        transitionTask.actionIcon = @"icon_手工流转.png";
        NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
        if([canTransition isEqualToString:@"true"])
        {
            [aryActionItems addObject:transitionTask];
        }
        
        NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
        
        //退回
        NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
        if([canSendback isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
                transitionTask.actionName = @"sendBackAction";
                transitionTask.actionTitle = @"返回修改";
                transitionTask.actionIcon = @"icon_退回.png";
                [aryActionItems addObject:transitionTask];
            }
        }
        
        //反馈
        NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
        if([isCanFeedback isEqualToString:@"true"])
        {
            TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
            transitionTask.actionName = @"feedbackAction";
            transitionTask.actionTitle = @"反馈";
            transitionTask.actionIcon = @"icon_反馈.png";
            [aryActionItems addObject:transitionTask];
        }
        
        //加签
        NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
        if([isCanEndorse isEqualToString:@"true"])
        {
            TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
            transitionTask.actionName = @"endorseAction";
            transitionTask.actionTitle = @"加签";
            transitionTask.actionIcon = @"icon_加签.png";
            [aryActionItems addObject:transitionTask];
        }
        
        //已阅
        NSString *processType = [dicActionInfo objectForKey:@"processType"];
        if([processType isEqualToString:@"READER"])
        {
            TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
            transitionTask.actionName = @"autotranslateAction";
            transitionTask.actionTitle = @"已阅";
            transitionTask.actionIcon = @"icon_已阅.png";
            [aryActionItems addObject:transitionTask];
        }
        
        //会签步骤
        NSArray *nextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        int counterSignStepNum = 0;
        for(NSDictionary *nextStepDict in nextSteps)
        {
            NSString *isCountersignStep = [nextStepDict objectForKey:@"isCountersignStep"];
            if([isCountersignStep isEqualToString:@"true"])
            {
                NSString *stepDesc = [nextStepDict objectForKey:@"stepDesc"];
                TaskActionEntity *transitionTask1 = [[TaskActionEntity alloc] init];
                transitionTask1.actionIcon = @"icon_发起会签.png";
                transitionTask1.actionName = @"countersignAction";
                transitionTask1.actionTitle = stepDesc;
                [aryActionItems addObject:transitionTask1];
                counterSignStepNum ++;
            }
            else
            {
                //如果下一个步骤是结束的话，默认不处理（因为我们不把结束流程放在流转的界面里面）
                NSString *stepDesc = [nextStepDict objectForKey:@"stepDesc"];
                if([stepDesc isEqualToString:@"结束"])
                {
                    counterSignStepNum ++;
                }
            }
        }
        //如果展开的下一个步骤的个数等于全部个数那么不显示流转按钮
        if(counterSignStepNum == nextSteps.count)
        {
            [aryActionItems removeObject:transitionTask];
        }
        
        //结束流程
        NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
        if([canFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
                transitionTask.actionIcon = @"icon_结束流程.png";
                transitionTask.actionName = @"finishAction";
                transitionTask.actionTitle = @"结束流程";
                [aryActionItems addObject:transitionTask];
            }
        }
        
        //结束步骤
        NSString *canSingleFinish = [dicActionInfo objectForKey:@"canSingleFinish"];
        if([canSingleFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *transitionTask = [[TaskActionEntity alloc] init];
                transitionTask.actionIcon = @"icon_结束步骤.png";
                transitionTask.actionName = @"singleFinishAction";
                transitionTask.actionTitle = @"结束";
                [aryActionItems addObject:transitionTask];
            }
        }
        
        self.actionListAry = aryActionItems;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem  alloc] initWithTitle:@"办  理" style:UIBarButtonItemStyleBordered target:self action:@selector(onRightBarClick:)];
        self.target.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

- (void)cancelRequest
{
    [webHelper cancel];
}

- (void)onRightBarClick:(UIBarButtonItem *)sender
{
    if(self.actionPopover && self.actionPopover.isPopoverVisible)
    {
        [self.actionPopover dismissPopoverAnimated:YES];
    }
    else
    {
        TaskActionViewController *task = [[TaskActionViewController alloc] init];
        task.actionList = self.actionListAry;
        task.params = self.params;
        task.dicActionInfo = self.dicActionInfo;
        task.target = self.target;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:task];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navi];
        self.actionPopover = popover;
        task.currentPopover = self.actionPopover;
        self.actionPopover.popoverContentSize = CGSizeMake(366, 456);
        [self.actionPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end
