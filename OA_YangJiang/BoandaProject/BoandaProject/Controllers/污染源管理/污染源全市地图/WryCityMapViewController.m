//
//  WryCityMapViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-1-20.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WryCityMapViewController.h"
#import "WryBMKPointAnnotation.h"
#import "WRYDetailViewController.h"
#import "MapPinButton.h"
#import "DataCacheTool.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"

#define kWRY_MAP_DATA_KEY @"WryMapData"
#define kServiceTag_Default 1
#define kServiceTag_Query 2

@interface WryCityMapViewController ()

@property (nonatomic, strong) MKMapView* defaultMapView;
@property (nonatomic, strong) UIPopoverController *popSearchController;
@property (nonatomic, strong) NSArray *listDataArray;
@property (nonatomic, strong) NSArray *wryAnnosArray;
@property (nonatomic, assign) int currentServiceTag;

@end

@implementation WryCityMapViewController
@synthesize defaultMapView;

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
    
    self.title = @"污染源地图";
    
    [self addUIViews];
    

    BOOL ret = [[DataCacheTool sharedInstance] shouldUpdateData:kWRY_MAP_DATA_KEY];
    if(ret)
    {
        [self requestAllData];
    }
    else
    {
        self.listDataArray = [[DataCacheTool sharedInstance] getCacheDataWithKey:kWRY_MAP_DATA_KEY];
        [self refreshMapAnnotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.popSearchController)
    {
        [self.popSearchController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Private Method

- (void)addUIViews
{
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithTitle:@"污染源查询" style:UIBarButtonItemStyleBordered target:self action:@selector(onSearchClicked:)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
    self.defaultMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
    self.defaultMapView.delegate = self;
    CLLocationCoordinate2D yangjiangCoor;
    yangjiangCoor.latitude = 21.85375826644;
    yangjiangCoor.longitude = 111.9817558632;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(yangjiangCoor, 100000,100000);
    [self.defaultMapView setRegion:region animated:YES];
    [self.view addSubview:self.defaultMapView];
}

- (void)refreshMapAnnotation
{
    [self performSelector:@selector(removeAnnotations) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0.5];
}

- (void)removeAnnotations
{
    if(self.wryAnnosArray && self.wryAnnosArray.count > 0)
    {
        [self.defaultMapView removeAnnotations:self.wryAnnosArray];
    }
}

- (void)addAnnotations
{
    NSMutableArray *annos = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.listDataArray.count; i++) {
        NSDictionary *item = [self.listDataArray objectAtIndex:i];
        WryBMKPointAnnotation *annotation = [[WryBMKPointAnnotation alloc] init];
        NSString *lat = [item objectForKey:@"WD"];
        NSString *lon = [item objectForKey:@"JD"];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([lat floatValue], [lon floatValue]);
        annotation.coordinate = coor;
        annotation.infoItem = item;
        annotation.title = [item objectForKey:@"WRYMC"];
        annotation.subtitle = [item objectForKey:@"DWDZ"];
        annotation.wrymc = [item objectForKey:@"WRYMC"];
        annotation.wrybh = [NSString stringWithFormat:@"%@", [item objectForKey:@"WRYBH"]];
        [annos addObject:annotation];
        
        [self.defaultMapView addAnnotation:annotation];
    }
    self.wryAnnosArray = annos;
}

#pragma mark - Network Handler Method

- (void)requestAllData
{
    self.currentServiceTag = kServiceTag_Default;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setObject:@"QUERY_WRY_SEARCH_LIST" forKey:@"service"];
    NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableString *tmp = [[NSMutableString alloc] initWithString:jsonStr];
    [tmp replaceOccurrencesOfString:@":," withString:@":\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmp.length)];
    [tmp replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tmp.length)];
    jsonStr = tmp;
    NSDictionary *tmpDict = [jsonStr objectFromJSONString];
    if(tmpDict == nil)
    {
        [self showAlertMessage:@"获取污染源企业数据出错."];
    }
    else
    {
        self.listDataArray = [tmpDict objectForKey:@"result"];
        if(self.currentServiceTag == kServiceTag_Default)
        {
            //缓存数据
            [[DataCacheTool sharedInstance] setCacheData:self.listDataArray andWithKey:kWRY_MAP_DATA_KEY];
        }
    }
    
    //刷新地图数据
    if(self.currentServiceTag == kServiceTag_Default)
    {
        self.listDataArray = [[DataCacheTool sharedInstance] getCacheDataWithKey:kWRY_MAP_DATA_KEY];
    }
    [self refreshMapAnnotation];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取污染源企业数据出错."];
}

#pragma mark - BMKMapView Delegate Methods

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    WryBMKPointAnnotation * anno = view.annotation;
    WRYDetailViewController *detail = [[WRYDetailViewController alloc] initWithNibName:@"WRYDetailViewController" bundle:nil];
    detail.wrybh = anno.wrybh;
    detail.wrymc = anno.wrymc;
    [self.navigationController pushViewController:detail animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[WryBMKPointAnnotation class]])
    {
		MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"WryBMKPointAnnotation"];
		newAnnotation.draggable = NO;
        
        UIImage *flagImage = [UIImage imageNamed:@"wry_pin.png"];
        
        // size the flag down to the appropriate size
        CGRect resizeRect;
        resizeRect.size = flagImage.size;
        CGSize maxSize = CGRectInset(self.view.bounds, 10.0f, 10.0f).size;
        maxSize.height -= self.navigationController.navigationBar.frame.size.height + 40.0f;
        if (resizeRect.size.width > maxSize.width)
        {
            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
        }
        if (resizeRect.size.height > maxSize.height)
        {
            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
        }
        resizeRect.origin = CGPointMake(0.0, 0.0);
        UIGraphicsBeginImageContext(resizeRect.size);
        [flagImage drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newAnnotation.image = resizedImage;
        newAnnotation.opaque = NO;
        
        newAnnotation.canShowCallout = YES;
		
        MapPinButton *btn = [[MapPinButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        btn.infoItem = [(WryBMKPointAnnotation*)annotation infoItem];
        [btn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
        newAnnotation.rightCalloutAccessoryView = btn;
		return newAnnotation;
	}
	return nil;
}

#pragma mark - Event Handler Methods

- (void)onSearchClicked:(id)sender
{
    if([self.popSearchController isPopoverVisible])
    {
        [self.popSearchController dismissPopoverAnimated:YES];
        return;
    }
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    WRYSearchViewController *controller = [[WRYSearchViewController alloc] initWithNibName:@"WRYSearchViewController" bundle:nil];
    controller.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:navi];
    popController.popoverContentSize = CGSizeMake(320, 440);
    self.popSearchController = popController;
    
    [self.popSearchController presentPopoverFromBarButtonItem:item permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - PassSearchCondition Delegate

- (void)passSearchConditon:(NSDictionary *)aParams
{
    if(self.popSearchController)
    {
        [self.popSearchController dismissPopoverAnimated:YES];
    }
    if(self.webHelper)
    {
        [self.webHelper cancel];
    }
    if(aParams && aParams.allKeys.count > 0)
    {
        self.currentServiceTag = kServiceTag_Query;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:aParams copyItems:YES];
        [params setObject:@"QUERY_WRY_SEARCH_LIST" forKey:@"service"];
        
        NSString *strURL = [ServiceUrlString generateUrlByParameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strURL andParentView:self.view delegate:self];
    }
}

@end
