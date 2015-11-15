//
//  OtherFactorListViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-12-17.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFactorDelegate <NSObject>

- (void)passWithSelectedNameValue:(NSArray *)nameAry andWithKeyValue:(NSArray *)keyAry;

@end

@interface OtherFactorListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<ChooseFactorDelegate> delegate;
@property (nonatomic, strong) UIPopoverController *parentController;

@property (nonatomic, strong) NSMutableArray *selectedFactorNames;
@property (nonatomic, strong) NSMutableArray *selectedFactorKeys;

@end
