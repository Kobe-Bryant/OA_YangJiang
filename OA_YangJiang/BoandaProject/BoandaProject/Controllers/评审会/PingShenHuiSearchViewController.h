//
//  PingShenHuiSearchViewController.h
//  BoandaProject
//
//  Created by 曾静 on 14-3-15.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface PingShenHuiSearchViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *hyxxLabel;
@property (nonatomic, strong) IBOutlet UITextField *hyxxField;
@property (nonatomic, strong) IBOutlet UILabel *kssjxLabel;
@property (nonatomic, strong) IBOutlet UITextField *kssjField;
@property (nonatomic, strong) IBOutlet UILabel *jssjLabel;
@property (nonatomic, strong) IBOutlet UITextField *jssjField;
@property (nonatomic, strong) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;

@end
