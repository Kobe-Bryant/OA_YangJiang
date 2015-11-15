//
//  AddressBookViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-8.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersHelper.h"
#import "MBProgressHUD.h"
#import "DataSyncManager.h"

@interface AddressBookViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *mySearchController;
    
    UITableView *deptTableView;
    NSMutableArray *deptDataArray;
    
    UITableView *detailTableView;
    NSMutableArray *detailDataArray;
    
    NSMutableArray *searchResultArray;
    
    UsersHelper *usersHelper;
    
    NSString *parentButtonTitle;
    UIButton *parentButton;
    
    UILabel *titleLabel;
    
    int businessTag;
    
    MBProgressHUD *refreshHUD;
}

@property (nonatomic, strong) DataSyncManager *syncManager;

@end
