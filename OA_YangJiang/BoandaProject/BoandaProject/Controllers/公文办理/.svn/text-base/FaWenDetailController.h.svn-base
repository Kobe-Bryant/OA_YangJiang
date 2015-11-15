//
//  FaWenDetailController.h
//  GuangXiOA
//  待办发文详细信息
//  Created by 曾静 on 11-12-27.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoActionsDataModel.h"
#import "NSURLConnHelper.h"
#import "TaskActionBaseViewController.h"

@interface FaWenDetailController : TaskActionBaseViewController

@property (nonatomic,strong) NSDictionary *infoDic; //发文信息
@property (nonatomic,strong) NSArray *toDisplayKey;//发文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property (nonatomic,strong) NSMutableArray *toDisplayHeightAry;
@property (nonatomic,strong) NSString *LCSLBH;
@property (nonatomic,strong) NSArray *stepAry;      //发文步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //步骤的高度
@property (nonatomic,strong) NSArray *attachmentAry; //发文附件
@property (nonatomic,strong) NSArray *gwInfoAry; //正式公文信息

@property (nonatomic,strong) IBOutlet UITableView *resTableView;
@property (nonatomic,assign) BOOL isBanli;

@property (nonatomic,strong) ToDoActionsDataModel *actionsModel;

@property (nonatomic,copy) NSDictionary *itemParams;

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh isBanli:(BOOL)banli;
@end
