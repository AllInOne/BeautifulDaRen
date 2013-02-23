//
//  SinaRequest.m
//  AllInOne
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSDKWeiboRequest.h"
#import "BSDKEngine.h"
#import "BSDKDefines.h"

@interface BSDKWeiboRequest ()
@property (nonatomic, retain) BSDKEngine * engine;
@property (nonatomic, retain) NSString * methodUrl;
@property (nonatomic, retain) NSString * httpMethod;
@property (nonatomic, retain) NSDictionary * params;
@property (nonatomic, assign) BSDKRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary * httpHeaderFields;
@property (nonatomic, assign) processDoneWithDictBlock doneCallback;

@property (nonatomic, retain) BSDKRequest       *request;
@end

@implementation BSDKWeiboRequest
@synthesize engine = _engine;
@synthesize methodUrl = _methodUrl;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params;
@synthesize postDataType = _postDataType;
@synthesize httpHeaderFields = _httpHeaderFields;
@synthesize doneCallback = _doneCallback;
@synthesize request = _request;

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

        [self retain];
    }

    return self;
}

- (void)dealloc
{
    [_methodUrl release];
    [_httpMethod release];
    [_params release];
    [_httpHeaderFields release];
    [_engine release];
    [_request disconnect];
    [_request release];
    Block_release(_doneCallback);
    [super dealloc];
}

- (void)start
{
    self.request = [BSDKRequest requestWithAccessToken:@"JKLERKEJRK"
                                                   url:@"http://223.4.235.226:9001/api/mlService.php"
                                            httpMethod:self.httpMethod
                                                params:self.params
                                          postDataType:self.postDataType
                                      httpHeaderFields:self.httpHeaderFields
                                              delegate:self];

    [_request connect];
//    [self.engine loadRequestWithMethodName:self.methodUrl
//                                        httpMethod:self.httpMethod
//                                            params:self.params
//                                      postDataType:self.postDataType
//                                  httpHeaderFields:self.httpHeaderFields];
}

- (void)doneWithStatus: (AIO_STATUS)status andData: (NSDictionary*)data
{
    self.doneCallback(status, data);
}

#pragma mark - WBRequestDelegate Methods
- (void)request:(BSDKRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = nil;
    if ([result isKindOfClass:[NSDictionary class]])
    {
        dict = (NSDictionary *)result;
    }

    NSLog(@"========================================================");
    NSLog(@"\r\n \r\n BSDK RESPONSE: %@\r\n \r\n", dict);
    NSLog(@"========================================================");

    self.doneCallback(AIO_STATUS_SUCCESS, dict);

    [self release];
}

- (void)request:(BSDKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"requestDidFailWithError: %@", error);
    NSDictionary * errorDict = [NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], K_BSDK_RESPONSE_MESSAGE, K_BSDK_RESPONSE_STATUS_FAILED, K_BSDK_RESPONSE_STATUS, nil];

//    [self doNotifyProcessStatus:error.code andData:errorDict];
    self.doneCallback(error.code, errorDict);

    [self release];
}

@end
