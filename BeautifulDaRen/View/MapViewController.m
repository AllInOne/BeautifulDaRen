//
//  MapViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/24/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MKAnnotation.h> 

@interface Annotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end

@implementation Annotation
@synthesize coordinate, title, subtitle;

- (void)dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}
@end

@implementation MapViewController
@synthesize mapView=_mapView;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

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
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidUnload
{
    self.mapView = nil;
    [super viewDidUnload];
}

- (void)dealloc{
    [_mapView release];
    [super dealloc];
}

- (id)initWithName: (NSString*)name
       description: (NSString*)description
          latitude: (double_t)latitude
         longitude: (double_t)longitude
{
    self = [self initWithNibName:nil bundle:nil];
    if(self)
    {
        [_mapView setMapType: MKMapTypeStandard];
        _mapView.delegate=self;
        _mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
        
        MKCoordinateRegion region;
        region.center.latitude = latitude;
        region.center.longitude = longitude;
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;
        [_mapView setRegion:region animated:YES];
        
        Annotation * anno = [[[Annotation alloc] init] autorelease];
        anno.title = [NSString stringWithFormat:@"Name:%@", name];
        anno.subtitle = [NSString stringWithFormat:@"%@", description];
        anno.coordinate = region.center;
        [_mapView addAnnotation:anno];
    }
    return self;
}

#pragma mark MKMapViewDelegate
-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // todo do something when click the annotation.
}


@end
