//
//  BaseViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//  所以UIViewController的基类，默认是竖屏的

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "NSURLConnHelperDelegate.h"
@interface BaseViewController : UIViewController<NSURLConnHelperDelegate>
@property(nonatomic,strong)NSURLConnHelper *webHelper;
-(void)showAlertMessage:(NSString*)msg;
@end
