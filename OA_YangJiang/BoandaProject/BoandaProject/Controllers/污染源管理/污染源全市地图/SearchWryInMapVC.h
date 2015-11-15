//
//  SearchWryInMapVC.h
//  NanShanApp
//
//  Created by 曾静 on 12-10-23.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WRYConditionPassDelegate.h"

@interface SearchWryInMapVC : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *radiusField;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, weak) id<WRYConditionPassDelegate> delegate;
@property (copy, nonatomic) NSString *conditionKey;
@property (nonatomic, strong) NSString *selectedValue;

-(IBAction)searchBtnPressed:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
