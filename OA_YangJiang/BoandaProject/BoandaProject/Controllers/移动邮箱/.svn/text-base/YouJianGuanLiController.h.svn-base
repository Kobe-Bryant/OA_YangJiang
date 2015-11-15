//
//  YouJianGuanLiController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "BaseViewController.h"

#define nWebDataForContent 1//附件
#define nWebDataForEmailList  2//邮件列表

@interface YouJianGuanLiController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate>

@property (nonatomic,strong) NSMutableArray *parsedInBoxItemAry;//收件箱
@property (nonatomic,strong) IBOutlet UITableView* listTableView;
@property (nonatomic,strong) NSMutableArray *parsedOutBoxItemAry;//发件箱

@property (nonatomic,unsafe_unretained) NSInteger listDataType;
@property (nonatomic,strong) IBOutlet UITableView* fileTableView;
@property (nonatomic,unsafe_unretained) NSInteger nWebDataType;

@property (nonatomic,strong) NSMutableArray *parsedFileItemAry;//附件
@property (nonatomic,strong) NSDictionary *curEmaiJBXXDic; //当前文件的基本信息
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *fromLabel;
@property (nonatomic,strong) IBOutlet UILabel *sendTimeLabel;
@property (nonatomic,strong) IBOutlet UITextView *mainTextView;
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,unsafe_unretained) NSInteger curPageOfSend;//收文当前页数
@property (nonatomic,unsafe_unretained) NSInteger pagesumOfSend;//收文总页数
@property (nonatomic,unsafe_unretained) NSInteger curPageOfRecv;//发文当前页数
@property (nonatomic,unsafe_unretained) NSInteger pagesumOfRecv;//发文总页数

@property (nonatomic,strong) NSString *urlSend;
@property (nonatomic,strong) NSString * urlRecv;
@property (nonatomic,strong) NSMutableSet *readedSet;


//转发,回复,编写
@property (nonatomic,unsafe_unretained) BOOL choosed;
@property (nonatomic,strong) NSString *fjrString;
@property (nonatomic,strong) NSString *btString;
@property (nonatomic,strong) NSString *nrString;
@property (nonatomic,strong) NSString *fjrID;
@property (nonatomic,strong) NSString *fjbh;

@end
