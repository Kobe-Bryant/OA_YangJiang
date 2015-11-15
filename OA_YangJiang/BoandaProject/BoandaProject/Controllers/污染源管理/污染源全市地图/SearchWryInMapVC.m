//
//  SearchWryInMapVC.m
//  NanShanApp
//
//  Created by 曾静 on 12-10-23.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "SearchWryInMapVC.h"

@interface SearchWryInMapVC ()

@end

@implementation SearchWryInMapVC
@synthesize radiusField,slider,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320, 440);
    radiusField.text = [NSString stringWithFormat:@"%d",(int)slider.value];
    if (self.selectedValue.length > 0)
    {
        radiusField.text = self.selectedValue;
        slider.value = [self.selectedValue integerValue];
    }
}

-(IBAction)sliderValueChanged:(id)sender
{
    self.selectedValue = [NSString stringWithFormat:@"%d",(int)slider.value];
    radiusField.text = [NSString stringWithFormat:@"%d",(int)slider.value];
}

-(IBAction)searchBtnPressed:(id)sender
{
    if([self.delegate respondsToSelector:@selector(passCondtionWithValue:andWithKey:)])
    {
        [self.delegate passCondtionWithValue:self.selectedValue andWithKey:self.conditionKey];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
