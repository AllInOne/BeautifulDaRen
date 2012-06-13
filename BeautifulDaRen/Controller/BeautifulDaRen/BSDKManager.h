//
//  SinaSDKManager.h
//  AllInOne
//
//  Created by jerry.li on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerConstants.h"
#import "BSDKEngine.h"
#import "BaseManager.h"

@interface BSDKManager : BaseManager <BSDKEngineDelegate>

@property (strong, nonatomic) BSDKEngine *BSDKWeiboEngine;

+ (BSDKManager*) sharedManager;

- (BOOL)isLogin;

- (void)setRootviewController:(UIViewController*)rootViewController;

- (void)signUpWithUsername:(NSString*) username password:(NSString*)password email:(NSString*)email city:(NSString*)city andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)loginWithUsername:(NSString*) username password:(NSString*)password andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)logoutWithDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)changePasswordByUsername:(NSString*) username toNewPassword:(NSString*)newpassword andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)getUserInforByUsername:(NSString*) username andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)searchUsersByUsername:(NSString*) username andDoneCallback:(processDoneWithDictBlock)doneBlock;

- (void)sendRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(BSDKRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
                     doneCallback:(processDoneWithDictBlock)callback;

// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text 
                    image:(UIImage *)image 
                     shop:(NSString*)shop
                    brand:(NSString*)branch
                    price:(NSInteger)price
              poslatitude:(float)latitude
             posLongitude:(float)longitude
             doneCallback:(processDoneWithDictBlock)callback;

// If username is specified, then it will retrieve the weibos which is sent by this user, or it will retrieve the neweset weibos.
- (void)getWeiboListByUsername:(NSString*)username
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback;

- (void)searchWeiboByKeyword:(NSString*)key
                      pageSize:(NSInteger)pageSize 
                     pageIndex:(NSInteger)pageIndex 
               andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboListByClassId:(NSString*)classId
                    pageSize:(NSInteger)pageSize 
                   pageIndex:(NSInteger)pageIndex 
             andDoneCallback:(processDoneWithDictBlock)callback;

- (void)getWeiboClassesWithDoneCallback:(processDoneWithDictBlock)callback;

- (void)followUser:(NSString*)username
   andDoneCallback:(processDoneWithDictBlock)callback;

- (void)unFollowUser:(NSString*)username
   andDoneCallback:(processDoneWithDictBlock)callback;

//- (void)getFollowList:(NSString*)username
//     andDoneCallback:(processDoneWithDictBlock)callback;

- (void)sendComment:(NSString*)comment
            toWeibo:(NSString*)blogId
     andDoneCallback:(processDoneWithDictBlock)callback;



@end
