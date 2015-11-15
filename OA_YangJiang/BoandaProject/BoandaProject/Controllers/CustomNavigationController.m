//
//  CustomNavigationController.m
//  GuangXiOA
//
//  Created by zhang on 13-3-26.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation CustomNavigationController

-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return   [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

@end
