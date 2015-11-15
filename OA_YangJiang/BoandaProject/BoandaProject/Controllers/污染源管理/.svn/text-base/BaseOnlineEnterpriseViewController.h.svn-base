//
//  BaseOnlineEnterpriseViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-12-5.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

#define kServiceName_WasteWater @"QUERY_ZAJC_FSQY_LIST" //废水企业服务
#define kServiceName_WasteAir @"QUERY_ZAJC_FQQY_LIST" //废气企业服务

@interface BaseOnlineEnterpriseViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

- (void)requestData;

@end
