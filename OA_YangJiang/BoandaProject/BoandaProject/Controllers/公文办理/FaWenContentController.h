//
//  FawenDetailController.h
//  GuangXiOA
//  已办发文详细信息
//  Created by 曾静 on 11-12-29.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "BaseViewController.h"

@interface FaWenContentController : BaseViewController<NSURLConnHelperDelegate>

@property (nonatomic,strong) NSArray *bsgwFilesAry;//上传报送公文
@property (nonatomic,assign) BOOL isHaveZSGW;//是否有正式打印公文
@property (nonatomic,strong) NSDictionary *jbxxDic;//基本信息
@property (nonatomic,strong) NSArray *zsgwFilesAry;//正式公文上传的
@property (nonatomic,strong) NSString *fwid;
@property (nonatomic,strong) IBOutlet UITableView *resTableView;

@property (nonatomic,strong) NSArray *toDisplayKey;//发文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property(nonatomic,strong) NSMutableArray *toDisplayHeightAry;

@property (nonatomic,strong) NSArray *stepAry;      //处理步骤
@property (nonatomic,strong) NSArray *stepHeightAry;//步骤的高度

- (id)initWithNibName:(NSString *)nibNameOrNil andFWID:(NSString*)idstr;
@end
