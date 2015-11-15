//
//  EmailPersonViewController.h
//  GuangXiOA
//
//  Created by apple on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#import "BaseViewController.h"
#define DEPARTMENT_ARRAY_KEY @"departmentArray"
#define PERSON_ARRAY_KEY @"personArray"

@protocol EmailPersonViewControllerDelegate;

@interface EmailPersonViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,QQSectionHeaderViewDelegate>
{
    id<EmailPersonViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,strong) NSMutableArray *departmentArray;
@property (nonatomic,strong) NSMutableArray *personArray;
@property (nonatomic,strong) NSMutableArray *sdArray;
@property (nonatomic,strong) NSMutableArray *spArray;
@property (nonatomic,strong) NSMutableArray *sdIsOpenArray;
@property (nonatomic,strong) NSMutableArray *spIsOpenArray;
@property (nonatomic,assign) NSInteger segTag;
@property (nonatomic,assign) BOOL segChange;
@property (nonatomic,strong) NSMutableArray *checkArray;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) id<EmailPersonViewControllerDelegate> delegate;


- (void)reloaData;

@end

@protocol EmailPersonViewControllerDelegate <NSObject>
//- (void)segmentDidSelectedTypetag:(NSInteger)typeTag;
//- (void)refleshButtonClicked;
- (void)didSelectedCellSendTo:(NSString *)sento array:(NSArray *)array;
@end

