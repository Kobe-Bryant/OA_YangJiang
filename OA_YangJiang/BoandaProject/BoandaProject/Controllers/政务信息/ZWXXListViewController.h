//
//  ZWXXListViewController.h
//  GuangXiOA
//
//  Created by zhang on 12-9-18.
//  政务信息
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"
#import "CommenWordsViewController.h"
#import "BaseViewController.h"

@interface ZWXXListViewController : BaseViewController<
UITableViewDataSource,UITableViewDelegate,PopupDateDelegate,WordsDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet UITableView *myTableView;

@property(nonatomic,retain)IBOutlet UITextField *btField;//标题
@property(nonatomic,retain)IBOutlet UITextField *bsdwField;//报送单位
@property(nonatomic,retain)IBOutlet UITextField *kssjField;//开始时间
@property(nonatomic,retain)IBOutlet UITextField *jssjField;//结束时间

@property(nonatomic,retain)IBOutlet UILabel *btLabel;//标题
@property(nonatomic,retain)IBOutlet UILabel *bsdwLabel;//报送单位
@property(nonatomic,retain)IBOutlet UILabel *kssjLabel;//开始时间
@property(nonatomic,retain)IBOutlet UILabel *jssjLabel;//结束时间
@property(nonatomic,retain)IBOutlet UIButton *searchButton;

-(IBAction)btnSearch:(id)sender;
-(IBAction)btnTextBSDW:(id)sender;
@end
