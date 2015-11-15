//
//  WRYConditionListViewController.h
//  FoShanYDZF
//
//  Created by 曾静 on 13-11-13.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WRYConditionPassDelegate.h"

@interface WRYConditionListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) id<WRYConditionPassDelegate> delegate;
@property (copy, nonatomic) NSString *conditionKey;
@property (nonatomic, strong) NSString *selectedValue;
@property (assign, nonatomic) int listType;//展示数据类型 0表示监管级别 1表示所在区县 2表示所在地市

@end
