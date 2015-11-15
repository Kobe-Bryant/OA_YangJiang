//
//  LinDaoRiChenController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "CommenWordsViewController.h"
#import "UsersHelper.h"

#define NOT_CURWEEK -1

@interface LinDaoRiChenController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,WordsDelegate>

@property (nonatomic,strong) IBOutlet UITableView *rcTableView;
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,strong) NSArray *daysPngName;
@property (nonatomic,unsafe_unretained) NSInteger curDayInAWeek;//一周中的星期几 从星期天开始
@property (nonatomic,strong) NSDictionary *dicWeekTodo;//一周的事件 key 0 1 2 3 4 5 6
@property (nonatomic,strong) UILabel *labelWeekRange;
@property (nonatomic,strong) NSDate *curShowDate;//当前显示日期
@property (nonatomic,strong) NSDictionary *dicWeekHeight;//陪同人员的label高度 key 0 1 2 3 4 5 6
@property (nonatomic,strong) NSURLConnHelper *webHelper;

@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
@property (nonatomic,strong) NSArray *allDeptAry;

@property (nonatomic,strong) NSString *deptID;
@property (nonatomic,strong) UsersHelper *usersHelper;
@property (nonatomic,strong) NSString *bgsId;
@property (nonatomic,strong) NSString *shbjldId;

-(IBAction)lastWeekPressed:(id)sender;
-(IBAction)nextWeekPressed:(id)sender;

@end
