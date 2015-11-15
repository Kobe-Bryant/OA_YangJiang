//
//  AllWBListViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//


#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "BaseViewController.h"

@interface AllWBListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,WordsDelegate,NSURLConnHelperDelegate,PopupDateDelegate>
@property(nonatomic,strong)IBOutlet UITableView *resultTableView;
@property(nonatomic,strong)IBOutlet UITextField *titleField;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UITextField *niwenField;
@property(nonatomic,strong)IBOutlet UILabel *niwenLabel;

@property(nonatomic,strong)IBOutlet UITextField *fromDateField;
@property(nonatomic,strong)IBOutlet UILabel *fromDateLabel;
@property(nonatomic,strong)IBOutlet UITextField *endDateField;
@property(nonatomic,strong)IBOutlet UILabel *endDateLabel;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupDateViewController *dateController;
@property(nonatomic,assign) NSInteger currentTag;
@property(nonatomic,strong)IBOutlet UIButton *searchBtn;
@property(nonatomic,assign) NSInteger pageCount;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;

@property (nonatomic,strong) NSString *danweiDM;//单位代码
@property(nonatomic,assign)BOOL bHaveShowed;
@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property(nonatomic,strong) NSMutableArray *resultAry;

@property(nonatomic,strong)NSString *urlString; //不含p_CURRENT的url
-(void)showSearchBar:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)touchFromDate:(id)sender;



@end
