//
//  DBDetailViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-15.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceUrlString.h"
#import "TaskActionBaseViewController.h"
#import "ToDoActionsDataModel.h"

@interface DBDetailViewController : TaskActionBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) NSString *DBID;
@property (nonatomic, strong) ToDoActionsDataModel *actionsModel;
@property (strong, nonatomic) NSMutableArray *attachmentAry;
@property (strong, nonatomic) NSMutableDictionary *rwdbinfoDict;
@property (nonatomic,copy) NSDictionary *itemParams;
- (id)initWithNibName:(NSString *)nibNameOrNil andLCSLBH:(NSString*)bh andBZBH:(NSString *)bz isBanli:(BOOL)banli;

@end
