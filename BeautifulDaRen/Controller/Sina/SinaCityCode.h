//
//  SinaCityCode.h
//  BeautifulDaRen
//
//  Created by Jerry Lee on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaCityCode : NSObject

+ (SinaCityCode*) sharedInstance;

-(NSString*)getProvinceNameByCode:(NSString*)code;

-(NSString*)getCityNameByProvinceCode:(NSString*)provinceCode andCityCode:(NSString*)cityCode;
@end
