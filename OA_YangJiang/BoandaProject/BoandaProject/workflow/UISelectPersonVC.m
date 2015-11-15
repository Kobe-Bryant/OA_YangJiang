//
//  UISelectPersonVC.m
//  HNYDZF
//
//  Created by zhang on 12-12-13.
//
//

#import "UISelectPersonVC.h"

@interface UISelectPersonVC ()
@property(nonatomic,strong)UISegmentedControl *segCtrl;
@property(nonatomic,strong) NSMutableArray * arySelUsrs;

@end

@implementation UISelectPersonVC
@synthesize segCtrl,aryWorkflowUsrs,multiUsr,toSelPersonType,delegate,arySelUsrs;
@synthesize departUserModel,myTableView,tableDataType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)segCtrlValueChanged:(id)sender{
    if(segCtrl.selectedSegmentIndex == 0){
        tableDataType = kTableData_WorkflowUsrs;
    }else{
        tableDataType = kTableData_Depart;
        if(departUserModel == nil)
        {
            self.departUserModel = [[DepartUsersDataModel alloc] initWithTarget:self andParentView:self.view];
            [departUserModel requestDepartUsers];
        }
    }
    [myTableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake( 320, 480);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(okBtnPressed:)];
    self.navigationItem.rightBarButtonItem = barItem;

    
    if(toSelPersonType != kPersonType_Master){
        UISegmentedControl *aSegCtrl =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"流程定义",@"组织机构", nil]];
       // aSegCtrl.frame = CGRectMake(10, 10, 180, 40);
        aSegCtrl.selectedSegmentIndex = 0;
        aSegCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segCtrl = aSegCtrl;
        [segCtrl addTarget:self action:@selector(segCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];

        self.navigationItem.titleView = segCtrl;
        tableDataType = kTableData_WorkflowUsrs;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(tableDataType == kTableData_DepartUsrs||toSelPersonType == kPersonType_Master)
        segCtrl.hidden= YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if(departUserModel)
        [departUserModel cancelRequest];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)okBtnPressed:(id)sender{
    [delegate returnSelectedPersons:arySelUsrs andPersonType:toSelPersonType];
    
}

-(void)setAryWorkflowUsrs:(NSArray *)ary{
    aryWorkflowUsrs = [ary copy];
    [arySelUsrs removeAllObjects];
    
}

-(void)departsDataReceived:(NSArray*)aryDeparts{
    [myTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(tableDataType == kTableData_Depart)
        return [departUserModel.aryDeparts count];        
    else
        return [aryWorkflowUsrs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableDataType == kTableData_Depart) {
        
        NSDictionary *dic = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
        NSString *departID = [dic objectForKey:@"deptId"];
        return [departUserModel getLevelByDepartID:departID];
    }
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
	}
    
    if (tableDataType == kTableData_Depart) {
        NSDictionary *dic = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"deptName"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
    }else{
        NSDictionary *dic = [aryWorkflowUsrs objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"userName"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(arySelUsrs){
            if([arySelUsrs containsObject:dic])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
	return cell;
	
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableDataType == kTableData_DepartUsrs || tableDataType == kTableData_WorkflowUsrs) {
        
        if (arySelUsrs == nil) {
            self.arySelUsrs = [NSMutableArray arrayWithCapacity:3];
        }
        
        NSDictionary *dic  = [aryWorkflowUsrs objectAtIndex:indexPath.row];
        if(toSelPersonType == kPersonType_Master && multiUsr==NO){
            [arySelUsrs removeAllObjects];
            [arySelUsrs addObject:dic];
        }else{
            
            if([arySelUsrs containsObject:dic])
                [arySelUsrs removeObject:dic];
            else
                [arySelUsrs addObject:dic];
        }
        
        [tableView reloadData];
    }
    else{
        NSDictionary *dicSelDepart = [departUserModel.aryDeparts objectAtIndex:indexPath.row];
        UISelectPersonVC *controller = [[UISelectPersonVC alloc] initWithNibName:@"UISelectPersonVC" bundle:nil];
        controller.tableDataType = kTableData_DepartUsrs;
        controller.aryWorkflowUsrs = [dicSelDepart objectForKey:@"users"];
        controller.toSelPersonType = toSelPersonType;
        controller.delegate = delegate;
        controller.multiUsr = multiUsr;
        [self.navigationController pushViewController:controller animated:YES];

    }
    
    
}

@end
