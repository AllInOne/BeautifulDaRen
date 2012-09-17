//
//  LocationHelper.m
//  BeautifulDaRen
//
//  Created by jerry.li on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationHelper.h"

#define LOCATION_RETRY_COUNT_LIMITATION   (100)

static LocationHelper *sharedInstance;

@interface LocationHelper ()
@property (nonatomic, assign) getLocationDoneBlock doneCallback;
@property (nonatomic, retain) NSString * locationStr;
@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) NSError * error;
@property (nonatomic, assign) NSInteger retryCount;
-(void) startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude;
-(void) start;
@end

@implementation LocationHelper

@synthesize locationStr = _locationStr;
@synthesize location = _location;
@synthesize doneCallback = _doneCallback;
@synthesize error = _error;
@synthesize retryCount = _retryCount;

+ (LocationHelper*) sharedManager {
    @synchronized([LocationHelper class]) {
        if (!sharedInstance) {
            sharedInstance = [[LocationHelper alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        gps = [[CLLocationManager alloc] init];  
        gps.delegate = self;  
        gps.desiredAccuracy = kCLLocationAccuracyBest;  
        gps.distanceFilter = kCLDistanceFilterNone; 
    }
    
    return self;
}

-(void)dealloc
{
    [_locationStr release];
    [_location release];
    if (_doneCallback) {
        Block_release(_doneCallback);
    }

    [gps release];
    [_error release];
    [super dealloc];
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation  
           fromLocation:(CLLocation *) oldLocation;  
{  
    self.locationStr = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    self.location = newLocation;
    [self startedReverseGeoderWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [gps stopUpdatingLocation];
}  

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {  
    if ( [error code] == kCLErrorDenied ) {  
        [manager stopUpdatingHeading];  
    } else if ([error code] == kCLErrorHeadingFailure) {  
        
    }  
}  

-(void) startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude{  
    CLLocationCoordinate2D coordinate2D;  
    coordinate2D.longitude = longitude;  
    coordinate2D.latitude = latitude;  
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];  
    geoCoder.delegate = self;  
    [geoCoder start];  
}  

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark  
{  
    
    NSString *subthroung=placemark.thoroughfare;  
    NSString *local=placemark.locality;  
    NSLog(@"您当前所在位置:%@,%@", local, subthroung);
    
    if (_doneCallback) {
        _doneCallback(self.error, self.location, placemark);
    }
    
    Block_release(_doneCallback);
    _doneCallback = nil;
}  
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error  
{
    _error = nil;
    self.error = error;
    
    _retryCount++;
    
    if (self.retryCount < LOCATION_RETRY_COUNT_LIMITATION) {
        [gps startUpdatingLocation];
    }
    else
    {
        if (_doneCallback) {
            _doneCallback(self.error, self.location, nil);
        }
        
        Block_release(_doneCallback);
        _doneCallback = nil;    
    }
}  

-(void) start
{
    _retryCount = 0;
    [gps startUpdatingLocation];
}

- (void)getCurrentLocationWithDoneCallbck:(getLocationDoneBlock)callback
{
    if (_doneCallback) {
        NSError * error = [NSError errorWithDomain:@"BSDK" code:101 userInfo:nil];
        callback(error, nil, nil);
        return;
    }
    _doneCallback = Block_copy(callback);
    [[LocationHelper sharedManager] start];
}

@end
