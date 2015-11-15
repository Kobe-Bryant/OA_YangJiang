//
//  AllDBListViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-14.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDateViewController.h"
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
@interface AllDBListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,PopupDateDelegate,NSURLConnHelperDelegate>
{
    BOOL bHaveShowed;
    NSMutableArray *resultAry;
    NSInteger currentTag;
    int totalCount;//数据总条数
    int currentStatus;//紧急状态，0一般 1紧急 2特急
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
- (IBAction)statusSegmentClick:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextField *startTimeField;
@property (strong, nonatomic) IBOutlet UITextField *endTimeField;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;

@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;


- (IBAction)touchDateField:(UITextField *)sender;
- (IBAction)searchButtonClick:(id)sender;

@end
