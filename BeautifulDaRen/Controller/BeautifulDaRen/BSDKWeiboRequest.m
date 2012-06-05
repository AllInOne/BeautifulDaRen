//
//  SinaRequest.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSDKWeiboRequest.h"
#import "BSDKEngine.h"

@interface BSDKWeiboRequest ()
@property (nonatomic, retain) BSDKEngine * engine;
@property (nonatomic, retain) NSString * methodUrl;
@property (nonatomic, retain) NSString * httpMethod;
@property (nonatomic, retain) NSDictionary * params;
@property (nonatomic, assign) BSDKRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary * httpHeaderFields;
@property (nonatomic, assign) processDoneWithDictBlock doneCallback;

@end

@implementation BSDKWeiboRequest
@synthesize engine = _engine;
@synthesize methodUrl = _methodUrl;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params; 
@synthesize postDataType = _postDataType;
@synthesize httpHeaderFields = _httpHeaderFields;
@synthesize doneCallback = _doneCallback;

- (id)initWithEngine:(BSDKEngine*)engine
          methodName:(NSString *)methodName
          httpMethod:(NSString *)httpMethod
              params:(NSDictionary *)params
        postDataType:(BSDKRequestPostDataType)postDataType
    httpHeaderFields:(NSDictionary *)httpHeaderFields
        doneCallback:(processDoneWithDictBlock)callback
{
    self = [super init];
    
    if (self)
    {
        self.methodUrl = methodName;
        self.httpMethod = httpMethod;
        self.params = params;
        self.postDataType = postDataType;
        self.httpHeaderFields = httpHeaderFields;
        self.doneCallback = Block_copy(callback);
        self.engine = engine;
    }
    
    return self;
}

- (void)dealloc
{
    [_methodUrl release];
    [_httpMethod release];
    [_params release];
    [_httpHeaderFields release];
    Block_release(_doneCallback);
    [super dealloc];
}

- (void)start
{
    [self.engine loadRequestWithMethodName:self.methodUrl
                                        httpMethod:self.httpMethod
                                            params:self.params
                                      postDataType:self.postDataType
                                  httpHeaderFields:self.httpHeaderFields];
}

- (void)doneWithStatus: (AIO_STATUS)status andData: (NSDictionary*)data
{
    self.doneCallback(status, data);
}
@end
