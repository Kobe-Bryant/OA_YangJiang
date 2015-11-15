//
//  DisplayAttachFileController.h
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASINetworkQueue.h"
#import "MovePopViewController.h"
#import "ASIHTTPRequestDelegate.h"
@interface DisplayAttachFileController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,MovePopViewControllerDelegate,UIDocumentInteractionControllerDelegate,ASIHTTPRequestDelegate>

@property (nonatomic, strong) IBOutlet UILabel *labelTip;
@property (nonatomic, strong) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSMutableDictionary* fileFiles;
@property (nonatomic,assign) BOOL isFW; //发文
@property (nonatomic, assign)BOOL isHY; //会议


- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName;

@end
