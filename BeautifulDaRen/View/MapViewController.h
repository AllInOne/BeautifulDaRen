//
//  MapViewController.h
//  BeautifulDaRen
//
//  Created by gang liu on 4/24/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;

@property (retain, nonatomic) IBOutlet MKMapView * mapView;
- (id)initWithName: (NSString*)name
       description: (NSString*)description
          latitude: (double_t)latitude
         longitude: (double_t)longitude;
@end
