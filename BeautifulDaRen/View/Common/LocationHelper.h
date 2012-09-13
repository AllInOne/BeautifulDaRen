//
//  LocationHelper.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>   
#import <MapKit/MKReverseGeocoder.h>   
#import <MapKit/MKPlacemark.h>  

typedef void(^getLocationDoneBlock)(NSError * error, CLLocation * location, MKPlacemark * placeMark);

@interface LocationHelper : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate> {  
    CLLocationManager *gps;  
}

+ (LocationHelper*) sharedManager;
- (void)getCurrentLocationWithDoneCallbck:(getLocationDoneBlock)callback;

@end
