//
//  WNWZDetailViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceUrlString.h"
#import "TaskActionBaseViewController.h"
#import "ToDoActionsDataModel.h"

@interface WNWZDetailViewController : TaskActionBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) NSMutableArray *attachmentAry;
@property (strong, nonatomic) NSMutableDictionary *wlwzinfoDict;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,assign) BOOL bOKFromTransfer;
@property (nonatomic, strong) NSString *WZID;
@property (nonatomic, strong) NSArray *titleArray1;
@property (nonatomic,copy) NSDictionary *itemParams;
@property (nonatomic, strong) ToDoActionsDataModel *actionsModel;

- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh andBZBH:(NSString *)bz isBanli:(BOOL)banli;

@end
