//
//  ToDoActionsDataModel.h
//  BoandaProject
//
//  Created by 曾静 on 14-02-14.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
// 

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WorkflowShowStyle) {
    WorkflowShowStyleDefault = 0,
    WorkflowShowStylePopover = 1
};

@class TaskActionBaseViewController;

@interface ToDoActionsDataModel : NSObject

/**
 *  流程动作展示Popover
 */
@property (nonatomic, strong) UIPopoverController *actionPopover;

/**
 
 ###说明
 ToDoActionsDataModel封装了工作流方面的入口调用的模块，主要是调用任务状态的服务获取公文的流程状态信息，根据支持的流程步骤类型让用户选择处理方式。
 调用方式如下:
 1.调用initWithTarget:andParentView:andShowStyle:创建对象
 2.调用requestActionDatasByParams:获取任务的流程信息
 */

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param atarget 目标ViewController
 *  @param inView  展示指示器的View
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)aTarget andParentView:(UIView*)inView;

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param aTarget 目标ViewController
 *  @param inView  展示指示器的View
 *  @param aStyle  流程动作展示样式 @see 'WorkflowShowStyle', 默认是WorkflowShowStyleDefault在导航栏显示
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)aTarget andParentView:(UIView*)inView andShowStyle:(WorkflowShowStyle)aStyle;

/**
 *  请求公文的流程状态，即获取可支持流转的步骤列表
 *
 *  @param params 任务的信息
 */
- (void)requestActionDatasByParams:(NSDictionary *)params;

/**
 *  取消请求
 */
- (void)cancelRequest;

@end
