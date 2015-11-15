//
//  EnterpriseMapCell.m
//  BoandaProject
//
//  Created by 曾静 on 13-10-10.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "EnterpriseMapCell.h"
#import "WRYDetailViewController.h"

@implementation EnterpriseMapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self makeCellView];
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coor
{
    _coordinate = coor;
    WryBMKPointAnnotation *anno = [[WryBMKPointAnnotation alloc] init];
    anno.coordinate = coor;
    anno.title = self.title;
    anno.subtitle = self.subTitle;
    [defaultMapView addAnnotation:anno];
    defaultMapView.centerCoordinate = coor;
}

- (void)makeCellView
{
    defaultMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 600)];
	defaultMapView.delegate = self;
    CLLocationCoordinate2D yangjiangCoor;
    yangjiangCoor.latitude = 21.85375826644;
    yangjiangCoor.longitude = 111.9817558632;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(yangjiangCoor, 100000,100000);
    [defaultMapView setRegion:region];
    [self.contentView addSubview:defaultMapView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - BMKMapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[WryBMKPointAnnotation class]])
    {
		MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"WryBMKPointAnnotation"];
		newAnnotation.draggable = NO;
        
        UIImage *flagImage = [UIImage imageNamed:@"wry_pin.png"];
        newAnnotation.image = flagImage;
        newAnnotation.canShowCallout = YES;
		
		return newAnnotation;
	}
	return nil;
}


@end
