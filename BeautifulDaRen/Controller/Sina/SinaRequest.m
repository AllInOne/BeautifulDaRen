//
//  SinaRequest.m
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinaRequest.h"
#import "WBEngine.h"

@interface SinaRequest ()
@property (nonatomic, retain) WBEngine * engine;
@property (nonatomic, retain) NSString * methodUrl;
@property (nonatomic, retain) NSString * httpMethod;
@property (nonatomic, retain) NSDictionary * params;
@property (nonatomic, assign) WBRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary * httpHeaderFields;
@property (nonatomic, assign) processDoneWithDictBlock doneCallback;

@end

@implementation SinaRequest
@synthesize engine = _engine;
@synthesize methodUrl = _methodUrl;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params; 
@synthesize postDataType = _postDataType;
@synthesize httpHeaderFields = _httpHeaderFields;
@synthesize doneCallback = _doneCallback;

- (id)initWithEngine:(WBEngine*)engine
          methodName:(NSString *)methodName
          httpMethod:(NSString *)httpMethod
              params:(NSDictionary *)params
        postDataType:(WBRequestPostDataType)postDataType
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
    [self.methodUrl release];
    [self.httpMethod release];
    [self.params release];
    [self.httpHeaderFields release];
    Block_release(self.doneCallback);
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
