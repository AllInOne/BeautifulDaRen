//
//  SinaRequest.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSDKEngine.h"
#import "ControllerConstants.h"

@interface BSDKWeiboRequest : NSObject <RequestProtocol>

- (id)initWithEngine: (BSDKEngine*)engine
          methodName:(NSString *)methodName
          httpMethod:(NSString *)httpMethod
              params:(NSDictionary *)params
        postDataType:(BSDKRequestPostDataType)postDataType
    httpHeaderFields:(NSDictionary *)httpHeaderFields
        doneCallback:(processDoneWithDictBlock)callback;
@end
