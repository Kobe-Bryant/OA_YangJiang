//
//  LaiwenDetailController.h
//  GuangXiOA
//  来文办理
//  Created by 曾静 on 13-12-26.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "ToDoActionsDataModel.h"
#import "TaskActionBaseViewController.h"

@interface LaiWenDetailController : TaskActionBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *LCSLBH;

@property (nonatomic, strong) NSDictionary *infoDic; //来文信息
@property (nonatomic, strong) NSArray *toDisplayKey;//来文信息所要显示的key
@property (nonatomic, strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property (nonatomic, strong) NSMutableArray *toDisplayHeightAry;//基本信息cell高度
@property (nonatomic, strong) NSArray *stepAry;      //来文步骤
@property (nonatomic, strong) NSArray *stepHeightAry;//来文步骤的高度
@property (nonatomic, strong) NSArray *attachmentAry; //来文附件
@property (nonatomic, strong) NSArray *chushiOpinionAry; //处室意见信息

@property (nonatomic, assign) BOOL bOKFromTransfer;
@property (nonatomic, assign) BOOL isBanli;

@property (nonatomic, strong) IBOutlet UITableView *resTableView;

@property (nonatomic, strong) ToDoActionsDataModel *actionsModel;
@property (nonatomic, strong) NSDictionary *itemParams;

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh isBanli:(BOOL)banli;

@end
