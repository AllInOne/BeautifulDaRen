
#import "BSDKRequest.h"
#import "WBUtil.h"
#import "JSON.h"
#import "BSDKDefines.h"

#import "WBSDKGlobal.h"

#define kWBRequestTimeOutInterval   180.0
#define kWBRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

#define KWBMaxImageDataSize         80000

static NSMutableString *logBody;

@interface BSDKRequest (Private)

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;
+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;
- (NSMutableData *)postBody;

- (void)handleResponseData:(NSData *)data;
- (id)parseJSONData:(NSData *)data error:(NSError **)error;

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
- (void)failedWithError:(NSError *)error;
@end


@implementation BSDKRequest

@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize postDataType;
@synthesize httpHeaderFields;
@synthesize delegate;


#pragma mark - BSDKRequest Life Circle

- (void)dealloc
{
    [url release];
    url = nil;
    [httpMethod release];
    httpMethod = nil;
    [params release];
    params = nil;
    [httpHeaderFields release];
    httpHeaderFields = nil;
    
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
    
    [super dealloc];
}

#pragma mark - BSDKRequest Private Methods

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    [logBody appendString:dataString];
}

- (NSMutableData *)postBody
{
    if (logBody == nil) {
        logBody = [[NSMutableString stringWithCapacity:256] retain];
    }
    
    [logBody setString:@""];
    
    NSMutableData *body = [NSMutableData data];
    
    if (postDataType == kBSDKRequestPostDataTypeNormal)
    {
        [BSDKRequest appendUTF8Body:body dataString:[BSDKRequest stringFromDictionary:params]];
    }
    else if (postDataType == kBSDKRequestPostDataTypeMultipart)
    {
        NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kWBRequestStringBoundary];
		NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kWBRequestStringBoundary];
        
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        
        [BSDKRequest appendUTF8Body:body dataString:bodyPrefixString];
        
        for (id key in [params keyEnumerator]) 
		{
			if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]]))
			{
				[dataDictionary setObject:[params valueForKey:key] forKey:key];
				continue;
			}
			
			[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
			[BSDKRequest appendUTF8Body:body dataString:bodyPrefixString];
		}
		
		if ([dataDictionary count] > 0) 
		{
			for (id key in dataDictionary) 
			{
				NSObject *dataParam = [dataDictionary valueForKey:key];
				
				if ([dataParam isKindOfClass:[UIImage class]]) 
				{
//					NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
//					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key]];
//					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithString:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
//					[body appendData:imageData];

					NSData* imageData = UIImageJPEGRepresentation((UIImage *)dataParam, 1);
                    
                    // if the size is big, we need to recompress the image
                    NSInteger size = [imageData length];
                    if (size > KWBMaxImageDataSize) {
                        imageData = UIImageJPEGRepresentation((UIImage *)dataParam, KWBMaxImageDataSize/size);
                    }
                    
					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"Pic.jpg\"\r\n", key]];
					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithString:@"Content-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
					[body appendData:imageData];
				} 
				else if ([dataParam isKindOfClass:[NSData class]]) 
				{
					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key]];
					[BSDKRequest appendUTF8Body:body dataString:[NSString stringWithString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
					[body appendData:(NSData*)dataParam];
				}
				[BSDKRequest appendUTF8Body:body dataString:bodySuffixString];
			}
		}
    }
    NSLog(@"========================================================");
    NSLog(@"\r\n \r\nBSDK REQUEST: %@ \r\n \r\n", logBody);
    NSLog(@"========================================================");
    return body;
}

- (void)handleResponseData:(NSData *)data 
{
    if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)])
    {
        [delegate request:self didReceiveRawData:data];
    }
	
	NSError* error = nil;
	id result = [self parseJSONData:data error:&error];
	
	if (error) 
	{
		[self failedWithError:error];
	} 
	else 
	{
        if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
		{
            [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
		}
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
	
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	SBJSON *jsonParser = [[SBJSON alloc]init];
	
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:dataString error:&parseError];
	
	if (parseError)
    {
        if (error != nil)
        {
            *error = [self errorWithCode:kWBErrorCodeSDK
                                userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", kWBSDKErrorCodeParseError]
                                                                     forKey:kWBSDKErrorCodeKey]];
        }
	}
        
	[dataString release];
	[jsonParser release];
	
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
		if ([result objectForKey:@"error_code"] != nil && [[result objectForKey:@"error_code"] intValue] != 200)
		{
			if (error != nil) 
			{
				*error = [self errorWithCode:kWBErrorCodeInterface userInfo:result];
			}
		}
	}
	
	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kWBSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error 
{
//	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) 
//	{
//		[delegate request:self didFailWithError:error];
//	}
    NSDictionary * falkResponse = nil;
    NSLog(@"******************BSDK error:%@, %d", error, error.code);
    if (error.code == -1004) {
        falkResponse = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"server_no_response", @"server_no_response"), K_BSDK_RESPONSE_MESSAGE, K_BSDK_RESPONSE_STATUS_FAILED, K_BSDK_RESPONSE_STATUS, nil];
    }
    else
    {
        falkResponse = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"server_request_error", @"server_request_error"), K_BSDK_RESPONSE_MESSAGE, K_BSDK_RESPONSE_STATUS_FAILED, K_BSDK_RESPONSE_STATUS, nil];
    }

    if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
    {
        [delegate request:self didFinishLoadingWithResult:falkResponse];
    }
}

#pragma mark - WBRequest Public Methods

+ (BSDKRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
                 postDataType:(BSDKRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<BSDKRequestDelegate>)delegate
{
    BSDKRequest *request = [[[BSDKRequest alloc] init] autorelease];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.postDataType = postDataType;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    
    return request;
}

+ (BSDKRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod 
                               params:(NSDictionary *)params
                         postDataType:(BSDKRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<BSDKRequestDelegate>)delegate
{
    // add the access token field
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"checkCode"];
    return [BSDKRequest requestWithURL:url
                          httpMethod:httpMethod
                              params:mutableParams
                        postDataType:postDataType 
                    httpHeaderFields:httpHeaderFields
                            delegate:delegate];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [BSDKRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

- (void)connect
{
    NSString *urlString = [BSDKRequest serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:kWBRequestTimeOutInterval];
    
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:@"POST"])
    {
        if (postDataType == kBSDKRequestPostDataTypeMultipart)
        {
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kWBRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        [request setHTTPBody:[self postBody]];
    }
    
    for (NSString *key in [httpHeaderFields keyEnumerator])
    {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    [self performSelector:@selector(requestOnTimeout) withObject:self afterDelay:60.0];
}

- (void)requestOnTimeout
{
    
    NSDictionary * falkResponse = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"server_no_response", @"server_no_response"), K_BSDK_RESPONSE_MESSAGE, K_BSDK_RESPONSE_STATUS_FAILED, K_BSDK_RESPONSE_STATUS, nil];
//    [self handleResponseData:falkResponse];
    if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
    {
        [delegate request:self didFinishLoadingWithResult:falkResponse];
    }
//    [self failedWithError:[NSError errorWithDomain:@"BSDK" code:1005 userInfo:nil]];
    [self disconnect];
}

- (void)disconnect
{
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release];
    connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse 
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
    NSLog(@"%@", [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
	[self handleResponseData:responseData];
    
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
