//
//  SinaRequest.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBEngine.h"
#import "ControllerConstants.h"

@interface SinaRequest : NSObject <RequestProtocol>

- (id)initWithEngine: (WBEngine*)engine
          methodName:(NSString *)methodName
          httpMethod:(NSString *)httpMethod
              params:(NSDictionary *)params
        postDataType:(WBRequestPostDataType)postDataType
    httpHeaderFields:(NSDictionary *)httpHeaderFields
        doneCallback:(processDoneWithDictBlock)callback;
@end
