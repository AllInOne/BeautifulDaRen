#import <Foundation/Foundation.h>

typedef enum
{
    kBSDKRequestPostDataTypeNone,
	kBSDKRequestPostDataTypeNormal,			// for normal data post, such as "user=name&password=psd"
	kBSDKRequestPostDataTypeMultipart,        // for uploading images and files.
}BSDKRequestPostDataType;

@class BSDKRequest;

@protocol BSDKRequestDelegate <NSObject>

@optional

- (void)request:(BSDKRequest *)request didReceiveResponse:(NSURLResponse *)response;

- (void)request:(BSDKRequest *)request didReceiveRawData:(NSData *)data;

- (void)request:(BSDKRequest *)request didFailWithError:(NSError *)error;

- (void)request:(BSDKRequest *)request didFinishLoadingWithResult:(id)result;

@end

@interface BSDKRequest : NSObject
{
    NSString                *url;
    NSString                *httpMethod;
    NSDictionary            *params;
    BSDKRequestPostDataType   postDataType;
    NSDictionary            *httpHeaderFields;

    NSURLConnection         *connection;
    NSMutableData           *responseData;

    id<BSDKRequestDelegate>   delegate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property BSDKRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary *httpHeaderFields;
@property (nonatomic, assign) id<BSDKRequestDelegate> delegate;

+ (BSDKRequest *)requestWithURL:(NSString *)url
                   httpMethod:(NSString *)httpMethod
                       params:(NSDictionary *)params
                 postDataType:(BSDKRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<BSDKRequestDelegate>)delegate;

+ (BSDKRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod
                               params:(NSDictionary *)params
                         postDataType:(BSDKRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<BSDKRequestDelegate>)delegate;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

- (void)connect;
- (void)disconnect;

@end
