//
//  LocationHelper.h
//  BeautifulDaRen
//
//  Created by jerry.li on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h> 

typedef void(^getLocationDoneBlock)(NSError * error, CLLocation * location, MKPlacemark * placeMark);

@interface LocationHelper : NSObject

@end
