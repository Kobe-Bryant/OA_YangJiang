//
//  WRYDetailViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-7-30.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WRYDetailViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, copy) NSString *wrybh;
@property (nonatomic, copy) NSString *wrymc;

@end
