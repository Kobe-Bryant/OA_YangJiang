//
//  WRYConditionTextViewController.h
//  FoShanYDZF
//
//  Created by 曾静 on 13-11-13.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "WRYConditionPassDelegate.h"

@interface WRYConditionTextViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) id<WRYConditionPassDelegate> delegate;
@property (copy, nonatomic) NSString *conditionKey;
@property (nonatomic, strong) NSString *selectedValue;

- (IBAction)onComfirmClick:(id)sender;

@end
