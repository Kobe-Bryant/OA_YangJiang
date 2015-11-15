//
//  WRYSearchViewController.h
//  FoShanYDZF
//
//  Created by 曾静 on 13-11-13.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WRYConditionPassDelegate.h"

@protocol PassSearchConditionDelegate <NSObject>

- (void)passSearchConditon:(NSDictionary *)params;

@end

@interface WRYSearchViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,WRYConditionPassDelegate>

@property (weak, nonatomic)  id<PassSearchConditionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

@end
