//
//  OnlineWasteAirEnterpriseListViewController.m
//  BoandaProject
//
//  Created by 曾静 on 13-12-5.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "OnlineWasteAirEnterpriseListViewController.h"

@interface OnlineWasteAirEnterpriseListViewController ()

@end

@implementation OnlineWasteAirEnterpriseListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"废气企业信息";
        self.serviceName = @"QUERY_ZAJC_FQQY_LIST";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
