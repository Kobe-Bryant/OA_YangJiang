//
//  TodoGWListViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TodoGWListViewController.h"

@interface TodoGWListViewController ()

@end

@implementation TodoGWListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@", kLCLXBH_LW,kLCLXBH_FW,kLCLXBH_WNWZ,kLCLXBH_WBFW,kLCLXBH_DBRW,kLCLXBH_HYTZ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
