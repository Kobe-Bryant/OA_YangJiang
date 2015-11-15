//
//  WRYListViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-29.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WRYListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    BOOL bHaveShowed;
    int currentPage;
    int pageCount;
}

@property (strong, nonatomic) IBOutlet UILabel *dwmcLabel;
@property (strong, nonatomic) IBOutlet UITextField *dwmcField;
@property (strong, nonatomic) IBOutlet UILabel *szqyLabel;
@property (strong, nonatomic) IBOutlet UITextField *szqyField;
@property (strong, nonatomic) IBOutlet UILabel *jgjbLabel;
@property (strong, nonatomic) IBOutlet UITextField *jgjbField;
@property (strong, nonatomic) IBOutlet UILabel *hylxLabel;
@property (strong, nonatomic) IBOutlet UITextField *hylxField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;

- (IBAction)searchButtonClick:(id)sender;

@end
