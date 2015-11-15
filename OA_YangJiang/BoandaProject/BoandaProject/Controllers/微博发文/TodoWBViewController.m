//
//  TodoWBViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TodoWBViewController.h"
#import "WBDetailsViewController.h"
@interface TodoWBViewController ()

@end

@implementation TodoWBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeStr = kLCLXBH_WBFW;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
    NSString *lclxbh = [dic objectForKey:@"LCSLBH"];

    WBDetailsViewController *controller = [[WBDetailsViewController alloc] initWithNibName:@"WBDetailsViewController" andLCSLBH:lclxbh isBanli:YES];
    controller.itemParams = dic;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

@end
