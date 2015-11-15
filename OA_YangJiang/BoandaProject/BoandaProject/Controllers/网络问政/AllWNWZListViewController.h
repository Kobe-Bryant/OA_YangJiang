//
//  AllWNWZListViewController.h
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

@interface AllWNWZListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,PopupDateDelegate,NSURLConnHelperDelegate>
{
    BOOL bHaveShowed;
    NSMutableArray *resultAry;
    NSInteger currentTag;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UITextField *startTimeField;
@property (strong, nonatomic) IBOutlet UITextField *endTimeField;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UILabel *subjectTitle;
@property (strong, nonatomic) IBOutlet UITextField *subjectField;

@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;

@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property(nonatomic,assign) NSInteger pageCount;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSString *urlString;


- (IBAction)touchDateField:(UITextField *)sender;
- (IBAction)searchButtonClick:(id)sender;

@end
