//
//  TaskActionViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-2-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TaskActionViewController.h"
#import "TaskActionControl.h"
#import "TaskActionEntity.h"

#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
#import "CopyActionViewController.h"
#import "AutoTranslateViewController.h"
#import "EndorseForSeriesActionController.h"

#define kWORKFLOW_FINISH_ACTION 0 //结束流程
#define kWORKFLOW_SINGLEFINISH_ACTION 1 //结束步骤

@interface TaskActionViewController ()

@end

@implementation TaskActionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"办理";
    
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 366, 456)];
    int rows = (self.actionList.count % 3) ? self.actionList.count/3 : self.actionList.count/3 + 1;
    CGFloat bgHeight = (rows+1)*30 + rows*112;
    actionScrollView.contentSize = CGSizeMake(366, bgHeight);
    [self.view addSubview:actionScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int listCount = self.actionList.count;
    int span = 30;
    int w = 82;
    int h = 112;
    int n = 3;
    for (int i = 0; i < listCount; i++)
    {
        TaskActionEntity *item = [self.actionList objectAtIndex:i];
        CGRect frame = CGRectMake(span+(span+w)*(i%n), (span+h)*(i/n)+35, w, h);
        TaskActionControl *ac = [[TaskActionControl alloc] initWithFrame:frame andMenuInfo:item];
        NSString *selectorName = [NSString stringWithFormat:@"%@:", item.actionName];
        SEL selector = NSSelectorFromString(selectorName);
        [ac addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [actionScrollView addSubview:ac];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Event Handler Methods

//结束流程
-(void)finishAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_FINISH_ACTION;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//结束步骤
-(void)singleFinishAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_SINGLEFINISH_ACTION;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//流转
-(void)transitionAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    NSArray *nextSteps = [self.dicActionInfo objectForKey:@"nextSteps"];
    
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
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.target.navigationController pushViewController:controller animated:YES];
}

//会签
-(void)countersignAction:(id)sender
{
    UIBarButtonItem *barItem = (UIBarButtonItem *)sender;
    
    CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    NSArray *aryNextSteps = [self.dicActionInfo objectForKey:@"nextSteps"];
    for(NSDictionary *item in aryNextSteps)
    {
        if([[item objectForKey:@"isCountersignStep"] isEqualToString:@"true"] && [barItem.title isEqualToString:[item objectForKey:@"stepDesc"]])
        {
            controller.nextStepId = [item objectForKey:@"stepId"];
        }
    }
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    controller.stepDesc = item.title;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//退回
-(void)sendBackAction:(id)sender
{
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.target.navigationController pushViewController:controller animated:YES];
}

//返回
-(void)feedbackAction:(id)sender
{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.target.navigationController pushViewController:controller animated:YES];
}

//加签
-(void)endorseAction:(id)sender
{
    //"countersignType":"SERIAL"
    NSString *countersignType = [self.dicActionInfo objectForKey:@"countersignType"];
    if([countersignType isEqualToString:@"SERIAL"])
    {
        //串行
        EndorseForSeriesActionController *controller = [[EndorseForSeriesActionController alloc] initWithNibName:@"EndorseForSeriesActionController" bundle:nil];
        controller.bzbh = [self.params objectForKey:@"BZBH"];
        controller.delegate = (id<HandleGWDelegate>)self.target;
        [self.target.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
        controller.bzbh = [self.params objectForKey:@"BZBH"];
        controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = (id<HandleGWDelegate>)self.target;
        [self.target.navigationController pushViewController:controller animated:YES];
    }
}

//抄送
-(void)copyAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    CopyActionViewController *controller = [[CopyActionViewController alloc] initWithNibName:@"CopyActionViewController" bundle:nil];
    controller.LCLXBH = [self.params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [self.params objectForKey:@"BZDYBH"];
    controller.BZBH = [self.params objectForKey:@"BZBH"];
    controller.LCSLBH = [self.params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//已阅
-(void)autotranslateAction:(id)sender
{
    AutoTranslateViewController *controller = [[AutoTranslateViewController alloc] initWithNibName:@"AutoTranslateViewController" bundle:nil];
    controller.LCLXBH = [self.params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [self.params objectForKey:@"BZDYBH"];
    controller.BZBH = [self.params objectForKey:@"BZBH"];
    controller.LCSLBH = [self.params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = (id<HandleGWDelegate>)self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

@end
