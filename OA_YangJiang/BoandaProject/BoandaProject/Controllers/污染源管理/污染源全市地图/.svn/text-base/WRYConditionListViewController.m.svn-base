//
//  WRYConditionListViewController.m
//  FoShanYDZF
//
//  Created by 曾静 on 13-11-13.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WRYConditionListViewController.h"
#import "SharedInformations.h"

@interface WRYConditionListViewController ()
@property (nonatomic, strong) NSArray *listDataArray;
@end

@implementation WRYConditionListViewController

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
    
    if(self.listType == 0)
    {
        //监管级别
        NSArray *ary = [SharedInformations getJGJBNameList];
        self.listDataArray = ary;
    }
    else if (self.listType == 1)
    {
        //所在地市
        NSArray *ary = [[NSArray alloc] initWithObjects:@"阳江市", nil];
        self.listDataArray = ary;
    }
    else if (self.listType == 2)
    {
        //所在区县
        NSArray *ary = [SharedInformations getSSQXNameList];
        self.listDataArray = ary;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *title = [self.listDataArray objectAtIndex:indexPath.row];
    if([title isEqualToString:self.selectedValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedValue = [self.listDataArray objectAtIndex:indexPath.row];
    [self.listTableView reloadData];
    if([self.delegate respondsToSelector:@selector(passCondtionWithValue:andWithKey:)])
    {
        [self.delegate passCondtionWithValue:self.selectedValue andWithKey:self.conditionKey];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
