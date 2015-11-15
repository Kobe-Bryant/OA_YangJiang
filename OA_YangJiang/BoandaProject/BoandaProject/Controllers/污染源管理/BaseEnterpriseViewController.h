//
//  BaseEnterpriseViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-10-9.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WasteEnterpriseDetailViewController.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

@interface BaseEnterpriseViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dwmcLabel;
@property (strong, nonatomic) IBOutlet UITextField *dwmcField;
@property (strong, nonatomic) IBOutlet UILabel *szqyLabel;
@property (strong, nonatomic) IBOutlet UITextField *szqyField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (assign, nonatomic) BOOL bHaveShowed;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;

- (IBAction)searchButtonClick:(id)sender;

- (void)requestData;

- (void)doSearchWithName:(NSString *)name andWithAddress:(NSString *)addr;

@end
