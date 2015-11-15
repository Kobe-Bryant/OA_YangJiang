//
//  TodoDBViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TodoDBViewController.h"
#import "DBDetailViewController.h"

@interface TodoDBViewController ()

@end

@implementation TodoDBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeStr = kLCLXBH_DBRW;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
    DBDetailViewController *controller = [[DBDetailViewController alloc] initWithNibName:@"DBDetailViewController" andLCSLBH:[dic objectForKey:@"LCSLBH"] andBZBH:[dic objectForKey:@"BZBH"] isBanli:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
